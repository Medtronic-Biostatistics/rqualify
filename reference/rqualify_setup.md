# Initialize environment for IQ-OQ.

Initialize environment for IQ-OQ.

## Usage

``` r
rqualify_setup(
  path_save,
  setup_tinytex = TRUE,
  setup_pandoc = TRUE,
  verbose = TRUE
)
```

## Arguments

- path_save:

  Character. Path where the 'R-validation' folder will be created to
  store validation outputs.

- setup_tinytex:

  Logical. If TRUE, sets up tinytex for LaTeX document generation.

- setup_pandoc:

  Logical. If TRUE, sets up pandoc for document conversion.

- verbose:

  Logical. If TRUE, prints progress messages to the console.

## Details

The function sets up the environment by configuring locale settings and
installing any dependencies, including tinytex and pandoc.

## See also

[`rqualify`](https://medtronic-biostatistics.github.io/rqualify/reference/rqualify.md)
which calls this function internally.

## Examples

``` r
if (FALSE) { # \dontrun{
rqualify_setup(path_save   = "~")
} # }
```
