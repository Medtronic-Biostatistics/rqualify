test_that("render_validation() copies Rmd, renders, and runs pdflatex when render_latex=TRUE", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- file.path(tmp, "R-validation")
  dir.create(path_rvalidation)

  seen <- list(render = NULL, pdflatex = NULL, pdflatex_wd = NA_character_)

  local_mocked_bindings(
    render = function(input, output_format, quiet, ...) {
      seen$render <<- list(input = input,
                           output_format = output_format,
                           quiet = quiet)
      # Pretend rendering produced a .tex file
      file.create(file.path(dirname(input), "R-validation.tex"))
      invisible(input)
    },
    pdflatex = function(file, ...) {
      seen$pdflatex    <<- file
      seen$pdflatex_wd <<- getwd()
      invisible(file)
    }
  )

  starting_wd <- getwd()

  render_validation(path_rvalidation = path_rvalidation,
                    render_latex     = TRUE,
                    verbose          = FALSE)

  # Rmd copied into the validation folder
  expect_true(file.exists(file.path(path_rvalidation, "R-validation.Rmd")))

  # render() called with correct args
  expect_equal(normalizePath(seen$render$input, winslash = "/"),
               normalizePath(file.path(path_rvalidation, "R-validation.Rmd"),
                             winslash = "/"))
  expect_identical(seen$render$output_format, "latex_document")
  expect_true(seen$render$quiet)

  # pdflatex() called from the validation folder
  expect_equal(normalizePath(seen$pdflatex, winslash = "/"),
               normalizePath(file.path(path_rvalidation, "R-validation.tex"),
                             winslash = "/"))
  expect_equal(normalizePath(seen$pdflatex_wd, winslash = "/"),
               normalizePath(path_rvalidation, winslash = "/"))

  # Working directory restored at end of render_validation()
  expect_equal(getwd(), starting_wd)
})

test_that("render_validation() skips pdflatex when render_latex=FALSE", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- file.path(tmp, "R-validation")
  dir.create(path_rvalidation)

  called <- list(render = 0L, pdflatex = 0L)

  local_mocked_bindings(
    render = function(input, output_format, quiet, ...) {
      called$render <<- called$render + 1L
      invisible(input)
    },
    pdflatex = function(file, ...) {
      called$pdflatex <<- called$pdflatex + 1L
      invisible(file)
    }
  )

  render_validation(path_rvalidation = path_rvalidation,
                    render_latex     = FALSE,
                    verbose          = FALSE)

  expect_equal(called$render, 1L)
  expect_equal(called$pdflatex, 0L)
})

test_that("render_validation() uses verbose output and quiet=FALSE for latex mode", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- file.path(tmp, "R-validation")
  dir.create(path_rvalidation)

  seen <- list(render = NULL, pdflatex = NULL)

  local_mocked_bindings(
    render = function(input, output_format, quiet, ...) {
      seen$render <<- list(input = input,
                           output_format = output_format,
                           quiet = quiet)
      file.create(file.path(dirname(input), "R-validation.tex"))
      invisible(input)
    },
    pdflatex = function(file, ...) {
      seen$pdflatex <<- file
      invisible(file)
    }
  )

  expect_output(
    render_validation(path_rvalidation = path_rvalidation,
                      render_latex     = TRUE,
                      verbose          = TRUE),
    "Now generating RMarkdown.*RMarkdown report complete"
  )

  expect_identical(seen$render$quiet, FALSE)
  expect_equal(normalizePath(seen$pdflatex, winslash = "/"),
               normalizePath(file.path(path_rvalidation, "R-validation.tex"),
                             winslash = "/"))
})


test_that("render_validation() registers locale/language restoration on the caller's frame", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- file.path(tmp, "R-validation")
  dir.create(path_rvalidation)

  local_mocked_bindings(
    render   = function(input, output_format, quiet, ...) {
      file.create(file.path(dirname(input), "R-validation.tex"))
      invisible(input)
    },
    pdflatex = function(file, ...) invisible(file)
  )

  # Record locale/language as observed *before* and *during* the caller's body,
  # then again *after* it returns. The on.exit handlers registered by
  # render_validation should restore the originals only after the caller
  # returns (not when render_validation itself returns).
  original_collate  <- Sys.getlocale("LC_COLLATE")
  original_time     <- Sys.getlocale("LC_TIME")
  original_language <- Sys.getenv("LANGUAGE")

  observed <- list()

  caller_fn <- function() {
    render_validation(path_rvalidation = path_rvalidation,
                      render_latex     = TRUE,
                      verbose          = FALSE)
    # render_validation has returned; its cleanup handlers should NOT have
    # fired yet because they were attached to *this* frame's on.exit stack.
    observed$mid_collate  <<- Sys.getlocale("LC_COLLATE")
    observed$mid_time     <<- Sys.getlocale("LC_TIME")
    observed$mid_language <<- Sys.getenv("LANGUAGE")
  }
  caller_fn()

  # Inside caller_fn(), locale/language were the values render_validation set
  expect_identical(observed$mid_collate,  "C")
  expect_identical(observed$mid_time,     "C")
  expect_identical(observed$mid_language, "en")

  # After caller_fn() returns, originals are restored
  expect_identical(Sys.getlocale("LC_COLLATE"), original_collate)
  expect_identical(Sys.getlocale("LC_TIME"),    original_time)
  expect_identical(Sys.getenv("LANGUAGE"),      original_language)
})

test_that("render_validation() registers working-directory restoration on the caller's frame", {
  tmp <- withr::local_tempdir()
  path_rvalidation <- file.path(tmp, "R-validation")
  dir.create(path_rvalidation)

  local_mocked_bindings(
    render = function(input, output_format, quiet, ...) {
      file.create(file.path(dirname(input), "R-validation.tex"))
      invisible(input)
    },
    pdflatex = function(file, ...) invisible(file)
  )

  starting_wd <- getwd()

  # render_validation() itself does setwd(oldwd) at the end of the body
  # (so the wd is back to starting_wd by the time it returns). The
  # on.exit handler is a belt-and-braces restore in case pdflatex() errors.
  # We confirm the handler is on the caller's frame by inducing an error
  # *after* setwd-into-path_rvalidation but *before* render_validation's
  # own setwd-back. We trip this by having pdflatex() throw.
  local_mocked_bindings(
    render = function(input, output_format, quiet, ...) {
      file.create(file.path(dirname(input), "R-validation.tex"))
      invisible(input)
    },
    pdflatex = function(file, ...) stop("simulated pdflatex failure")
  )

  caller_fn <- function() {
    tryCatch(
      render_validation(path_rvalidation = path_rvalidation,
                        render_latex     = TRUE,
                        verbose          = FALSE),
      error = function(e) NULL
    )
    # If the wd handler were on render_validation's frame, it would have
    # fired already and we'd see starting_wd here. If it's on caller_fn's
    # frame (the desired behavior), the wd is still inside path_rvalidation.
    normalizePath(getwd(), winslash = "/")
  }

  mid_wd <- caller_fn()

  expect_equal(mid_wd,
               normalizePath(path_rvalidation, winslash = "/"))
  expect_equal(getwd(), starting_wd)
})
