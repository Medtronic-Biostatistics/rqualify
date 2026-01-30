#' Initialize environment for IQ-OQ.
#'
#'@param path_save Character. Path where the 'R-validation' folder will be created
#'  to store validation outputs.
#'
#' @param r_test_path Character. Path to the folder containing the base tests
#'   to be copied into the 'R-validation/IQ-OQ-TestOutput' directory.
#'
#' @param setup_tinytex Logical. If TRUE, sets up tinytex for LaTeX document
#'  generation.
#'
#' @param setup_pandoc Logical. If TRUE, sets up pandoc for document conversion.
#'
#' @param verbose Logical. If TRUE, prints progress messages to the console.
#'
#' @details The function sets up the environment by configuring locale settings and
#'   installing any dependencies, including tinytex and pandoc.
#'
#' @examples
#' \dontrun{
#' rqualify_setup(path_save   = "~",
#'                r_test_path = file.path(R.home(), "tests"))
#' }
#'
#' @seealso \code{\link{rqualify}} which calls this function internally.
#'
#' @importFrom pandoc pandoc_install pandoc_activate
#' @importFrom rmarkdown pandoc_available
#' @importFrom tinytex install_tinytex tinytex_root
#' @importFrom utils install.packages installed.packages
#'
#'
#' @export
rqualify_setup <- function(path_save, r_test_path, setup_tinytex=TRUE,
                           setup_pandoc=TRUE, verbose=TRUE){

  # Get function call
  mf   <- match.call(expand.dots = FALSE)

  if(verbose) cat("\n=== Now setting up environment for validation ===")

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


  ##############################################################################
  # Environment set-up
  ##############################################################################
  # Set locale and language - required for core test
  Sys.setlocale("LC_COLLATE", "C")
  Sys.setlocale("LC_TIME", "C")
  Sys.setenv(LANGUAGE = "en")


  #-------------------------------------------------------------------------------
  # Set-up tinytex
  #-------------------------------------------------------------------------------
  if(setup_tinytex){

    if(verbose) cat("\n=== Now setting up tinytex ===")

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

  #-------------------------------------------------------------------------------
  # Set-up Pandoc
  #-------------------------------------------------------------------------------
  if(setup_pandoc){
    if(verbose) cat("\n=== Now setting up Pandoc ===")

    # Check if Pandoc is installed, if not, install
    has_pandoc     <- pandoc_available()

    if(!has_pandoc){
      pandoc_install()
      pandoc_activate()
    }
  }

  if(verbose) cat("\n=== Validation environment set-up complete ===")
}

