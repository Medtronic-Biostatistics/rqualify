test_that("errors when path_save is missing", {
  expect_error(setup_validation_dirs(), "path_save")
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
