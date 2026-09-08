test_that("existing LaTeX is reused and non-PDF renders do not need it", {
  local_mocked_bindings(
    find_pdflatex = function() "/existing/pdflatex",
    install_tinytex = function(...) stop("must not install")
  )
  expect_no_error(setup_tinytex_env(TRUE, TRUE, FALSE))
  expect_no_error(setup_tinytex_env(FALSE, TRUE, FALSE))
  local_mocked_bindings(find_pdflatex = function() stop("must not inspect LaTeX"))
  expect_no_error(setup_tinytex_env(TRUE, FALSE, FALSE))
})

test_that("missing LaTeX is installed without forcing replacement", {
  installed <- FALSE
  local_mocked_bindings(
    find_pdflatex = function() if (installed) "/installed/pdflatex" else "",
    activate_tinytex_path = function() NULL,
    install_tinytex = function(bundle, force, extra_packages) {
      expect_false(force)
      expect_identical(extra_packages, "grfext")
      installed <<- TRUE
    }
  )
  expect_error(setup_tinytex_env(FALSE, TRUE, FALSE), "pdflatex.*not detected")
  expect_false(installed)
  expect_no_error(setup_tinytex_env(TRUE, TRUE, FALSE))
  expect_true(installed)
})

test_that("TinyTeX discovery uses actual binary directories on each platform", {
  root <- withr::local_tempdir()
  for (layout in c("universal-darwin", "aarch64-linux", "x86_64-linux", "windows", "win32")) {
    bin <- file.path(root, layout, "bin", layout)
    dir.create(bin, recursive = TRUE)
    windows <- layout %in% c("windows", "win32")
    file.create(file.path(bin, if (windows) "pdflatex.exe" else "pdflatex"))
    local_mocked_bindings(os_type = function() if (windows) "windows" else "unix")
    expect_identical(tinytex_bin_dirs(file.path(root, layout)), bin)
  }
  expect_length(tinytex_bin_dirs(""), 0)
})

test_that("discovered TinyTeX bins are activated without duplicate PATH entries", {
  root <- withr::local_tempdir()
  bin <- file.path(root, "bin", "universal-darwin")
  dir.create(bin, recursive = TRUE)
  file.create(file.path(bin, "pdflatex"))
  withr::local_envvar(PATH = "/usr/bin")
  local_mocked_bindings(tinytex_root = function() root, os_type = function() "unix", path_sep = function() ":")
  activate_tinytex_path()
  activate_tinytex_path()
  expect_identical(Sys.getenv("PATH"), paste(bin, "/usr/bin", sep = ":"))
})
