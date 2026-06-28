# Several tests below call setup_validation_dirs() with a real path and so
# would hit the `R.home()/tests` precondition. On CRAN-style CI runners R is
# often installed without its test suite, so that folder may be absent and
# the precondition would fire first. Stub dir_exists() to report the tests
# folder as present, delegating to the real dir.exists() for everything else.
local_allow_tests_folder <- function(env = parent.frame()) {
  r_tests <- file.path(R.home(), "tests")
  testthat::local_mocked_bindings(
    dir_exists = function(paths) {
      if (identical(paths, r_tests)) TRUE else base::dir.exists(paths)
    },
    .env = env
  )
}

test_that("creates R-validation and IQ-OQ-TestOutput folders and returns paths", {
  local_allow_tests_folder()
  tmp <- withr::local_tempdir()

  paths <- setup_validation_dirs(tmp)

  expect_type(paths, "list")
  expect_named(paths, c("path_save", "path_rvalidation", "path_iqoqtestoutput"))
  expect_true(dir.exists(paths$path_rvalidation))
  expect_true(dir.exists(paths$path_iqoqtestoutput))
  expect_equal(basename(paths$path_rvalidation), "R-validation")
  expect_equal(basename(paths$path_iqoqtestoutput), "IQ-OQ-TestOutput")
  expect_equal(
    paths$path_iqoqtestoutput,
    file.path(paths$path_rvalidation, "IQ-OQ-TestOutput")
  )
})

test_that("normalizes path_save using forward slashes", {
  local_allow_tests_folder()
  tmp <- withr::local_tempdir()

  paths <- setup_validation_dirs(tmp)

  expect_false(grepl("\\\\", paths$path_save))
})

test_that("errors when path_save is missing", {
  expect_error(setup_validation_dirs(), class = "rqualify_missing_arg")
})

test_that("errors when an R-validation folder already exists", {
  local_allow_tests_folder()
  tmp <- withr::local_tempdir()
  dir.create(file.path(tmp, "R-validation"))

  expect_error(setup_validation_dirs(tmp), class = "rqualify_dir_exists")
})

test_that("errors when the R installation lacks a 'tests' folder", {
  tmp <- withr::local_tempdir()
  r_tests <- file.path(R.home(), "tests")

  local_mocked_bindings(
    dir_exists = function(paths) {
      if (identical(paths, r_tests)) FALSE else base::dir.exists(paths)
    }
  )

  expect_error(
    setup_validation_dirs(tmp),
    class = "rqualify_no_tests_folder"
  )

  # Precondition should fire before any folders are created
  expect_false(dir.exists(file.path(tmp, "R-validation")))
})

test_that("removes the outer R-validation folder when the inner dir.create fails", {
  # On Unix, chmod 0555 on the parent makes it read+execute only, so the
  # dir.create() calls inside setup_validation_dirs() cannot succeed. We assert
  # that we still get a classed rqualify_dir_create_failed error and that no
  # R-validation folder is left behind.
  skip_on_os("windows")
  local_allow_tests_folder()

  tmp <- withr::local_tempdir()
  locked <- file.path(tmp, "locked")
  dir.create(locked)
  Sys.chmod(locked, mode = "0555")
  withr::defer(Sys.chmod(locked, mode = "0755"))

  result <- tryCatch(
    suppressWarnings(setup_validation_dirs(locked)),
    error = function(e) e
  )
  expect_s3_class(result, "rqualify_dir_create_failed")
  expect_false(dir.exists(file.path(locked, "R-validation")))
})
