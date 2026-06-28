test_that("setup_tinytex_env(TRUE) installs TinyTeX and prepends bin to PATH", {
  withr::local_envvar(PATH = "/usr/bin")
  withr::local_options(tinytex.install_packages = NULL)

  calls <- list(install_tinytex = 0L, tinytex_root = 0L)

  local_mocked_bindings(
    install_tinytex = function(...) {
      calls$install_tinytex <<- calls$install_tinytex + 1L
      invisible(NULL)
    },
    tinytex_root = function(...) {
      calls$tinytex_root <<- calls$tinytex_root + 1L
      "/fake/TinyTeX"
    },
    is_tinytex = function() TRUE
  )

  expect_invisible(
    setup_tinytex_env(setup_tinytex = TRUE,
                      render_latex  = TRUE,
                      verbose       = FALSE)
  )

  expect_equal(calls$install_tinytex, 1L)
  expect_equal(calls$tinytex_root, 1L)
  expect_true(isTRUE(getOption("tinytex.install_packages")))
  expect_true(startsWith(Sys.getenv("PATH"), "/fake/TinyTeX"))
})

test_that("setup_tinytex_env(FALSE) errors when TinyTeX absent and render needed", {
  local_mocked_bindings(
    is_tinytex = function() FALSE,
    install_tinytex = function(...) stop("should not be called"),
    tinytex_root = function() stop("should not be called")
  )

  expect_error(
    setup_tinytex_env(setup_tinytex = FALSE,
                      render_latex  = TRUE,
                      verbose       = FALSE),
    "TinyTeX is not detected"
  )
})

test_that("setup_tinytex_env(FALSE) is a no-op when render_latex is FALSE", {
  local_mocked_bindings(
    is_tinytex = function() FALSE,
    install_tinytex = function(...) stop("should not be called"),
    tinytex_root = function() stop("should not be called")
  )

  expect_no_error(
    setup_tinytex_env(setup_tinytex = FALSE,
                      render_latex  = FALSE,
                      verbose       = FALSE)
  )
})

test_that("setup_tinytex_env(FALSE) succeeds when TinyTeX is already present", {
  local_mocked_bindings(
    is_tinytex = function() TRUE,
    install_tinytex = function(...) stop("should not be called"),
    tinytex_root = function() stop("should not be called")
  )

  expect_no_error(
    setup_tinytex_env(setup_tinytex = FALSE,
                      render_latex  = TRUE,
                      verbose       = FALSE)
  )
})

test_that("setup_tinytex_env(TRUE) builds a Windows-shaped PATH on Windows", {
  withr::local_envvar(PATH = "C:\\Windows\\System32")

  local_mocked_bindings(
    install_tinytex = function(...) invisible(NULL),
    tinytex_root    = function(...) "C:/TinyTeX",
    is_tinytex      = function() TRUE,
    os_type         = function() "windows",
    path_sep        = function() ";"
  )

  setup_tinytex_env(setup_tinytex = TRUE,
                    render_latex  = TRUE,
                    verbose       = FALSE)

  new_path <- Sys.getenv("PATH")

  # Both Windows bin variants are prepended, semicolon-separated, ahead of
  # the original PATH.
  expect_match(new_path,
               "^C:/TinyTeX/bin/win32;C:/TinyTeX/bin/windows;C:\\\\Windows\\\\System32$")
})

test_that("setup_tinytex_env(TRUE) builds a Linux-shaped PATH on non-Windows", {
  withr::local_envvar(PATH = "/usr/bin")

  local_mocked_bindings(
    install_tinytex = function(...) invisible(NULL),
    tinytex_root    = function(...) "/opt/TinyTeX",
    is_tinytex      = function() TRUE,
    os_type         = function() "unix",
    path_sep        = function() ":"
  )

  setup_tinytex_env(setup_tinytex = TRUE,
                    render_latex  = TRUE,
                    verbose       = FALSE)

  expect_identical(Sys.getenv("PATH"),
                   "/opt/TinyTeX/bin/x86_64-linux:/usr/bin")
})
