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
  bin <- file.path(root, "bin", "native")
  dir.create(bin, recursive = TRUE)
  executable <- if (.Platform$OS.type == "windows") "pdflatex.exe" else "pdflatex"
  file.create(file.path(bin, executable))
  original <- file.path(root, "existing tools")
  withr::local_envvar(PATH = original)
  local_mocked_bindings(tinytex_root = function() root)
  activate_tinytex_path()
  activate_tinytex_path()
  expect_identical(Sys.getenv("PATH"), paste(bin, original, sep = .Platform$path.sep))
})

test_that("Windows PATH activation preserves drive letters and spaces", {
  bin <- "C:/Users/Example User/TinyTeX/bin/windows"
  original <- "C:/Windows/System32;D:/Other Tools"
  withr::local_envvar(PATH = original)
  local_mocked_bindings(
    tinytex_root = function() "C:/Users/Example User/TinyTeX",
    tinytex_bin_dirs = function(root) bin,
    path_sep = function() ";"
  )
  activate_tinytex_path()
  activate_tinytex_path()
  expect_identical(Sys.getenv("PATH"), paste(bin, original, sep = ";"))
})

test_that("setup activates an existing TinyTeX executable before installing", {
  root <- withr::local_tempdir()
  bin <- file.path(root, "bin", "native")
  dir.create(bin, recursive = TRUE)
  executable <- file.path(bin, if (.Platform$OS.type == "windows") "pdflatex.exe" else "pdflatex")
  file.create(executable)
  Sys.chmod(executable, "0755")
  withr::local_envvar(PATH = "")
  local_mocked_bindings(
    tinytex_root = function() root,
    install_tinytex = function(...) stop("must not install")
  )
  expect_identical(find_pdflatex(), "")
  expect_no_error(setup_tinytex_env(FALSE, TRUE, FALSE))
  expect_identical(normalizePath(find_pdflatex(), winslash = "/"), normalizePath(executable, winslash = "/"))
})

test_that("TinyTeX installation failures do not establish a usable renderer", {
  local_mocked_bindings(
    find_pdflatex = function() "",
    activate_tinytex_path = function() NULL,
    install_tinytex = function(...) NULL
  )
  expect_output(
    expect_error(setup_tinytex_env(TRUE, TRUE, TRUE), "did not provide a usable pdflatex"),
    "Now setting up TinyTeX"
  )
})

test_that("failed TinyTeX discovery leaves PATH untouched", {
  withr::local_envvar(PATH = "original path")
  local_mocked_bindings(tinytex_root = function() stop("TinyTeX is not installed"))
  expect_no_error(activate_tinytex_path())
  expect_identical(Sys.getenv("PATH"), "original path")
})
