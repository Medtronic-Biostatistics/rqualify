#' Thin wrappers around `.Platform` to keep platform detection mockable
#'
#' These exist solely so tests can stub OS-specific branches via
#' [testthat::local_mocked_bindings()] — `.Platform` itself is a base-R
#' constant and not mockable.
#'
#' @return `os_type()` returns `"windows"` or `"unix"`; `path_sep()`
#'   returns the platform path separator (`";"` on Windows, `":"` elsewhere).
#'
#' @keywords internal
#' @noRd
os_type <- function() {
  .Platform$OS.type
}

#' @rdname os_type
#' @noRd
path_sep <- function() {
  .Platform$path.sep
}

#' Thin wrapper around `base::dir.exists()` for mockability in tests.
#'
#' @keywords internal
#' @noRd
dir_exists <- function(paths) {
  dir.exists(paths)
}
