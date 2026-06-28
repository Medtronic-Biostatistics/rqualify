#' Register an expression on a target frame's `on.exit` stack
#'
#' Internal utility. Lets a helper function install an `on.exit()`
#' handler that fires when its *caller* returns, rather than when the
#' helper itself returns. Used in `render_validation()` to keep
#' locale, language, and working-directory restoration alive for the
#' duration of `rqualify()`.
#'
#' @param expr  An unevaluated expression (typically a `bquote()` call).
#' @param frame The environment to attach the handler to.
#'
#' @noRd
register_on_exit <- function(expr, frame) {
  do.call(
    "on.exit",
    list(expr, add = TRUE),
    envir = frame
  )
}
