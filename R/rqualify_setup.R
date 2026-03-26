#' Initialize environment for IQ-OQ.
#'
#' @param setup_tinytex Logical. If TRUE, sets up TinyTeX for LaTeX document
#'  generation. Note, this does not install the tinytex R package, but the TinyTeX 
#'  LaTeX bundle. It is a convenient wrapper for installing TinyTeX using 
#'  `tinytex::install_tinytex()`, and adding the TinyTeX location to the environment
#'  The function installes the "TinyTeX" bundle and the additional package `grfext`,
#'  and sets the TinyTeX installation path on the system PATH.
#'
#' @param setup_pandoc Logical. If TRUE, sets up pandoc for document conversion.
#'  Note, this does not install the pandoc R package, but the Pandoc software. It
#'  is a convenient wrapper around `pandoc::pandoc_install()` and `pandoc::pandoc_activate()`, 
#'  which are called internally.
#'
#' @param verbose Logical. If TRUE, prints progress messages to the console.
#'
#' @details `rqualify_setup` allows users to easily install TinyTeX and Pandoc
#'   as required for rendering Rmd files to PDF. The process can
#'   be quite time consuming, especially if TinyTeX needs to be installed, and there
#'   may be apparent hanging processes -- this is expected behavior. 
#'
#' @return A list with the installed Pandoc and TinyTeX versions, though the primary
#'  purpose of this function is its side effects, setting up TinyTeX and Pandoc as specified.
#'   
#' @examples
#' rqualify_setup(setup_tinytex = FALSE,
#'                setup_pandoc  = FALSE)
#'
#' @seealso \code{\link{rqualify}} which calls this function internally.
#'
#' @importFrom pandoc pandoc_install pandoc_activate
#' @importFrom tinytex install_tinytex tinytex_root tlmgr_version
#' @importFrom rmarkdown pandoc_version
#'
#' @export
rqualify_setup <- function(setup_tinytex=TRUE, setup_pandoc=TRUE, verbose=TRUE){

  #-----------------------------------------------------------------------------
  # Set-up tinytex
  #-----------------------------------------------------------------------------
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

  #-----------------------------------------------------------------------------
  # Set-up Pandoc
  #-----------------------------------------------------------------------------
  if(setup_pandoc){
    if(verbose) cat("\n=== Now setting up Pandoc ===")
    
    pandoc_install()
    pandoc_activate()
  }

  if(verbose) cat("\n=== Validation environment set-up complete ===")
  
  
  #-----------------------------------------------------------------------------
  # Return Pandoc and tinytex versions
  #-----------------------------------------------------------------------------
  list(pandoc_version  = rmarkdown::pandoc_version(), 
       tinytex_version = tinytex::tlmgr_version())
}

