# rqualify

## Installation

You can install the package via CRAN:

    install.packages("rqualify")

The package can currently be installed from this Github repository using
the following:

    # If needed install.packages("remotes")
    remotes::install_github("Medtronic-Biostatistics/rqualify")

## Purpose

The purpose of this package is to ease the R software validation steps
required for regulatory submissions. The `rqualify` function automates
the generation of a validation document that can be used to demonstrate
that an R environment is suitable for use in a regulated setting.

## R Software Qualification

Once the `rqualify` package is installed, executing the validation
script is as simple as running the function:

    library(rqualify)
    rqualify(path_save = tempdir())

Make sure the folder you specify does not already include a folder named
`R-validation`. See
[`?rqualify`](https://medtronic-biostatistics.github.io/rqualify/reference/rqualify.md)
for more info.

## Special Thanks

We would like to thank [Marc Schwartz](https://msbiostats.com/) for
allowing us to modify [R-IQ-OQ](https://github.com/marcschwartz/R-IQ-OQ)
into the RMarkdown file made available by this package. As the original
code was released under the GNU GPL version 2 license, we are adhering
to the licensing and releasing this package under GNU GPL version 2 as
well.
