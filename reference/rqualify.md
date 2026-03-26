# Run IQ-OQ on an installation of R software

Run IQ-OQ on an installation of R software

## Usage

``` r
rqualify(
  path_save,
  setup_tinytex = TRUE,
  setup_pandoc = TRUE,
  file_rmd = "R-validation.Rmd",
  verbose = TRUE
)
```

## Arguments

- path_save:

  Character. Path to save the R-validation folder. Ensure a folder named
  \`R-validation\` does not already exist at this location.

- setup_tinytex:

  Logical. If TRUE, sets up TinyTeX for LaTeX document generation. Note,
  this does not install the tinytex R package, but the TinyTeX LaTeX
  bundle. It is a convenient wrapper for installing TinyTeX using
  \`tinytex::install_tinytex()\`, and adding the TinyTeX location to the
  environment path. See
  [`rqualify_setup`](https://medtronic-biostatistics.github.io/rqualify/reference/rqualify_setup.md)
  for more details.

- setup_pandoc:

  Logical. If TRUE, sets up pandoc for document conversion. Note, this
  does not install the pandoc R package, but the Pandoc software. It is
  a convenient wrapper around \`pandoc::pandoc_install()\` and
  \`pandoc::pandoc_activate()\`, which are called internally.

- file_rmd:

  String. Name of RMarkdown file to render. Default is
  "R-validation.Rmd". Also included is "R-validationPreamble.Rmd", which
  contains the preamble and introduction portion of the report. The
  RMarkdown file should be located in the \`inst/qualify_r\` folder of
  the package.

- verbose:

  Logical. If TRUE, prints progress messages to the console.

## Value

The path to the \`R-validation\` folder. The primary purpose of this
function is its side effects, rendering an RMarkdown document.

## Details

This function creates a folder named R-validation at the specified path,
sets up the environment, and executes the validation process. The output
of the validation will be saved in the created folder.

The validation process involves running a series of tests on the R
installation and can be quite time consuming. The function will print
progress messages to the console if \`verbose\` is set to TRUE.

The following steps are carried out:

1.  Create the folder tree R-validation/IQ-OQ-TestOutput at path_save,
    or selected folder

2.  Install TinyTeX and necessary LaTeX packages

3.  Install Pandoc

4.  Copy Rmd file to the R-validation folder

5.  Execute the IQ-OQ by rendering the Rmd to LaTeX

6.  Compile the LaTeX file to pdf

## Examples

``` r
if (FALSE) { # rlang::is_interactive()
# \donttest{
rqualify(path_save     = tempdir(),
         setup_tinytex = TRUE,
         setup_pandoc  = TRUE,
         file_rmd      = "R-validationPreamble.Rmd")
# }
}
```
