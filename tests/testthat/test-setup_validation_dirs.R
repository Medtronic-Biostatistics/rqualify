test_that("creates R-validation and IQ-OQ-TestOutput folders and returns paths", {
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
  tmp <- withr::local_tempdir()

  paths <- setup_validation_dirs(tmp)

  expect_false(grepl("\\\\", paths$path_save))
})

test_that("errors when path_save is missing", {
  expect_error(setup_validation_dirs(), "path_save")
})

test_that("errors when an R-validation folder already exists", {
  tmp <- withr::local_tempdir()
  dir.create(file.path(tmp, "R-validation"))

  expect_error(setup_validation_dirs(tmp), "already exists")
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
    "R installation does not contain 'tests' folder"
  )

  # Precondition should fire before any folders are created
  expect_false(dir.exists(file.path(tmp, "R-validation")))
})
