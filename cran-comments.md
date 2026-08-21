## Release summary

rqualify 1.0.4 is a maintenance release with bug fixes, internal
refactoring, and API hardening. The public API is unchanged.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Highlights since 1.0.3

* Bug fix: `setup_tinytex_env()` no longer assumes the TinyTeX `bin/`
  subdirectory is named `x86_64-linux` on every non-Windows platform.
  The subdirectory is now detected by listing `bin/`, which correctly
  handles macOS (including Apple Silicon) and `aarch64-linux`.
* Bug fix: removed a duplicated "Now generating RMarkdown" banner that
  was printed before LaTeX compilation when `verbose = TRUE`.
* Bug fix: fixed a stray dangling backtick in roxygen documentation.
* `rqualify()` now validates its arguments before doing any work.
* All errors and warnings now signal subclassed conditions (e.g.
  `rqualify_no_tests_folder`, `rqualify_validation_failed`) so callers
  can catch specific failures programmatically.
* Internal refactor: split `rqualify()` into five testable helper
  functions; test coverage rose from 1.52% to 96%.
* Removed unused namespace imports and the unused `LazyData: true` from
  DESCRIPTION.

## Test environments

* local macOS, R 4.5.3
* GitHub Actions: macos-latest (release), windows-latest (release),
  ubuntu-latest (devel/release/oldrel-1) via the standard
  r-lib/actions R-CMD-check workflow
