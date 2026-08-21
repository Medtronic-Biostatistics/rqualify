# Code style

This package follows the [tidyverse style
guide](https://style.tidyverse.org/), enforced by
[`styler`](https://styler.r-lib.org/) and checked by
[`lintr`](https://lintr.r-lib.org/).

## Formatting

Before submitting changes, run:

``` r

styler::style_pkg()
```

This applies `styler::tidyverse_style()` (the default) across all R,
Rmd, and Quarto sources in the package, including tests and vignettes.

Notable conventions enforced by this style:

- Two-space indentation.
- Spaces around `=`, `<-`, infix operators, and after commas.
- One argument per line for multi-line function calls (no column-aligned
  `=`).
- `<-` for assignment (not `=`).

## Linting

A `.lintr` config in the project root is read automatically by `lintr`.
To check the package:

``` r

lintr::lint_package()
```

The config:

- Sets `line_length_linter` to 100 characters.
- Disables `object_name_linter` (the package uses both snake_case and
  the existing `path_*` / `summ_*` conventions that pre-date this
  config).
- Disables `commented_code_linter` (commented examples appear in the
  bundled R-validation Rmd).
- Excludes `inst/qualify_r/R-validation.Rmd` and `vignettes/` from
  linting, since these contain narrative prose with embedded code that
  the default linters flag noisily.

## CI

Coverage is reported via Codecov on every push and PR (see
`.github/workflows/test-coverage.yaml`). Style and lint checks are not
yet wired into CI; running them locally before submitting is sufficient
for now.
