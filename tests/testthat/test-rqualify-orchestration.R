test_that("rqualify() orchestrates helpers in the expected order with correct arguments", {
  state <- new.env(parent = emptyenv())
  state$calls <- list()
  record <- function(name, args = list()) {
    state$calls <- c(state$calls, list(list(name = name, args = args)))
  }

  fake_paths <- list(
    path_save           = "/fake/parent",
    path_rvalidation    = "/fake/parent/R-validation",
    path_iqoqtestoutput = "/fake/parent/R-validation/IQ-OQ-TestOutput"
  )

  local_mocked_bindings(
    setup_validation_dirs = function(path_save) {
      record("setup_validation_dirs", list(path_save = path_save))
      fake_paths
    },
    setup_tinytex_env = function(setup_tinytex, render_latex, verbose) {
      record(
        "setup_tinytex_env",
        list(
          setup_tinytex = setup_tinytex,
          render_latex = render_latex,
          verbose = verbose
        )
      )
      invisible(NULL)
    },
    setup_pandoc_env = function(setup_pandoc, verbose) {
      record(
        "setup_pandoc_env",
        list(setup_pandoc = setup_pandoc, verbose = verbose)
      )
      invisible(NULL)
    },
    render_validation = function(path_rvalidation, render_latex, verbose) {
      record(
        "render_validation",
        list(
          path_rvalidation = path_rvalidation,
          render_latex = render_latex,
          verbose = verbose
        )
      )
      invisible(NULL)
    },
    check_validation_results = function(path_rvalidation) {
      record(
        "check_validation_results",
        list(path_rvalidation = path_rvalidation)
      )
      invisible("ok")
    }
  )

  result <- rqualify(
    path_save     = "/fake/parent",
    setup_tinytex = FALSE,
    setup_pandoc  = FALSE,
    render_latex  = TRUE,
    verbose       = FALSE
  )

  # Return value is the R-validation path from setup_validation_dirs()
  expect_identical(result, fake_paths$path_rvalidation)

  calls <- state$calls

  # Each helper called exactly once, in the expected order
  expect_identical(
    vapply(calls, `[[`, character(1), "name"),
    c(
      "setup_validation_dirs",
      "setup_tinytex_env",
      "setup_pandoc_env",
      "render_validation",
      "check_validation_results"
    )
  )

  # Arguments propagated correctly
  expect_identical(calls[[1]]$args$path_save, "/fake/parent")

  expect_identical(
    calls[[2]]$args,
    list(
      setup_tinytex = FALSE,
      render_latex = TRUE,
      verbose = FALSE
    )
  )

  expect_identical(
    calls[[3]]$args,
    list(setup_pandoc = FALSE, verbose = FALSE)
  )

  expect_identical(
    calls[[4]]$args,
    list(
      path_rvalidation = fake_paths$path_rvalidation,
      render_latex = TRUE,
      verbose = FALSE
    )
  )

  expect_identical(
    calls[[5]]$args,
    list(path_rvalidation = fake_paths$path_rvalidation)
  )
})

test_that("rqualify() errors when path_save is missing without calling any helper", {
  state <- new.env(parent = emptyenv())
  state$called <- 0L
  fail_if_called <- function(...) {
    state$called <- state$called + 1L
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
  expect_identical(state$called, 0L)
})

test_that("rqualify() forwards render_latex = FALSE to the relevant helpers", {
  seen <- new.env(parent = emptyenv())
  fake_paths <- list(
    path_save           = "/fake",
    path_rvalidation    = "/fake/R-validation",
    path_iqoqtestoutput = "/fake/R-validation/IQ-OQ-TestOutput"
  )

  local_mocked_bindings(
    setup_validation_dirs = function(path_save) fake_paths,
    setup_tinytex_env = function(setup_tinytex, render_latex, verbose) {
      seen$tinytex_render_latex <- render_latex
      invisible(NULL)
    },
    setup_pandoc_env = function(...) invisible(NULL),
    render_validation = function(path_rvalidation, render_latex, verbose) {
      seen$render_render_latex <- render_latex
      invisible(NULL)
    },
    check_validation_results = function(...) invisible("ok")
  )

  rqualify(
    path_save = "/fake",
    setup_tinytex = FALSE,
    setup_pandoc = FALSE,
    render_latex = FALSE,
    verbose = FALSE
  )

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
    setup_validation_dirs = function(path_save) fake_paths,
    setup_tinytex_env = function(...) invisible(NULL),
    setup_pandoc_env = function(...) invisible(NULL),
    render_validation = function(...) invisible(NULL),
    check_validation_results = function(path_rvalidation) {
      warning("R-validation failed. Please check the output files in the 'R-validation' folder.")
      invisible("fail")
    }
  )

  expect_warning(
    result <- rqualify(
      path_save = "/fake",
      setup_tinytex = FALSE,
      setup_pandoc = FALSE,
      verbose = FALSE
    ),
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
    setup_validation_dirs = function(path_save) fake_paths,
    setup_tinytex_env = function(...) invisible(NULL),
    setup_pandoc_env = function(...) invisible(NULL),
    render_validation = function(...) invisible(NULL),
    check_validation_results = function(path_rvalidation) {
      warning(
        "Test summary file not found. ",
        "Please check the output files in the 'R-validation' folder."
      )
      invisible("missing")
    }
  )

  expect_warning(
    result <- rqualify(
      path_save = "/fake",
      setup_tinytex = FALSE,
      setup_pandoc = FALSE,
      verbose = FALSE
    ),
    "not found"
  )
  expect_identical(result, fake_paths$path_rvalidation)
})

test_that("rqualify() rejects non-string path_save", {
  expect_error(rqualify(path_save = 1L), class = "rqualify_bad_arg")
  expect_error(rqualify(path_save = c("a", "b")), class = "rqualify_bad_arg")
  expect_error(rqualify(path_save = NA_character_), class = "rqualify_bad_arg")
  expect_error(rqualify(path_save = ""), class = "rqualify_bad_arg")
})

test_that("rqualify() rejects non-logical setup_* / render_latex / verbose", {
  expect_error(
    rqualify(path_save = "/tmp", setup_tinytex = "yes"),
    class = "rqualify_bad_arg"
  )
  expect_error(
    rqualify(path_save = "/tmp", setup_pandoc = 1),
    class = "rqualify_bad_arg"
  )
  expect_error(
    rqualify(path_save = "/tmp", render_latex = NA),
    class = "rqualify_bad_arg"
  )
  expect_error(
    rqualify(path_save = "/tmp", verbose = c(TRUE, FALSE)),
    class = "rqualify_bad_arg"
  )
})

test_that("rqualify() validates arguments before calling any helper", {
  state <- new.env(parent = emptyenv())
  state$called <- 0L
  fail_if_called <- function(...) {
    state$called <- state$called + 1L
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
    rqualify(path_save = "/tmp", verbose = "loud"),
    class = "rqualify_bad_arg"
  )
  expect_identical(state$called, 0L)
})

test_that("rqualify() signals classed error when path_save is missing", {
  expect_error(rqualify(), class = "rqualify_missing_arg")
})
