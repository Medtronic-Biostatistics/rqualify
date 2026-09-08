# Shared execution and result classification for both report formats.
validation_suites <- function() {
  c(
    iq = "Installation Qualification",
    basic = "Core Operational Qualification - System Tests",
    base_examples = "Base Package Operational Qualification - Package Examples",
    base_vignettes = "Base Package Operational Qualification - Package Vignettes",
    recommended_examples = "Recommended Package Operational Qualification - Package Examples",
    recommended_vignettes = "Recommended Package Operational Qualification - Package Vignettes",
    base_tests = "Base Package Operational Qualification - Package Tests",
    recommended_tests = "Recommended Package Operational Qualification - Package Tests"
  )
}

run_r_script <- function(file_code, file_output) {
  system2(
    file.path(R.home("bin"), if (os_type() == "windows") "R.exe" else "R"),
    c("--vanilla", shQuote(paste0("--file=", file_code))),
    stdout = file_output, stderr = file_output
  )
}

run_validation_code <- function(code_block, file_prefix, folder_output) {
  file_code <- file.path(folder_output, paste0(file_prefix, ".R"))
  file_output <- file.path(folder_output, paste0(file_prefix, "Out.txt"))
  writeLines(code_block, file_code, useBytes = TRUE)
  # Never interpret a previous run's output as evidence for this execution.
  if (file.exists(file_output) && !file.remove(file_output)) {
    stop("Cannot remove previous subprocess output: ", file_output)
  }
  diagnostics <- character()
  started <- Sys.time()
  exit_status <- tryCatch(
    withCallingHandlers(
      run_r_script(file_code, file_output),
      warning = function(w) {
        diagnostics <<- c(diagnostics, conditionMessage(w))
        invokeRestart("muffleWarning")
      }
    ),
    error = function(e) {
      diagnostics <<- c(diagnostics, conditionMessage(e))
      NA_integer_
    }
  )
  output <- if (file.exists(file_output)) readLines(file_output, warn = FALSE) else character()
  output <- c(output, diagnostics)
  if (!length(output)) output <- "Subprocess produced no output."
  writeLines(output, file_output, useBytes = TRUE)
  completion <- trimws(output)
  completion <- completion[completion %in% c("Test suite result: PASS", "Test suite result: FAIL")]
  completed <- length(completion) == 1L
  exited_ok <- isTRUE(exit_status == 0L)
  list(
    output = output,
    exit_status = as.integer(exit_status),
    completed = completed,
    system_results = if (exited_ok) "PASS" else "FAIL",
    test_results = if (exited_ok && completed && completion == "Test suite result: PASS") "PASS" else "FAIL",
    script = normalizePath(file_code, winslash = "/"),
    log = normalizePath(file_output, winslash = "/"),
    elapsed_seconds = as.numeric(difftime(Sys.time(), started, units = "secs"))
  )
}

validation_output <- function(code_block, file_prefix, folder_output) {
  result <- run_validation_code(code_block, file_prefix, folder_output)
  if (!isTRUE(result$exit_status == 0L)) {
    stop("Unable to collect installation information; see ", result$log)
  }
  result$output
}

validation_suite_code <- function(suite, folder_output) {
  suite <- match.arg(suite, names(validation_suites()))
  quote_path <- function(path) encodeString(normalizePath(path, winslash = "/", mustWork = TRUE), quote = '"')
  if (suite == "iq") {
    call <- "0L"
  } else if (suite == "basic") {
    tests <- file.path(folder_output, "tests")
    if (!dir.exists(tests)) {
      if (!file.copy(file.path(R.home(), "tests"), folder_output, recursive = TRUE)) {
        stop("Could not copy the installed R tests to ", folder_output)
      }
    }
    call <- sprintf(
      'tools::testInstalledBasic(scope = "basic", outDir = %s, testSrcdir = %s)',
      quote_path(tests), quote_path(tests)
    )
  } else {
    parts <- strsplit(suite, "_", fixed = TRUE)[[1]]
    call <- sprintf(
      'tools::testInstalledPackages(outDir = %s, scope = "%s", types = "%s", errorsAreFatal = FALSE)',
      quote_path(folder_output), parts[1], parts[2]
    )
  }
  c(
    "options(echo = FALSE, useFancyQuotes = FALSE)",
    paste0("result <- tryCatch(", call,
           ", error = function(e) { message(conditionMessage(e)); 1L })"),
    "passed <- length(result) == 1L && isTRUE(result == 0L)",
    'cat("\\nTest suite result: ", if (passed) "PASS" else "FAIL", "\\n", sep = "")',
    "q(status = if (passed) 0L else 1L)"
  )
}

run_validation_suite <- function(suite, folder_output) {
  suite <- match.arg(suite, names(validation_suites()))
  index <- match(suite, names(validation_suites())) - 1L
  result <- run_validation_code(
    validation_suite_code(suite, folder_output),
    if (suite == "iq") "rbanner" else paste0("CMDFile", index),
    folder_output
  )
  result$suite <- suite
  result
}

summarise_validation_runs <- function(runs) {
  ids <- vapply(runs, `[[`, character(1), "suite")
  if (anyDuplicated(ids) || !setequal(ids, names(validation_suites()))) {
    stop("Validation results must contain each of the eight expected suites exactly once.")
  }
  runs <- runs[match(names(validation_suites()), ids)]
  data.frame(
    test_suite = unname(validation_suites()),
    system_results = c(NA_character_, vapply(runs[-1], `[[`, character(1), "system_results")),
    test_results = vapply(runs, `[[`, character(1), "test_results"),
    exit_status = vapply(runs, `[[`, integer(1), "exit_status"),
    completed = vapply(runs, `[[`, logical(1), "completed"),
    stringsAsFactors = FALSE
  )
}
