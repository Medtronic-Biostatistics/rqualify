passing_summary <- function() {
  data.frame(
    test_suite = c(
      "Installation Qualification",
      "Core Operational Qualification - System Tests",
      "Base Package Operational Qualification - Package Examples",
      "Base Package Operational Qualification - Package Vignettes",
      "Recommended Package Operational Qualification - Package Examples",
      "Recommended Package Operational Qualification - Package Vignettes",
      "Base Package Operational Qualification - Package Tests",
      "Recommended Package Operational Qualification - Package Tests"
    ),
    system_results = c(NA_character_, rep("PASS", 7)),
    test_results = rep("PASS", 8),
    exit_status = rep(0L, 8), completed = rep(TRUE, 8)
  )
}

write_test_summary <- function(path, data = passing_summary()) {
  dir.create(file.path(path, "IQ-OQ-TestOutput"), showWarnings = FALSE)
  write.csv(data, file.path(path, "IQ-OQ-TestOutput", "test_summary.csv"), row.names = FALSE)
}

local_r_tests_dir_exists <- function(exists = TRUE, env = parent.frame()) {
  r_tests <- normalizePath(
    file.path(R.home(), "tests"),
    mustWork = FALSE,
    winslash = "/"
  )

  local_mocked_bindings(
    dir_exists = function(paths) {
      paths <- normalizePath(paths, mustWork = FALSE, winslash = "/")
      ifelse(paths == r_tests, exists, base::dir.exists(paths))
    },
    .env = env
  )
}
