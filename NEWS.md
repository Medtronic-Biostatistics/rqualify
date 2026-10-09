# rqualify 1.2.0

## Major changes

- Qualification now requires a successful subprocess exit and an explicit PASS completion result. 

- Summary checking now validates all eight expected suites, required columns, allowed statuses, and consistency with available execution evidence. Missing or malformed summaries cannot establish a successful qualification.

- Added `details = TRUE` to `rqualify()` to return overall status, per-suite evidence, report paths, timestamps, and R/tool versions. These results are also saved as `validation_result.rds`; the default return remains the output directory path.

- Quarto uses its bundled Pandoc and Typst without checking for or installing TinyTeX or standalone Pandoc. The selected R executable is passed to Quarto explicitly.

- Invalid engines, logical arguments, and output paths are rejected before setup. Dependency checks precede directory creation, allowing retries after a missing prerequisite is resolved. 


## Minor changes

- Fixed the Windows CI test for TinyTeX PATH activation to use the native path separator and executable name. 

- Both report formats now share execution and result-classification functions. Subprocess scripts and logs are retained, and paths containing spaces or quotes are handled safely.

- Added regression tests for subprocess failures, malformed summaries, engine-specific prerequisites, retries, tool discovery, and structured results. Added opt-in PDF rendering smoke tests for both templates and a dedicated CI workflow using short failure fixtures.

- Expanded test coverage for tool-version metadata, all six package test suites, subprocess diagnostics, template and directory failures, and missing renderers.

- Clarified that core system tests use `scope = "basic"`; development and internet scopes are not run. Updated the templates, function documentation, and vignettes to describe the actual checks and results.

- Added a light, dark, and automatic theme selector to the pkgdown website, with code highlighting for both light and dark modes.


# rqualify 1.1.0

## Major changes

- Support for report generation via quarto and typst, enabling RStudio users to run a report without having to install tinytex or pandoc (quarto, pandoc and typst are included in the RStudio installation).

## Minor changes

- Added several functions to increase modularity and allow for easier development of unit tests.

- Added several unit tests for the new functions.

# rqualify 1.0.2

## Major changes

- None.

## Minor changes

- Altered rqualify code to include on.exit calls for resetting locale and env settings, and the working directory in response to additional CRAN comments, core functionality remained unchanged.

# rqualify 1.0.1

## Major changes

- None.

## Minor changes

- Altered rqualify function example and vignette in response to CRAN comments, core functionality remained unchanged.

# rqualify 1.0.0

## Major changes

- Initial release for CRAN.
