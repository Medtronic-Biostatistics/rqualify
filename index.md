# rqualify

This package is currently under active development.

## Installation

The package can currently be installed from this Github repository using
the following (ensure devtools is installed):

    devtools::install_git("https://github.com/Medtronic-Biostatistics/rqualify.git")

## Purpose

The purpose of this package is to ease the R software validation steps
required for regulatory submissions. The `rqualify` function automates
the generation of a validation document that can be used to demonstrate
that an R environment is suitable for use in a regulated setting.

## R Software Qualification

Once the `rqualify` package is installed, executing the validation
script is as simple as running the function:

    rqualify(path_save  = path.expand('~'))

You will be prompted to select a folder where the validation files will
be saved – make sure the folder you select does not already include a
folder named `R-validation`.

Alternately, you can specify the output folder directly:

    rqualify(path_save = "C:/path/to/your/folder")

There is also the option to automatically zip up the results. By
default, if the validation is successful, the `R-validation` folder is
zipped up into a file named `R-validation.zip`. If you would like to
disable this feature, you can set `create_zip=FALSE` in the call to
`rqualify`. See
[`?rqualify`](https://medtronic-biostatistics.github.io/rqualify/reference/rqualify.md)
for more info.

## Special Thanks

We would like to thank [Marc Schwartz](https://msbiostats.com/) for
allowing us to modify [R-IQ-OQ](https://github.com/marcschwartz/R-IQ-OQ)
into the RMarkdown file made available by this package. As the original
code was released under the GNU GPL version 2 license, we are adhering
to the licensing and releasing this package under GNU GPL version 2 as
well.
