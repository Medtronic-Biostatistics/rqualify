test_that("setup_pandoc_env(TRUE) installs and activates Pandoc", {
  calls <- list(install = 0L, activate = 0L)

  local_mocked_bindings(
    pandoc_install = function(...) {
      calls$install <<- calls$install + 1L
      invisible(NULL)
    },
    pandoc_activate = function(...) {
      calls$activate <<- calls$activate + 1L
      invisible(NULL)
    },
    pandoc_available = function(...) stop("should not be consulted when setup_pandoc=TRUE")
  )

  expect_invisible(
    setup_pandoc_env(setup_pandoc = TRUE, verbose = FALSE)
  )
  expect_equal(calls$install, 1L)
  expect_equal(calls$activate, 1L)
})

test_that("setup_pandoc_env(FALSE) activates when Pandoc is already available", {
  calls <- list(install = 0L, activate = 0L)

  local_mocked_bindings(
    pandoc_install = function(...) {
      calls$install <<- calls$install + 1L
      invisible(NULL)
    },
    pandoc_activate = function(...) {
      calls$activate <<- calls$activate + 1L
      invisible(NULL)
    },
    pandoc_available = function(...) TRUE
  )

  expect_no_error(
    setup_pandoc_env(setup_pandoc = FALSE, verbose = FALSE)
  )
  expect_equal(calls$install, 0L)
  expect_equal(calls$activate, 1L)
})

test_that("setup_pandoc_env(FALSE) errors when Pandoc is unavailable", {
  local_mocked_bindings(
    pandoc_install   = function(...) stop("should not be called"),
    pandoc_activate  = function(...) stop("should not be called"),
    pandoc_available = function(...) FALSE
  )

  expect_error(
    setup_pandoc_env(setup_pandoc = FALSE, verbose = FALSE),
    "Pandoc is not detected"
  )
})
