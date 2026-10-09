render_pandoc_available <- function() rmarkdown::pandoc_available()

setup_pandoc_env <- function(setup_pandoc, verbose) {
  # Includes system Pandoc and the copy bundled with RStudio or Quarto.
  if (render_pandoc_available()) return(invisible(NULL))
  if (pandoc_available()) {
    pandoc_activate(quiet = !verbose)
    return(invisible(NULL))
  }
  if (!setup_pandoc) {
    stop("Pandoc is not detected. Please set setup_pandoc to TRUE to install Pandoc.", call. = FALSE)
  }
  if (verbose) cat("\n=== Now setting up Pandoc ===\n")
  pandoc_install()
  pandoc_activate(quiet = !verbose)
  if (!render_pandoc_available()) stop("Pandoc setup did not provide a usable renderer.", call. = FALSE)
  invisible(NULL)
}

setup_quarto_env <- function() {
  if (!quarto::quarto_available(min = "1.4")) {
    stop("Quarto >= 1.4 is required for the Typst report. Install Quarto or use engine = 'latex'.", call. = FALSE)
  }
  invisible(NULL)
}

restore_validation_env <- function(values) {
  unset <- names(values)[is.na(values)]
  if (length(unset)) Sys.unsetenv(unset)
  values <- values[!is.na(values)]
  if (length(values)) do.call(Sys.setenv, as.list(values))
  invisible(NULL)
}
