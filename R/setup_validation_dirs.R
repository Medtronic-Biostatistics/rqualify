# Validate the destination without creating files or installing dependencies.
validation_paths <- function(path_save) {
  if (missing(path_save) || !is.character(path_save) || length(path_save) != 1L ||
      is.na(path_save) || !nzchar(trimws(path_save))) {
    stop("`path_save` must be a single, non-empty directory path.", call. = FALSE)
  }
  if (!dir_exists(path_save)) stop("`path_save` must be an existing directory.", call. = FALSE)
  path_save <- normalizePath(path_save, winslash = "/", mustWork = TRUE)
  if (file.access(path_save, 2L) != 0L) stop("`path_save` is not writable.", call. = FALSE)
  if (!dir_exists(file.path(R.home(), "tests"))) {
    stop(
      "R installation does not contain 'tests' folder. If running on Linux, ",
      "see https://cran.r-project.org/doc/manuals/r-patched/R-admin.html",
      "#Testing-a-Unix_002dalike-Installation for instructions to install R with tests.",
      call. = FALSE
    )
  }
  output <- file.path(path_save, "R-validation")
  link <- Sys.readlink(output)
  if (file.exists(output) || (!is.na(link) && nzchar(link))) {
    stop("Folder 'R-validation' already exists at the specified path. Rename or remove.", call. = FALSE)
  }
  list(path_save = path_save, path_rvalidation = output,
       path_iqoqtestoutput = file.path(output, "IQ-OQ-TestOutput"))
}

setup_validation_dirs <- function(path_save) {
  if (missing(path_save)) stop("`path_save` is required.", call. = FALSE)
  paths <- validation_paths(path_save)
  if (!dir.create(paths$path_rvalidation, showWarnings = FALSE)) {
    stop("Could not create the R-validation directory.", call. = FALSE)
  }
  if (!dir.create(paths$path_iqoqtestoutput, showWarnings = FALSE)) {
    # Only remove the new, empty directory created by this invocation.
    unlink(paths$path_rvalidation, recursive = TRUE)
    stop("Could not create the IQ-OQ-TestOutput directory.", call. = FALSE)
  }
  paths
}
