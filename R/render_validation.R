#' Render the R-validation RMarkdown document
#'
#' Internal helper. Copies the bundled `R-validation.Rmd` into
#' `path_rvalidation`, temporarily sets the locale and `LANGUAGE`
#' environment variable to the values required by the core R test suite,
#' renders the document to LaTeX and (optionally) compiles the resulting
#' `.tex` to PDF, or renders using Quarto.
#'
#' Locale, language, and working-directory restoration is registered on
#' the caller's exit handler stack (via `on_exit_frame`) so that those
#' settings persist for the lifetime of the calling function rather than
#' being reset when this helper returns.
#'
#' @param path_rvalidation Character. Path to the `R-validation` folder.
#' 
#' @param render_latex Logical. Compile the rendered `.tex` to PDF.
#' 
#' @param engine Character. Engine to generate the PDF. Either \code{latex} or 
#'   \code{quarto}
#' 
#' @param verbose Logical. Print progress messages.
#' 
#' @param on_exit_frame An environment whose `on.exit` stack should
#'   receive cleanup handlers. Defaults to `parent.frame()`.
#'
#' @return Invisibly, the path to the rendered `R-validation.Rmd` or `R-validation.qmd`.
#'
#' @keywords internal
#' @noRd
render_validation <- function(path_rvalidation,
                              render_latex,
                              engine = "latex",
                              verbose,
                              on_exit_frame = parent.frame()) {
  engine <- match.arg(engine, c("latex", "quarto"))
  
  current_locale_collate <- Sys.getlocale("LC_COLLATE")
  current_locale_time    <- Sys.getlocale("LC_TIME")
  current_language       <- Sys.getenv("LANGUAGE", unset = NA_character_)
  
  register_on_exit(
    bquote(Sys.setlocale("LC_COLLATE", .(current_locale_collate))),
    on_exit_frame
  )
  register_on_exit(
    bquote(Sys.setlocale("LC_TIME", .(current_locale_time))),
    on_exit_frame
  )
  register_on_exit(
    bquote(restore_validation_env(c(LANGUAGE = .(current_language)))),
    on_exit_frame
  )
  
  Sys.setlocale("LC_COLLATE", "C")
  Sys.setlocale("LC_TIME", "C")
  Sys.setenv(LANGUAGE = "en")
  
  
  if(engine == "latex"){
    
    if (verbose) cat("\n=== Now generating RMarkdown ===\n")
    
    path_rmd <- file.path("qualify_r", "R-validation.Rmd")
    if (!file.copy(system.file(path_rmd, package = "rqualify"), path_rvalidation)) {
      stop("Could not copy the RMarkdown report template.")
    }
    
    
    input_rmd <- file.path(path_rvalidation, "R-validation.Rmd")
    render(
      input         = input_rmd,
      output_format = "latex_document",
      quiet         = !verbose
    )
    path_tex <- file.path(path_rvalidation, "R-validation.tex")
    if (!file.exists(path_tex)) stop("Rendering did not produce the expected LaTeX report.")
    
    if (render_latex) {
      path_tex <- file.path(path_rvalidation, "R-validation.tex")
      
      oldwd <- getwd()
      register_on_exit(bquote(setwd(.(oldwd))), on_exit_frame)
      
      if (verbose) cat("\n=== Now generating RMarkdown ===\n")
      
      setwd(path_rvalidation)
      pdflatex(path_tex)
      setwd(oldwd)
      if (!file.exists(file.path(path_rvalidation, "R-validation.pdf"))) {
        stop("LaTeX did not produce the expected PDF report.")
      }
      
      if (verbose) cat("\n=== RMarkdown report complete===\n")
    }
    
    return(invisible(input_rmd))
  }

  if(engine == "quarto"){
    #-----------------------------------------------------------------------------
    # Render qmd to pdf
    #-----------------------------------------------------------------------------
    # Copy Rmd file to 'path_rvalidation'
    pkg_qmd <- file.path("qualify_r", "R-validation.qmd")
    path_qmd <- file.path(path_rvalidation, "R-validation.qmd")
    
    if (!file.copy(system.file(pkg_qmd, package = "rqualify"), path_rvalidation)) {
      stop("Could not copy the Quarto report template.")
    }
    
    if(verbose) cat("\n=== Now generating PDF ===\n")
    
    quarto_render(input = path_qmd, quiet = !verbose, as_job = FALSE)
    if (!file.exists(file.path(path_rvalidation, "R-validation.pdf"))) {
      stop("Quarto did not produce the expected PDF report.")
    }
    
    invisible(path_qmd)
  }
    
}

#' Register an expression on a target frame's `on.exit` stack
#'
#' @keywords internal
#' @noRd
register_on_exit <- function(expr, frame) {
  do.call(
    "on.exit",
    list(expr, add = TRUE),
    envir = frame
  )
}
