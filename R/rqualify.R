#' Run IQ-OQ on an installation of R software
#'
#' @param path_save Character. Path to save the R-validation folder. Ensure
#'   a folder named R-validation does not already exist at this location.
#'
#' @param setup_tinytex Logical. If TRUE, sets up TinyTeX for LaTeX document
#'  generation. Note, this does not install the tinytex R package, but the TinyTeX 
#'  LaTeX bundle. It is a convenient wrapper for installing TinyTeX using 
#'  \code{tinytex::install_tinytex()}, and adding the TinyTeX location to the environment.
#'  The function installs the "TinyTeX" bundle and the additional package grfext,
#'  and sets the TinyTeX installation path on the system PATH.
#'
#' @param setup_pandoc Logical. If TRUE, sets up pandoc for document conversion.
#'  Note, this does not install the pandoc R package, but the Pandoc software. It
#'  is a convenient wrapper around \code{pandoc::pandoc_install()} and `
#'  \code{pandoc::pandoc_activate()}, which are called internally.
#'  
#' @param render_latex Logical. If TRUE, renders the generated LaTeX file to PDF using 
#'   \code{tinytex::pdflatex()}.
#' 
#' @param verbose Logical. If TRUE, prints progress messages to the console.
#' 
#' @details This function creates a folder named R-validation at the specified path, allows
#'   users to conveniently install TinyTeX and Pandoc, renders an RMarkdown file to LaTeX, 
#'   compiles the LaTeX to PDF, and saves the output in the created folder.
#' 
#' The validation process involves running a series of tests on the R installation and
#' can be quite time consuming. The function will print progress messages to the 
#' console if \code{verbose} is set to TRUE.
#'
#' The following steps are carried out using default arguments:
#'
#' \enumerate{
#'   \item Create the folder tree R-validation/IQ-OQ-TestOutput at \code{path_save}
#'   \item Install TinyTeX and necessary LaTeX packages
#'   \item Install Pandoc
#'   \item Copy RMarkdown validation file to the R-validation folder
#'   \item Execute the IQ-OQ by rendering the RMarkdown file to LaTeX
#'   \item Compile the LaTeX file to pdf
#' }
#' 
#' @return The path to the R-validation folder. The primary purpose of this 
#'   function is its side effects, rendering an RMarkdown document.
#'   
#' @examplesIf tinytex::is_tinytex() && pandoc::pandoc_available()
#' \donttest{
#' # Render the R-validation report, must have TinyTeX and Pandoc installed for 
#' # this example, otherwise set setup_tinytex and setup_pandoc to TRUE.
#' rqualify(path_save     = tempdir(),
#'          setup_tinytex = FALSE,
#'          setup_pandoc  = FALSE)
#' }
#' \dontshow{
#' unlink(file.path(tempdir(), "R-validation"), recursive=TRUE)
#' }
#'   
#' @importFrom rmarkdown render pandoc_version
#' @importFrom tools file_path_sans_ext
#' @importFrom utils read.csv
#' @importFrom pandoc pandoc_install pandoc_activate pandoc_available
#' @importFrom tinytex install_tinytex tinytex_root tlmgr_version pdflatex is_tinytex
#'
#' @export
rqualify <- function(path_save,
                     setup_tinytex = TRUE,
                     setup_pandoc  = TRUE,
                     render_latex  = TRUE,
                     verbose       = TRUE) {

  if (missing(path_save)) {
    stop("`path_save` is required.")
  }

  paths <- setup_validation_dirs(path_save)

  setup_tinytex_env(setup_tinytex, render_latex, verbose)
  setup_pandoc_env(setup_pandoc, verbose)

  render_validation(
    path_rvalidation = paths$path_rvalidation,
    render_latex     = render_latex,
    verbose          = verbose
  )

  check_validation_results(paths$path_rvalidation)

  paths$path_rvalidation
}
