# Introduction to the rqualify Package

## R Installation IQ/OQ

This vignette is an overview of the `R-validation.Rmd` file, showing
what code is executed when the file is rendered. This overview is for
informational purposes and documents the internal structure of the
`R-validation.Rmd` file. If any of the code blocks are updated, this is
not considered a breaking change as the document will still render
properly.

Please see
<https://medtronic-biostatistics.github.io/rqualify/index.html> for the
full documentation. Here is a minimal usage example:

``` r
library(rqualify)

# Render the R-validation report, must have TinyTeX and Pandoc installed, 
# otherwise set setup_tinytex and setup_pandoc to TRUE.
rqualify(path_save    = tempdir(),
         setup_tinytex = FALSE,
         setup_pandoc  = FALSE)
```

### R-validation.Rmd Contents

Below includes example output of installation facts, installation
qualification, and operational qualification. The installation facts and
qualification results are generated at the time of the package build or
site build, while the operational qualification results were generated
on a Windows machine with R version 4.5.1. Here, the code blocks are
shown for informational purposes, the actual PDF report does not include
the code blocks, only the results of each executed code block.

#### Installation Qualification

First, some R installation facts are gathered and stored in variables.
These variables are then used to populate the title page of the report
with details about the R installation being qualified.

``` r
# Get R installation facts
RVersionInfo <- R.Version()
Version      <- RVersionInfo$version.string
Arch         <- gsub("_", " ", RVersionInfo$arch)
Platform     <- gsub("_", " ", RVersionInfo$platform)
```

    R Version: R version 4.5.3 (2026-03-11)

    Architecture: x86 64

    Platform: x86 64-pc-linux-gnu

------------------------------------------------------------------------

The following is the output of
[`R.home()`](https://rdrr.io/r/base/Rhome.html), showing where R was
installed on this computer:

``` r
r_home <- paste0(R.home(), sep="\n")
```

    /opt/R/4.5.3/lib/R

------------------------------------------------------------------------

The following is the output of `system("R -e 'q()'")`, presenting the R
welcome banner as displayed from a default R console (terminal) to show
the R console correctly running and then exiting:

``` r
# Output the R startup banner
results0 <- try(system(paste(shQuote(file.path(R.home("bin"), "R")), "-e", shQuote("q()")), intern = TRUE))

if (class(results0) != "try-error"){
  results0 <- paste(results0, collapse = "\n")
  results0 <- gsub("> q\\(\\)", "", results0)
} else{
  results0 <- "Unable to execute R at the command line"
}
```

    R version 4.5.3 (2026-03-11) -- "Reassured Reassurer"
    Copyright (C) 2026 The R Foundation for Statistical Computing
    Platform: x86_64-pc-linux-gnu

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

------------------------------------------------------------------------

The following is the output of
[`Sys.info()`](https://rdrr.io/r/base/Sys.info.html), defining some
details about the current system upon which R is running and user
information:

``` r
# Run Sys.info() at the command line
results_sysinfo <- code_exec(code_block    = "Sys.info()",
                             file_prefix   = "sysinfo",
                             folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble and arrow)
results_sysinfo_clean <- results_sysinfo[-(1:(which(results_sysinfo == "> Sys.info()")))]

if(any(results_sysinfo_clean == "> ")){
  results_sysinfo_clean <- results_sysinfo_clean[-which(results_sysinfo_clean == "> ")]
}
```

                                                  sysname 
                                                  "Linux" 
                                                  release 
                                      "6.17.0-1010-azure" 
                                                  version 
    "#10~24.04.1-Ubuntu SMP Fri Mar  6 22:00:57 UTC 2026" 
                                                 nodename 
                                          "runnervm35a4x" 
                                                  machine 
                                                 "x86_64" 
                                                    login 
                                                "unknown" 
                                                     user 
                                                 "runner" 
                                           effective_user 
                                                 "runner" 

------------------------------------------------------------------------

The following is the output of `.Platform`, defining some details of the
platform upon which R was built (compiled):

``` r
# Run .Platform at the command line
results_platform <- code_exec(code_block    = ".Platform",
                              file_prefix   = "platform",
                              folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_platform_clean <- results_platform[-(1:(which(results_platform == "> .Platform")))]

if(any(results_platform_clean == "> ")){
  results_platform_clean <- results_platform_clean[-which(results_platform_clean == "> ")]
}
```

    $OS.type
    [1] "unix"

    $file.sep
    [1] "/"

    $dynlib.ext
    [1] ".so"

    $GUI
    [1] "X11"

    $endian
    [1] "little"

    $pkgType
    [1] "source"

    $path.sep
    [1] ":"

    $r_arch
    [1] ""

------------------------------------------------------------------------

The following is the output of `R.version`, defining detailed
information on the currently running version of R:

``` r
# Run R.version at the command line
results_rversion <- code_exec(code_block    = "R.version",
                              file_prefix   = "rversion",
                              folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_rversion_clean <- results_rversion[-(1:(which(results_rversion == "> R.version")))]

if(any(results_rversion_clean == "> ")){
  results_rversion_clean <- results_rversion_clean[-which(results_rversion_clean == "> ")]
}
```

                   _                           
    platform       x86_64-pc-linux-gnu         
    arch           x86_64                      
    os             linux-gnu                   
    system         x86_64, linux-gnu           
    status                                     
    major          4                           
    minor          5.3                         
    year           2026                        
    month          03                          
    day            11                          
    svn rev        89597                       
    language       R                           
    version.string R version 4.5.3 (2026-03-11)
    nickname       Reassured Reassurer         

------------------------------------------------------------------------

The following is the output of `.Machine`, defining the numerical
characteristics of the computer upon which R is running:

``` r
# Run .Machine at the command line
results_machine <- code_exec(code_block    = ".Machine",
                             file_prefix   = "machine",
                             folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_machine_clean <- results_machine[-(1:(which(results_machine == "> .Machine")))]

if(any(results_machine_clean == "> ")){
  results_machine_clean <- results_machine_clean[-which(results_machine_clean == "> ")]
}
```

    $double.eps
    [1] 2.220446e-16

    $double.neg.eps
    [1] 1.110223e-16

    $double.xmin
    [1] 2.225074e-308

    $double.xmax
    [1] 1.797693e+308

    $double.base
    [1] 2

    $double.digits
    [1] 53

    $double.rounding
    [1] 5

    $double.guard
    [1] 0

    $double.ulp.digits
    [1] -52

    $double.neg.ulp.digits
    [1] -53

    $double.exponent
    [1] 11

    $double.min.exp
    [1] -1022

    $double.max.exp
    [1] 1024

    $integer.max
    [1] 2147483647

    $sizeof.long
    [1] 8

    $sizeof.longlong
    [1] 8

    $sizeof.longdouble
    [1] 16

    $sizeof.pointer
    [1] 8

    $sizeof.time_t
    [1] 8

    $longdouble.eps
    [1] 1.084202e-19

    $longdouble.neg.eps
    [1] 5.421011e-20

    $longdouble.digits
    [1] 64

    $longdouble.rounding
    [1] 5

    $longdouble.guard
    [1] 0

    $longdouble.ulp.digits
    [1] -63

    $longdouble.neg.ulp.digits
    [1] -64

    $longdouble.exponent
    [1] 15

    $longdouble.min.exp
    [1] -16382

    $longdouble.max.exp
    [1] 16384

------------------------------------------------------------------------

The following is the output of
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html), defining
current R version, locale information and attached packages:

``` r
# Run sessionInfo() at the command line
results_sessioninfo <- code_exec(code_block   = "sessionInfo()",
                                 file_prefix  = "sessioninfo",
                                 folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_sessioninfo_clean <- results_sessioninfo[-(1:(which(results_sessioninfo == "> sessionInfo()")))]

if(any(results_sessioninfo_clean == "> ")){
  results_sessioninfo_clean <- results_sessioninfo_clean[-which(results_sessioninfo_clean == "> ")]
}
```

    R version 4.5.3 (2026-03-11)
    Platform: x86_64-pc-linux-gnu
    Running under: Ubuntu 24.04.4 LTS

    Matrix products: default
    BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

    locale:
     [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
     [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
     [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

    time zone: UTC
    tzcode source: system (glibc)

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    loaded via a namespace (and not attached):
    [1] compiler_4.5.3

------------------------------------------------------------------------

The following is the output of
[`.libPaths()`](https://rdrr.io/r/base/libPaths.html), the current
package library location; may be more than one folder:

``` r
results_libpath <- code_exec(code_block   = ".libPaths()",
                             file_prefix  = "libpaths",
                             folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_libpath_clean <- results_libpath[-(1:(which(results_libpath == "> .libPaths()")))]

if(any(results_libpath_clean == "> ")){
  results_libpath_clean <- results_libpath_clean[-which(results_libpath_clean == "> ")]
}
```

    [1] "/home/runner/work/_temp/Library" "/opt/R/4.5.3/lib/R/site-library"
    [3] "/opt/R/4.5.3/lib/R/library"     

------------------------------------------------------------------------

The following is the output of
[`rmarkdown::pandoc_version()`](https://pkgs.rstudio.com/rmarkdown/reference/pandoc_available.html)
listing the version of Pandoc used to render the report (note, if Pandoc
is not installed, the output will indicate that Pandoc is not
available):

``` r
if(pandoc::pandoc_available()){
  results_pandoc_ver <- code_exec(code_block   = "rmarkdown::pandoc_version()",
                                  file_prefix  = "pandoc_ver",
                                  folder_output = dir_temp)
  
  # Clean-up the results (remove the unnecessary preamble)
  results_pandoc_ver_clean <- results_pandoc_ver[-(1:(which(results_pandoc_ver == "> rmarkdown::pandoc_version()")))]
  
  if(any(results_pandoc_ver_clean == "> ")){
    results_pandoc_ver_clean <- results_pandoc_ver_clean[-which(results_pandoc_ver_clean == "> ")]
  }
} else{
  results_pandoc_ver_clean <- "Pandoc not available"
}
```

    [1] ‘3.1.11’

------------------------------------------------------------------------

The following is the output of
[`tinytex::tlmgr_version()`](https://rdrr.io/pkg/tinytex/man/tlmgr.html)
listing the version and installation path of TinyTex used to render the
report to pdf (note, if TinyTeX is not installed, the output will
indicate that TinyTeX is not available):

``` r
if(tinytex::is_tinytex()){
  results_tinytex_ver <- code_exec(code_block   = "tinytex::tlmgr_version()",
                                   file_prefix  = "tinytex_ver",
                                   folder_output = dir_temp)
  
  # Clean-up the results (remove the unnecessary preamble)
  results_tinytex_ver_clean <- results_tinytex_ver[-(1:(which(results_tinytex_ver == "> tinytex::tlmgr_version()")))]
  
  if(any(results_tinytex_ver_clean == "> ")){
    results_tinytex_ver_clean <- results_tinytex_ver_clean[-which(results_tinytex_ver_clean == "> ")]
  }
} else{
  results_tinytex_ver_clean <- "TinyTeX not available"
}
```

    TinyTeX not available

------------------------------------------------------------------------

#### Operational Qualification

##### R Core Operational Qualification - System Tests (OQ)

The following is the output of `testInstalledBasic("both")`, which runs
a series of core system-wide operational tests of the R installation,
including various regression tests:

``` r
# Copy system tests to IQ-OQ-TestOutput/tests
r_test_path <- file.path(R.home(), "tests")
fc          <- file.copy(r_test_path, "IQ-OQ-TestOutput", recursive=TRUE)

# Set absolute test path
path_system_tests <- normalizePath("IQ-OQ-TestOutput/tests", winslash="/")

code_check1 <- sprintf('
options(echo = FALSE)
options(useFancyQuotes = FALSE)

Failure <- tryCatch(tools:::testInstalledBasic(
                    scope      = "basic",
                    outDir     = "%s",
                    testSrcdir = "%s"
                    ),
                    error=function(e) TRUE)

if (Failure){
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile1Fail", showWarnings = FALSE)
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
',path_system_tests,path_system_tests)

results1 <- code_exec(code_block    = code_check1,
                      file_prefix   = "CMDFile1",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    running strict specific tests
      running code in 'eval-etc.R'
      comparing 'eval-etc.Rout' to 'eval-etc.Rout.save' ... OK
      running code in 'simple-true.R'
      comparing 'simple-true.Rout' to 'simple-true.Rout.save' ... OK
      running code in 'arith-true.R'
      comparing 'arith-true.Rout' to 'arith-true.Rout.save' ... OK
      running code in 'lm-tests.R'
      comparing 'lm-tests.Rout' to 'lm-tests.Rout.save' ... OK
      running code in 'ok-errors.R'
      comparing 'ok-errors.Rout' to 'ok-errors.Rout.save' ... OK
      running code in 'method-dispatch.R'
      comparing 'method-dispatch.Rout' to 'method-dispatch.Rout.save' ... OK
      running code in 'array-subset.R'
      running code in 'p-r-random-tests.R'
      comparing 'p-r-random-tests.Rout' to 'p-r-random-tests.Rout.save' ... OK
      running code in 'd-p-q-r-tst-2.R'
      running code in 'any-all.R'
      comparing 'any-all.Rout' to 'any-all.Rout.save' ... OK
      running code in 'structure.R'
      comparing 'structure.Rout' to 'structure.Rout.save' ... OK
      running code in 'd-p-q-r-tests.R'
      comparing 'd-p-q-r-tests.Rout' to 'd-p-q-r-tests.Rout.save' ... OK
    running sloppy specific tests
      running code in 'complex.R'
      comparing 'complex.Rout' to 'complex.Rout.save' ... OK
      running code in 'print-tests.R'
      comparing 'print-tests.Rout' to 'print-tests.Rout.save' ... OK
      running code in 'lapack.R'
      comparing 'lapack.Rout' to 'lapack.Rout.save' ... OK
      running code in 'datasets.R'
      comparing 'datasets.Rout' to 'datasets.Rout.save' ... OK
      running code in 'datetime.R'
      comparing 'datetime.Rout' to 'datetime.Rout.save' ... OK
      running code in 'iec60559.R'
      comparing 'iec60559.Rout' to 'iec60559.Rout.save' ... OK
    running regression tests
      running code in 'reg-tests-1a.R'
      running code in 'reg-tests-1b.R'
      running code in 'reg-tests-1c.R'
      running code in 'reg-tests-1d.R'
      running code in 'reg-tests-1e.R'
      running code in 'reg-tests-2.R'
      comparing 'reg-tests-2.Rout' to 'reg-tests-2.Rout.save' ... OK
      running code in 'reg-examples1.R'
      running code in 'reg-examples2.R'
      running code in 'reg-packages.R'
      running code in 'reg-S4-examples.R'
      running code in 'classes-methods.R'
      running code in 'datetime3.R'
      running code in 'p-qbeta-strict-tst.R'
      running code in 'reg-IO.R'
      comparing 'reg-IO.Rout' to 'reg-IO.Rout.save' ... OK
      running code in 'reg-IO2.R'
      comparing 'reg-IO2.Rout' to 'reg-IO2.Rout.save' ... OK
      running code in 'reg-plot.R'
      comparing 'reg-plot.pdf' to 'reg-plot.pdf.save' ... OK
      running code in 'reg-S4.R'
      comparing 'reg-S4.Rout' to 'reg-S4.Rout.save' ... OK
      running code in 'reg-BLAS.R'
      running code in 'reg-encodings.R'
      running code in 'reg-translation.R'
      running code in 'reg-tests-3.R'
      comparing 'reg-tests-3.Rout' to 'reg-tests-3.Rout.save' ... OK
      running code in 'reg-examples3.R'
      comparing 'reg-examples3.Rout' to 'reg-examples3.Rout.save' ... OK
    running tests of plotting Latin-1
      expect failure or some differences if not in a Latin or UTF-8 locale
      running code in 'reg-plot-latin1.R'
      comparing 'reg-plot-latin1.pdf' to 'reg-plot-latin1.pdf.save' ...OK


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

------------------------------------------------------------------------

##### R Base Package Operational Qualification - Package Examples (OQ)

The following is the output of
`testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "examples", errorsAreFatal = FALSE)`,
which runs a series of operational tests of the R Base package code
examples:

``` r
code_check2 <- '
options(echo = FALSE)
options(useFancyQuotes = FALSE)
Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "examples", errorsAreFatal = FALSE),
                    error=function(e) TRUE)
if (Failure) {
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile2Fail")
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
'
results2 <- code_exec(code_block    = code_check2,
                      file_prefix   = "CMDFile2",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    Testing examples for package 'base'
    Testing examples for package 'tools'
      comparing 'tools-Ex.Rout' to 'tools-Ex.Rout.save' ... OK
    Testing examples for package 'utils'
    Testing examples for package 'grDevices'
      comparing 'grDevices-Ex.Rout' to 'grDevices-Ex.Rout.save' ... OK
    Testing examples for package 'graphics'
      comparing 'graphics-Ex.Rout' to 'graphics-Ex.Rout.save' ... OK
    Testing examples for package 'stats'
      comparing 'stats-Ex.Rout' to 'stats-Ex.Rout.save' ... OK
    Testing examples for package 'datasets'
      comparing 'datasets-Ex.Rout' to 'datasets-Ex.Rout.save' ... OK
    Testing examples for package 'methods'
    Testing examples for package 'grid'
      comparing 'grid-Ex.Rout' to 'grid-Ex.Rout.save' ... OK
    Testing examples for package 'splines'
      comparing 'splines-Ex.Rout' to 'splines-Ex.Rout.save' ... OK
    Testing examples for package 'stats4'
      comparing 'stats4-Ex.Rout' to 'stats4-Ex.Rout.save' ... OK
    Testing examples for package 'tcltk'
    Testing examples for package 'compiler'
    Testing examples for package 'parallel'


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

------------------------------------------------------------------------

##### R Base Package Operational Qualification - Package Vignettes (OQ)

The following is the output of
`testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "vignettes", errorsAreFatal = FALSE)`,
which runs a series of operational tests of the R Base package vignette
code examples:

``` r
code_check3 <- '
options(echo = FALSE)
options(useFancyQuotes = FALSE)
Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "vignettes", errorsAreFatal = FALSE),
                    error=function(e) TRUE)
if (Failure) {
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile3Fail", showWarnings = FALSE)
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
'
results3 <- code_exec(code_block    = code_check3,
                      file_prefix   = "CMDFile3",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    Running vignettes for package 'utils'
      Running 'Sweave.Rnw'
    Running vignettes for package 'stats'
      Running 'reshape.Rnw'
    Running vignettes for package 'grid'
      Running 'displaylist.Rnw'
      Running 'frame.Rnw'
      Running 'grid.Rnw'
      Running 'grobs.Rnw'
      Running 'interactive.Rnw'
      Running 'locndimn.Rnw'
      Running 'moveline.Rnw'
      Running 'nonfinite.Rnw'
      Running 'plotexample.Rnw'
      Running 'rotated.Rnw'
      Running 'saveload.Rnw'
      Running 'sharing.Rnw'
      Running 'viewports.Rnw'
    Running vignettes for package 'parallel'
      Running 'parallel.Rnw'


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

------------------------------------------------------------------------

##### R Recommended Package Operational Qualification - Package Examples (OQ)

The following is the output of
`testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "examples", errorsAreFatal = FALSE)`,
which runs a series of operational tests of the R Recommended package
code examples:

``` r
code_check4 <- '
options(echo = FALSE)
options(useFancyQuotes = FALSE)
Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "examples", errorsAreFatal = FALSE),
                    error=function(e) TRUE)
if (Failure){
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile4Fail", showWarnings = FALSE)
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
'
results4 <- code_exec(code_block    = code_check4,
                      file_prefix   = "CMDFile4",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    Testing examples for package 'MASS'
      comparing 'MASS-Ex.Rout' to 'MASS-Ex.Rout.save' ... OK
    Testing examples for package 'lattice'
    Testing examples for package 'Matrix'
    Testing examples for package 'nlme'
    Testing examples for package 'survival'
      comparing 'survival-Ex.Rout' to 'survival-Ex.Rout.save' ... OK
    Testing examples for package 'boot'
      comparing 'boot-Ex.Rout' to 'boot-Ex.Rout.save' ... OK
    Testing examples for package 'cluster'
    Testing examples for package 'codetools'
    Testing examples for package 'foreign'
    Testing examples for package 'KernSmooth'
    Testing examples for package 'rpart'
      comparing 'rpart-Ex.Rout' to 'rpart-Ex.Rout.save' ... OK
    Testing examples for package 'class'
    Testing examples for package 'nnet'
    Testing examples for package 'spatial'
      comparing 'spatial-Ex.Rout' to 'spatial-Ex.Rout.save' ... OK
    Testing examples for package 'mgcv'


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

------------------------------------------------------------------------

##### R Recommended Package Operational Qualification - Package Vignettes (OQ)

The following is the output of
`testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "vignettes", errorsAreFatal = FALSE)`,
which runs a series of operational tests of the R Recommended package
vignette code examples:

``` r
code_check5 <- '
options(echo = FALSE)
options(useFancyQuotes = FALSE)
Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "vignettes", errorsAreFatal = FALSE),
                    error=function(e) TRUE)
if (Failure){
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile5Fail", showWarnings = FALSE)
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
'
results5 <- code_exec(code_block    = code_check5,
                      file_prefix   = "CMDFile5",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    Running vignettes for package 'lattice'
      Running 'grid.Rnw'
    Running vignettes for package 'Matrix'
      Running 'Comparisons.Rnw'
      Running 'Design-issues.Rnw'
      Running 'Intro2Matrix.Rnw'
      Running 'Introduction.Rnw'
      Running 'sparseModels.Rnw'
    Running vignettes for package 'survival'
      Running 'adjcurve.Rnw'
      Running 'approximate.Rnw'
      Running 'compete.Rnw'
      Running 'concordance.Rnw'
      Running 'matrix.Rnw'
      Running 'methods.Rnw'
      Running 'multi.Rnw'
      Running 'other.Rnw'
      Running 'population.Rnw'
      Running 'redistribute.Rnw'
      Running 'splines.Rnw'
      Running 'survival.Rnw'
      Running 'tiedtimes.Rnw'
      Running 'timedep.Rnw'
      Running 'validate.Rnw'
    Running vignettes for package 'rpart'
      Running 'longintro.Rnw'
      Running 'usercode.Rnw'


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

------------------------------------------------------------------------

##### R Base Package Operational Qualification - Package Tests (OQ)

The following is the output of
`testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "tests", errorsAreFatal = FALSE)`,
which runs a series of operational tests of the R Base package code
tests:

``` r
code_check6 <- '
options(echo = FALSE)
options(useFancyQuotes = FALSE)
Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "tests", errorsAreFatal = FALSE),
                    error=function(e) TRUE)
if (Failure){
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile6Fail", showWarnings = FALSE)
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
'
results6 <- code_exec(code_block    = code_check6,
                      file_prefix   = "CMDFile6",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    Running specific tests for package 'tools'
      Running 'hashes.R'
      Running 'QC.R'
      Running 'Rd.R'
      Running 'Rd2HTML.R'
      Running 'Rd2pdf.R'
      Running 'S3.R'
      Running 'undoc.R'
    Running specific tests for package 'utils'
      Running 'charclass.R'
      Running 'completion.R'
      Running 'relist.R'
      Running 'Sweave-tst.R'
      Running 'tar.R'
    Running specific tests for package 'grDevices'
      Running 'convertColor-tests.R'
      Running 'encodings.R'
      comparing 'encodings.Rout' to 'encodings.Rout.save' ... OK
      Running 'encodings2.R'
      comparing 'encodings2.Rout' to 'encodings2.Rout.save' ... OK
      Running 'encodings3.R'
      comparing 'encodings3.Rout' to 'encodings3.Rout.save' ... OK
      Running 'grDev-tsts.R'
      Running 'palettes-tests.R'
      Running 'ps-tests.R'
      comparing 'ps-tests.Rout' to 'ps-tests.Rout.save' ... OK
      Running 'saved-recordPlot.R'
      Running 'urw-fonts.R'
      Running 'xyTable.R'
      comparing 'xyTable.Rout' to 'xyTable.Rout.save' ... OK
      Running 'zzcheck-encodings.R'
    Running specific tests for package 'stats'
      Running 'arimaML.R'
      Running 'bandwidth.R'
      comparing 'bandwidth.Rout' to 'bandwidth.Rout.save' ... OK
      Running 'cmdscale.R'
      Running 'density_chk.R'
      Running 'dpq-xtra.R'
      Running 'drop1-polr.R'
      Running 'factanal-tst.R'
      Running 'glm-etc.R'
      Running 'glm.R'
      comparing 'glm.Rout' to 'glm.Rout.save' ... OK
      Running 'ig_glm.R'
      Running 'ks-test.R'
      comparing 'ks-test.Rout' to 'ks-test.Rout.save' ... OK
      Running 'loglin.R'
      comparing 'loglin.Rout' to 'loglin.Rout.save' ... OK
      Running 'nafns.R'
      Running 'nlm.R'
      Running 'nls.R'
      comparing 'nls.Rout' to 'nls.Rout.save' ... OK
      Running 'NLSstClosest.R'
      Running 'offsets.R'
      Running 'ppr.R'
      Running 'psmirnov.R'
      comparing 'psmirnov.Rout' to 'psmirnov.Rout.save' ... OK
      Running 'simulate.R'
      comparing 'simulate.Rout' to 'simulate.Rout.save' ... OK
      Running 'smooth.spline.R'
      Running 'table-margins.R'
      Running 'ts-tests.R'
    Running specific tests for package 'methods'
      Running 'basicRefClass.R'
      Running 'duplicateClass.R'
      Running 'envRefClass.R'
      Running 'fieldAssignments.R'
      Running 'mixinInitialize.R'
      Running 'namesAndSlots.R'
      Running 'nextWithDots.R'
      Running 'refClassExample.R'
      Running 'S3.R'
      Running 'testConditionalIs.R'
      Running 'testGroupGeneric.R'
      Running 'testIs.R'
    Running specific tests for package 'grid'
      Running 'bugs.R'
      Running 'clippaths.R'
      Running 'compositing.R'
      Running 'coords.R'
      Running 'glyphs.R'
      Running 'grep.R'
      comparing 'grep.Rout' to 'grep.Rout.save' ... OK
      Running 'groups.R'
      Running 'masks.R'
      Running 'nesting.R'
      Running 'paths.R'
      Running 'patterns.R'
      Running 'reg.R'
      Running 'testls.R'
      comparing 'testls.Rout' to 'testls.Rout.save' ... OK
      Running 'units.R'
    Running specific tests for package 'splines'
      Running 'sparse-tst.R'
      Running 'spline-tst.R'
    Running specific tests for package 'stats4'
      Running 'confint.R'
    Running specific tests for package 'compiler'
      Running 'assign.R'
      Running 'basics.R'
      Running 'const.R'
      Running 'curexpr.R'
      Running 'envir.R'
      Running 'jit.R'
      Running 'loop.R'
      Running 'srcref.R'
      Running 'switch.R'
      Running 'vischk.R'
    Running specific tests for package 'parallel'
      Running 'Master.R'
      Running 'RSeed.R'


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

------------------------------------------------------------------------

##### R Recommended Package Operational Qualification - Package Tests (OQ)

The following is the output of
`testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "tests", errorsAreFatal = FALSE)`,
which runs a series of operational tests of the R Recommended package
code tests:

``` r
code_check7 <- '
options(echo = FALSE)
options(useFancyQuotes = FALSE)
Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "tests", errorsAreFatal = FALSE),
                    error=function(e) TRUE)
if (Failure){
  cat("\n\nTest suite result: FAIL\n\n")
  fc <- file.create("IQ-OQ-TestOutput/CMDFile7Fail", showWarnings = FALSE)
} else {
  cat("\n\nTest suite result: PASS\n\n")
}
q(status = Failure)
'
results7 <- code_exec(code_block    = code_check7,
                      file_prefix   = "CMDFile7",
                      folder_output = "IQ-OQ-TestOutput")
```

    R version 4.5.1 (2025-06-13 ucrt) -- "Great Square Root"
    Copyright (C) 2025 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > 
    > options(echo = FALSE)
    Running specific tests for package 'MASS'
      Running 'confint.R'
      Running 'cov.mcd.R'
      Running 'fitdistr.R'
      comparing 'fitdistr.Rout' to 'fitdistr.Rout.save' ... OK
      Running 'glm.nb.R'
      Running 'glmmPQL.R'
      Running 'hubers.R'
      Running 'lme.R'
      Running 'loglm.R'
      Running 'polr.R'
      Running 'profile.R'
      Running 'regression.R'
      comparing 'regression.Rout' to 'regression.Rout.save' ... OK
      Running 'rlm.R'
      Running 'scripts.R'
    Running specific tests for package 'lattice'
      Running 'auto-key.R'
      Running 'barchart-width.R'
      Running 'call.R'
      Running 'colorkey-title.R'
      Running 'dataframe-methods.R'
      Running 'dates.R'
      Running 'dotplotscoping.R'
      Running 'fontsize.R'
      Running 'levelplot.R'
      Running 'MASSch04.R'
      Running 'scales.R'
      Running 'shade-wireframe.R'
      Running 'summary.R'
      Running 'temp.R'
      Running 'test.R'
      Running 'wireframe.R'
    Running specific tests for package 'Matrix'
      Running 'abIndex-tsts.R'
      Running 'base-matrix-fun.R'
      Running 'bind.R'
      comparing 'bind.Rout' to 'bind.Rout.save' ... OK
      Running 'Class+Meth.R'
      Running 'dg_Matrix.R'
      Running 'dpo-test.R'
      Running 'dtpMatrix.R'
      Running 'factorizing.R'
      Running 'group-methods.R'
      Running 'indexing.R'
      comparing 'indexing.Rout' to 'indexing.Rout.save' ...30,31d29
    < Warning in Sys.setLanguage("en") :
    <   no natural language support or missing translations
      Running 'matprod.R'
      Running 'matr-exp.R'
      Running 'other-pkgs.R'
      Running 'packed-unpacked.R'
      Running 'Simple.R'
      Running 'spModel.matrix.R'
      Running 'symmDN.R'
      Running 'validObj.R'
      Running 'write-read.R'
    Running specific tests for package 'nlme'
      Running 'anova.gls.R'
      Running 'augPred_lab.R'
      Running 'augPredmissing.R'
      Running 'coef.R'
      comparing 'coef.Rout' to 'coef.Rout.save' ... OK
      Running 'contrMat.R'
      Running 'corMatrix.R'
      Running 'corStruct.R'
      Running 'data.frame.R'
      Running 'deparse.R'
      Running 'deviance.R'
      Running 'fitted.R'
      Running 'getData.R'
      Running 'getVarCov.R'
      Running 'gls.R'
      Running 'gnls-ch8.R'
      Running 'lme.R'
      comparing 'lme.Rout' to 'lme.Rout.save' ... OK
      Running 'lmList.R'
      Running 'missing.R'
      comparing 'missing.Rout' to 'missing.Rout.save' ... OK
      Running 'nlme.R'
      Running 'nlme2.R'
      Running 'predict.lme.R'
      Running 'scoping.R'
      Running 'sigma-fixed-etc.R'
      Running 'updateLme.R'
      Running 'varConstProp.R'
      Running 'varFixed.R'
      Running 'varIdent.R'
    Running specific tests for package 'survival'
      Running 'aareg.R'
      comparing 'aareg.Rout' to 'aareg.Rout.save' ... OK
      Running 'anova.R'
      comparing 'anova.Rout' to 'anova.Rout.save' ... OK
      Running 'bladder.R'
      comparing 'bladder.Rout' to 'bladder.Rout.save' ... OK
      Running 'book1.R'
      comparing 'book1.Rout' to 'book1.Rout.save' ... OK
      Running 'book2.R'
      comparing 'book2.Rout' to 'book2.Rout.save' ... OK
      Running 'book3.R'
      comparing 'book3.Rout' to 'book3.Rout.save' ... OK
      Running 'book4.R'
      comparing 'book4.Rout' to 'book4.Rout.save' ... OK
      Running 'book5.R'
      comparing 'book5.Rout' to 'book5.Rout.save' ... OK
      Running 'book6.R'
      comparing 'book6.Rout' to 'book6.Rout.save' ... OK
      Running 'book7.R'
      comparing 'book7.Rout' to 'book7.Rout.save' ... OK
      Running 'brier.R'
      comparing 'brier.Rout' to 'brier.Rout.save' ... OK
      Running 'cancer.R'
      comparing 'cancer.Rout' to 'cancer.Rout.save' ... OK
      Running 'checkSurv2.R'
      comparing 'checkSurv2.Rout' to 'checkSurv2.Rout.save' ... OK
      Running 'clogit.R'
      comparing 'clogit.Rout' to 'clogit.Rout.save' ... OK
      Running 'concordance.R'
      comparing 'concordance.Rout' to 'concordance.Rout.save' ... OK
      Running 'concordance2.R'
      comparing 'concordance2.Rout' to 'concordance2.Rout.save' ... OK
      Running 'concordance3.R'
      comparing 'concordance3.Rout' to 'concordance3.Rout.save' ... OK
      Running 'counting.R'
      comparing 'counting.Rout' to 'counting.Rout.save' ... OK
      Running 'coxsurv.R'
      comparing 'coxsurv.Rout' to 'coxsurv.Rout.save' ... OK
      Running 'coxsurv2.R'
      comparing 'coxsurv2.Rout' to 'coxsurv2.Rout.save' ... OK
      Running 'coxsurv3.R'
      comparing 'coxsurv3.Rout' to 'coxsurv3.Rout.save' ... OK
      Running 'coxsurv4.R'
      comparing 'coxsurv4.Rout' to 'coxsurv4.Rout.save' ... OK
      Running 'coxsurv5.R'
      comparing 'coxsurv5.Rout' to 'coxsurv5.Rout.save' ... OK
      Running 'coxsurv6.R'
      comparing 'coxsurv6.Rout' to 'coxsurv6.Rout.save' ... OK
      Running 'detail.R'
      comparing 'detail.Rout' to 'detail.Rout.save' ... OK
      Running 'difftest.R'
      comparing 'difftest.Rout' to 'difftest.Rout.save' ... OK
      Running 'doaml.R'
      comparing 'doaml.Rout' to 'doaml.Rout.save' ... OK
      Running 'doublecolon.R'
      comparing 'doublecolon.Rout' to 'doublecolon.Rout.save' ... OK
      Running 'doweight.R'
      comparing 'doweight.Rout' to 'doweight.Rout.save' ... OK
      Running 'dropspecial.R'
      comparing 'dropspecial.Rout' to 'dropspecial.Rout.save' ... OK
      Running 'ekm.R'
      comparing 'ekm.Rout' to 'ekm.Rout.save' ... OK
      Running 'expected.R'
      comparing 'expected.Rout' to 'expected.Rout.save' ... OK
      Running 'expected2.R'
      comparing 'expected2.Rout' to 'expected2.Rout.save' ... OK
      Running 'factor.R'
      comparing 'factor.Rout' to 'factor.Rout.save' ... OK
      Running 'factor2.R'
      comparing 'factor2.Rout' to 'factor2.Rout.save' ... OK
      Running 'finegray.R'
      comparing 'finegray.Rout' to 'finegray.Rout.save' ... OK
      Running 'fr_cancer.R'
      comparing 'fr_cancer.Rout' to 'fr_cancer.Rout.save' ... OK
      Running 'fr_kidney.R'
      comparing 'fr_kidney.Rout' to 'fr_kidney.Rout.save' ... OK
      Running 'fr_lung.R'
      comparing 'fr_lung.Rout' to 'fr_lung.Rout.save' ... OK
      Running 'fr_ovarian.R'
      comparing 'fr_ovarian.Rout' to 'fr_ovarian.Rout.save' ... OK
      Running 'fr_rat1.R'
      comparing 'fr_rat1.Rout' to 'fr_rat1.Rout.save' ... OK
      Running 'fr_resid.R'
      comparing 'fr_resid.Rout' to 'fr_resid.Rout.save' ... OK
      Running 'fr_simple.R'
      comparing 'fr_simple.Rout' to 'fr_simple.Rout.save' ... OK
      Running 'frailty.R'
      comparing 'frailty.Rout' to 'frailty.Rout.save' ... OK
      Running 'frank.R'
      comparing 'frank.Rout' to 'frank.Rout.save' ... OK
      Running 'infcox.R'
      comparing 'infcox.Rout' to 'infcox.Rout.save' ... OK
      Running 'jasa.R'
      comparing 'jasa.Rout' to 'jasa.Rout.save' ... OK
      Running 'model.matrix.R'
      comparing 'model.matrix.Rout' to 'model.matrix.Rout.save' ... OK
      Running 'mstate.R'
      comparing 'mstate.Rout' to 'mstate.Rout.save' ... OK
      Running 'mstate2.R'
      comparing 'mstate2.Rout' to 'mstate2.Rout.save' ... OK
      Running 'mstrata.R'
      comparing 'mstrata.Rout' to 'mstrata.Rout.save' ... OK
      Running 'multi2.R'
      comparing 'multi2.Rout' to 'multi2.Rout.save' ... OK
      Running 'multi3.R'
      comparing 'multi3.Rout' to 'multi3.Rout.save' ... OK
      Running 'multistate.R'
      comparing 'multistate.Rout' to 'multistate.Rout.save' ... OK
      Running 'neardate.R'
      comparing 'neardate.Rout' to 'neardate.Rout.save' ... OK
      Running 'nested.R'
      comparing 'nested.Rout' to 'nested.Rout.save' ... OK
      Running 'nsk.R'
      comparing 'nsk.Rout' to 'nsk.Rout.save' ... OK
      Running 'ovarian.R'
      comparing 'ovarian.Rout' to 'ovarian.Rout.save' ... OK
      Running 'overlap.R'
      comparing 'overlap.Rout' to 'overlap.Rout.save' ... OK
      Running 'prednew.R'
      comparing 'prednew.Rout' to 'prednew.Rout.save' ... OK
      Running 'predsurv.R'
      comparing 'predsurv.Rout' to 'predsurv.Rout.save' ... OK
      Running 'pseudo.R'
      comparing 'pseudo.Rout' to 'pseudo.Rout.save' ... OK
      Running 'pspline.R'
      comparing 'pspline.Rout' to 'pspline.Rout.save' ... OK
      Running 'pyear.R'
      comparing 'pyear.Rout' to 'pyear.Rout.save' ... OK
      Running 'quantile.R'
      comparing 'quantile.Rout' to 'quantile.Rout.save' ... OK
      Running 'r_lung.R'
      comparing 'r_lung.Rout' to 'r_lung.Rout.save' ... OK
      Running 'r_resid.R'
      comparing 'r_resid.Rout' to 'r_resid.Rout.save' ... OK
      Running 'r_sas.R'
      comparing 'r_sas.Rout' to 'r_sas.Rout.save' ... OK
      Running 'r_scale.R'
      comparing 'r_scale.Rout' to 'r_scale.Rout.save' ... OK
      Running 'r_stanford.R'
      comparing 'r_stanford.Rout' to 'r_stanford.Rout.save' ... OK
      Running 'r_strata.R'
      comparing 'r_strata.Rout' to 'r_strata.Rout.save' ... OK
      Running 'r_tdist.R'
      comparing 'r_tdist.Rout' to 'r_tdist.Rout.save' ... OK
      Running 'r_user.R'
      comparing 'r_user.Rout' to 'r_user.Rout.save' ... OK
      Running 'ratetable.R'
      comparing 'ratetable.Rout' to 'ratetable.Rout.save' ... OK
      Running 'residsf.R'
      comparing 'residsf.Rout' to 'residsf.Rout.save' ... OK
      Running 'royston.R'
      comparing 'royston.Rout' to 'royston.Rout.save' ... OK
      Running 'rttright.R'
      comparing 'rttright.Rout' to 'rttright.Rout.save' ... OK
      Running 'singtest.R'
      comparing 'singtest.Rout' to 'singtest.Rout.save' ... OK
      Running 'strata2.R'
      comparing 'strata2.Rout' to 'strata2.Rout.save' ... OK
      Running 'stratatest.R'
      comparing 'stratatest.Rout' to 'stratatest.Rout.save' ... OK
      Running 'summary_survfit.R'
      comparing 'summary_survfit.Rout' to 'summary_survfit.Rout.save' ... OK
      Running 'surv.R'
      comparing 'surv.Rout' to 'surv.Rout.save' ... OK
      Running 'survcheck.R'
      comparing 'survcheck.Rout' to 'survcheck.Rout.save' ... OK
      Running 'survfit1.R'
      comparing 'survfit1.Rout' to 'survfit1.Rout.save' ... OK
      Running 'survfit2.R'
      comparing 'survfit2.Rout' to 'survfit2.Rout.save' ... OK
      Running 'survreg1.R'
      comparing 'survreg1.Rout' to 'survreg1.Rout.save' ... OK
      Running 'survreg2.R'
      comparing 'survreg2.Rout' to 'survreg2.Rout.save' ... OK
      Running 'survSplit.R'
      comparing 'survSplit.Rout' to 'survSplit.Rout.save' ... OK
      Running 'survtest.R'
      comparing 'survtest.Rout' to 'survtest.Rout.save' ... OK
      Running 'testci.R'
      comparing 'testci.Rout' to 'testci.Rout.save' ... OK
      Running 'testci2.R'
      comparing 'testci2.Rout' to 'testci2.Rout.save' ... OK
      Running 'testnull.R'
      comparing 'testnull.Rout' to 'testnull.Rout.save' ... OK
      Running 'testreg.R'
      comparing 'testreg.Rout' to 'testreg.Rout.save' ... OK
      Running 'tiedtime.R'
      comparing 'tiedtime.Rout' to 'tiedtime.Rout.save' ... OK
      Running 'tmerge.R'
      comparing 'tmerge.Rout' to 'tmerge.Rout.save' ... OK
      Running 'tmerge2.R'
      comparing 'tmerge2.Rout' to 'tmerge2.Rout.save' ... OK
      Running 'tmerge3.R'
      comparing 'tmerge3.Rout' to 'tmerge3.Rout.save' ... OK
      Running 'tt.R'
      comparing 'tt.Rout' to 'tt.Rout.save' ... OK
      Running 'tt2.R'
      comparing 'tt2.Rout' to 'tt2.Rout.save' ... OK
      Running 'turnbull.R'
      comparing 'turnbull.Rout' to 'turnbull.Rout.save' ... OK
      Running 'update.R'
      comparing 'update.Rout' to 'update.Rout.save' ... OK
      Running 'yates0.R'
      comparing 'yates0.Rout' to 'yates0.Rout.save' ... OK
      Running 'yates1.R'
      comparing 'yates1.Rout' to 'yates1.Rout.save' ... OK
      Running 'yates2.R'
      Running 'zph.R'
      comparing 'zph.Rout' to 'zph.Rout.save' ... OK
    Running specific tests for package 'boot'
      Running 'parallel-censboot.R'
    Running specific tests for package 'cluster'
      Running 'agnes-ex.R'
      comparing 'agnes-ex.Rout' to 'agnes-ex.Rout.save' ... OK
      Running 'clara-ex.R'
      comparing 'clara-ex.Rout' to 'clara-ex.Rout.save' ... OK
      Running 'clara-gower.R'
      Running 'clara-NAs.R'
      comparing 'clara-NAs.Rout' to 'clara-NAs.Rout.save' ... OK
      Running 'clara.R'
      comparing 'clara.Rout' to 'clara.Rout.save' ... OK
      Running 'clusplot-out.R'
      comparing 'clusplot-out.Rout' to 'clusplot-out.Rout.save' ... OK
      Running 'daisy-ex.R'
      comparing 'daisy-ex.Rout' to 'daisy-ex.Rout.save' ... OK
      Running 'diana-boots.R'
      Running 'diana-ex.R'
      comparing 'diana-ex.Rout' to 'diana-ex.Rout.save' ... OK
      Running 'ellipsoid-ex.R'
      comparing 'ellipsoid-ex.Rout' to 'ellipsoid-ex.Rout.save' ... OK
      Running 'fanny-ex.R'
      comparing 'fanny-ex.Rout' to 'fanny-ex.Rout.save' ... OK
      Running 'mona.R'
      comparing 'mona.Rout' to 'mona.Rout.save' ... OK
      Running 'pam.R'
      comparing 'pam.Rout' to 'pam.Rout.save' ... OK
      Running 'silhouette-default.R'
      comparing 'silhouette-default.Rout' to 'silhouette-default.Rout.save' ... OK
      Running 'sweep-ex.R'
    Running specific tests for package 'codetools'
      Running 'tests.R'
    Running specific tests for package 'foreign'
      Running 'arff.R'
      comparing 'arff.Rout' to 'arff.Rout.save' ... OK
      Running 'download.R'
      Running 'minitab.R'
      comparing 'minitab.Rout' to 'minitab.Rout.save' ... OK
      Running 'mval_bug.R'
      comparing 'mval_bug.Rout' to 'mval_bug.Rout.save' ... OK
      Running 'octave.R'
      comparing 'octave.Rout' to 'octave.Rout.save' ... OK
      Running 'S3.R'
      comparing 'S3.Rout' to 'S3.Rout.save' ... OK
      Running 'sas.R'
      Running 'spss.R'
      comparing 'spss.Rout' to 'spss.Rout.save' ... OK
      Running 'stata.R'
      comparing 'stata.Rout' to 'stata.Rout.save' ... OK
      Running 'testEmpty.R'
      comparing 'testEmpty.Rout' to 'testEmpty.Rout.save' ... OK
      Running 'writeForeignSPSS.R'
      comparing 'writeForeignSPSS.Rout' to 'writeForeignSPSS.Rout.save' ... OK
      Running 'xport.R'
      comparing 'xport.Rout' to 'xport.Rout.save' ... OK
    Running specific tests for package 'KernSmooth'
      Running 'bkfe.R'
      Running 'locpoly.R'
    Running specific tests for package 'rpart'
      Running 'backticks.R'
      comparing 'backticks.Rout' to 'backticks.Rout.save' ... OK
      Running 'cost.R'
      comparing 'cost.Rout' to 'cost.Rout.save' ... OK
      Running 'cptest.R'
      comparing 'cptest.Rout' to 'cptest.Rout.save' ... OK
      Running 'minus_in_formula.R'
      comparing 'minus_in_formula.Rout' to 'minus_in_formula.Rout.save' ... OK
      Running 'priors.R'
      comparing 'priors.Rout' to 'priors.Rout.save' ... OK
      Running 'rescale.R'
      comparing 'rescale.Rout' to 'rescale.Rout.save' ... OK
      Running 'testall.R'
      comparing 'testall.Rout' to 'testall.Rout.save' ... OK
      Running 'treble.R'
      comparing 'treble.Rout' to 'treble.Rout.save' ... OK
      Running 'treble2.R'
      comparing 'treble2.Rout' to 'treble2.Rout.save' ... OK
      Running 'treble3.R'
      comparing 'treble3.Rout' to 'treble3.Rout.save' ... OK
      Running 'treble4.R'
      comparing 'treble4.Rout' to 'treble4.Rout.save' ... OK
      Running 'usersplits.R'
      comparing 'usersplits.Rout' to 'usersplits.Rout.save' ... OK
      Running 'xpred1.R'
      comparing 'xpred1.Rout' to 'xpred1.Rout.save' ... OK
      Running 'xpred2.R'
      comparing 'xpred2.Rout' to 'xpred2.Rout.save' ... OK
    Running specific tests for package 'spatial'


    Test suite result: PASS

The final line of the above output displays the status of running the
above tests. `PASS` indicates a successful running of the tests, a
`FAIL` would indicate that an error was detected during the running of
the tests.

There may be some tests where the result of performing a `diff` on two
files that were being compared demonstrate a content difference that may
or may not be relevant and may be dependent upon locale settings. Any
such differences displayed in the above output should be reviewed in
detail to determine their relevance to the Operational Qualification of
this R installation.

#### Summary of Findings

The final page of the report will include a table with the summary of
findings from the above tests, including the overall status of the
Installation Qualification and Operational Qualification of this R
installation. The overall status is determined by the presence of any
`FAIL` results in the above tests, which would indicate a failure in the
qualification of this R installation.

Please see
<https://medtronic-biostatistics.github.io/rqualify/index.html> for the
full documentation and an example of a successful report.
