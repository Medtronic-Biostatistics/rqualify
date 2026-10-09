# Read and validate the machine-readable evidence before reporting an outcome.
read_validation_results <- function(path_rvalidation) {
  path <- file.path(path_rvalidation, "IQ-OQ-TestOutput", "test_summary.csv")
  if (!file.exists(path)) return(list(status = "missing", summary = NULL))
  invalid <- function() list(status = "invalid", summary = NULL)
  summary <- tryCatch(read.csv(path, stringsAsFactors = FALSE, check.names = FALSE),
                      error = function(e) NULL)
  required <- c("test_suite", "system_results", "test_results")
  if (is.null(summary) || anyDuplicated(names(summary)) ||
      !all(required %in% names(summary)) || nrow(summary) != 8L ||
      anyDuplicated(summary$test_suite) ||
      !setequal(summary$test_suite, unname(validation_suites()))) return(invalid())
  summary <- summary[match(unname(validation_suites()), summary$test_suite), , drop = FALSE]
  rownames(summary) <- NULL
  if (!is.na(summary$system_results[1]) ||
      !all(summary$system_results[-1] %in% c("PASS", "FAIL")) ||
      !all(summary$test_results %in% c("PASS", "FAIL"))) return(invalid())
  # When execution evidence is present, it must agree with the reported result.
  evidence <- c("exit_status", "completed")
  if (any(evidence %in% names(summary))) {
    if (!all(evidence %in% names(summary)) || !is.numeric(summary$exit_status) ||
        !is.logical(summary$completed) || anyNA(summary$completed)) return(invalid())
    passed <- summary$test_results == "PASS"
    if (any(passed & (!summary$completed | is.na(summary$exit_status))) ||
        any(summary$exit_status[passed] != 0L) ||
        any(summary$system_results[-1] == "PASS" &
            (is.na(summary$exit_status[-1]) | summary$exit_status[-1] != 0L))) return(invalid())
  }
  failed <- any(summary$system_results %in% "FAIL") || any(summary$test_results == "FAIL")
  list(status = if (failed) "fail" else "ok", summary = summary)
}

check_validation_results <- function(path_rvalidation) {
  result <- read_validation_results(path_rvalidation)
  message <- switch(result$status,
    missing = "Test summary file not found. Please check the output files in the 'R-validation' folder.",
    invalid = "Test summary is invalid or incomplete. Qualification cannot be confirmed; check the output files in the 'R-validation' folder.",
    fail = "R-validation failed. Please check the output files in the 'R-validation' folder.",
    NULL
  )
  if (!is.null(message)) warning(message, call. = FALSE)
  invisible(result$status)
}
