#' Package-level path and filename constants
#'
#' Internal. Centralizes the magic strings used to construct the
#' `R-validation` folder tree and to locate the bundled RMarkdown
#' template, so that any future rename only touches one place.
#'
#' @noRd
rqualify_paths <- list(
  rmd_subdir       = "qualify_r",
  rmd_file         = "R-validation.Rmd",
  tex_file         = "R-validation.tex",
  rvalidation_dir  = "R-validation",
  testoutput_dir   = "IQ-OQ-TestOutput",
  summary_file     = "test_summary.csv"
)
