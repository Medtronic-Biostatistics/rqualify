#' Build and signal a classed condition
#'
#' Internal helpers. `rqualify_stop()` and `rqualify_warn()` signal
#' subclassed `error`/`warning` conditions so that callers can catch
#' specific failures programmatically (e.g. `tryCatch(rqualify(...),
#' rqualify_no_tests_folder = handler)`).
#'
#' Every condition carries the class hierarchy
#' `c(subclass, "rqualify_condition", "<error|warning>", "condition")`,
#' so callers can also catch any rqualify-originated condition with
#' `tryCatch(..., rqualify_condition = handler)`.
#'
#' @param subclass Character. Specific condition subclass, e.g.
#'   `"rqualify_no_tests_folder"`.
#' @param message  Character. Condition message.
#' @param ...      Additional named fields stored on the condition.
#'
#' @keywords internal
#' @noRd
rqualify_stop <- function(subclass, message, ...) {
  stop(rqualify_condition(subclass, "error", message, ...))
}

#' @keywords internal
#' @noRd
rqualify_warn <- function(subclass, message, ...) {
  warning(rqualify_condition(subclass, "warning", message, ...))
}

#' @keywords internal
#' @noRd
rqualify_condition <- function(subclass, kind, message, ...) {
  structure(
    class = c(subclass, "rqualify_condition", kind, "condition"),
    list(message = message, call = sys.call(-2), ...)
  )
}
