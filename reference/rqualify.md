# Run IQ-OQ on an installation of R software

Run IQ-OQ on an installation of R software

## Usage

``` r
rqualify(
  path_save,
  setup_tinytex = TRUE,
  setup_pandoc = TRUE,
  verbose = TRUE,
  create_zip = TRUE
)
```

## Arguments

- path_save:

  Character. Path to save the R-validation folder. Ensure a folder named
  \`R-validation\` does not already exist at this location.

- setup_tinytex:

  Logical. If TRUE, sets up tinytex for LaTeX document generation.

- setup_pandoc:

  Logical. If TRUE, sets up pandoc for document conversion.

- verbose:

  Logical. If TRUE, prints progress messages to the console.

- create_zip:

  Logical. If TRUE, creates a zip file of the R-validation folder after
  validation.

## Details

This function creates a folder named R-validation at the specified path,
sets up the environment, and executes the validation process. The output
of the validation will be saved in the created folder. By default, the
contents of the R-validation folder will be zipped up if the validation
is successful.

The following steps are carried out:

1.  Create the folder tree R-validation/IQ-OQ-TestOutput at path_save,
    or selected folder

2.  Install tinytex and necessary LaTeX packages

3.  Install pandoc

4.  Copy R-validation.Rmd to the R-validation folder

5.  Execute the IQ-OQ by rendering R-validation.Rmd to R-validation.tex

6.  Compile R-validation.tex to R-validation.pdf

7.  If IQ-OQ is successful, create R-validation.zip at folder where
    R-validation is located

## Examples

``` r
if (FALSE) { # \dontrun{
rqualify(path_save  = path.expand('~'))
} # }
```
