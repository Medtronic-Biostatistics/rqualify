test_that("only complete, valid passing results are accepted", {
  tmp <- withr::local_tempdir()
  write_test_summary(tmp)
  expect_no_warning(result <- check_validation_results(tmp))
  expect_identical(result, "ok")
  expect_equal(read_validation_results(tmp)$summary, passing_summary())
})

test_that("test and subprocess failures are reported", {
  tmp <- withr::local_tempdir()
  for (column in c("test_results", "system_results")) {
    summary <- passing_summary()
    summary[[column]][2] <- "FAIL"
    write_test_summary(tmp, summary)
    expect_warning(result <- check_validation_results(tmp), "R-validation failed")
    expect_identical(result, "fail")
  }
})

test_that("malformed, incomplete, and inconsistent summaries cannot pass", {
  tmp <- withr::local_tempdir()
  good <- passing_summary()
  bad <- list(
    missing_columns = data.frame(unrelated = "PASS"),
    empty = good[FALSE, ],
    missing_suite = good[-1, ],
    duplicate_suite = good[c(1:7, 7), ],
    missing_results = transform(good, test_results = NA_character_),
    invalid_result = transform(good, test_results = "unknown"),
    missing_system_results = transform(good, system_results = NA_character_),
    missing_completion = transform(good, completed = FALSE),
    nonzero_exit = transform(good, exit_status = 1L),
    missing_exit = transform(good, exit_status = NA_integer_)
  )
  for (name in names(bad)) {
    write_test_summary(tmp, bad[[name]])
    expect_warning(result <- check_validation_results(tmp), "invalid or incomplete", info = name)
    expect_identical(result, "invalid", info = name)
  }
})

test_that("missing summaries are reported distinctly", {
  tmp <- withr::local_tempdir()
  expect_warning(result <- check_validation_results(tmp), "not found")
  expect_identical(result, "missing")
})
