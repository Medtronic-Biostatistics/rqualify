#' Run IQ-OQ on an installation of R software
#'
#' @param path_save Character. Path to save the R-validation folder. If not provided
#'   on Windows, you will be prompted to select a folder.
#'
#' @param setup_tinytex Logical. If TRUE, sets up tinytex for LaTeX document
#'  generation.
#'
#' @param setup_pandoc Logical. If TRUE, sets up pandoc for document conversion.
#'
#' @param verbose Logical. If TRUE, prints progress messages to the console.
#'
#' @param create_zip Logical. If TRUE, creates a zip file of the R-validation folder after validation.
#'
#' @details This function creates a folder named R-validation at the specified path,
#' sets up the environment, and executes the validation process.
#' The output of the validation will be saved in the created folder. By default,
#' the contents of the R-validation folder will be zipped up if the validation
#' is successful.
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
#'   \item If IQ-OQ is successful, create R-validation.zip at folder where R-validation is located
#' }
#'
#' @examples
#' \dontrun{
#' rqualify(path_save  = path.expand('~'))
#' }
#'
#' @importFrom rmarkdown render
#' @importFrom tinytex pdflatex
#' @importFrom utils choose.dir read.csv zip
#'
#' @export
rqualify <- function(path_save, setup_tinytex=TRUE, setup_pandoc=TRUE,
                     verbose=TRUE, create_zip=TRUE){

  # Get function call
  mf   <- match.call(expand.dots = FALSE)

  # If path_save not provided, prompt for input
  if(!"path_save" %in% names(mf)){
    if(tolower(.Platform$OS.type) == "windows"){
      path_save <- choose.dir(caption = "Select a folder")
      if(is.na(path_save)){
        stop("No folder selected. Please select a valid folder.")
      }
    } else{
      stop("Automatic folder selection is only available on Windows. Please provide 'path_save'.")
    }
  }

  # Normalize folder path
  path_save <- normalizePath(path_save, winslash="/")

  # Check for existence of tests folder in R installation path
  r_test_path <- file.path(R.home(), "tests")
  if(!dir.exists(r_test_path)){
    stop("R installation does not contain 'tests' folder. If running on Linux, see https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Testing-a-Unix_002dalike-Installation for instructions to install R with tests.")
  }

  # Set rvalidation folder path
  path_rvalidation <- file.path(path_save, "R-validation")

  #-----------------------------------------------------------------------------
  # Initialize environment
  #-----------------------------------------------------------------------------
  rs <- rqualify_setup(path_save, r_test_path, setup_tinytex, setup_pandoc, verbose)

  #-----------------------------------------------------------------------------
  # Run the tests and generate validation report
  #-----------------------------------------------------------------------------
  # Copy Rmd validation file to 'path_rvalidation'
  fc <- file.copy(system.file("validation_r/R-validation.Rmd", package='rqualify'),
                  path_rvalidation)

  # Remder: Rmd >> tex >> pdf
  if(verbose) cat("\n=== Now generating RMarkdown report ===")
  os <- setwd(path_rvalidation)
  render("R-validation.Rmd", output_format = "latex_document")
  pdflatex("R-validation.tex")
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

  # Zip up results?
  if(create_zip & pass_validation){
    wd <- getwd()
    setwd(path_save)
    zip(zipfile = file.path(path_save, "R-validation.zip"),
        files   = "R-validation")
    setwd(wd)
  }

  cat(sprintf("\nValidation output available at %s", path_rvalidation))

  if(create_zip & pass_validation){
    cat(sprintf("\nZipped validation output available at %s", file.path(path_save, "R-validation.zip\n\n")))
  }
}
