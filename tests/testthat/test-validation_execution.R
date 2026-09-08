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
