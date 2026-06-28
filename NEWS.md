# rqualify 1.0.4

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
* Introduced thin `os_type()` / `path_sep()` wrappers around `.Platform`
  so OS-specific branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  and `setup_pandoc_env()`, including platform-mocked tests that cover
  the Windows and non-Windows `PATH` shapes.
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
* Introduced thin `os_type()` / `path_sep()` wrappers around `.Platform`
  so OS-specific branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  and `setup_pandoc_env()`, including platform-mocked tests that cover
  the Windows and non-Windows `PATH` shapes.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
 to `.Rbuildignore` to exclude Positron session
  artifacts from the package build.
* Added `^STYLE\.md# rqualify 1.0.4

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
* Introduced thin `os_type()` / `path_sep()` wrappers around `.Platform`
  so OS-specific branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  and `setup_pandoc_env()`, including platform-mocked tests that cover
  the Windows and non-Windows `PATH` shapes.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
 and `^\.lintr# rqualify 1.0.4

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
* Introduced thin `os_type()` / `path_sep()` wrappers around `.Platform`
  so OS-specific branches can be exercised in tests via
  `testthat::local_mocked_bindings()`.
* Fixed a typo in the `@details` documentation ("Pandox" -> "Pandoc").

## Test scaffolding

* Added pure tests for `setup_validation_dirs()` and
  `check_validation_results()`.
* Added `local_mocked_bindings()`-based tests for `setup_tinytex_env()`
  and `setup_pandoc_env()`, including platform-mocked tests that cover
  the Windows and non-Windows `PATH` shapes.
* Added mocked tests for `render_validation()` that stub
  `rmarkdown::render()` and `tinytex::pdflatex()` and assert that the
  locale, language, and working-directory `on.exit` handlers fire on the
  caller's frame rather than when `render_validation()` itself returns.
* Added orchestration tests for `rqualify()` that verify the helper call
  order, argument propagation, the missing-`path_save` guard, and that
  the `R-validation` path is still returned when
  `check_validation_results()` warns (FAIL summaries or missing summary
  files).
 to `.Rbuildignore` so the
  contributor-facing style files are not shipped in the installed
  package.
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

