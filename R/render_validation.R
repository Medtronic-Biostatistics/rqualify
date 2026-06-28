#' Render the R-validation RMarkdown document
#'
#' Internal helper. Copies the bundled `R-validation.Rmd` into
#' `path_rvalidation`, temporarily sets the locale and `LANGUAGE`
#' environment variable to the values required by the core R test suite,
#' renders the document to LaTeX, and (optionally) compiles the resulting
#' `.tex` to PDF.
#'
#' Locale, language, and working-directory restoration is registered on
#' the caller's exit handler stack (via `on_exit_frame`) so that those
#' settings persist for the lifetime of the calling function rather than
#' being reset when this helper returns.
#'
#' @param path_rvalidation Character. Path to the `R-validation` folder.
#' @param render_latex     Logical. Compile the rendered `.tex` to PDF.
#' @param verbose          Logical. Print progress messages.
#' @param on_exit_frame    An environment whose `on.exit` stack should
#'   receive cleanup handlers. Defaults to `parent.frame()`.
#'
#' @return Invisibly, the path to the rendered `R-validation.Rmd`.
#'
#' @keywords internal
#' @noRd
render_validation <- function(path_rvalidation,
                              render_latex,
                              verbose,
                              on_exit_frame = parent.frame()) {
  # `on_exit_frame` defaults to the caller's frame so that locale, language,
  # and working-directory restoration handlers persist for the lifetime of
  # the calling function rather than firing when render_validation() itself
  # returns. Pass an explicit environment to override (mainly for tests).
  path_rmd <- file.path("qualify_r", "R-validation.Rmd")
  file.copy(
    system.file(path_rmd, package = "rqualify"),
    path_rvalidation
  )

  current_locale_collate <- Sys.getlocale("LC_COLLATE")
  current_locale_time <- Sys.getlocale("LC_TIME")
  current_language <- Sys.getenv("LANGUAGE")

  register_on_exit(
    bquote(Sys.setlocale("LC_COLLATE", .(current_locale_collate))),
    on_exit_frame
  )
  register_on_exit(
    bquote(Sys.setlocale("LC_TIME", .(current_locale_time))),
    on_exit_frame
  )
  register_on_exit(
    bquote(Sys.setenv("LANGUAGE" = .(current_language))),
    on_exit_frame
  )

  Sys.setlocale("LC_COLLATE", "C")
  Sys.setlocale("LC_TIME", "C")
  Sys.setenv(LANGUAGE = "en")

  if (verbose) cat("\n=== Now generating RMarkdown ===\n")

  input_rmd <- file.path(path_rvalidation, "R-validation.Rmd")
  render(
    input         = input_rmd,
    output_format = "latex_document",
    quiet         = !verbose
  )

  if (render_latex) {
    path_tex <- file.path(path_rvalidation, "R-validation.tex")

    oldwd <- getwd()
    register_on_exit(bquote(setwd(.(oldwd))), on_exit_frame)

    if (verbose) cat("\n=== Now compiling LaTeX to PDF ===\n")

    setwd(path_rvalidation)
    pdflatex(path_tex)
    setwd(oldwd)

    if (verbose) cat("\n=== RMarkdown report complete ===\n")
  }

  invisible(input_rmd)
}

#' Register an expression on a target frame's `on.exit` stack
#'
#' @keywords internal
#' @noRd
register_on_exit <- function(expr, frame) {
  do.call(
    "on.exit",
    list(expr, add = TRUE),
    envir = frame
  )
}
