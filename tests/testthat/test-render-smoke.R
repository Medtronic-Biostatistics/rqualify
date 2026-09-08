# Opt-in integration tests compile the real templates using short subprocess
# fixtures. The full installed-R test suites are intentionally not run in CI.
smoke_template <- function(engine, path) {
  ext <- if (engine == "latex") "Rmd" else "qmd"
  template <- readLines(system.file("qualify_r", paste0("R-validation.", ext), package = "rqualify"))
  template <- gsub("rqualify:::run_validation_suite", "smoke_suite", template, fixed = TRUE)
  fixture <- c(
    "smoke_suite <- function(suite, folder_output) {",
    '  index <- match(suite, names(rqualify:::validation_suites())) - 1L',
    '  code <- if (suite == "basic") "stop(\'deliberate smoke-test crash\')" else rqualify:::validation_suite_code("iq", folder_output)',
    '  run <- rqualify:::run_validation_code(code, if (index == 0L) "rbanner" else paste0("CMDFile", index), folder_output)',
    "  run$suite <- suite",
    "  run",
    "}"
  )
  start <- grep("^```\\{r codeexec,", template)
  template <- append(template, fixture, after = start)
  input <- file.path(path, paste0("R-validation.", ext))
  writeLines(template, input)
  input
}

for (engine in c("latex", "quarto")) local({
  engine <- engine
  test_that(paste(engine, "template renders a PDF and preserves a crashed suite as FAIL"), {
    skip_if(Sys.getenv("RQUALIFY_RENDER_SMOKE") != "true", "Opt-in renderer integration test")
    tmp <- withr::local_tempdir()
    withr::local_dir(tmp)
    withr::local_options(tinytex.install_packages = FALSE)
    withr::local_envvar(QUARTO_R = file.path(R.home("bin"), "Rscript"),
                       R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep))
    dir.create(file.path(tmp, "IQ-OQ-TestOutput"))
    input <- smoke_template(engine, tmp)
    if (engine == "latex") {
      rmarkdown::render(input, output_format = "latex_document", quiet = TRUE,
                        envir = new.env(parent = globalenv()))
      tinytex::pdflatex(file.path(tmp, "R-validation.tex"))
    } else {
      quarto::quarto_render(input, quiet = TRUE, as_job = FALSE)
    }
    pdf <- file.path(tmp, "R-validation.pdf")
    expect_true(file.exists(pdf))
    expect_identical(readChar(pdf, nchars = 4L, useBytes = TRUE), "%PDF")
    summary <- read_validation_results(tmp)
    expect_identical(summary$status, "fail")
    expect_identical(summary$summary$test_results, c("PASS", "FAIL", rep("PASS", 6)))
    expect_identical(summary$summary$exit_status[2], 1L)
    expect_false(summary$summary$completed[2])
  })
})
