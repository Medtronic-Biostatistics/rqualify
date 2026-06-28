#' Check the test summary written by the validation render
#'
#' Internal helper. Reads `IQ-OQ-TestOutput/test_summary.csv` and issues
#' a `warning()` if any `system_results` or `test_results` entry is
#' `"FAIL"`, or if the summary file is missing.
#'
#' @param path_rvalidation Character. Path to the `R-validation` folder.
#'
#' @return Invisibly, one of `"ok"`, `"fail"`, or `"missing"`, describing
#'   the outcome. The function is primarily called for its warning side
#'   effects.
#'
#' @keywords internal
#' @noRd
check_validation_results <- function(path_rvalidation) {
  path_results <- file.path(path_rvalidation, "IQ-OQ-TestOutput", "test_summary.csv")

  if (!file.exists(path_results)) {
    warning(
      "Test summary file not found. ",
      "Please check the output files in the 'R-validation' folder."
    )
    return(invisible("missing"))
  }

  summ_results <- read.csv(path_results)

  failed <- any(summ_results$system_results %in% "FAIL") ||
    any(summ_results$test_results %in% "FAIL")

  if (failed) {
    warning("R-validation failed. Please check the output files in the 'R-validation' folder.")
    return(invisible("fail"))
  }

  invisible("ok")
}
