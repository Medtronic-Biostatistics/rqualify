find_pdflatex <- function() unname(Sys.which("pdflatex"))

# Discover the installed layout instead of assuming an OS or architecture.
tinytex_bin_dirs <- function(root) {
  if (!length(root) || is.na(root) || !nzchar(root)) return(character())
  dirs <- c(file.path(root, "bin"), list.dirs(file.path(root, "bin"), recursive = FALSE))
  executable <- if (os_type() == "windows") "pdflatex.exe" else "pdflatex"
  dirs[file.exists(file.path(dirs, executable))]
}

activate_tinytex_path <- function() {
  root <- tryCatch(tinytex_root(), error = function(e) "")
  dirs <- tinytex_bin_dirs(root)
  if (length(dirs)) {
    old <- strsplit(Sys.getenv("PATH"), path_sep(), fixed = TRUE)[[1]]
    Sys.setenv(PATH = paste(unique(c(dirs, old)), collapse = path_sep()))
  }
  invisible(NULL)
}

setup_tinytex_env <- function(setup_tinytex, render_latex, verbose) {
  if (!render_latex) return(invisible(NULL))
  if (nzchar(find_pdflatex())) return(invisible(NULL))
  activate_tinytex_path()
  if (nzchar(find_pdflatex())) return(invisible(NULL))
  if (!setup_tinytex) {
    stop("LaTeX (pdflatex) is not detected. Set setup_tinytex to TRUE to install TinyTeX, ",
         "or render_latex to FALSE to generate only the LaTeX file.", call. = FALSE)
  }
  if (verbose) cat("\n=== Now setting up TinyTeX ===\n")
  install_tinytex(bundle = "TinyTeX", force = FALSE, extra_packages = "grfext")
  activate_tinytex_path()
  if (!nzchar(find_pdflatex())) stop("TinyTeX setup did not provide a usable pdflatex executable.", call. = FALSE)
  invisible(NULL)
}
