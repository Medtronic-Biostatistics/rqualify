#' Set up Pandoc for the validation render
#'
#' Internal helper. If `setup_pandoc` is `TRUE`, installs and activates
#' Pandoc via the \pkg{pandoc} package. Otherwise, activates an existing
#' Pandoc installation or stops with an informative error.
#'
#' @param setup_pandoc Logical. Install and activate Pandoc.
#' @param verbose      Logical. Print progress messages.
#'
#' @return Invisibly, `NULL`. Called for side effects.
#'
#' @keywords internal
#' @noRd
setup_pandoc_env <- function(setup_pandoc, verbose) {
  if (setup_pandoc) {
    if (verbose) cat("\n=== Now setting up Pandoc ===\n")
    pandoc_install()
    pandoc_activate()
    return(invisible(NULL))
  }

  if (pandoc_available()) {
    pandoc_activate()
  } else {
    stop("Pandoc is not detected. Please set setup_pandoc to TRUE to install Pandoc.")
  }

  invisible(NULL)
}
