test_that("rqualify() errors when path_save is missing without calling any helper", {
  calls <- character()
  fail_if_called <- function(...) {
    calls <<- c(calls, "called")
    stop("should not be called")
  }

  local_mocked_bindings(
    setup_validation_dirs    = fail_if_called,
    setup_tinytex_env        = fail_if_called,
    setup_pandoc_env         = fail_if_called,
    render_validation        = fail_if_called,
    check_validation_results = fail_if_called
  )

  expect_error(
    rqualify(setup_tinytex = FALSE, setup_pandoc = FALSE, verbose = FALSE),
    "path_save"
  )
  expect_length(calls, 0)
})

test_that("rqualify() forwards render_latex = FALSE to the relevant helpers", {
  seen <- list()
  fake_paths <- list(
    path_save           = "/fake",
    path_rvalidation    = "/fake/R-validation",
    path_iqoqtestoutput = "/fake/R-validation/IQ-OQ-TestOutput"
  )

  local_mocked_bindings(
    setup_validation_dirs = function(path_save) fake_paths,
    setup_tinytex_env = function(setup_tinytex, render_latex, verbose) {
      seen$tinytex_render_latex <<- render_latex
      invisible(NULL)
    },
    setup_pandoc_env = function(...) invisible(NULL),
    render_validation = function(path_rvalidation, engine, render_latex, verbose) {
      seen$render_render_latex <<- render_latex
      invisible(NULL)
    },
    check_validation_results = function(...) invisible("ok")
  )

  rqualify(path_save     = "/fake",
           engine        = "latex",
           setup_tinytex = FALSE,
           setup_pandoc  = FALSE,
           render_latex  = FALSE,
           verbose       = FALSE)

  expect_false(seen$tinytex_render_latex)
  expect_false(seen$render_render_latex)
})

test_that("rqualify() still returns the R-validation path when check_validation_results() warns", {
  fake_paths <- list(
    path_save           = "/fake",
    path_rvalidation    = "/fake/R-validation",
    path_iqoqtestoutput = "/fake/R-validation/IQ-OQ-TestOutput"
  )

  local_mocked_bindings(
    setup_validation_dirs    = function(path_save) fake_paths,
    setup_tinytex_env        = function(...) invisible(NULL),
    setup_pandoc_env         = function(...) invisible(NULL),
    render_validation        = function(...) invisible(NULL),
    check_validation_results = function(path_rvalidation) {
      warning("R-validation failed. Please check the output files in the 'R-validation' folder.")
      invisible("fail")
    }
  )

  expect_warning(
    result <- rqualify(path_save     = "/fake",
                       setup_tinytex = FALSE,
                       setup_pandoc  = FALSE,
                       verbose       = FALSE),
    "R-validation failed"
  )
  expect_identical(result, fake_paths$path_rvalidation)
})

test_that("rqualify() still returns the R-validation path when summary file is missing", {
  fake_paths <- list(
    path_save           = "/fake",
    path_rvalidation    = "/fake/R-validation",
    path_iqoqtestoutput = "/fake/R-validation/IQ-OQ-TestOutput"
  )

  local_mocked_bindings(
    setup_validation_dirs    = function(path_save) fake_paths,
    setup_tinytex_env        = function(...) invisible(NULL),
    setup_pandoc_env         = function(...) invisible(NULL),
    render_validation        = function(...) invisible(NULL),
    check_validation_results = function(path_rvalidation) {
      warning("Test summary file not found. Please check the output files in the 'R-validation' folder.")
      invisible("missing")
    }
  )

  expect_warning(
    result <- rqualify(path_save     = "/fake",
                       setup_tinytex = FALSE,
                       setup_pandoc  = FALSE,
                       verbose       = FALSE),
    "not found"
  )
  expect_identical(result, fake_paths$path_rvalidation)
})
