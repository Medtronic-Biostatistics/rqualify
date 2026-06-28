#' Create the R-validation folder tree
#'
#' Internal helper. Normalizes `path_save`, verifies that the running R
#' installation contains a `tests` directory, ensures no prior
#' `R-validation` folder exists at the destination, and creates
#' `R-validation/IQ-OQ-TestOutput`.
#'
#' If creating the inner `IQ-OQ-TestOutput` folder fails, the outer
#' `R-validation` folder is removed so that the caller is not left with a
#' partial tree that would trip the "already exists" guard on a retry.
#'
#' Errors are subclassed conditions:
#' * `rqualify_missing_arg`         - `path_save` not supplied
#' * `rqualify_no_tests_folder`     - R installation lacks `tests/`
#' * `rqualify_dir_exists`          - `R-validation` already present
#' * `rqualify_dir_create_failed`   - `dir.create()` failed
#'
#' @param path_save Character. Parent directory in which to create the
#'   `R-validation` folder.
#'
#' @return A named list with elements `path_save`, `path_rvalidation`, and
#'   `path_iqoqtestoutput` (all normalized absolute paths).
#'
#' @noRd
setup_validation_dirs <- function(path_save) {
  if (missing(path_save)) {
    rqualify_stop(
      "rqualify_missing_arg",
      "`path_save` is required."
    )
  }

  path_save <- normalizePath(path_save, winslash = "/")

  r_test_path <- file.path(R.home(), "tests")
  if (!dir_exists(r_test_path)) {
    rqualify_stop(
      "rqualify_no_tests_folder",
      paste0(
        "R installation does not contain 'tests' folder. If running on Linux, ",
        "see https://cran.r-project.org/doc/manuals/r-patched/R-admin.html",
        "#Testing-a-Unix_002dalike-Installation for instructions to install ",
        "R with tests."
      ),
      path = r_test_path
    )
  }

  path_rvalidation <- file.path(path_save, rqualify_paths$rvalidation_dir)
  path_iqoqtestoutput <- file.path(path_rvalidation, rqualify_paths$testoutput_dir)

  if (dir_exists(path_rvalidation)) {
    rqualify_stop(
      "rqualify_dir_exists",
      paste0(
        "Folder '", rqualify_paths$rvalidation_dir,
        "' already exists at the specified path. Rename or remove."
      ),
      path = path_rvalidation
    )
  }

  if (!dir.create(path_rvalidation)) {
    rqualify_stop(
      "rqualify_dir_create_failed",
      sprintf("Could not create directory '%s'.", path_rvalidation),
      path = path_rvalidation
    )
  }

  # If the inner dir.create fails, remove the outer one so we don't leave a
  # partial tree behind that the next rqualify() call would refuse to
  # overwrite.
  inner_ok <- tryCatch(
    dir.create(path_iqoqtestoutput),
    warning = function(w) FALSE,
    error = function(e) FALSE
  )
  if (!isTRUE(inner_ok)) {
    unlink(path_rvalidation, recursive = TRUE)
    rqualify_stop(
      "rqualify_dir_create_failed",
      sprintf("Could not create directory '%s'.", path_iqoqtestoutput),
      path = path_iqoqtestoutput
    )
  }

  list(
    path_save           = path_save,
    path_rvalidation    = path_rvalidation,
    path_iqoqtestoutput = path_iqoqtestoutput
  )
}
