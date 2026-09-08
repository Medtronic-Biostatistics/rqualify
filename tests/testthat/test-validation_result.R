test_that("version probes use the first output line and reject failed commands", {
  r <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "R.exe" else "R")
  expect_match(command_version(r), "^R version ")
  for (command in list(NULL, NA_character_, "")) {
    expect_identical(command_version(command), NA_character_)
  }
  tmp <- withr::local_tempdir()
  expect_identical(command_version(file.path(tmp, "missing-executable")), NA_character_)

  for (code in list(
    "q(status = 0L)",
    c('cat("misleading version 1.0\\n")', "q(status = 1L)")
  )) {
    script <- file.path(tmp, "version probe.R")
    writeLines(code, script)
    expect_identical(command_version(r, c("--vanilla", "--slave", shQuote(paste0("--file=", script)))), NA_character_)
  }
  local_mocked_bindings(system2 = function(...) stop("cannot start command"), .package = "base")
  expect_identical(command_version(r), NA_character_)
})

test_that("Quarto version metadata comes from its selected bundled tools", {
  binary <- "/Selected Tools/quarto"
  seen <- list()
  local_mocked_bindings(quarto_path = function() binary, .package = "quarto")
  local_mocked_bindings(
    command_version = function(command, args = "--version") {
      seen[[length(seen) + 1L]] <<- list(command = command, args = args)
      switch(args[1], "--version" = "1.8.0", pandoc = "pandoc 3.6", typst = "typst 0.13")
    },
    find_pdflatex = function() stop("must not inspect LaTeX")
  )
  result <- validation_tool_versions("quarto")
  expect_identical(result$quarto_path, binary)
  expect_identical(result$quarto, "1.8.0")
  expect_identical(result$pandoc, "pandoc 3.6")
  expect_identical(result$typst, "typst 0.13")
  expect_identical(result$latex, NA_character_)
  expect_identical(vapply(seen, `[[`, character(1), "command"), rep(binary, 3))
  expect_identical(lapply(seen, `[[`, "args"), list("--version", c("pandoc", "--version"), c("typst", "--version")))
  expect_identical(result$R, as.character(getRversion()))
  expect_identical(result$R_home, normalizePath(R.home(), winslash = "/"))
  expect_identical(result$rqualify, as.character(utils::packageVersion("rqualify")))
})

test_that("LaTeX version metadata records unavailable optional tools", {
  local_mocked_bindings(pandoc_version = function() numeric_version("3.6.1"), .package = "rmarkdown")
  local_mocked_bindings(find_pdflatex = function() "")
  result <- validation_tool_versions("latex")
  expect_identical(result$pandoc, "3.6.1")
  expect_identical(result$latex, NA_character_)
  expect_identical(result$quarto, NA_character_)
  expect_identical(result$typst, NA_character_)

  local_mocked_bindings(
    find_pdflatex = function() "/existing/pdflatex",
    command_version = function(command, args = "--version") {
      expect_identical(command, "/existing/pdflatex")
      "pdfTeX 3.141592653"
    }
  )
  expect_identical(validation_tool_versions("latex")$latex, "pdfTeX 3.141592653")
})

test_that("result metadata only reports artifacts that exist", {
  tmp <- withr::local_tempdir()
  paths <- list(path_rvalidation = tmp)
  versions <- list(R = as.character(getRversion()))
  started <- Sys.time()
  result <- collect_validation_result(paths, "latex", versions, started)
  expect_identical(result$status, "missing")
  expect_null(result$summary)
  expect_null(result$files$source)
  expect_null(result$files$latex)
  expect_null(result$files$pdf)
  expect_null(result$files$summary)

  file.create(file.path(tmp, c("R-validation.qmd", "R-validation.pdf")))
  write_test_summary(tmp)
  result <- collect_validation_result(paths, "quarto", versions, started)
  expect_identical(result$status, "ok")
  expect_identical(result$files$source, file.path(tmp, "R-validation.qmd"))
  expect_identical(result$files$pdf, file.path(tmp, "R-validation.pdf"))
  expect_identical(result$files$summary, file.path(tmp, "IQ-OQ-TestOutput", "test_summary.csv"))
  expect_identical(result$files$metadata, file.path(tmp, "validation_result.rds"))
  expect_identical(result$versions, versions)
  expect_identical(result$started_at, started)
  expect_gte(result$finished_at, started)
})
