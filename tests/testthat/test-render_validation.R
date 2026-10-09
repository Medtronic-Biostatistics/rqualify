test_that("LaTeX rendering copies the template and produces the requested artifact", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    render = function(input, output_format, quiet) {
      expect_true(file.exists(input))
      expect_identical(output_format, "latex_document")
      expect_true(quiet)
      file.create(file.path(dirname(input), "R-validation.tex"))
    },
    pdflatex = function(file) {
      expect_equal(normalizePath(getwd()), normalizePath(tmp))
      file.create(sub("tex$", "pdf", file))
    }
  )
  oldwd <- getwd()
  result <- render_validation(tmp, TRUE, verbose = FALSE)
  expect_identical(result, file.path(tmp, "R-validation.Rmd"))
  expect_true(file.exists(file.path(tmp, "R-validation.pdf")))
  expect_identical(getwd(), oldwd)
})

test_that("LaTeX-only rendering does not invoke pdflatex", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    render = function(input, ...) file.create(file.path(dirname(input), "R-validation.tex")),
    pdflatex = function(...) stop("must not compile")
  )
  expect_no_error(render_validation(tmp, FALSE, verbose = FALSE))
  expect_false(file.exists(file.path(tmp, "R-validation.pdf")))
})

test_that("Quarto renders synchronously and respects quiet mode", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    render = function(...) stop("must not invoke R Markdown"),
    pdflatex = function(...) stop("must not invoke LaTeX"),
    quarto_render = function(input, quiet, as_job) {
      expect_true(file.exists(input))
      expect_true(quiet)
      expect_false(as_job)
      file.create(file.path(dirname(input), "R-validation.pdf"))
    }
  )
  expect_output(result <- render_validation(tmp, TRUE, engine = "quarto", verbose = FALSE), NA)
  expect_identical(result, file.path(tmp, "R-validation.qmd"))
  expect_true(file.exists(file.path(tmp, "R-validation.pdf")))
})

test_that("a renderer that produces no artifact cannot silently succeed", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(render = function(...) NULL, quarto_render = function(...) NULL)
  expect_error(render_validation(tmp, FALSE, verbose = FALSE), "expected LaTeX report")
  expect_error(render_validation(tmp, FALSE, engine = "quarto", verbose = FALSE), "expected PDF report")
})

test_that("render errors restore working directory, locale, and language", {
  tmp <- withr::local_tempdir()
  oldwd <- getwd()
  old_collate <- Sys.getlocale("LC_COLLATE")
  old_time <- Sys.getlocale("LC_TIME")
  withr::local_envvar(LANGUAGE = NA_character_)
  local_mocked_bindings(
    render = function(input, ...) file.create(file.path(dirname(input), "R-validation.tex")),
    pdflatex = function(...) stop("deliberate renderer failure")
  )
  caller <- function() render_validation(tmp, TRUE, verbose = FALSE)
  expect_error(caller(), "deliberate renderer failure")
  expect_identical(getwd(), oldwd)
  expect_identical(Sys.getlocale("LC_COLLATE"), old_collate)
  expect_identical(Sys.getlocale("LC_TIME"), old_time)
  expect_true(is.na(Sys.getenv("LANGUAGE", unset = NA_character_)))
})

test_that("template copy failures stop before invoking either renderer", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(file.copy = function(...) FALSE, .package = "base")
  local_mocked_bindings(
    render = function(...) stop("must not render"),
    quarto_render = function(...) stop("must not render")
  )
  expect_error(render_validation(tmp, TRUE, verbose = FALSE), "Could not copy the RMarkdown report template")
  expect_error(render_validation(tmp, TRUE, engine = "quarto", verbose = FALSE), "Could not copy the Quarto report template")
})

test_that("a LaTeX compiler that produces no PDF cannot silently succeed", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    render = function(input, ...) file.create(file.path(dirname(input), "R-validation.tex")),
    pdflatex = function(...) NULL
  )
  expect_error(render_validation(tmp, TRUE, verbose = FALSE), "LaTeX did not produce the expected PDF report")
})

test_that("verbose rendering reports progress and enables renderer output", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(
    render = function(input, output_format, quiet) {
      expect_false(quiet)
      file.create(file.path(dirname(input), "R-validation.tex"))
    },
    pdflatex = function(file) file.create(sub("tex$", "pdf", file)),
    quarto_render = function(input, quiet, as_job) {
      expect_false(quiet)
      expect_false(as_job)
      file.create(file.path(dirname(input), "R-validation.pdf"))
    }
  )
  expect_output(render_validation(tmp, TRUE, verbose = TRUE), "RMarkdown report complete")
  expect_output(render_validation(tmp, TRUE, engine = "quarto", verbose = TRUE), "Now generating PDF")
})
