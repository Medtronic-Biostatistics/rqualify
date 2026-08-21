# rqualify 1.0.4

## API hardening

* `rqualify()` now validates its arguments before doing any work:
  `path_save` must be a single non-empty string, and `setup_tinytex`,
  `setup_pandoc`, `render_latex`, and `verbose` must each be a single
  `TRUE` or `FALSE` (not `NA`, not coercible).
* All `stop()` and `warning()` calls now signal subclassed conditions so
  that callers can catch specific failures programmatically. Every
  condition carries the class hierarchy
  `c(subclass, "rqualify_condition", "<error|warning>", "condition")`.
  The defined subclasses are:
  * `rqualify_missing_arg` - `path_save` not supplied
  * `rqualify_bad_arg` - argument failed a type/length check
  * `rqualify_no_tests_folder` - R installation lacks `tests/`
  * `rqualify_dir_exists` - `R-validation` folder already present
  * `rqualify_dir_create_failed` - `dir.create()` returned `FALSE`
  * `rqualify_tinytex_missing` - TinyTeX not detected and
    `setup_tinytex = FALSE`
  * `rqualify_tinytex_incomplete` - no `bin/` subdirectory under the
    TinyTeX root
  * `rqualify_pandoc_missing` - Pandoc not detected and
    `setup_pandoc = FALSE`
  * `rqualify_summary_missing` (warning) - `test_summary.csv` not
    written by the validation render
  * `rqualify_validation_failed` (warning) - one or more rows in
    `test_summary.csv` are `"FAIL"`
* `setup_validation_dirs()` now removes the outer `R-validation` folder
  if creating the inner `IQ-OQ-TestOutput` folder fails, so a failed
  call no longer leaves behind a partial tree that would trip the
  "already exists" guard on a retry.

## Bug fixes

* `setup_tinytex_env()` no longer assumes the TinyTeX `bin/` subdirectory
  is named `x86_64-linux` on every non-Windows platform. The subdirectory
  is now detected by listing `bin/`, which fixes `PATH` wiring on macOS
  (including Apple Silicon) and on `aarch64-linux`. A clearer error is
  raised if no `bin/` subdirectory is found.
* Fixed a duplicated `"Now generating RMarkdown"` banner printed by
  `rqualify(verbose = TRUE)` before LaTeX compilation; it now reads
  `"Now compiling LaTeX to PDF"`.
* Fixed a stray dangling backtick in the `@param setup_pandoc`
  documentation that rendered oddly on the help page and the package
  website.

## Major changes

* None. The public API is unchanged: `rqualify()` retains its signature,
  return value, and side effects.

## Internal changes

* Refactored `rqualify()` into focused, independently testable internal
  helpers:
  * `setup_validation_dirs()` — path normalization, R `tests/` precondition
    check, and creation of the `R-validation/IQ-OQ-TestOutput` tree.
  * `setup_tinytex_env()` — TinyTeX installation and `PATH` wiring, or a
    precondition check when `setup_tinytex = FALSE`.
  * `setup_pandoc_env()` — Pandoc installation and activation, or a
    precondition check when `setup_pandoc = FALSE`.
  * `render_validation()` — Rmd copy, locale/language management, render
    to LaTeX, and optional `pdflatex()` compilation. The `on.exit()`
    handlers that restore locale, `LANGUAGE`, and the working directory
    are now attached to the caller's frame (via a small
    `register_on_exit()` utility), preserving the original lifetime of
    those restorations.
  * `check_validation_results()` — reads `test_summary.csv`, warns on
    failures or missing files, and returns a `"ok"` / `"fail"` /
    `"missing"` status code for testability.
* Introduced thin `os_type()` / `path_sep()` / `dir_exists()` wrappers
  around `.Platform` and `dir.exists()` so OS-specific and base-function
  branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Removed unused `@importFrom` entries
  (`tools::file_path_sans_ext`, `rmarkdown::pandoc_version`,
  `tinytex::tlmgr_version`) so the package namespace only imports symbols
  it actually uses.
* Removed `LazyData: true` from `DESCRIPTION` since the package exports
  no datasets; `R CMD build` was already stripping it.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").
* Qualified the step list in `@details` so it makes clear that the
  TinyTeX install, Pandoc install, and `pdflatex` compilation steps are
  conditional on `setup_tinytex`, `setup_pandoc`, and `render_latex`
  respectively.

## Code organization

* Moved `register_on_exit()` out of `R/render_validation.R` and into a
  new `R/utils.R` so it lives alongside other general-purpose internal
  utilities.
* Hoisted the package's magic strings (the bundled-Rmd subdir and
  filename, and the names of the `R-validation`, `IQ-OQ-TestOutput`,
  and `test_summary.csv` artifacts) into a single `rqualify_paths`
  named list in a new `R/paths.R`, so any future rename only needs to
  touch one place.
* Dropped redundant `@keywords internal` lines from helpers that are
  already marked `@noRd` — `@noRd` already suppresses `.Rd` generation,
  so the keyword had no effect.
* Documented why `setup_tinytex_env()` leaves
  `options(tinytex.install_packages = TRUE)` set after `rqualify()`
  returns (so subsequent renders in the same session can auto-install
  missing CTAN packages).

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  (including filesystem-based tests that cover the Windows
  `win32`+`windows`, Linux `x86_64-linux`, and macOS `universal-darwin`
  `bin/` layouts, plus the new incomplete-install error path) and
  `setup_pandoc_env()`.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
* Added `withr` to `Suggests` to support these tests.
* Added tests for the new classed-condition machinery
  (`rqualify_stop`, `rqualify_warn`, and the `check_string` /
  `check_flag` argument validators), input-validation tests for
  `rqualify()` that confirm guard errors fire before any helper is
  called, and a chmod-based test for the partial-tree-cleanup behavior
  of `setup_validation_dirs()`. Existing error/warning tests were
  updated to assert on condition subclass rather than message text.

## Code style & CI

* Applied `styler::style_pkg()` (tidyverse style) across the package
  sources, tests, vignettes, and roxygen examples.
* Added a project-level `.lintr` config and a developer-facing `STYLE.md`
  documenting the convention and how to run `styler::style_pkg()` and
  `lintr::lint_package()`.
* Added a `lint.yaml` GitHub Actions workflow that runs
  `styler::style_pkg(dry = "fail")` and `lintr::lint_package()` on every
  push to `main`/`master` and on every pull request, so style drift is
  caught in CI.
* Wrapped two long warning strings to fit within the 100-character line
  limit enforced by `lintr`.

## Other

* Added `^\.posit# rqualify 1.0.4

## API hardening

* `rqualify()` now validates its arguments before doing any work:
  `path_save` must be a single non-empty string, and `setup_tinytex`,
  `setup_pandoc`, `render_latex`, and `verbose` must each be a single
  `TRUE` or `FALSE` (not `NA`, not coercible).
* All `stop()` and `warning()` calls now signal subclassed conditions so
  that callers can catch specific failures programmatically. Every
  condition carries the class hierarchy
  `c(subclass, "rqualify_condition", "<error|warning>", "condition")`.
  The defined subclasses are:
  * `rqualify_missing_arg` - `path_save` not supplied
  * `rqualify_bad_arg` - argument failed a type/length check
  * `rqualify_no_tests_folder` - R installation lacks `tests/`
  * `rqualify_dir_exists` - `R-validation` folder already present
  * `rqualify_dir_create_failed` - `dir.create()` returned `FALSE`
  * `rqualify_tinytex_missing` - TinyTeX not detected and
    `setup_tinytex = FALSE`
  * `rqualify_tinytex_incomplete` - no `bin/` subdirectory under the
    TinyTeX root
  * `rqualify_pandoc_missing` - Pandoc not detected and
    `setup_pandoc = FALSE`
  * `rqualify_summary_missing` (warning) - `test_summary.csv` not
    written by the validation render
  * `rqualify_validation_failed` (warning) - one or more rows in
    `test_summary.csv` are `"FAIL"`
* `setup_validation_dirs()` now removes the outer `R-validation` folder
  if creating the inner `IQ-OQ-TestOutput` folder fails, so a failed
  call no longer leaves behind a partial tree that would trip the
  "already exists" guard on a retry.

## Bug fixes

* `setup_tinytex_env()` no longer assumes the TinyTeX `bin/` subdirectory
  is named `x86_64-linux` on every non-Windows platform. The subdirectory
  is now detected by listing `bin/`, which fixes `PATH` wiring on macOS
  (including Apple Silicon) and on `aarch64-linux`. A clearer error is
  raised if no `bin/` subdirectory is found.
* Fixed a duplicated `"Now generating RMarkdown"` banner printed by
  `rqualify(verbose = TRUE)` before LaTeX compilation; it now reads
  `"Now compiling LaTeX to PDF"`.
* Fixed a stray dangling backtick in the `@param setup_pandoc`
  documentation that rendered oddly on the help page and the package
  website.

## Major changes

* None. The public API is unchanged: `rqualify()` retains its signature,
  return value, and side effects.

## Internal changes

* Refactored `rqualify()` into focused, independently testable internal
  helpers:
  * `setup_validation_dirs()` — path normalization, R `tests/` precondition
    check, and creation of the `R-validation/IQ-OQ-TestOutput` tree.
  * `setup_tinytex_env()` — TinyTeX installation and `PATH` wiring, or a
    precondition check when `setup_tinytex = FALSE`.
  * `setup_pandoc_env()` — Pandoc installation and activation, or a
    precondition check when `setup_pandoc = FALSE`.
  * `render_validation()` — Rmd copy, locale/language management, render
    to LaTeX, and optional `pdflatex()` compilation. The `on.exit()`
    handlers that restore locale, `LANGUAGE`, and the working directory
    are now attached to the caller's frame (via a small
    `register_on_exit()` utility), preserving the original lifetime of
    those restorations.
  * `check_validation_results()` — reads `test_summary.csv`, warns on
    failures or missing files, and returns a `"ok"` / `"fail"` /
    `"missing"` status code for testability.
* Introduced thin `os_type()` / `path_sep()` / `dir_exists()` wrappers
  around `.Platform` and `dir.exists()` so OS-specific and base-function
  branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Removed unused `@importFrom` entries
  (`tools::file_path_sans_ext`, `rmarkdown::pandoc_version`,
  `tinytex::tlmgr_version`) so the package namespace only imports symbols
  it actually uses.
* Removed `LazyData: true` from `DESCRIPTION` since the package exports
  no datasets; `R CMD build` was already stripping it.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").
* Qualified the step list in `@details` so it makes clear that the
  TinyTeX install, Pandoc install, and `pdflatex` compilation steps are
  conditional on `setup_tinytex`, `setup_pandoc`, and `render_latex`
  respectively.

## Code organization

* Moved `register_on_exit()` out of `R/render_validation.R` and into a
  new `R/utils.R` so it lives alongside other general-purpose internal
  utilities.
* Hoisted the package's magic strings (the bundled-Rmd subdir and
  filename, and the names of the `R-validation`, `IQ-OQ-TestOutput`,
  and `test_summary.csv` artifacts) into a single `rqualify_paths`
  named list in a new `R/paths.R`, so any future rename only needs to
  touch one place.
* Dropped redundant `@keywords internal` lines from helpers that are
  already marked `@noRd` — `@noRd` already suppresses `.Rd` generation,
  so the keyword had no effect.
* Documented why `setup_tinytex_env()` leaves
  `options(tinytex.install_packages = TRUE)` set after `rqualify()`
  returns (so subsequent renders in the same session can auto-install
  missing CTAN packages).

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  (including filesystem-based tests that cover the Windows
  `win32`+`windows`, Linux `x86_64-linux`, and macOS `universal-darwin`
  `bin/` layouts, plus the new incomplete-install error path) and
  `setup_pandoc_env()`.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
* Added `withr` to `Suggests` to support these tests.
* Added tests for the new classed-condition machinery
  (`rqualify_stop`, `rqualify_warn`, and the `check_string` /
  `check_flag` argument validators), input-validation tests for
  `rqualify()` that confirm guard errors fire before any helper is
  called, and a chmod-based test for the partial-tree-cleanup behavior
  of `setup_validation_dirs()`. Existing error/warning tests were
  updated to assert on condition subclass rather than message text.

## Code style & CI

* Applied `styler::style_pkg()` (tidyverse style) across the package
  sources, tests, vignettes, and roxygen examples.
* Added a project-level `.lintr` config and a developer-facing `STYLE.md`
  documenting the convention and how to run `styler::style_pkg()` and
  `lintr::lint_package()`.
* Added a `lint.yaml` GitHub Actions workflow that runs
  `styler::style_pkg(dry = "fail")` and `lintr::lint_package()` on every
  push to `main`/`master` and on every pull request, so style drift is
  caught in CI.
* Wrapped two long warning strings to fit within the 100-character line
  limit enforced by `lintr`.

## Other

 to `.Rbuildignore` to exclude Positron session
  artifacts from the package build.
* Added `^STYLE\.md# rqualify 1.0.4

## API hardening

* `rqualify()` now validates its arguments before doing any work:
  `path_save` must be a single non-empty string, and `setup_tinytex`,
  `setup_pandoc`, `render_latex`, and `verbose` must each be a single
  `TRUE` or `FALSE` (not `NA`, not coercible).
* All `stop()` and `warning()` calls now signal subclassed conditions so
  that callers can catch specific failures programmatically. Every
  condition carries the class hierarchy
  `c(subclass, "rqualify_condition", "<error|warning>", "condition")`.
  The defined subclasses are:
  * `rqualify_missing_arg` - `path_save` not supplied
  * `rqualify_bad_arg` - argument failed a type/length check
  * `rqualify_no_tests_folder` - R installation lacks `tests/`
  * `rqualify_dir_exists` - `R-validation` folder already present
  * `rqualify_dir_create_failed` - `dir.create()` returned `FALSE`
  * `rqualify_tinytex_missing` - TinyTeX not detected and
    `setup_tinytex = FALSE`
  * `rqualify_tinytex_incomplete` - no `bin/` subdirectory under the
    TinyTeX root
  * `rqualify_pandoc_missing` - Pandoc not detected and
    `setup_pandoc = FALSE`
  * `rqualify_summary_missing` (warning) - `test_summary.csv` not
    written by the validation render
  * `rqualify_validation_failed` (warning) - one or more rows in
    `test_summary.csv` are `"FAIL"`
* `setup_validation_dirs()` now removes the outer `R-validation` folder
  if creating the inner `IQ-OQ-TestOutput` folder fails, so a failed
  call no longer leaves behind a partial tree that would trip the
  "already exists" guard on a retry.

## Bug fixes

* `setup_tinytex_env()` no longer assumes the TinyTeX `bin/` subdirectory
  is named `x86_64-linux` on every non-Windows platform. The subdirectory
  is now detected by listing `bin/`, which fixes `PATH` wiring on macOS
  (including Apple Silicon) and on `aarch64-linux`. A clearer error is
  raised if no `bin/` subdirectory is found.
* Fixed a duplicated `"Now generating RMarkdown"` banner printed by
  `rqualify(verbose = TRUE)` before LaTeX compilation; it now reads
  `"Now compiling LaTeX to PDF"`.
* Fixed a stray dangling backtick in the `@param setup_pandoc`
  documentation that rendered oddly on the help page and the package
  website.

## Major changes

* None. The public API is unchanged: `rqualify()` retains its signature,
  return value, and side effects.

## Internal changes

* Refactored `rqualify()` into focused, independently testable internal
  helpers:
  * `setup_validation_dirs()` — path normalization, R `tests/` precondition
    check, and creation of the `R-validation/IQ-OQ-TestOutput` tree.
  * `setup_tinytex_env()` — TinyTeX installation and `PATH` wiring, or a
    precondition check when `setup_tinytex = FALSE`.
  * `setup_pandoc_env()` — Pandoc installation and activation, or a
    precondition check when `setup_pandoc = FALSE`.
  * `render_validation()` — Rmd copy, locale/language management, render
    to LaTeX, and optional `pdflatex()` compilation. The `on.exit()`
    handlers that restore locale, `LANGUAGE`, and the working directory
    are now attached to the caller's frame (via a small
    `register_on_exit()` utility), preserving the original lifetime of
    those restorations.
  * `check_validation_results()` — reads `test_summary.csv`, warns on
    failures or missing files, and returns a `"ok"` / `"fail"` /
    `"missing"` status code for testability.
* Introduced thin `os_type()` / `path_sep()` / `dir_exists()` wrappers
  around `.Platform` and `dir.exists()` so OS-specific and base-function
  branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Removed unused `@importFrom` entries
  (`tools::file_path_sans_ext`, `rmarkdown::pandoc_version`,
  `tinytex::tlmgr_version`) so the package namespace only imports symbols
  it actually uses.
* Removed `LazyData: true` from `DESCRIPTION` since the package exports
  no datasets; `R CMD build` was already stripping it.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").
* Qualified the step list in `@details` so it makes clear that the
  TinyTeX install, Pandoc install, and `pdflatex` compilation steps are
  conditional on `setup_tinytex`, `setup_pandoc`, and `render_latex`
  respectively.

## Code organization

* Moved `register_on_exit()` out of `R/render_validation.R` and into a
  new `R/utils.R` so it lives alongside other general-purpose internal
  utilities.
* Hoisted the package's magic strings (the bundled-Rmd subdir and
  filename, and the names of the `R-validation`, `IQ-OQ-TestOutput`,
  and `test_summary.csv` artifacts) into a single `rqualify_paths`
  named list in a new `R/paths.R`, so any future rename only needs to
  touch one place.
* Dropped redundant `@keywords internal` lines from helpers that are
  already marked `@noRd` — `@noRd` already suppresses `.Rd` generation,
  so the keyword had no effect.
* Documented why `setup_tinytex_env()` leaves
  `options(tinytex.install_packages = TRUE)` set after `rqualify()`
  returns (so subsequent renders in the same session can auto-install
  missing CTAN packages).

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  (including filesystem-based tests that cover the Windows
  `win32`+`windows`, Linux `x86_64-linux`, and macOS `universal-darwin`
  `bin/` layouts, plus the new incomplete-install error path) and
  `setup_pandoc_env()`.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
* Added `withr` to `Suggests` to support these tests.
* Added tests for the new classed-condition machinery
  (`rqualify_stop`, `rqualify_warn`, and the `check_string` /
  `check_flag` argument validators), input-validation tests for
  `rqualify()` that confirm guard errors fire before any helper is
  called, and a chmod-based test for the partial-tree-cleanup behavior
  of `setup_validation_dirs()`. Existing error/warning tests were
  updated to assert on condition subclass rather than message text.

## Code style & CI

* Applied `styler::style_pkg()` (tidyverse style) across the package
  sources, tests, vignettes, and roxygen examples.
* Added a project-level `.lintr` config and a developer-facing `STYLE.md`
  documenting the convention and how to run `styler::style_pkg()` and
  `lintr::lint_package()`.
* Added a `lint.yaml` GitHub Actions workflow that runs
  `styler::style_pkg(dry = "fail")` and `lintr::lint_package()` on every
  push to `main`/`master` and on every pull request, so style drift is
  caught in CI.
* Wrapped two long warning strings to fit within the 100-character line
  limit enforced by `lintr`.

## Other

 and `^\.lintr# rqualify 1.0.4

## API hardening

* `rqualify()` now validates its arguments before doing any work:
  `path_save` must be a single non-empty string, and `setup_tinytex`,
  `setup_pandoc`, `render_latex`, and `verbose` must each be a single
  `TRUE` or `FALSE` (not `NA`, not coercible).
* All `stop()` and `warning()` calls now signal subclassed conditions so
  that callers can catch specific failures programmatically. Every
  condition carries the class hierarchy
  `c(subclass, "rqualify_condition", "<error|warning>", "condition")`.
  The defined subclasses are:
  * `rqualify_missing_arg` - `path_save` not supplied
  * `rqualify_bad_arg` - argument failed a type/length check
  * `rqualify_no_tests_folder` - R installation lacks `tests/`
  * `rqualify_dir_exists` - `R-validation` folder already present
  * `rqualify_dir_create_failed` - `dir.create()` returned `FALSE`
  * `rqualify_tinytex_missing` - TinyTeX not detected and
    `setup_tinytex = FALSE`
  * `rqualify_tinytex_incomplete` - no `bin/` subdirectory under the
    TinyTeX root
  * `rqualify_pandoc_missing` - Pandoc not detected and
    `setup_pandoc = FALSE`
  * `rqualify_summary_missing` (warning) - `test_summary.csv` not
    written by the validation render
  * `rqualify_validation_failed` (warning) - one or more rows in
    `test_summary.csv` are `"FAIL"`
* `setup_validation_dirs()` now removes the outer `R-validation` folder
  if creating the inner `IQ-OQ-TestOutput` folder fails, so a failed
  call no longer leaves behind a partial tree that would trip the
  "already exists" guard on a retry.

## Bug fixes

* `setup_tinytex_env()` no longer assumes the TinyTeX `bin/` subdirectory
  is named `x86_64-linux` on every non-Windows platform. The subdirectory
  is now detected by listing `bin/`, which fixes `PATH` wiring on macOS
  (including Apple Silicon) and on `aarch64-linux`. A clearer error is
  raised if no `bin/` subdirectory is found.
* Fixed a duplicated `"Now generating RMarkdown"` banner printed by
  `rqualify(verbose = TRUE)` before LaTeX compilation; it now reads
  `"Now compiling LaTeX to PDF"`.
* Fixed a stray dangling backtick in the `@param setup_pandoc`
  documentation that rendered oddly on the help page and the package
  website.

## Major changes

* None. The public API is unchanged: `rqualify()` retains its signature,
  return value, and side effects.

## Internal changes

* Refactored `rqualify()` into focused, independently testable internal
  helpers:
  * `setup_validation_dirs()` — path normalization, R `tests/` precondition
    check, and creation of the `R-validation/IQ-OQ-TestOutput` tree.
  * `setup_tinytex_env()` — TinyTeX installation and `PATH` wiring, or a
    precondition check when `setup_tinytex = FALSE`.
  * `setup_pandoc_env()` — Pandoc installation and activation, or a
    precondition check when `setup_pandoc = FALSE`.
  * `render_validation()` — Rmd copy, locale/language management, render
    to LaTeX, and optional `pdflatex()` compilation. The `on.exit()`
    handlers that restore locale, `LANGUAGE`, and the working directory
    are now attached to the caller's frame (via a small
    `register_on_exit()` utility), preserving the original lifetime of
    those restorations.
  * `check_validation_results()` — reads `test_summary.csv`, warns on
    failures or missing files, and returns a `"ok"` / `"fail"` /
    `"missing"` status code for testability.
* Introduced thin `os_type()` / `path_sep()` / `dir_exists()` wrappers
  around `.Platform` and `dir.exists()` so OS-specific and base-function
  branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Removed unused `@importFrom` entries
  (`tools::file_path_sans_ext`, `rmarkdown::pandoc_version`,
  `tinytex::tlmgr_version`) so the package namespace only imports symbols
  it actually uses.
* Removed `LazyData: true` from `DESCRIPTION` since the package exports
  no datasets; `R CMD build` was already stripping it.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").
* Qualified the step list in `@details` so it makes clear that the
  TinyTeX install, Pandoc install, and `pdflatex` compilation steps are
  conditional on `setup_tinytex`, `setup_pandoc`, and `render_latex`
  respectively.

## Code organization

* Moved `register_on_exit()` out of `R/render_validation.R` and into a
  new `R/utils.R` so it lives alongside other general-purpose internal
  utilities.
* Hoisted the package's magic strings (the bundled-Rmd subdir and
  filename, and the names of the `R-validation`, `IQ-OQ-TestOutput`,
  and `test_summary.csv` artifacts) into a single `rqualify_paths`
  named list in a new `R/paths.R`, so any future rename only needs to
  touch one place.
* Dropped redundant `@keywords internal` lines from helpers that are
  already marked `@noRd` — `@noRd` already suppresses `.Rd` generation,
  so the keyword had no effect.
* Documented why `setup_tinytex_env()` leaves
  `options(tinytex.install_packages = TRUE)` set after `rqualify()`
  returns (so subsequent renders in the same session can auto-install
  missing CTAN packages).

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  (including filesystem-based tests that cover the Windows
  `win32`+`windows`, Linux `x86_64-linux`, and macOS `universal-darwin`
  `bin/` layouts, plus the new incomplete-install error path) and
  `setup_pandoc_env()`.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
* Added `withr` to `Suggests` to support these tests.
* Added tests for the new classed-condition machinery
  (`rqualify_stop`, `rqualify_warn`, and the `check_string` /
  `check_flag` argument validators), input-validation tests for
  `rqualify()` that confirm guard errors fire before any helper is
  called, and a chmod-based test for the partial-tree-cleanup behavior
  of `setup_validation_dirs()`. Existing error/warning tests were
  updated to assert on condition subclass rather than message text.

## Code style & CI

* Applied `styler::style_pkg()` (tidyverse style) across the package
  sources, tests, vignettes, and roxygen examples.
* Added a project-level `.lintr` config and a developer-facing `STYLE.md`
  documenting the convention and how to run `styler::style_pkg()` and
  `lintr::lint_package()`.
* Added a `lint.yaml` GitHub Actions workflow that runs
  `styler::style_pkg(dry = "fail")` and `lintr::lint_package()` on every
  push to `main`/`master` and on every pull request, so style drift is
  caught in CI.
* Wrapped two long warning strings to fit within the 100-character line
  limit enforced by `lintr`.

## Other

 to `.Rbuildignore` so the
  contributor-facing style files are not shipped in the installed
  package.
* Reordered README badges so CI badges (R-CMD-check, lint, Codecov)
  come first, followed by CRAN and download badges. A broken CI run is
  now visible at a glance.
* Refreshed `cran-comments.md` with a 1.0.4 release summary.
* Bumped `RoxygenNote` to 7.3.3.


# rqualify 1.0.2

## Major changes

* None.

## Minor changes

* Altered rqualify code to include on.exit calls for resetting locale and env settings, and the working directory in response to additional CRAN comments, core functionality remained unchanged.


# rqualify 1.0.1

## Major changes

* None.

## Minor changes

* Altered rqualify function example and vignette in response to CRAN comments, core functionality remained unchanged.


# rqualify 1.0.0

## Major changes

* Initial release for CRAN.
