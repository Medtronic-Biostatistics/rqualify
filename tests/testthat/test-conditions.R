test_that("check_string accepts a non-empty string", {
  expect_no_error(check_string("hello", "x"))
})

test_that("check_string rejects non-strings, wrong-length, NA, and empty", {
  for (bad in list(1L, TRUE, NA_character_, character(0), c("a", "b"), "")) {
    expect_error(
      check_string(bad, "x"),
      class = "rqualify_bad_arg"
    )
  }
})

test_that("check_flag accepts TRUE / FALSE", {
  expect_no_error(check_flag(TRUE, "x"))
  expect_no_error(check_flag(FALSE, "x"))
})

test_that("check_flag rejects non-logicals, wrong-length, and NA", {
  for (bad in list(1L, "yes", NA, logical(0), c(TRUE, FALSE))) {
    expect_error(
      check_flag(bad, "x"),
      class = "rqualify_bad_arg"
    )
  }
})

test_that("rqualify_stop signals an error with the requested subclass", {
  err <- tryCatch(
    rqualify_stop("rqualify_test_subclass", "boom", detail = 42),
    error = function(e) e
  )
  expect_s3_class(err, "rqualify_test_subclass")
  expect_s3_class(err, "rqualify_condition")
  expect_s3_class(err, "error")
  expect_identical(conditionMessage(err), "boom")
  expect_identical(err$detail, 42)
})

test_that("rqualify_warn signals a warning with the requested subclass", {
  w <- tryCatch(
    rqualify_warn("rqualify_test_subclass", "uh oh"),
    warning = function(w) w
  )
  expect_s3_class(w, "rqualify_test_subclass")
  expect_s3_class(w, "rqualify_condition")
  expect_s3_class(w, "warning")
  expect_identical(conditionMessage(w), "uh oh")
})
