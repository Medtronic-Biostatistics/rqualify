make_validation_tree <- function(parent, summary_rows = NULL) {
  path_rvalidation <- file.path(parent, "R-validation")
  dir.create(path_rvalidation)
  dir.create(file.path(path_rvalidation, "IQ-OQ-TestOutput"))

  if (!is.null(summary_rows)) {
    write.csv(
      summary_rows,
      file.path(path_rvalidation, "IQ-OQ-TestOutput", "test_summary.csv"),
      row.names = FALSE
    )
  }

  path_rvalidation
}

test_that("returns 'ok' silently when all results pass", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- make_validation_tree(
    tmp,
    data.frame(
      system_results = c("PASS", "PASS"),
      test_results   = c("PASS", "PASS"),
      stringsAsFactors = FALSE
    )
  )

  expect_no_warning(
    res <- check_validation_results(path_rvalidation)
  )
  expect_identical(res, "ok")
})

test_that("warns and returns 'fail' when any test_results entry is FAIL", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- make_validation_tree(
    tmp,
    data.frame(
      system_results = c("PASS", "PASS"),
      test_results   = c("PASS", "FAIL"),
      stringsAsFactors = FALSE
    )
  )

  expect_warning(
    res <- check_validation_results(path_rvalidation),
    "R-validation failed"
  )
  expect_identical(res, "fail")
})

test_that("warns and returns 'fail' when any system_results entry is FAIL", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- make_validation_tree(
    tmp,
    data.frame(
      system_results = c("PASS", "FAIL"),
      test_results   = c("PASS", "PASS"),
      stringsAsFactors = FALSE
    )
  )

  expect_warning(
    res <- check_validation_results(path_rvalidation),
    "R-validation failed"
  )
  expect_identical(res, "fail")
})

test_that("warns and returns 'missing' when test_summary.csv is absent", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- make_validation_tree(tmp)  # no summary written

  expect_warning(
    res <- check_validation_results(path_rvalidation),
    "not found"
  )
  expect_identical(res, "missing")
})
