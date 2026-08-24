local_r_tests_dir_exists <- function(exists = TRUE, env = parent.frame()) {
  r_tests <- normalizePath(
    file.path(R.home(), "tests"),
    mustWork = FALSE,
    winslash = "/"
  )

  local_mocked_bindings(
    dir_exists = function(paths) {
      paths <- normalizePath(paths, mustWork = FALSE, winslash = "/")
      ifelse(paths == r_tests, exists, base::dir.exists(paths))
    },
    .env = env
  )
}

test_that("errors when path_save is missing", {
  expect_error(setup_validation_dirs(), "path_save")
})

test_that("errors when the R installation lacks a 'tests' folder", {
  tmp <- withr::local_tempdir()
  local_r_tests_dir_exists(FALSE)

  expect_error(
    setup_validation_dirs(tmp),
    "R installation does not contain 'tests' folder"
  )

  # Precondition should fire before any folders are created
  expect_false(dir.exists(file.path(tmp, "R-validation")))
})

test_that("creates the R-validation folder tree and returns normalized paths", {
  tmp <- withr::local_tempdir()
  local_r_tests_dir_exists()

  result <- setup_validation_dirs(tmp)

  expected_path_save <- normalizePath(tmp, winslash = "/")
  expected_path_rvalidation <- file.path(expected_path_save, "R-validation")
  expected_path_iqoqtestoutput <- file.path(
    expected_path_rvalidation,
    "IQ-OQ-TestOutput"
  )

  expect_identical(
    result,
    list(
      path_save = expected_path_save,
      path_rvalidation = expected_path_rvalidation,
      path_iqoqtestoutput = expected_path_iqoqtestoutput
    )
  )
  expect_equal(
    dir.exists(c(expected_path_rvalidation, expected_path_iqoqtestoutput)),
    c(TRUE, TRUE)
  )
})

test_that("errors when R-validation already exists at the destination", {
  tmp <- withr::local_tempdir()
  local_r_tests_dir_exists()
  dir.create(file.path(tmp, "R-validation"))

  expect_error(
    setup_validation_dirs(tmp),
    "Folder 'R-validation' already exists"
  )
  expect_equal(
    dir.exists(file.path(tmp, "R-validation", "IQ-OQ-TestOutput")),
    FALSE
  )
})

test_that("normalizes relative path_save before creating directories", {
  tmp <- withr::local_tempdir()
  local_r_tests_dir_exists()
  dir.create(file.path(tmp, "output"))
  withr::local_dir(tmp)

  result <- setup_validation_dirs("output")

  expected_path_save <- normalizePath("output", winslash = "/")
  expected_path_rvalidation <- file.path(expected_path_save, "R-validation")
  expected_path_iqoqtestoutput <- file.path(
    expected_path_rvalidation,
    "IQ-OQ-TestOutput"
  )

  expect_identical(
    result,
    list(
      path_save = expected_path_save,
      path_rvalidation = expected_path_rvalidation,
      path_iqoqtestoutput = expected_path_iqoqtestoutput
    )
  )
  expect_equal(
    dir.exists(c(expected_path_rvalidation, expected_path_iqoqtestoutput)),
    c(TRUE, TRUE)
  )
})
