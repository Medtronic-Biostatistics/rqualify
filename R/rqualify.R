#' Run IQ-OQ on an installation of R software
#'
#' @param path_save Character. Existing, writable directory in which to create
#'   the R-validation folder. That folder must not already exist.
#' @param setup_tinytex Logical. Allow installation of TinyTeX and the grfext
#'   package when PDF compilation requires LaTeX and no existing installation
#'   is available. Existing LaTeX installations are reused. Ignored for Quarto.
#' @param setup_pandoc Logical. Allow installation of Pandoc when none is
#'   available for R Markdown. Existing system, IDE, or managed installations
#'   are reused. Ignored for Quarto, which includes Pandoc.
#' @param render_latex Logical. Compile the LaTeX report to PDF when
#'   \code{engine = "latex"}. If FALSE, generate only the LaTeX file.
#'   Ignored for Quarto, which always generates a PDF through Typst.
#' @param engine Character. Either \code{"latex"} or \code{"quarto"}.
#' @param verbose Logical. Print progress messages.
#' @param details Logical. Return structured qualification results instead of
#'   just the output directory. Defaults to FALSE for compatibility.
#'
#' @details Arguments, the destination, and engine-specific prerequisites are
#'   checked before output directories are created. Quarto uses its bundled
#'   Pandoc and Typst and does not require TinyTeX or a separate Pandoc install.
#'   The selected R installation must include its installed tests.
#'
#'   Both report formats use the same subprocess runner. Passing a suite
#'   requires a zero exit status and exactly one explicit PASS completion
#'   result. Crashes and incomplete results cannot pass. The core system tests
#'   use \code{tools::testInstalledBasic(scope = "basic")}; development and
#'   internet test scopes are not run. Base and recommended package examples,
#'   vignettes, and tests are checked separately.
#'
#'   The output includes the report source, subprocess scripts and logs,
#'   \code{IQ-OQ-TestOutput/test_summary.csv}, and \code{validation_result.rds}.
#'   Failed qualification, missing summaries, and invalid summaries produce
#'   warnings. Inspect the returned details or saved results to distinguish
#'   these outcomes. Rendering errors stop execution and leave diagnostic files
#'   in the output directory. Temporary environment changes are restored.
#'
#' @return By default, the path to the R-validation folder. With
#'   \code{details = TRUE}, a \code{rqualify_result} list containing
#'   \code{status} (\code{"ok"}, \code{"fail"}, \code{"missing"}, or
#'   \code{"invalid"}), the per-suite \code{summary}, \code{output_dir},
#'   artifact paths in \code{files}, \code{engine}, \code{core_test_scope},
#'   R and tool \code{versions}, and start and finish times. This list is also
#'   saved as \code{validation_result.rds} for either return mode.
#'
#' @examples
#' \dontrun{
#' # Reuse installed LaTeX and Pandoc.
#' rqualify(path_save = tempdir(), setup_tinytex = FALSE, setup_pandoc = FALSE)
#'
#' # Quarto uses its bundled tools; choose a fresh output location.
#' destination <- tempfile()
#' dir.create(destination)
#' result <- rqualify(destination, engine = "quarto", details = TRUE)
#' result$status
#' result$summary
#' }
#'
#' @importFrom rmarkdown render pandoc_version
#' @importFrom tools file_path_sans_ext
#' @importFrom utils read.csv
#' @importFrom pandoc pandoc_install pandoc_activate pandoc_available
#' @importFrom tinytex install_tinytex tinytex_root tlmgr_version pdflatex is_tinytex
#' @importFrom quarto quarto_render
#' @export
rqualify <- function(path_save, 
                     setup_tinytex=TRUE, 
                     setup_pandoc=TRUE, 
                     render_latex=TRUE,
                     engine = "latex",
                     verbose=TRUE,
                     details=FALSE){
  
  if (missing(path_save)) {
    stop("`path_save` is required.")
  }
  if (!is.character(engine) || length(engine) != 1L || is.na(engine) ||
      !engine %in% c("latex", "quarto")) {
    stop("`engine` must be 'latex' or 'quarto'.", call. = FALSE)
  }
  flags <- list(setup_tinytex = setup_tinytex, setup_pandoc = setup_pandoc,
                render_latex = render_latex, verbose = verbose, details = details)
  for (name in names(flags)) {
    value <- flags[[name]]
    if (!is.logical(value) || length(value) != 1L || is.na(value)) {
      stop("`", name, "` must be TRUE or FALSE.", call. = FALSE)
    }
  }
  validation_paths(path_save)
  old_env <- Sys.getenv(c("PATH", "RSTUDIO_PANDOC", "QUARTO_R"), unset = NA_character_)
  on.exit(restore_validation_env(old_env), add = TRUE)
  if (engine == "latex") {
    setup_pandoc_env(setup_pandoc, verbose)
    setup_tinytex_env(setup_tinytex, render_latex, verbose)
  } else {
    setup_quarto_env()
    Sys.setenv(QUARTO_R = file.path(R.home("bin"), "Rscript"))
  }
  versions <- validation_tool_versions(engine)
  started <- Sys.time()
  paths <- setup_validation_dirs(path_save)
  
  render_validation(
    path_rvalidation = paths$path_rvalidation,
    render_latex     = render_latex,
    engine           = engine,
    verbose          = verbose
  )
  
  result <- collect_validation_result(paths, engine, versions, started)
  saveRDS(result, result$files$metadata)
  check_validation_results(paths$path_rvalidation)
  if (details) result else paths$path_rvalidation
}
