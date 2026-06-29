make_fake_tinytex <- function(parent, subdirs) {
  bin <- file.path(parent, "bin")
  dir.create(bin, recursive = TRUE)
  for (sd in subdirs) dir.create(file.path(bin, sd))
  parent
}

test_that("setup_tinytex_env(TRUE) prepends the detected bin subdir to PATH", {
  withr::local_envvar(PATH = "/usr/bin")
  withr::local_options(tinytex.install_packages = NULL)

  fake_root <- make_fake_tinytex(withr::local_tempdir(), "x86_64-linux")

  calls <- new.env(parent = emptyenv())
  calls$install_tinytex <- 0L
  calls$tinytex_root <- 0L

  local_mocked_bindings(
    install_tinytex = function(...) {
      calls$install_tinytex <- calls$install_tinytex + 1L
      invisible(NULL)
    },
    tinytex_root = function(...) {
      calls$tinytex_root <- calls$tinytex_root + 1L
      fake_root
    },
    is_tinytex = function() TRUE
  )

  expect_invisible(
    setup_tinytex_env(
      setup_tinytex = TRUE,
      render_latex = TRUE,
      verbose = FALSE
    )
  )

  expect_equal(calls$install_tinytex, 1L)
  expect_equal(calls$tinytex_root, 1L)
  expect_true(isTRUE(getOption("tinytex.install_packages")))
  expect_true(startsWith(Sys.getenv("PATH"), file.path(fake_root, "bin")))
})

test_that("setup_tinytex_env(TRUE) errors when TinyTeX bin/ is empty", {
  withr::local_envvar(PATH = "/usr/bin")

  fake_root <- withr::local_tempdir()
  dir.create(file.path(fake_root, "bin"))

  local_mocked_bindings(
    install_tinytex = function(...) invisible(NULL),
    tinytex_root    = function(...) fake_root,
    is_tinytex      = function() TRUE
  )

  expect_error(
    setup_tinytex_env(
      setup_tinytex = TRUE,
      render_latex = TRUE,
      verbose = FALSE
    ),
    class = "rqualify_tinytex_incomplete"
  )
})

test_that("setup_tinytex_env(FALSE) errors when TinyTeX absent and render needed", {
  local_mocked_bindings(
    is_tinytex = function() FALSE,
    install_tinytex = function(...) stop("should not be called"),
    tinytex_root = function() stop("should not be called")
  )

  expect_error(
    setup_tinytex_env(
      setup_tinytex = FALSE,
      render_latex = TRUE,
      verbose = FALSE
    ),
    class = "rqualify_tinytex_missing"
  )
})

test_that("setup_tinytex_env(FALSE) is a no-op when render_latex is FALSE", {
  local_mocked_bindings(
    is_tinytex = function() FALSE,
    install_tinytex = function(...) stop("should not be called"),
    tinytex_root = function() stop("should not be called")
  )

  expect_no_error(
    setup_tinytex_env(
      setup_tinytex = FALSE,
      render_latex = FALSE,
      verbose = FALSE
    )
  )
})

test_that("setup_tinytex_env(FALSE) succeeds when TinyTeX is already present", {
  local_mocked_bindings(
    is_tinytex = function() TRUE,
    install_tinytex = function(...) stop("should not be called"),
    tinytex_root = function() stop("should not be called")
  )

  expect_no_error(
    setup_tinytex_env(
      setup_tinytex = FALSE,
      render_latex = TRUE,
      verbose = FALSE
    )
  )
})

test_that("setup_tinytex_env(TRUE) prepends both win32 and windows subdirs when present", {
  withr::local_envvar(PATH = "C:\\Windows\\System32")

  fake_root <- make_fake_tinytex(withr::local_tempdir(), c("win32", "windows"))

  local_mocked_bindings(
    install_tinytex = function(...) invisible(NULL),
    tinytex_root    = function(...) fake_root,
    is_tinytex      = function() TRUE,
    path_sep        = function() ";"
  )

  setup_tinytex_env(
    setup_tinytex = TRUE,
    render_latex = TRUE,
    verbose = FALSE
  )

  new_path <- Sys.getenv("PATH")
  expect_match(new_path, "/bin/win32;", fixed = TRUE)
  expect_match(new_path, "/bin/windows;", fixed = TRUE)
  expect_match(new_path, "C:\\\\Windows\\\\System32$")
})

test_that("setup_tinytex_env(TRUE) handles macOS-style bin subdir", {
  withr::local_envvar(PATH = "/usr/bin")

  fake_root <- make_fake_tinytex(withr::local_tempdir(), "universal-darwin")

  local_mocked_bindings(
    install_tinytex = function(...) invisible(NULL),
    tinytex_root    = function(...) fake_root,
    is_tinytex      = function() TRUE
  )

  setup_tinytex_env(
    setup_tinytex = TRUE,
    render_latex = TRUE,
    verbose = FALSE
  )

  expect_true(startsWith(
    Sys.getenv("PATH"),
    file.path(fake_root, "bin", "universal-darwin")
  ))
})
