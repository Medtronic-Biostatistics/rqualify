#' Set up TinyTeX for the validation render
#'
#' Internal helper. If `setup_tinytex` is `TRUE`, installs the TinyTeX
#' bundle (plus the `grfext` package) and prepends its `bin` directory to
#' the session `PATH`. If `setup_tinytex` is `FALSE`, verifies that a
#' working TinyTeX is already present whenever a LaTeX render will be
#' attempted.
#'
#' @param setup_tinytex Logical. Install and activate TinyTeX.
#' @param render_latex  Logical. Whether a downstream LaTeX render will run;
#'   used to decide whether a missing TinyTeX is fatal when
#'   `setup_tinytex = FALSE`.
#' @param verbose       Logical. Print progress messages.
#'
#' @return Invisibly, `NULL`. Called for side effects (installation, PATH
#'   mutation, option setting).
#'
#' @keywords internal
#' @noRd
setup_tinytex_env <- function(setup_tinytex, render_latex, verbose) {
  if (setup_tinytex) {
    if (verbose) cat("\n=== Now setting up tinytex ===\n")

    install_tinytex(
      bundle         = "TinyTeX",
      force          = TRUE,
      extra_packages = "grfext"
    )

    options(tinytex.install_packages = TRUE)

    path_TinyTeX <- tinytex_root()
    bin_root <- file.path(path_TinyTeX, "bin")

    # tinytex::install_tinytex() lays down exactly one OS-specific subdir
    # under bin/ (e.g. windows, win32, x86_64-linux, aarch64-linux,
    # universal-darwin). Detect it rather than hardcoding, so this works on
    # macOS and aarch64-linux as well as Windows and x86_64-linux.
    bin_subdirs <- list.dirs(bin_root, recursive = FALSE, full.names = TRUE)
    if (length(bin_subdirs) == 0) {
      stop(
        "Could not locate a bin/ subdirectory under the TinyTeX root (",
        bin_root, "). TinyTeX installation may be incomplete."
      )
    }

    # On Windows, recent TinyTeX layouts include both win32 and windows; on
    # other platforms there is a single subdirectory.
    path_tt <- paste(bin_subdirs, collapse = path_sep())

    Sys.setenv(PATH = paste(path_tt, Sys.getenv("PATH"), sep = path_sep()))
    return(invisible(NULL))
  }

  if (!is_tinytex() && render_latex) {
    stop(
      "TinyTeX is not detected. Please set setup_tinytex to TRUE to install ",
      "TinyTeX, or set render_latex to FALSE to skip rendering the LaTeX ",
      "file to PDF."
    )
  }

  invisible(NULL)
}
