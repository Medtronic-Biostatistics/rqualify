test_that("an available system or IDE Pandoc is reused", {
  local_mocked_bindings(
    render_pandoc_available = function() TRUE,
    pandoc_install = function(...) stop("must not install"),
    pandoc_activate = function(...) stop("must not change active Pandoc")
  )
  expect_no_error(setup_pandoc_env(TRUE, FALSE))
  expect_no_error(setup_pandoc_env(FALSE, FALSE))
})

test_that("managed Pandoc is activated without reinstalling", {
  seen <- FALSE
  local_mocked_bindings(
    render_pandoc_available = function() FALSE,
    pandoc_available = function() TRUE,
    pandoc_install = function(...) stop("must not install"),
    pandoc_activate = function(quiet) { seen <<- quiet }
  )
  setup_pandoc_env(FALSE, FALSE)
  expect_true(seen)
})

test_that("Pandoc is installed only when missing and explicitly enabled", {
  installed <- activated <- FALSE
  local_mocked_bindings(
    render_pandoc_available = function() activated,
    pandoc_available = function() FALSE,
    pandoc_install = function(...) { installed <<- TRUE },
    pandoc_activate = function(...) { activated <<- TRUE }
  )
  expect_error(setup_pandoc_env(FALSE, FALSE), "Pandoc is not detected")
  expect_false(installed)
  expect_no_error(setup_pandoc_env(TRUE, FALSE))
  expect_true(installed)
  expect_true(activated)
})

test_that("an installation without a usable Pandoc renderer fails", {
  local_mocked_bindings(pandoc_available = function(...) FALSE, .package = "rmarkdown")
  local_mocked_bindings(
    pandoc_available = function() FALSE,
    pandoc_install = function() NULL,
    pandoc_activate = function(quiet) expect_false(quiet)
  )
  expect_output(
    expect_error(setup_pandoc_env(TRUE, TRUE), "did not provide a usable renderer"),
    "Now setting up Pandoc"
  )
})

test_that("Quarto must satisfy the minimum version before rendering", {
  available <- FALSE
  local_mocked_bindings(
    quarto_available = function(min) {
      expect_identical(min, "1.4")
      available
    }, .package = "quarto"
  )
  expect_error(setup_quarto_env(), "Quarto >= 1.4 is required")
  available <- TRUE
  expect_no_error(setup_quarto_env())
})
