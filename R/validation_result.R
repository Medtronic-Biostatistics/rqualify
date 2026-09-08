command_version <- function(command, args = "--version") {
  if (!length(command) || is.na(command) || !nzchar(command)) return(NA_character_)
  output <- tryCatch(suppressWarnings(system2(command, args, stdout = TRUE, stderr = TRUE)),
                     error = function(e) character())
  status <- attr(output, "status")
  if (!length(output) || (!is.null(status) && status != 0L)) return(NA_character_)
  output[1]
}

validation_tool_versions <- function(engine) {
  versions <- list(
    R = as.character(getRversion()), R_home = normalizePath(R.home(), winslash = "/"),
    rqualify = as.character(utils::packageVersion("rqualify")),
    pandoc = NA_character_, latex = NA_character_, quarto = NA_character_, typst = NA_character_
  )
  if (engine == "quarto") {
    binary <- quarto::quarto_path()
    versions$quarto_path <- binary
    versions$quarto <- command_version(binary)
    versions$pandoc <- command_version(binary, c("pandoc", "--version"))
    versions$typst <- command_version(binary, c("typst", "--version"))
  } else {
    versions$pandoc <- as.character(rmarkdown::pandoc_version())
    versions$latex <- command_version(find_pdflatex())
  }
  versions
}

collect_validation_result <- function(paths, engine, versions, started) {
  checked <- read_validation_results(paths$path_rvalidation)
  existing <- function(name) {
    path <- file.path(paths$path_rvalidation, name)
    if (file.exists(path)) path else NULL
  }
  structure(list(
    status = checked$status,
    summary = checked$summary,
    output_dir = paths$path_rvalidation,
    files = list(
      source = existing(if (engine == "latex") "R-validation.Rmd" else "R-validation.qmd"),
      latex = existing("R-validation.tex"),
      pdf = existing("R-validation.pdf"),
      summary = existing("IQ-OQ-TestOutput/test_summary.csv"),
      metadata = file.path(paths$path_rvalidation, "validation_result.rds")
    ),
    engine = engine,
    core_test_scope = "basic",
    versions = versions,
    started_at = started,
    finished_at = Sys.time()
  ), class = c("rqualify_result", "list"))
}
