mock_report <- function(summary = passing_summary(), env = parent.frame()) {
  testthat::local_mocked_bindings(
    setup_pandoc_env = function(...) NULL,
    setup_tinytex_env = function(...) NULL,
    setup_quarto_env = function() NULL,
    validation_tool_versions = function(engine) list(R = as.character(getRversion()), engine = engine),
    render_validation = function(path_rvalidation, engine, render_latex, verbose) {
      write_test_summary(path_rvalidation, summary)
      file.create(file.path(path_rvalidation, if (render_latex || engine == "quarto") "R-validation.pdf" else "R-validation.tex"))
    }, .env = env
  )
}

test_that("default return stays a path and detailed results preserve evidence", {
  local_r_tests_dir_exists()
  mock_report()
  tmp <- withr::local_tempdir()
  result <- rqualify(tmp, verbose = FALSE)
  expect_identical(result, file.path(normalizePath(tmp, winslash = "/"), "R-validation"))
  saved <- readRDS(file.path(result, "validation_result.rds"))
  expect_s3_class(saved, "rqualify_result")
  expect_identical(saved$status, "ok")
  expect_identical(saved$core_test_scope, "basic")
  expect_equal(saved$summary, passing_summary())
  expect_true(file.exists(saved$files$pdf))

  tmp2 <- withr::local_tempdir()
  detailed <- rqualify(tmp2, engine = "quarto", details = TRUE, verbose = FALSE)
  expect_s3_class(detailed, "rqualify_result")
  expect_identical(detailed$engine, "quarto")
  expect_identical(detailed$versions$engine, "quarto")
  expect_equal(readRDS(detailed$files$metadata), detailed)
})

test_that("Quarto bypasses LaTeX and standalone Pandoc setup and restores its environment", {
  local_r_tests_dir_exists()
  mock_report()
  local_mocked_bindings(
    setup_tinytex_env = function(...) stop("must not inspect TinyTeX"),
    setup_pandoc_env = function(...) stop("must not inspect Pandoc"),
    setup_quarto_env = function() expect_true(TRUE),
    render_validation = function(path_rvalidation, ...) {
      expect_identical(Sys.getenv("QUARTO_R"), file.path(R.home("bin"), "Rscript"))
      write_test_summary(path_rvalidation)
    }
  )
  withr::local_envvar(QUARTO_R = NA_character_)
  tmp <- withr::local_tempdir()
  expect_no_error(rqualify(tmp, engine = "quarto", setup_tinytex = FALSE,
                          setup_pandoc = FALSE, verbose = FALSE))
  expect_true(is.na(Sys.getenv("QUARTO_R", unset = NA_character_)))
})

test_that("failed prerequisite checks create no output and permit retry", {
  local_r_tests_dir_exists()
  mock_report()
  ready <- FALSE
  local_mocked_bindings(setup_pandoc_env = function(...) {
    if (!ready) stop("missing dependency")
  })
  tmp <- withr::local_tempdir()
  expect_error(rqualify(tmp), "missing dependency")
  expect_false(dir.exists(file.path(tmp, "R-validation")))
  ready <- TRUE
  expect_no_error(rqualify(tmp, verbose = FALSE))
})

test_that("invalid inputs are rejected before setup or file creation", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    setup_tinytex_env = function(...) stop("unexpected setup"),
    setup_pandoc_env = function(...) stop("unexpected setup")
  )
  expect_error(rqualify(), "path_save")
  for (engine in list("typo", "lat", NA_character_, character(), c("latex", "quarto"))) {
    expect_error(rqualify(tmp, engine = engine), "engine")
  }
  for (path in list(NULL, character(), NA_character_, "", 1, c(tmp, tmp), file.path(tmp, "missing"))) {
    expect_error(rqualify(path), "path_save")
  }
  for (name in c("setup_tinytex", "setup_pandoc", "render_latex", "verbose", "details")) {
    for (value in list(NA, NULL, 1, c(TRUE, FALSE))) {
      args <- c(list(path_save = tmp), setNames(list(value), name))
      expect_error(do.call(rqualify, args), name)
    }
  }
  expect_false(dir.exists(file.path(tmp, "R-validation")))
})

test_that("failed qualification remains failed in returned and saved details", {
  local_r_tests_dir_exists()
  summary <- passing_summary()
  summary$test_results[2] <- "FAIL"
  summary$system_results[2] <- "FAIL"
  summary$completed[2] <- FALSE
  summary$exit_status[2] <- 1L
  mock_report(summary)
  tmp <- withr::local_tempdir()
  expect_warning(result <- rqualify(tmp, details = TRUE, verbose = FALSE), "R-validation failed")
  expect_identical(result$status, "fail")
  expect_identical(readRDS(result$files$metadata)$status, "fail")
})

test_that("PATH changes are restored after setup failure", {
  local_r_tests_dir_exists()
  withr::local_envvar(PATH = "/original", RSTUDIO_PANDOC = NA_character_)
  local_mocked_bindings(setup_pandoc_env = function(...) {
    Sys.setenv(PATH = "/changed", RSTUDIO_PANDOC = "/changed")
    stop("setup failed")
  })
  tmp <- withr::local_tempdir()
  expect_error(rqualify(tmp), "setup failed")
  expect_identical(Sys.getenv("PATH"), "/original")
  expect_true(is.na(Sys.getenv("RSTUDIO_PANDOC", unset = NA_character_)))
})
