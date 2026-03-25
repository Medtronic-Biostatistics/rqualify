#' Run IQ-OQ on an installation of R software
#'
#' @param path_save Character. Path to save the R-validation folder. Ensure
#'   a folder named `R-validation` does not already exist at this location.
#'
#' @param setup_tinytex Logical. If TRUE, sets up tinytex for LaTeX document
#'  generation.
#'
#' @param setup_pandoc Logical. If TRUE, sets up pandoc for document conversion.
#'
#' @param verbose Logical. If TRUE, prints progress messages to the console.
#'
#' @details This function creates a folder named R-validation at the specified path,
#' sets up the environment, and executes the validation process.
#' The output of the validation will be saved in the created folder. 
#' 
#' The validation process involves running a series of tests on the R installation and
#' can be quite time consuming. The function will print progress messages to the 
#' console if `verbose` is set to TRUE.
#'
#' The following steps are carried out:
#'
#' \enumerate{
#'   \item Create the folder tree R-validation/IQ-OQ-TestOutput at path_save, or selected folder
#'   \item Install tinytex and necessary LaTeX packages
#'   \item Install pandoc
#'   \item Copy R-validation.Rmd to the R-validation folder
#'   \item Execute the IQ-OQ by rendering R-validation.Rmd to R-validation.tex
#'   \item Compile R-validation.tex to R-validation.pdf
#' }
#' 
#' @return This function does not return a value. It performs side effects by 
#'   rendering a RMarkdown document.
#'
#' @importFrom rmarkdown render
#' @importFrom tinytex pdflatex
#' @importFrom utils read.csv
#'
#' @export
rqualify <- function(path_save, setup_tinytex=TRUE, setup_pandoc=TRUE,
                     verbose=TRUE){

  # Get function call
  mf   <- match.call(expand.dots = FALSE)

  # Normalize folder path
  path_save <- normalizePath(path_save, winslash="/")

  # Check for existence of tests folder
  r_test_path <- file.path(R.home(), "tests")
  if(!dir.exists(r_test_path)){
    stop("R installation does not contain 'tests' folder. If running on Linux, see https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Testing-a-Unix_002dalike-Installation for instructions to install R with tests.")
  }

  # Set rvalidation folder path
  path_rvalidation <- file.path(path_save, "R-validation")

  #-----------------------------------------------------------------------------
  # Initialize environment
  #-----------------------------------------------------------------------------
  rs <- rqualify_setup(path_save, setup_tinytex, setup_pandoc, verbose)

  #-----------------------------------------------------------------------------
  # Run the tests and generate validation report
  #-----------------------------------------------------------------------------
  # Copy Rmd validation file to 'path_rvalidation'
  fc <- file.copy(system.file("qualify_r/R-validation.Rmd", package='rqualify'),
                  path_rvalidation)

  # Render: Rmd >> tex >> pdf
  if(verbose) cat("\n=== Now generating RMarkdown report ===")
  
  path_rmd <- file.path(path_rvalidation, "R-validation.Rmd")
  path_tex <- file.path(path_rvalidation, "R-validation.tex")
  
  render(path_rmd, output_format = "latex_document", quiet=!verbose)
  
  os <- setwd(path_rvalidation)
  pdflatex(path_tex)
  setwd(os)
  if(verbose) cat("\n=== RMarkdown report complete===")

  # Check that validation passed
  path_results <- file.path(path_rvalidation, "IQ-OQ-TestOutput", "test_summary.csv")
  summ_results <- read.csv(path_results)

  if(any(summ_results$system_results %in% "FAIL") | any(summ_results$test_results %in% "FAIL")){
    pass_validation <- FALSE
    warning("R-validation failed. Please check the output files in the 'R-validation' folder.")
  } else{
    pass_validation <- TRUE
  }

}
