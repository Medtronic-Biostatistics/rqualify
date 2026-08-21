#' Create the R-validation folder tree
#'
#' Internal helper. Normalizes `path_save`, verifies that the running R
#' installation contains a `tests` directory, ensures no prior
#' `R-validation` folder exists at the destination, and creates
#' `R-validation/IQ-OQ-TestOutput`.
#'
#' @param path_save Character. Parent directory in which to create the
#'   `R-validation` folder.
#'
#' @return A named list with elements `path_save`, `path_rvalidation`, and
#'   `path_iqoqtestoutput` (all normalized absolute paths).
#'
#' @keywords internal
#' @noRd
setup_validation_dirs <- function(path_save) {
  if (missing(path_save)) {
    stop("`path_save` is required.")
  }

  path_save <- normalizePath(path_save, winslash = "/")

  r_test_path <- file.path(R.home(), "tests")
  if (!dir_exists(r_test_path)) {
    stop(
      "R installation does not contain 'tests' folder. If running on Linux, ",
      "see https://cran.r-project.org/doc/manuals/r-patched/R-admin.html",
      "#Testing-a-Unix_002dalike-Installation for instructions to install R ",
      "with tests."
    )
  }

  path_rvalidation    <- file.path(path_save, "R-validation")
  path_iqoqtestoutput <- file.path(path_rvalidation, "IQ-OQ-TestOutput")

  if (dir_exists(path_rvalidation)) {
    stop("Folder 'R-validation' already exists at the specified path. Rename or remove.")
  }

  dir.create(path_rvalidation)
  dir.create(path_iqoqtestoutput)

  list(
    path_save           = path_save,
    path_rvalidation    = path_rvalidation,
    path_iqoqtestoutput = path_iqoqtestoutput
  )
}
