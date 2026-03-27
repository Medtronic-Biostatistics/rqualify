# Run IQ-OQ on an installation of R software

Run IQ-OQ on an installation of R software

## Usage

``` r
rqualify(
  path_save,
  setup_tinytex = TRUE,
  setup_pandoc = TRUE,
  render_latex = TRUE,
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
  environment. The function installs the "TinyTeX" bundle and the
  additional package \`grfext\`, and sets the TinyTeX installation path
  on the system PATH.

- setup_pandoc:

  Logical. If TRUE, sets up pandoc for document conversion. Note, this
  does not install the pandoc R package, but the Pandoc software. It is
  a convenient wrapper around \`pandoc::pandoc_install()\` and
  \`pandoc::pandoc_activate()\`, which are called internally.

- render_latex:

  Logical. If TRUE, renders the generated LaTeX file to PDF using
  \`tinytex::pdflatex()\`.

- verbose:

  Logical. If TRUE, prints progress messages to the console.

## Value

The path to the \`R-validation\` folder. The primary purpose of this
function is its side effects, rendering an RMarkdown document.

## Details

This function creates a folder named R-validation at the specified path,
allows users to conveniently install TinyTeX and Pandox, renders an
RMarkdown file to LaTeX, compiles the LaTeX to PDF, and saves the output
in the created folder.

The validation process involves running a series of tests on the R
installation and can be quite time consuming. The function will print
progress messages to the console if \`verbose\` is set to TRUE.

The following steps are carried out using default arguments:

1.  Create the folder tree R-validation/IQ-OQ-TestOutput at path_save

2.  Install TinyTeX and necessary LaTeX packages

3.  Install Pandoc

4.  Copy Rmd file to the R-validation folder

5.  Execute the IQ-OQ by rendering the Rmd to LaTeX

6.  Compile the LaTeX file to pdf

## Examples

``` r
if (FALSE) { # tinytex::is_tinytex() && pandoc::pandoc_available()
# \donttest{
# Render the R-validation report, must have TinyTeX and Pandoc installed for 
# this example, otherwise set setup_tinytex and setup_pandoc to TRUE.
rqualify(path_save     = tempdir(),
         setup_tinytex = FALSE,
         setup_pandoc  = FALSE)
# }
DONTSHOW({
unlink(file.path(tempdir(), "R-validation"), recursive=TRUE)
})
  
}
```
