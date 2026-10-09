# Run IQ-OQ on an installation of R software

Run IQ-OQ on an installation of R software

## Usage

``` r
rqualify(
  path_save,
  setup_tinytex = TRUE,
  setup_pandoc = TRUE,
  render_latex = TRUE,
  engine = "latex",
  verbose = TRUE,
  details = FALSE
)
```

## Arguments

- path_save:

  Character. Existing, writable directory in which to create the
  R-validation folder. That folder must not already exist.

- setup_tinytex:

  Logical. Allow installation of TinyTeX and the grfext package when PDF
  compilation requires LaTeX and no existing installation is available.
  Existing LaTeX installations are reused. Ignored for Quarto.

- setup_pandoc:

  Logical. Allow installation of Pandoc when none is available for R
  Markdown. Existing system, IDE, or managed installations are reused.
  Ignored for Quarto, which includes Pandoc.

- render_latex:

  Logical. Compile the LaTeX report to PDF when `engine = "latex"`. If
  FALSE, generate only the LaTeX file. Ignored for Quarto, which always
  generates a PDF through Typst.

- engine:

  Character. Either `"latex"` or `"quarto"`.

- verbose:

  Logical. Print progress messages.

- details:

  Logical. Return structured qualification results instead of just the
  output directory. Defaults to FALSE for compatibility.

## Value

By default, the path to the R-validation folder. With `details = TRUE`,
a `rqualify_result` list containing `status` (`"ok"`, `"fail"`,
`"missing"`, or `"invalid"`), the per-suite `summary`, `output_dir`,
artifact paths in `files`, `engine`, `core_test_scope`, R and tool
`versions`, and start and finish times. This list is also saved as
`validation_result.rds` for either return mode.

## Details

Arguments, the destination, and engine-specific prerequisites are
checked before output directories are created. Quarto uses its bundled
Pandoc and Typst and does not require TinyTeX or a separate Pandoc
install. The selected R installation must include its installed tests.

Both report formats use the same subprocess runner. Passing a suite
requires a zero exit status and exactly one explicit PASS completion
result. Crashes and incomplete results cannot pass. The core system
tests use `tools::testInstalledBasic(scope = "basic")`; development and
internet test scopes are not run. Base and recommended package examples,
vignettes, and tests are checked separately.

The output includes the report source, subprocess scripts and logs,
`IQ-OQ-TestOutput/test_summary.csv`, and `validation_result.rds`. Failed
qualification, missing summaries, and invalid summaries produce
warnings. Inspect the returned details or saved results to distinguish
these outcomes. Rendering errors stop execution and leave diagnostic
files in the output directory. Temporary environment changes are
restored.

## Examples

``` r
if (FALSE) { # \dontrun{
# Reuse installed LaTeX and Pandoc.
rqualify(path_save = tempdir(), setup_tinytex = FALSE, setup_pandoc = FALSE)

# Quarto uses its bundled tools; choose a fresh output location.
destination <- tempfile()
dir.create(destination)
result <- rqualify(destination, engine = "quarto", details = TRUE)
result$status
result$summary
} # }
```
