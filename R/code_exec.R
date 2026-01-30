#' Run a code chunk at the command line
#'
#' # This function allows you to run a block of R code or an R script file at the command line,
#'
#' @param code_path Character. Path to an R script file to be executed.
#'
#' @param code_block Character vector. R code to be executed.
#'
#' @param file_prefix Character. Prefix for the output files.
#'
#' @param folder_output Character. Path to the folder where output files will be saved.
#'
#' @details This function executes R code at the command line. Code can be input
#'   either as a path to a script using \code{code_path} or as a quoted code block using
#'   \code{code_block}. The output is then read and returned as a character vector.
#'
#' @examples
#' \dontrun{
#' out_temp <- tempdir()
#'
#' # Using code_block
#' code_exec(code_block="Sys.info()", file_prefix="sysinfo", folder_output=out_temp)
#'
#' # Using code_path (pre-existing R script)
#' code_exec(code_path=file.path(out_temp, "sysinfo.R"), file_prefix="sysinfo", folder_output=out_temp)
#' }
#'
#' @export
code_exec <- function(code_path, code_block, file_prefix, folder_output){

  mf <- match.call(expand.dots = FALSE)

  if("code_block" %in% names(mf)){
    # Set code file name
    file_code <- file.path(folder_output,
                           paste0(file_prefix, ".R"))


    # Write code_block to R file
    fileConn <- file(file_code)
    writeLines(code_block, fileConn)
    close(fileConn)
  } else{
    file_code <- code_path
  }


  # Set output file name
  file_output <- file.path(folder_output,
                           paste0(file_prefix, "Out.txt"))


  # Command to run @ command line
  cmd <- paste(shQuote(file.path(R.home("bin"), "R")),
               "CMD BATCH --vanilla --no-timing", shQuote(file_code), shQuote(file_output))

  # Run the command
  run <- try(system(cmd))

  # Load results and return
  readLines(file.path(folder_output, paste0(file_prefix, "Out.txt")))
}
