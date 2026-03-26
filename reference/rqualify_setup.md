# Initialize environment for IQ-OQ.

Initialize environment for IQ-OQ.

## Usage

``` r
rqualify_setup(setup_tinytex = TRUE, setup_pandoc = TRUE, verbose = TRUE)
```

## Arguments

- setup_tinytex:

  Logical. If TRUE, sets up TinyTeX for LaTeX document generation. Note,
  this does not install the tinytex R package, but the TinyTeX LaTeX
  bundle. It is a convenient wrapper for installing TinyTeX using
  \`tinytex::install_tinytex()\`, and adding the TinyTeX location to the
  environment The function installes the "TinyTeX" bundle and the
  additional package \`grfext\`, and sets the TinyTeX installation path
  on the system PATH.

- setup_pandoc:

  Logical. If TRUE, sets up pandoc for document conversion. Note, this
  does not install the pandoc R package, but the Pandoc software. It is
  a convenient wrapper around \`pandoc::pandoc_install()\` and
  \`pandoc::pandoc_activate()\`, which are called internally.

- verbose:

  Logical. If TRUE, prints progress messages to the console.

## Value

A list with the installed Pandoc and TinyTeX versions, though the
primary purpose of this function is its side effects, setting up TinyTeX
and Pandoc as specified.

## Details

\`rqualify_setup\` is an internal function that installs TinyTeX and
Pandoc as required for rendering Rmd files to PDF. The process can be
quite time consuming, especially if TinyTeX needs to be installed, and
there may be apparent hanging processes – this is expected behavior.

## See also

[`rqualify`](https://medtronic-biostatistics.github.io/rqualify/reference/rqualify.md)
which calls this function internally.

## Examples

``` r
if (FALSE) { # rlang::is_interactive()
# \donttest{
rqualify_setup()
# }
}
```
