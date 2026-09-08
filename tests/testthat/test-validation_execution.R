test_that("a real subprocess needs both a zero exit code and completion evidence", {
  tmp <- withr::local_tempdir()
  cases <- list(
    pass = c('cat("Test suite result: PASS\\n")', "q(status = 0L)"),
    crash = "stop('deliberate subprocess failure')",
    incomplete = "q(status = 0L)",
    exit_failure = c('cat("Test suite result: PASS\\n")', "q(status = 1L)"),
    test_failure = c('cat("Test suite result: FAIL\\n")', "q(status = 0L)"),
    contradictory = 'cat("Test suite result: PASS\\nTest suite result: FAIL\\n")'
  )
  for (name in names(cases)) {
    run <- run_validation_code(cases[[name]], name, tmp)
    expect_identical(run$test_results, if (name == "pass") "PASS" else "FAIL", info = name)
    expect_true(file.exists(run$log))
  }
})

test_that("missing executables and stale output cannot pass", {
  tmp <- withr::local_tempdir()
  writeLines("Test suite result: PASS", file.path(tmp, "missingOut.txt"))
  local_mocked_bindings(run_r_script = function(...) stop("executable unavailable"))
  run <- run_validation_code("q()", "missing", tmp)
  expect_identical(run$system_results, "FAIL")
  expect_identical(run$test_results, "FAIL")
  expect_false(run$completed)
  expect_match(run$output, "executable unavailable")
})

test_that("IQ runs from a directory containing spaces and apostrophes", {
  parent <- withr::local_tempdir()
  tmp <- file.path(parent, "qualification user's files")
  dir.create(tmp)
  run <- run_validation_suite("iq", tmp)
  expect_identical(run$exit_status, 0L)
  expect_true(run$completed)
  expect_identical(run$test_results, "PASS")
})

test_that("suite scripts escape paths and explicitly select the basic scope", {
  skip_on_os("windows")
  parent <- withr::local_tempdir()
  tmp <- file.path(parent, 'qualification "quoted" files')
  dir.create(tmp)
  dir.create(file.path(tmp, "tests"))
  code <- validation_suite_code("basic", tmp)
  expect_no_error(parse(text = code))
  seen <- NULL
  env <- new.env(parent = baseenv())
  env$q <- function(status) expect_identical(status, 0L)
  local_mocked_bindings(
    testInstalledBasic = function(scope, outDir, testSrcdir) {
      seen <<- list(scope = scope, outDir = outDir, testSrcdir = testSrcdir)
      0L
    }, .package = "tools"
  )
  capture.output(eval(parse(text = code), env))
  expect_identical(seen$scope, "basic")
  expect_identical(seen$outDir, normalizePath(file.path(tmp, "tests"), winslash = "/"))
  expect_identical(seen$testSrcdir, seen$outDir)
})

test_that("summary preserves failed exits and rejects missing or duplicated suites", {
  run <- list(exit_status = 0L, completed = TRUE, system_results = "PASS", test_results = "PASS")
  runs <- lapply(names(validation_suites()), function(id) c(run, list(suite = id)))
  runs[[2]]$exit_status <- 1L
  runs[[2]]$completed <- FALSE
  runs[[2]]$system_results <- runs[[2]]$test_results <- "FAIL"
  result <- summarise_validation_runs(runs)
  expect_identical(result$test_results[2], "FAIL")
  expect_identical(result$exit_status[2], 1L)
  expect_false(result$completed[2])
  expect_true(is.na(result$system_results[1]))
  expect_error(summarise_validation_runs(runs[-1]), "eight expected suites")
  expect_error(summarise_validation_runs(c(runs, runs[1])), "eight expected suites")
})

test_that("subprocess warnings and empty output remain available as diagnostics", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(run_r_script = function(...) {
    warning("subprocess launch warning")
    1L
  })
  expect_warning(run <- run_validation_code("q()", "warning", tmp), NA)
  expect_identical(run$test_results, "FAIL")
  expect_identical(run$exit_status, 1L)
  expect_match(readLines(run$log), "subprocess launch warning")

  local_mocked_bindings(run_r_script = function(...) 0L)
  run <- run_validation_code("q()", "empty", tmp)
  expect_false(run$completed)
  expect_identical(run$test_results, "FAIL")
  expect_identical(readLines(run$log), "Subprocess produced no output.")
})

test_that("unremovable stale logs prevent another subprocess from starting", {
  tmp <- withr::local_tempdir()
  log <- file.path(tmp, "staleOut.txt")
  writeLines("Test suite result: PASS", log)
  local_mocked_bindings(file.remove = function(...) FALSE, .package = "base")
  local_mocked_bindings(run_r_script = function(...) stop("must not launch"))
  expect_error(run_validation_code("q()", "stale", tmp), "Cannot remove previous subprocess output")
  expect_identical(readLines(log), "Test suite result: PASS")
})

test_that("installation information requires a successful subprocess", {
  tmp <- withr::local_tempdir()
  output <- validation_output('cat("installation information\\n")', "info", tmp)
  expect_true(any(output == "installation information"))
  expect_error(
    validation_output("stop('information probe failed')", "bad-info", tmp),
    "Unable to collect installation information; see .*bad-infoOut.txt"
  )
  expect_true(any(grepl("information probe failed", readLines(file.path(tmp, "bad-infoOut.txt")))))
})

test_that("basic suite copies test sources and runs only the basic scope", {
  root <- withr::local_tempdir()
  source <- file.path(root, "source", "tests")
  dir.create(source, recursive = TRUE)
  writeLines("# installed test fixture", file.path(source, "fixture.R"))
  output <- file.path(root, "output")
  dir.create(output)
  original_copy <- base::file.copy
  local_mocked_bindings(file.copy = function(from, to, recursive) {
    expect_identical(from, file.path(R.home(), "tests"))
    original_copy(source, to, recursive = recursive)
  }, .package = "base")
  seen <- NULL
  local_mocked_bindings(testInstalledBasic = function(scope, outDir, testSrcdir) {
    seen <<- list(scope = scope, outDir = outDir, testSrcdir = testSrcdir)
    0L
  }, .package = "tools")
  env <- new.env(parent = baseenv())
  env$q <- function(status) expect_identical(status, 0L)
  code <- validation_suite_code("basic", output)
  expect_identical(readLines(file.path(output, "tests", "fixture.R")), "# installed test fixture")
  expect_output(eval(parse(text = code), env), "Test suite result: PASS")
  expect_identical(seen$scope, "basic")
  expect_identical(seen$outDir, normalizePath(file.path(output, "tests"), winslash = "/"))
  expect_identical(seen$testSrcdir, seen$outDir)
})

test_that("failed copying of installed tests prevents suite execution", {
  tmp <- withr::local_tempdir()
  local_mocked_bindings(file.copy = function(...) FALSE, .package = "base")
  expect_error(validation_suite_code("basic", tmp), "Could not copy the installed R tests")
})

test_that("all package suites select the right scope and propagate test failures", {
  tmp <- withr::local_tempdir()
  seen <- NULL
  return_value <- 0L
  local_mocked_bindings(testInstalledPackages = function(outDir, scope, types, errorsAreFatal) {
    seen <<- list(outDir = outDir, scope = scope, types = types, errorsAreFatal = errorsAreFatal)
    if (is.null(return_value)) stop("package test crashed")
    return_value
  }, .package = "tools")
  cases <- expand.grid(scope = c("base", "recommended"), type = c("examples", "vignettes", "tests"))
  for (i in seq_len(nrow(cases))) {
    suite <- paste(cases$scope[i], cases$type[i], sep = "_")
    code <- validation_suite_code(suite, tmp)
    for (value in list(0L, 1L, NULL)) {
      return_value <- value
      env <- new.env(parent = baseenv())
      # Capture the script's exit without terminating the test process.
      env$q <- function(status) env$exit_status <- status
      output <- capture.output(suppressMessages(eval(parse(text = code), env)))
      passed <- identical(value, 0L)
      expect_identical(env$exit_status, if (passed) 0L else 1L, info = suite)
      expect_true(any(output == paste("Test suite result:", if (passed) "PASS" else "FAIL")), info = suite)
      expect_identical(seen, list(
        outDir = normalizePath(tmp, winslash = "/"),
        scope = as.character(cases$scope[i]), types = as.character(cases$type[i]), errorsAreFatal = FALSE
      ))
    }
  }
})
