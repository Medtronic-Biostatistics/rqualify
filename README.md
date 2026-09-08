# rqualify <a href="https://medtronic-biostatistics.github.io/rqualify/"><img src="man/figures/logo.png" alt="rqualify website" align="right" height="140"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/Medtronic-Biostatistics/rqualify/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Medtronic-Biostatistics/rqualify/actions/workflows/R-CMD-check.yaml) [![Codecov test coverage](https://codecov.io/gh/Medtronic-Biostatistics/rqualify/graph/badge.svg)](https://app.codecov.io/gh/Medtronic-Biostatistics/rqualify) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version-last-release/rqualify)](https://cran.r-project.org/package=rqualify) [![](http://cranlogs.r-pkg.org/badges/rqualify)](https://CRAN.R-project.org/package=rqualify) [![](https://cranlogs.r-pkg.org/badges/grand-total/rqualify)](https://CRAN.R-project.org/package=rqualify) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19617153.svg)](https://doi.org/10.5281/zenodo.19617153)

<!-- badges: end -->

Development version: **1.1.0.9000**.

## Installation

You can install the package via CRAN:

```r
install.packages("rqualify")
```

The package can also be installed from this Github repository using the following:

```r
# If needed install.packages("remotes")
remotes::install_github("Medtronic-Biostatistics/rqualify")
```

## Purpose

The purpose of this package is to ease the R software validation steps required for regulatory submissions. The `rqualify` function automates the generation of a validation document that can be used to demonstrate that an R environment is suitable for use in a regulated setting.

## R Software Qualification

Once the `rqualify` package is installed, there are a few ways to execute the validation process. For instance, you can install Pandoc and TinyTeX as follows:

```r
library(rqualify)

# Install and activate Pandoc
pandoc::pandoc_install()
pandoc::pandoc_activate()

# Install the TinyTeX bundle plus the grfext package
tinytex::install_tinytex(bundle="TinyTeX",
                force=FALSE,
                extra_packages="grfext")
              
rqualify(path_save     = tempdir(),
         setup_tinytex = FALSE,
         setup_pandoc  = FALSE)
```

Alternately, a more convenient approach to execute the entire validation process can be used, where the Pandoc and TinyTeX installation process are wrapped inside the function:

```r
library(rqualify)
rqualify(path_save = tempdir())
```

Another alternative is to use Quarto, especially if you want to execute the validation process from within RStudio:

```r
library(rqualify)
rqualify(path_save     = tempdir(),
         setup_tinytex = FALSE,
         setup_pandoc  = FALSE,
         engine        = "quarto")
```

In any case, ensure that the `path_save` location does not already include a folder named `R-validation`. See `?rqualify` for more info.

Pass `details = TRUE` to return the overall status, per-suite results, report paths, and tool versions. The same information is saved as `validation_result.rds` in the output folder. A status of `"ok"` requires a complete, valid summary with all tests passing.

Quarto uses its bundled Pandoc and Typst; the TinyTeX and Pandoc setup arguments apply only to the LaTeX engine. Existing tools are reused when available.

## Special Thanks

We would like to thank [Marc Schwartz](https://github.com/marcschwartz/) for allowing us to modify [R-IQ-OQ](https://github.com/marcschwartz/R-IQ-OQ) into the RMarkdown file made available by this package. As the original code was released under the GNU GPL version 2 license, we are adhering to the licensing and releasing this package under GNU GPL version 2 as well.
