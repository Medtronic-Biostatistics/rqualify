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
#'   users to conveniently install TinyTeX and Pandox, renders an RMarkdown file to LaTeX, 
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
rqualify <- function(path_save, setup_tinytex=TRUE, setup_pandoc=TRUE, 
                     render_latex=TRUE,
                     verbose=TRUE){
  
  # Normalize folder path
  path_save <- normalizePath(path_save, winslash="/")
  
  # Check for existence of tests folder
  r_test_path <- file.path(R.home(), "tests")
  if(!dir.exists(r_test_path)){
    stop("R installation does not contain 'tests' folder. If running on Linux, see https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Testing-a-Unix_002dalike-Installation for instructions to install R with tests.")
  }
  
  
  #-----------------------------------------------------------------------------
  # Create folder 'R-validation' and 'R-validation/IQ-OQ-TestOutput' at path_save
  #-----------------------------------------------------------------------------
  path_rvalidation    <- file.path(path_save, "R-validation")
  path_iqoqtestoutput <- file.path(path_rvalidation, "IQ-OQ-TestOutput")
  
  if(dir.exists(path_rvalidation)){
    stop("Folder 'R-validation' already exists at the specified path. Rename or remove.")
  }
  
  dc <- dir.create(path_rvalidation)
  dc <- dir.create(path_iqoqtestoutput)
  
  
  #-----------------------------------------------------------------------------
  # Set-up tinytex?
  #-----------------------------------------------------------------------------
  if(setup_tinytex){
    if(verbose) cat("\n=== Now setting up tinytex ===\n")
    
    # Install the TinyTeX LaTeX bundle
    install_tinytex(bundle="TinyTeX",
                    force=TRUE,
                    extra_packages="grfext")
    
    # Force install packages if missing
    options(tinytex.install_packages = TRUE)
    
    # Force TinyTex onto the path
    path_TinyTeX <- tinytex_root()
    
    if(.Platform$OS.type == "windows"){
      path_tt <- paste(file.path(path_TinyTeX, "bin", "win32"),
                       file.path(path_TinyTeX, "bin", "windows"),
                       sep=.Platform$path.sep)
    } else{
      path_tt <- file.path(path_TinyTeX, "bin", "x86_64-linux")
    }
    
    Sys.setenv(PATH = paste(path_tt, Sys.getenv("PATH"), sep=.Platform$path.sep))
  }
  
  if(!setup_tinytex){
    if(!is_tinytex() && render_latex){
      stop("TinyTeX is not not detected. Please set setup_tinytex to TRUE to install TinyTeX, or set render_latex to FALSE to skip rendering the LaTeX file to PDF.")
    }
  }
  
  
  #-----------------------------------------------------------------------------
  # Set-up pandoc?
  #-----------------------------------------------------------------------------
  if(setup_pandoc){
    if(verbose) cat("\n=== Now setting up Pandoc ===\n")
    
    pandoc_install()
    pandoc_activate()
  }
  
  if(!setup_pandoc){
    if(!pandoc::pandoc_available()){
      stop("Pandoc is not detected. Please set setup_pandoc to TRUE to install Pandoc.")
    }
  }
  

  #-----------------------------------------------------------------------------
  # Render Rmd to tex
  #-----------------------------------------------------------------------------
  # Copy Rmd file to 'path_rvalidation'
  path_rmd <- file.path("qualify_r", "R-validation.Rmd")
  
  fc <- file.copy(system.file(path_rmd, package='rqualify'),
                  path_rvalidation)
  
  # Set locale and language - required for core test
  Sys.setlocale("LC_COLLATE", "C")
  Sys.setlocale("LC_TIME", "C")
  Sys.setenv(LANGUAGE = "en")
  
  if(verbose) cat("\n=== Now generating RMarkdown ===\n")
  
  render(input         = file.path(path_rvalidation, "R-validation.Rmd"), 
         output_format = "latex_document", 
         quiet         = !verbose)
  
  #-----------------------------------------------------------------------------
  # Render tex to pdf?
  #-----------------------------------------------------------------------------
  if(render_latex){
    path_tex <- file.path(path_rvalidation, "R-validation.tex")
    
    if(verbose) cat("\n=== Now generating RMarkdown ===\n")
    
    os <- setwd(path_rvalidation)
    pdflatex(path_tex)
    setwd(os)
    if(verbose) cat("\n=== RMarkdown report complete===\n")
  }
  
  
  #-----------------------------------------------------------------------------
  # Check test summary results and print warning if any tests failed
  #-----------------------------------------------------------------------------
  path_results <- file.path(path_rvalidation, "IQ-OQ-TestOutput", "test_summary.csv")
  
  if(file.exists(path_results)){
    summ_results <- read.csv(path_results)
    
    if(any(summ_results$system_results %in% "FAIL") | any(summ_results$test_results %in% "FAIL")){
      warning("R-validation failed. Please check the output files in the 'R-validation' folder.")
    } 
  } else{
    warning("Test summary file not found. Please check the output files in the 'R-validation' folder.")
  }
  
  #-----------------------------------------------------------------------------
  # Output report path
  #-----------------------------------------------------------------------------
  path_rvalidation
}
