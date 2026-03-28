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

# Execute qualification using default arguments
rqualify(path_save = tempdir())
```

### R-validation.Rmd Contents

#### Installation Facts

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

#### Installation Qualification

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
}
```

R version 4.5.3 (2026-03-11) – “Reassured Reassurer” Copyright (C) 2026
The R Foundation for Statistical Computing Platform: x86_64-pc-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY. You are
welcome to redistribute it under certain conditions. Type ‘license()’ or
‘licence()’ for distribution details.

R is a collaborative project with many contributors. Type
‘contributors()’ for more information and ‘citation()’ on how to cite R
or R packages in publications.

Type ‘demo()’ for some demos, ‘help()’ for on-line help, or
‘help.start()’ for an HTML browser interface to help. Type ‘q()’ to quit
R.

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

                                             sysname ,                                              "Linux" ,                                              release ,                                  "6.17.0-1008-azure" ,                                              version , "#8~24.04.1-Ubuntu SMP Mon Jan 26 18:35:40 UTC 2026" ,                                             nodename ,                                      "runnervmrg6be" ,                                              machine ,                                             "x86_64" ,                                                login ,                                            "unknown" ,                                                 user ,                                             "runner" ,                                       effective_user ,                                             "runner" 

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

\$OS.type, \[1\] “unix”, , \$file.sep, \[1\] “/”, , \$dynlib.ext, \[1\]
“.so”, , \$GUI, \[1\] “X11”, , \$endian, \[1\] “little”, , \$pkgType,
\[1\] “source”, , \$path.sep, \[1\] “:”, , \$r_arch, \[1\] ““,

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

               _                           , platform       x86_64-pc-linux-gnu         , arch           x86_64                      , os             linux-gnu                   , system         x86_64, linux-gnu           , status                                     , major          4                           , minor          5.3                         , year           2026                        , month          03                          , day            11                          , svn rev        89597                       , language       R                           , version.string R version 4.5.3 (2026-03-11), nickname       Reassured Reassurer         

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

\$double.eps, \[1\] 2.220446e-16, , \$double.neg.eps, \[1\]
1.110223e-16, , \$double.xmin, \[1\] 2.225074e-308, , \$double.xmax,
\[1\] 1.797693e+308, , \$double.base, \[1\] 2, , \$double.digits, \[1\]
53, , \$double.rounding, \[1\] 5, , \$double.guard, \[1\] 0, ,
\$double.ulp.digits, \[1\] -52, , \$double.neg.ulp.digits, \[1\] -53, ,
\$double.exponent, \[1\] 11, , \$double.min.exp, \[1\] -1022, ,
\$double.max.exp, \[1\] 1024, , \$integer.max, \[1\] 2147483647, ,
\$sizeof.long, \[1\] 8, , \$sizeof.longlong, \[1\] 8, ,
\$sizeof.longdouble, \[1\] 16, , \$sizeof.pointer, \[1\] 8, ,
\$sizeof.time_t, \[1\] 8, , \$longdouble.eps, \[1\] 1.084202e-19, ,
\$longdouble.neg.eps, \[1\] 5.421011e-20, , \$longdouble.digits, \[1\]
64, , \$longdouble.rounding, \[1\] 5, , \$longdouble.guard, \[1\] 0, ,
\$longdouble.ulp.digits, \[1\] -63, , \$longdouble.neg.ulp.digits, \[1\]
-64, , \$longdouble.exponent, \[1\] 15, , \$longdouble.min.exp, \[1\]
-16382, , \$longdouble.max.exp, \[1\] 16384,

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

R version 4.5.3 (2026-03-11), Platform: x86_64-pc-linux-gnu, Running
under: Ubuntu 24.04.4 LTS, , Matrix products: default, BLAS:
/usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 , LAPACK:
/usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;
LAPACK version 3.12.0, , locale:, \[1\] LC_CTYPE=C.UTF-8 LC_NUMERIC=C
LC_TIME=C.UTF-8 , \[4\] LC_COLLATE=C.UTF-8 LC_MONETARY=C.UTF-8
LC_MESSAGES=C.UTF-8 , \[7\] LC_PAPER=C.UTF-8 LC_NAME=C LC_ADDRESS=C ,
\[10\] LC_TELEPHONE=C LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C , ,
time zone: UTC, tzcode source: system (glibc), , attached base
packages:, \[1\] stats graphics grDevices utils datasets methods base ,
, loaded via a namespace (and not attached):, \[1\] compiler_4.5.3

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

\[1\] “/home/runner/work/\_temp/Library”
“/opt/R/4.5.3/lib/R/site-library”, \[3\] “/opt/R/4.5.3/lib/R/library”

------------------------------------------------------------------------

The following is the output of
[`rmarkdown::pandoc_version()`](https://pkgs.rstudio.com/rmarkdown/reference/pandoc_available.html)
listing the version of Pandoc used to render the report:

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

\[1\] ‘3.1.11’

------------------------------------------------------------------------

The following is the output of
[`tinytex::tlmgr_version()`](https://rdrr.io/pkg/tinytex/man/tlmgr.html)
listing the version and installation path of TinyTex used to render the
report to pdf:

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”  
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”  
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”  
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “running strict specific tests”  
\[21\] ” running code in ‘eval-etc.R’”  
\[22\] ” comparing ‘eval-etc.Rout’ to ‘eval-etc.Rout.save’ … OK”  
\[23\] ” running code in ‘simple-true.R’”  
\[24\] ” comparing ‘simple-true.Rout’ to ‘simple-true.Rout.save’ … OK”  
\[25\] ” running code in ‘arith-true.R’”  
\[26\] ” comparing ‘arith-true.Rout’ to ‘arith-true.Rout.save’ … OK”  
\[27\] ” running code in ‘lm-tests.R’”  
\[28\] ” comparing ‘lm-tests.Rout’ to ‘lm-tests.Rout.save’ … OK”  
\[29\] ” running code in ‘ok-errors.R’”  
\[30\] ” comparing ‘ok-errors.Rout’ to ‘ok-errors.Rout.save’ … OK”  
\[31\] ” running code in ‘method-dispatch.R’”  
\[32\] ” comparing ‘method-dispatch.Rout’ to ‘method-dispatch.Rout.save’
… OK”  
\[33\] ” running code in ‘array-subset.R’”  
\[34\] ” running code in ‘p-r-random-tests.R’”  
\[35\] ” comparing ‘p-r-random-tests.Rout’ to
‘p-r-random-tests.Rout.save’ … OK” \[36\] ” running code in
‘d-p-q-r-tst-2.R’”  
\[37\] ” running code in ‘any-all.R’”  
\[38\] ” comparing ‘any-all.Rout’ to ‘any-all.Rout.save’ … OK”  
\[39\] ” running code in ‘structure.R’”  
\[40\] ” comparing ‘structure.Rout’ to ‘structure.Rout.save’ … OK”  
\[41\] ” running code in ‘d-p-q-r-tests.R’”  
\[42\] ” comparing ‘d-p-q-r-tests.Rout’ to ‘d-p-q-r-tests.Rout.save’ …
OK”  
\[43\] “running sloppy specific tests”  
\[44\] ” running code in ‘complex.R’”  
\[45\] ” comparing ‘complex.Rout’ to ‘complex.Rout.save’ … OK”  
\[46\] ” running code in ‘print-tests.R’”  
\[47\] ” comparing ‘print-tests.Rout’ to ‘print-tests.Rout.save’ … OK”  
\[48\] ” running code in ‘lapack.R’”  
\[49\] ” comparing ‘lapack.Rout’ to ‘lapack.Rout.save’ … OK”  
\[50\] ” running code in ‘datasets.R’”  
\[51\] ” comparing ‘datasets.Rout’ to ‘datasets.Rout.save’ … OK”  
\[52\] ” running code in ‘datetime.R’”  
\[53\] ” comparing ‘datetime.Rout’ to ‘datetime.Rout.save’ … OK”  
\[54\] ” running code in ‘iec60559.R’”  
\[55\] ” comparing ‘iec60559.Rout’ to ‘iec60559.Rout.save’ … OK”  
\[56\] “running regression tests”  
\[57\] ” running code in ‘reg-tests-1a.R’”  
\[58\] ” running code in ‘reg-tests-1b.R’”  
\[59\] ” running code in ‘reg-tests-1c.R’”  
\[60\] ” running code in ‘reg-tests-1d.R’”  
\[61\] ” running code in ‘reg-tests-1e.R’”  
\[62\] ” running code in ‘reg-tests-2.R’”  
\[63\] ” comparing ‘reg-tests-2.Rout’ to ‘reg-tests-2.Rout.save’ … OK”  
\[64\] ” running code in ‘reg-examples1.R’”  
\[65\] ” running code in ‘reg-examples2.R’”  
\[66\] ” running code in ‘reg-packages.R’”  
\[67\] ” running code in ‘reg-S4-examples.R’”  
\[68\] ” running code in ‘classes-methods.R’”  
\[69\] ” running code in ‘datetime3.R’”  
\[70\] ” running code in ‘p-qbeta-strict-tst.R’”  
\[71\] ” running code in ‘reg-IO.R’”  
\[72\] ” comparing ‘reg-IO.Rout’ to ‘reg-IO.Rout.save’ … OK”  
\[73\] ” running code in ‘reg-IO2.R’”  
\[74\] ” comparing ‘reg-IO2.Rout’ to ‘reg-IO2.Rout.save’ … OK”  
\[75\] ” running code in ‘reg-plot.R’”  
\[76\] ” comparing ‘reg-plot.pdf’ to ‘reg-plot.pdf.save’ …6892c6892”  
\[77\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 382.53 302.24 Tm (l) Tj 0 Tr”  
\[78\] “—”  
\[79\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 382.73 302.24 Tm (l) Tj 0 Tr”  
\[80\] “6895c6895”  
\[81\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 387.27 302.24 Tm (l) Tj 0 Tr”  
\[82\] “—”  
\[83\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 387.47 302.24 Tm (l) Tj 0 Tr”  
\[84\] “6898c6898”  
\[85\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 392.01 302.24 Tm (l) Tj 0 Tr”  
\[86\] “—”  
\[87\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 392.21 302.24 Tm (l) Tj 0 Tr”  
\[88\] “6901c6901”  
\[89\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 396.75 302.24 Tm (l) Tj 0 Tr”  
\[90\] “—”  
\[91\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 396.94 302.24 Tm (l) Tj 0 Tr”  
\[92\] “6904c6904”  
\[93\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 401.49 302.24 Tm (l) Tj 0 Tr”  
\[94\] “—”  
\[95\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 401.68 302.24 Tm (l) Tj 0 Tr”  
\[96\] “6907c6907”  
\[97\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 406.22 302.24 Tm (l) Tj 0 Tr”  
\[98\] “—”  
\[99\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 406.42 302.24 Tm (l) Tj 0 Tr”  
\[100\] “6910c6910”  
\[101\] “\< /F1 1 Tf 1 Tr 7.48 0 0 7.48 410.96 302.24 Tm (l) Tj 0 Tr”  
\[102\] “—”  
\[103\] “\> /F1 1 Tf 1 Tr 7.48 0 0 7.48 411.16 302.24 Tm (l) Tj 0 Tr”  
\[104\] “7102c7102”  
\[105\] “\< 390.23 119.08 m 390.23 111.88 l S”  
\[106\] “—”  
\[107\] “\> 390.43 119.08 m 390.43 111.88 l S”  
\[108\] “7110c7110”  
\[109\] “\< /F2 1 Tf 12.00 0.00 0.00 12.00 379.65 93.16 Tm \[(No) 15
(v)\] TJ”  
\[110\] “—”  
\[111\] “\> /F2 1 Tf 12.00 0.00 0.00 12.00 379.85 93.16 Tm \[(No) 15
(v)\] TJ”  
\[112\] “7130,7131c7130,7131”  
\[113\] “\< 394.77 119.08 m 394.77 119.08 l S”  
\[114\] “\< 394.77 119.08 m 394.77 104.22 l S”  
\[115\] “—”  
\[116\] “\> 394.97 119.08 m 394.97 119.08 l S”  
\[117\] “\> 394.97 119.08 m 394.97 104.22 l S”  
\[118\] “7133c7133”  
\[119\] “\< /F2 1 Tf 12.00 0.00 0.00 12.00 359.18 78.76 Tm \[(No) 15 (v
01 23:00)\] TJ” \[120\] “—”  
\[121\] “\> /F2 1 Tf 12.00 0.00 0.00 12.00 359.37 78.76 Tm \[(No) 15 (v
01 23:00)\] TJ” \[122\] “7135,7136c7135,7136”  
\[123\] “\< 391.42 490.60 m 391.42 490.60 l S”  
\[124\] “\< 391.42 490.60 m 391.42 497.80 l S”  
\[125\] “—”  
\[126\] “\> 391.61 490.60 m 391.61 490.60 l S”  
\[127\] “\> 391.61 490.60 m 391.61 497.80 l S”  
\[128\] “7138c7138”  
\[129\] “\< /F2 1 Tf 12.00 0.00 0.00 12.00 355.82 507.88 Tm \[(No) 15 (v
01 06:00)\] TJ” \[130\] “—”  
\[131\] “\> /F2 1 Tf 12.00 0.00 0.00 12.00 356.02 507.88 Tm \[(No) 15 (v
01 06:00)\] TJ” \[132\] “DIFFERED”  
\[133\] ” running code in ‘reg-S4.R’”  
\[134\] ” comparing ‘reg-S4.Rout’ to ‘reg-S4.Rout.save’ … OK”  
\[135\] ” running code in ‘reg-BLAS.R’”  
\[136\] ” running code in ‘reg-encodings.R’”  
\[137\] ” running code in ‘reg-translation.R’”  
\[138\] ” running code in ‘reg-tests-3.R’”  
\[139\] ” comparing ‘reg-tests-3.Rout’ to ‘reg-tests-3.Rout.save’ …
OK”  
\[140\] ” running code in ‘reg-examples3.R’”  
\[141\] ” comparing ‘reg-examples3.Rout’ to ‘reg-examples3.Rout.save’ …
OK”  
\[142\] “running tests of plotting Latin-1”  
\[143\] ” expect failure or some differences if not in a Latin or UTF-8
locale”  
\[144\] ” running code in ‘reg-plot-latin1.R’”  
\[145\] ” comparing ‘reg-plot-latin1.pdf’ to ‘reg-plot-latin1.pdf.save’
…OK”  
\[146\] “”  
\[147\] “”  
\[148\] “Test suite result: PASS”  
\[149\] “”

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”  
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”  
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”  
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “Testing examples for package ‘base’”  
\[21\] “Testing examples for package ‘tools’”  
\[22\] ” comparing ‘tools-Ex.Rout’ to ‘tools-Ex.Rout.save’ … OK”  
\[23\] “Testing examples for package ‘utils’”  
\[24\] “Testing examples for package ‘grDevices’”  
\[25\] ” comparing ‘grDevices-Ex.Rout’ to ‘grDevices-Ex.Rout.save’ … OK”
\[26\] “Testing examples for package ‘graphics’”  
\[27\] ” comparing ‘graphics-Ex.Rout’ to ‘graphics-Ex.Rout.save’ … OK”  
\[28\] “Testing examples for package ‘stats’”  
\[29\] ” comparing ‘stats-Ex.Rout’ to ‘stats-Ex.Rout.save’ … OK”  
\[30\] “Testing examples for package ‘datasets’”  
\[31\] ” comparing ‘datasets-Ex.Rout’ to ‘datasets-Ex.Rout.save’ … OK”  
\[32\] “Testing examples for package ‘methods’”  
\[33\] “Testing examples for package ‘grid’”  
\[34\] ” comparing ‘grid-Ex.Rout’ to ‘grid-Ex.Rout.save’ … OK”  
\[35\] “Testing examples for package ‘splines’”  
\[36\] ” comparing ‘splines-Ex.Rout’ to ‘splines-Ex.Rout.save’ … OK”  
\[37\] “Testing examples for package ‘stats4’”  
\[38\] ” comparing ‘stats4-Ex.Rout’ to ‘stats4-Ex.Rout.save’ … OK”  
\[39\] “Testing examples for package ‘tcltk’”  
\[40\] “Testing examples for package ‘compiler’”  
\[41\] “Testing examples for package ‘parallel’”  
\[42\] “”  
\[43\] “”  
\[44\] “Test suite result: PASS”  
\[45\] “”

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “Running vignettes for package ‘utils’”  
\[21\] ” Running ‘Sweave.Rnw’”  
\[22\] “Running vignettes for package ‘stats’”  
\[23\] ” Running ‘reshape.Rnw’”  
\[24\] “Running vignettes for package ‘grid’”  
\[25\] ” Running ‘displaylist.Rnw’”  
\[26\] ” Running ‘frame.Rnw’”  
\[27\] ” Running ‘grid.Rnw’”  
\[28\] ” Running ‘grobs.Rnw’”  
\[29\] ” Running ‘interactive.Rnw’”  
\[30\] ” Running ‘locndimn.Rnw’”  
\[31\] ” Running ‘moveline.Rnw’”  
\[32\] ” Running ‘nonfinite.Rnw’”  
\[33\] ” Running ‘plotexample.Rnw’”  
\[34\] ” Running ‘rotated.Rnw’”  
\[35\] ” Running ‘saveload.Rnw’”  
\[36\] ” Running ‘sharing.Rnw’”  
\[37\] ” Running ‘viewports.Rnw’”  
\[38\] “Running vignettes for package ‘parallel’”  
\[39\] ” Running ‘parallel.Rnw’”  
\[40\] “”  
\[41\] “”  
\[42\] “Test suite result: PASS”  
\[43\] “”

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”  
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”  
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”  
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “Testing examples for package ‘MASS’”  
\[21\] ” comparing ‘MASS-Ex.Rout’ to ‘MASS-Ex.Rout.save’ … OK”  
\[22\] “Testing examples for package ‘lattice’”  
\[23\] “Testing examples for package ‘Matrix’”  
\[24\] “Testing examples for package ‘nlme’”  
\[25\] “Testing examples for package ‘survival’”  
\[26\] ” comparing ‘survival-Ex.Rout’ to ‘survival-Ex.Rout.save’ … OK”
\[27\] “Testing examples for package ‘boot’”  
\[28\] ” comparing ‘boot-Ex.Rout’ to ‘boot-Ex.Rout.save’ … OK”  
\[29\] “Testing examples for package ‘cluster’”  
\[30\] “Testing examples for package ‘codetools’”  
\[31\] “Testing examples for package ‘foreign’”  
\[32\] “Testing examples for package ‘KernSmooth’”  
\[33\] “Testing examples for package ‘rpart’”  
\[34\] ” comparing ‘rpart-Ex.Rout’ to ‘rpart-Ex.Rout.save’ … OK”  
\[35\] “Testing examples for package ‘class’”  
\[36\] “Testing examples for package ‘nnet’”  
\[37\] “Testing examples for package ‘spatial’”  
\[38\] ” comparing ‘spatial-Ex.Rout’ to ‘spatial-Ex.Rout.save’ … OK”  
\[39\] “Testing examples for package ‘mgcv’”  
\[40\] “”  
\[41\] “”  
\[42\] “Test suite result: PASS”  
\[43\] “”

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “Running vignettes for package ‘lattice’”  
\[21\] ” Running ‘grid.Rnw’”  
\[22\] “Running vignettes for package ‘Matrix’”  
\[23\] ” Running ‘Comparisons.Rnw’”  
\[24\] ” Running ‘Design-issues.Rnw’”  
\[25\] ” Running ‘Intro2Matrix.Rnw’”  
\[26\] ” Running ‘Introduction.Rnw’”  
\[27\] ” Running ‘sparseModels.Rnw’”  
\[28\] “Running vignettes for package ‘survival’”  
\[29\] ” Running ‘adjcurve.Rnw’”  
\[30\] ” Running ‘approximate.Rnw’”  
\[31\] ” Running ‘compete.Rnw’”  
\[32\] ” Running ‘concordance.Rnw’”  
\[33\] ” Running ‘matrix.Rnw’”  
\[34\] ” Running ‘methods.Rnw’”  
\[35\] ” Running ‘multi.Rnw’”  
\[36\] ” Running ‘other.Rnw’”  
\[37\] ” Running ‘population.Rnw’”  
\[38\] ” Running ‘redistribute.Rnw’”  
\[39\] ” Running ‘splines.Rnw’”  
\[40\] ” Running ‘survival.Rnw’”  
\[41\] ” Running ‘tiedtimes.Rnw’”  
\[42\] ” Running ‘timedep.Rnw’”  
\[43\] ” Running ‘validate.Rnw’”  
\[44\] “Running vignettes for package ‘rpart’”  
\[45\] ” Running ‘longintro.Rnw’”  
\[46\] ” Running ‘usercode.Rnw’”  
\[47\] “”  
\[48\] “”  
\[49\] “Test suite result: PASS”  
\[50\] “”

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”  
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”  
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “Running specific tests for package ‘tools’”  
\[21\] ” Running ‘hashes.R’”  
\[22\] ” Running ‘QC.R’”  
\[23\] ” Running ‘Rd.R’”  
\[24\] ” Running ‘Rd2HTML.R’”  
\[25\] ” Running ‘Rd2pdf.R’”  
\[26\] ” Running ‘S3.R’”  
\[27\] ” Running ‘undoc.R’”  
\[28\] “Running specific tests for package ‘utils’”  
\[29\] ” Running ‘charclass.R’”  
\[30\] ” Running ‘completion.R’”  
\[31\] ” Running ‘relist.R’”  
\[32\] ” Running ‘Sweave-tst.R’”  
\[33\] ” Running ‘tar.R’”  
\[34\] “Running specific tests for package ‘grDevices’”  
\[35\] ” Running ‘convertColor-tests.R’”  
\[36\] ” Running ‘encodings.R’”  
\[37\] ” comparing ‘encodings.Rout’ to ‘encodings.Rout.save’ … OK”  
\[38\] ” Running ‘encodings2.R’”  
\[39\] ” comparing ‘encodings2.Rout’ to ‘encodings2.Rout.save’ … OK”
\[40\] ” Running ‘encodings3.R’”  
\[41\] ” comparing ‘encodings3.Rout’ to ‘encodings3.Rout.save’ … OK”
\[42\] ” Running ‘grDev-tsts.R’”  
\[43\] ” Running ‘palettes-tests.R’”  
\[44\] ” Running ‘ps-tests.R’”  
\[45\] ” comparing ‘ps-tests.Rout’ to ‘ps-tests.Rout.save’ … OK”  
\[46\] ” Running ‘saved-recordPlot.R’”  
\[47\] ” Running ‘urw-fonts.R’”  
\[48\] ” Running ‘xyTable.R’”  
\[49\] ” comparing ‘xyTable.Rout’ to ‘xyTable.Rout.save’ … OK”  
\[50\] ” Running ‘zzcheck-encodings.R’”  
\[51\] “Running specific tests for package ‘stats’”  
\[52\] ” Running ‘arimaML.R’”  
\[53\] ” Running ‘bandwidth.R’”  
\[54\] ” comparing ‘bandwidth.Rout’ to ‘bandwidth.Rout.save’ … OK”  
\[55\] ” Running ‘cmdscale.R’”  
\[56\] ” Running ‘density_chk.R’”  
\[57\] ” Running ‘dpq-xtra.R’”  
\[58\] ” Running ‘drop1-polr.R’”  
\[59\] ” Running ‘factanal-tst.R’”  
\[60\] ” Running ‘glm-etc.R’”  
\[61\] ” Running ‘glm.R’”  
\[62\] ” comparing ‘glm.Rout’ to ‘glm.Rout.save’ … OK”  
\[63\] ” Running ‘ig_glm.R’”  
\[64\] ” Running ‘ks-test.R’”  
\[65\] ” comparing ‘ks-test.Rout’ to ‘ks-test.Rout.save’ … OK”  
\[66\] ” Running ‘loglin.R’”  
\[67\] ” comparing ‘loglin.Rout’ to ‘loglin.Rout.save’ … OK”  
\[68\] ” Running ‘nafns.R’”  
\[69\] ” Running ‘nlm.R’”  
\[70\] ” Running ‘nls.R’”  
\[71\] ” comparing ‘nls.Rout’ to ‘nls.Rout.save’ … OK”  
\[72\] ” Running ‘NLSstClosest.R’”  
\[73\] ” Running ‘offsets.R’”  
\[74\] ” Running ‘ppr.R’”  
\[75\] ” Running ‘psmirnov.R’”  
\[76\] ” comparing ‘psmirnov.Rout’ to ‘psmirnov.Rout.save’ … OK”  
\[77\] ” Running ‘simulate.R’”  
\[78\] ” comparing ‘simulate.Rout’ to ‘simulate.Rout.save’ … OK”  
\[79\] ” Running ‘smooth.spline.R’”  
\[80\] ” Running ‘table-margins.R’”  
\[81\] ” Running ‘ts-tests.R’”  
\[82\] “Running specific tests for package ‘methods’”  
\[83\] ” Running ‘basicRefClass.R’”  
\[84\] ” Running ‘duplicateClass.R’”  
\[85\] ” Running ‘envRefClass.R’”  
\[86\] ” Running ‘fieldAssignments.R’”  
\[87\] ” Running ‘mixinInitialize.R’”  
\[88\] ” Running ‘namesAndSlots.R’”  
\[89\] ” Running ‘nextWithDots.R’”  
\[90\] ” Running ‘refClassExample.R’”  
\[91\] ” Running ‘S3.R’”  
\[92\] ” Running ‘testConditionalIs.R’”  
\[93\] ” Running ‘testGroupGeneric.R’”  
\[94\] ” Running ‘testIs.R’”  
\[95\] “Running specific tests for package ‘grid’”  
\[96\] ” Running ‘bugs.R’”  
\[97\] ” Running ‘clippaths.R’”  
\[98\] ” Running ‘compositing.R’”  
\[99\] ” Running ‘coords.R’”  
\[100\] ” Running ‘glyphs.R’”  
\[101\] ” Running ‘grep.R’”  
\[102\] ” comparing ‘grep.Rout’ to ‘grep.Rout.save’ … OK”  
\[103\] ” Running ‘groups.R’”  
\[104\] ” Running ‘masks.R’”  
\[105\] ” Running ‘nesting.R’”  
\[106\] ” Running ‘paths.R’”  
\[107\] ” Running ‘patterns.R’”  
\[108\] ” Running ‘reg.R’”  
\[109\] ” Running ‘testls.R’”  
\[110\] ” comparing ‘testls.Rout’ to ‘testls.Rout.save’ … OK”  
\[111\] ” Running ‘units.R’”  
\[112\] “Running specific tests for package ‘splines’”  
\[113\] ” Running ‘sparse-tst.R’”  
\[114\] ” Running ‘spline-tst.R’”  
\[115\] “Running specific tests for package ‘stats4’”  
\[116\] ” Running ‘confint.R’”  
\[117\] “Running specific tests for package ‘compiler’”  
\[118\] ” Running ‘assign.R’”  
\[119\] ” Running ‘basics.R’”  
\[120\] ” Running ‘const.R’”  
\[121\] ” Running ‘curexpr.R’”  
\[122\] ” Running ‘envir.R’”  
\[123\] ” Running ‘jit.R’”  
\[124\] ” Running ‘loop.R’”  
\[125\] ” Running ‘srcref.R’”  
\[126\] ” Running ‘switch.R’”  
\[127\] ” Running ‘vischk.R’”  
\[128\] “Running specific tests for package ‘parallel’”  
\[129\] ” Running ‘Master.R’”  
\[130\] ” Running ‘RSeed.R’”  
\[131\] “”  
\[132\] “”  
\[133\] “Test suite result: PASS”  
\[134\] “”

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

\[1\] “”  
\[2\] “R version 4.5.1 (2025-06-13 ucrt) – "Great Square Root"”  
\[3\] “Copyright (C) 2025 The R Foundation for Statistical Computing”  
\[4\] “Platform: x86_64-w64-mingw32/x64”  
\[5\] “”  
\[6\] “R is free software and comes with ABSOLUTELY NO WARRANTY.”  
\[7\] “You are welcome to redistribute it under certain conditions.”  
\[8\] “Type ‘license()’ or ‘licence()’ for distribution details.”  
\[9\] “”  
\[10\] “R is a collaborative project with many contributors.”  
\[11\] “Type ‘contributors()’ for more information and”  
\[12\] “‘citation()’ on how to cite R or R packages in publications.”  
\[13\] “”  
\[14\] “Type ‘demo()’ for some demos, ‘help()’ for on-line help, or”  
\[15\] “‘help.start()’ for an HTML browser interface to help.”  
\[16\] “Type ‘q()’ to quit R.”  
\[17\] “”  
\[18\] “\>”  
\[19\] “\> options(echo = FALSE)”  
\[20\] “Running specific tests for package ‘MASS’”  
\[21\] ” Running ‘confint.R’”  
\[22\] ” Running ‘cov.mcd.R’”  
\[23\] ” Running ‘fitdistr.R’”  
\[24\] ” comparing ‘fitdistr.Rout’ to ‘fitdistr.Rout.save’ … OK”  
\[25\] ” Running ‘glm.nb.R’”  
\[26\] ” Running ‘glmmPQL.R’”  
\[27\] ” Running ‘hubers.R’”  
\[28\] ” Running ‘lme.R’”  
\[29\] ” Running ‘loglm.R’”  
\[30\] ” Running ‘polr.R’”  
\[31\] ” Running ‘profile.R’”  
\[32\] ” Running ‘regression.R’”  
\[33\] ” comparing ‘regression.Rout’ to ‘regression.Rout.save’ … OK”  
\[34\] ” Running ‘rlm.R’”  
\[35\] ” Running ‘scripts.R’”  
\[36\] “Running specific tests for package ‘lattice’”  
\[37\] ” Running ‘auto-key.R’”  
\[38\] ” Running ‘barchart-width.R’”  
\[39\] ” Running ‘call.R’”  
\[40\] ” Running ‘colorkey-title.R’”  
\[41\] ” Running ‘dataframe-methods.R’”  
\[42\] ” Running ‘dates.R’”  
\[43\] ” Running ‘dotplotscoping.R’”  
\[44\] ” Running ‘fontsize.R’”  
\[45\] ” Running ‘levelplot.R’”  
\[46\] ” Running ‘MASSch04.R’”  
\[47\] ” Running ‘scales.R’”  
\[48\] ” Running ‘shade-wireframe.R’”  
\[49\] ” Running ‘summary.R’”  
\[50\] ” Running ‘temp.R’”  
\[51\] ” Running ‘test.R’”  
\[52\] ” Running ‘wireframe.R’”  
\[53\] “Running specific tests for package ‘Matrix’”  
\[54\] ” Running ‘abIndex-tsts.R’”  
\[55\] ” Running ‘base-matrix-fun.R’”  
\[56\] ” Running ‘bind.R’”  
\[57\] ” comparing ‘bind.Rout’ to ‘bind.Rout.save’ … OK”  
\[58\] ” Running ‘Class+Meth.R’”  
\[59\] ” Running ‘dg_Matrix.R’”  
\[60\] ” Running ‘dpo-test.R’”  
\[61\] ” Running ‘dtpMatrix.R’”  
\[62\] ” Running ‘factorizing.R’”  
\[63\] ” Running ‘group-methods.R’”  
\[64\] ” Running ‘indexing.R’”  
\[65\] ” comparing ‘indexing.Rout’ to ‘indexing.Rout.save’ …30,31d29”  
\[66\] “\< Warning in Sys.setLanguage("en") :”  
\[67\] “\< no natural language support or missing translations”  
\[68\] ” Running ‘matprod.R’”  
\[69\] ” Running ‘matr-exp.R’”  
\[70\] ” Running ‘other-pkgs.R’”  
\[71\] ” Running ‘packed-unpacked.R’”  
\[72\] ” Running ‘Simple.R’”  
\[73\] ” Running ‘spModel.matrix.R’”  
\[74\] ” Running ‘symmDN.R’”  
\[75\] ” Running ‘validObj.R’”  
\[76\] ” Running ‘write-read.R’”  
\[77\] “Running specific tests for package ‘nlme’”  
\[78\] ” Running ‘anova.gls.R’”  
\[79\] ” Running ‘augPred_lab.R’”  
\[80\] ” Running ‘augPredmissing.R’”  
\[81\] ” Running ‘coef.R’”  
\[82\] ” comparing ‘coef.Rout’ to ‘coef.Rout.save’ … OK”  
\[83\] ” Running ‘contrMat.R’”  
\[84\] ” Running ‘corMatrix.R’”  
\[85\] ” Running ‘corStruct.R’”  
\[86\] ” Running ‘data.frame.R’”  
\[87\] ” Running ‘deparse.R’”  
\[88\] ” Running ‘deviance.R’”  
\[89\] ” Running ‘fitted.R’”  
\[90\] ” Running ‘getData.R’”  
\[91\] ” Running ‘getVarCov.R’”  
\[92\] ” Running ‘gls.R’”  
\[93\] ” Running ‘gnls-ch8.R’”  
\[94\] ” Running ‘lme.R’”  
\[95\] ” comparing ‘lme.Rout’ to ‘lme.Rout.save’ … OK”  
\[96\] ” Running ‘lmList.R’”  
\[97\] ” Running ‘missing.R’”  
\[98\] ” comparing ‘missing.Rout’ to ‘missing.Rout.save’ … OK”  
\[99\] ” Running ‘nlme.R’”  
\[100\] ” Running ‘nlme2.R’”  
\[101\] ” Running ‘predict.lme.R’”  
\[102\] ” Running ‘scoping.R’”  
\[103\] ” Running ‘sigma-fixed-etc.R’”  
\[104\] ” Running ‘updateLme.R’”  
\[105\] ” Running ‘varConstProp.R’”  
\[106\] ” Running ‘varFixed.R’”  
\[107\] ” Running ‘varIdent.R’”  
\[108\] “Running specific tests for package ‘survival’”  
\[109\] ” Running ‘aareg.R’”  
\[110\] ” comparing ‘aareg.Rout’ to ‘aareg.Rout.save’ … OK”  
\[111\] ” Running ‘anova.R’”  
\[112\] ” comparing ‘anova.Rout’ to ‘anova.Rout.save’ … OK”  
\[113\] ” Running ‘bladder.R’”  
\[114\] ” comparing ‘bladder.Rout’ to ‘bladder.Rout.save’ … OK”  
\[115\] ” Running ‘book1.R’”  
\[116\] ” comparing ‘book1.Rout’ to ‘book1.Rout.save’ … OK”  
\[117\] ” Running ‘book2.R’”  
\[118\] ” comparing ‘book2.Rout’ to ‘book2.Rout.save’ … OK”  
\[119\] ” Running ‘book3.R’”  
\[120\] ” comparing ‘book3.Rout’ to ‘book3.Rout.save’ … OK”  
\[121\] ” Running ‘book4.R’”  
\[122\] ” comparing ‘book4.Rout’ to ‘book4.Rout.save’ … OK”  
\[123\] ” Running ‘book5.R’”  
\[124\] ” comparing ‘book5.Rout’ to ‘book5.Rout.save’ … OK”  
\[125\] ” Running ‘book6.R’”  
\[126\] ” comparing ‘book6.Rout’ to ‘book6.Rout.save’ … OK”  
\[127\] ” Running ‘book7.R’”  
\[128\] ” comparing ‘book7.Rout’ to ‘book7.Rout.save’ … OK”  
\[129\] ” Running ‘brier.R’”  
\[130\] ” comparing ‘brier.Rout’ to ‘brier.Rout.save’ … OK”  
\[131\] ” Running ‘cancer.R’”  
\[132\] ” comparing ‘cancer.Rout’ to ‘cancer.Rout.save’ … OK”  
\[133\] ” Running ‘checkSurv2.R’”  
\[134\] ” comparing ‘checkSurv2.Rout’ to ‘checkSurv2.Rout.save’ … OK”  
\[135\] ” Running ‘clogit.R’”  
\[136\] ” comparing ‘clogit.Rout’ to ‘clogit.Rout.save’ … OK”  
\[137\] ” Running ‘concordance.R’”  
\[138\] ” comparing ‘concordance.Rout’ to ‘concordance.Rout.save’ …
OK”  
\[139\] ” Running ‘concordance2.R’”  
\[140\] ” comparing ‘concordance2.Rout’ to ‘concordance2.Rout.save’ …
OK”  
\[141\] ” Running ‘concordance3.R’”  
\[142\] ” comparing ‘concordance3.Rout’ to ‘concordance3.Rout.save’ …
OK”  
\[143\] ” Running ‘counting.R’”  
\[144\] ” comparing ‘counting.Rout’ to ‘counting.Rout.save’ … OK”  
\[145\] ” Running ‘coxsurv.R’”  
\[146\] ” comparing ‘coxsurv.Rout’ to ‘coxsurv.Rout.save’ … OK”  
\[147\] ” Running ‘coxsurv2.R’”  
\[148\] ” comparing ‘coxsurv2.Rout’ to ‘coxsurv2.Rout.save’ … OK”  
\[149\] ” Running ‘coxsurv3.R’”  
\[150\] ” comparing ‘coxsurv3.Rout’ to ‘coxsurv3.Rout.save’ … OK”  
\[151\] ” Running ‘coxsurv4.R’”  
\[152\] ” comparing ‘coxsurv4.Rout’ to ‘coxsurv4.Rout.save’ … OK”  
\[153\] ” Running ‘coxsurv5.R’”  
\[154\] ” comparing ‘coxsurv5.Rout’ to ‘coxsurv5.Rout.save’ … OK”  
\[155\] ” Running ‘coxsurv6.R’”  
\[156\] ” comparing ‘coxsurv6.Rout’ to ‘coxsurv6.Rout.save’ … OK”  
\[157\] ” Running ‘detail.R’”  
\[158\] ” comparing ‘detail.Rout’ to ‘detail.Rout.save’ … OK”  
\[159\] ” Running ‘difftest.R’”  
\[160\] ” comparing ‘difftest.Rout’ to ‘difftest.Rout.save’ … OK”  
\[161\] ” Running ‘doaml.R’”  
\[162\] ” comparing ‘doaml.Rout’ to ‘doaml.Rout.save’ … OK”  
\[163\] ” Running ‘doublecolon.R’”  
\[164\] ” comparing ‘doublecolon.Rout’ to ‘doublecolon.Rout.save’ …
OK”  
\[165\] ” Running ‘doweight.R’”  
\[166\] ” comparing ‘doweight.Rout’ to ‘doweight.Rout.save’ … OK”  
\[167\] ” Running ‘dropspecial.R’”  
\[168\] ” comparing ‘dropspecial.Rout’ to ‘dropspecial.Rout.save’ …
OK”  
\[169\] ” Running ‘ekm.R’”  
\[170\] ” comparing ‘ekm.Rout’ to ‘ekm.Rout.save’ … OK”  
\[171\] ” Running ‘expected.R’”  
\[172\] ” comparing ‘expected.Rout’ to ‘expected.Rout.save’ … OK”  
\[173\] ” Running ‘expected2.R’”  
\[174\] ” comparing ‘expected2.Rout’ to ‘expected2.Rout.save’ … OK”  
\[175\] ” Running ‘factor.R’”  
\[176\] ” comparing ‘factor.Rout’ to ‘factor.Rout.save’ … OK”  
\[177\] ” Running ‘factor2.R’”  
\[178\] ” comparing ‘factor2.Rout’ to ‘factor2.Rout.save’ … OK”  
\[179\] ” Running ‘finegray.R’”  
\[180\] ” comparing ‘finegray.Rout’ to ‘finegray.Rout.save’ … OK”  
\[181\] ” Running ‘fr_cancer.R’”  
\[182\] ” comparing ‘fr_cancer.Rout’ to ‘fr_cancer.Rout.save’ … OK”  
\[183\] ” Running ‘fr_kidney.R’”  
\[184\] ” comparing ‘fr_kidney.Rout’ to ‘fr_kidney.Rout.save’ … OK”  
\[185\] ” Running ‘fr_lung.R’”  
\[186\] ” comparing ‘fr_lung.Rout’ to ‘fr_lung.Rout.save’ … OK”  
\[187\] ” Running ‘fr_ovarian.R’”  
\[188\] ” comparing ‘fr_ovarian.Rout’ to ‘fr_ovarian.Rout.save’ … OK”  
\[189\] ” Running ‘fr_rat1.R’”  
\[190\] ” comparing ‘fr_rat1.Rout’ to ‘fr_rat1.Rout.save’ … OK”  
\[191\] ” Running ‘fr_resid.R’”  
\[192\] ” comparing ‘fr_resid.Rout’ to ‘fr_resid.Rout.save’ … OK”  
\[193\] ” Running ‘fr_simple.R’”  
\[194\] ” comparing ‘fr_simple.Rout’ to ‘fr_simple.Rout.save’ … OK”  
\[195\] ” Running ‘frailty.R’”  
\[196\] ” comparing ‘frailty.Rout’ to ‘frailty.Rout.save’ … OK”  
\[197\] ” Running ‘frank.R’”  
\[198\] ” comparing ‘frank.Rout’ to ‘frank.Rout.save’ … OK”  
\[199\] ” Running ‘infcox.R’”  
\[200\] ” comparing ‘infcox.Rout’ to ‘infcox.Rout.save’ … OK”  
\[201\] ” Running ‘jasa.R’”  
\[202\] ” comparing ‘jasa.Rout’ to ‘jasa.Rout.save’ … OK”  
\[203\] ” Running ‘model.matrix.R’”  
\[204\] ” comparing ‘model.matrix.Rout’ to ‘model.matrix.Rout.save’ …
OK”  
\[205\] ” Running ‘mstate.R’”  
\[206\] ” comparing ‘mstate.Rout’ to ‘mstate.Rout.save’ … OK”  
\[207\] ” Running ‘mstate2.R’”  
\[208\] ” comparing ‘mstate2.Rout’ to ‘mstate2.Rout.save’ … OK”  
\[209\] ” Running ‘mstrata.R’”  
\[210\] ” comparing ‘mstrata.Rout’ to ‘mstrata.Rout.save’ … OK”  
\[211\] ” Running ‘multi2.R’”  
\[212\] ” comparing ‘multi2.Rout’ to ‘multi2.Rout.save’ … OK”  
\[213\] ” Running ‘multi3.R’”  
\[214\] ” comparing ‘multi3.Rout’ to ‘multi3.Rout.save’ … OK”  
\[215\] ” Running ‘multistate.R’”  
\[216\] ” comparing ‘multistate.Rout’ to ‘multistate.Rout.save’ … OK”  
\[217\] ” Running ‘neardate.R’”  
\[218\] ” comparing ‘neardate.Rout’ to ‘neardate.Rout.save’ … OK”  
\[219\] ” Running ‘nested.R’”  
\[220\] ” comparing ‘nested.Rout’ to ‘nested.Rout.save’ … OK”  
\[221\] ” Running ‘nsk.R’”  
\[222\] ” comparing ‘nsk.Rout’ to ‘nsk.Rout.save’ … OK”  
\[223\] ” Running ‘ovarian.R’”  
\[224\] ” comparing ‘ovarian.Rout’ to ‘ovarian.Rout.save’ … OK”  
\[225\] ” Running ‘overlap.R’”  
\[226\] ” comparing ‘overlap.Rout’ to ‘overlap.Rout.save’ … OK”  
\[227\] ” Running ‘prednew.R’”  
\[228\] ” comparing ‘prednew.Rout’ to ‘prednew.Rout.save’ … OK”  
\[229\] ” Running ‘predsurv.R’”  
\[230\] ” comparing ‘predsurv.Rout’ to ‘predsurv.Rout.save’ … OK”  
\[231\] ” Running ‘pseudo.R’”  
\[232\] ” comparing ‘pseudo.Rout’ to ‘pseudo.Rout.save’ … OK”  
\[233\] ” Running ‘pspline.R’”  
\[234\] ” comparing ‘pspline.Rout’ to ‘pspline.Rout.save’ … OK”  
\[235\] ” Running ‘pyear.R’”  
\[236\] ” comparing ‘pyear.Rout’ to ‘pyear.Rout.save’ … OK”  
\[237\] ” Running ‘quantile.R’”  
\[238\] ” comparing ‘quantile.Rout’ to ‘quantile.Rout.save’ … OK”  
\[239\] ” Running ‘r_lung.R’”  
\[240\] ” comparing ‘r_lung.Rout’ to ‘r_lung.Rout.save’ … OK”  
\[241\] ” Running ‘r_resid.R’”  
\[242\] ” comparing ‘r_resid.Rout’ to ‘r_resid.Rout.save’ … OK”  
\[243\] ” Running ‘r_sas.R’”  
\[244\] ” comparing ‘r_sas.Rout’ to ‘r_sas.Rout.save’ … OK”  
\[245\] ” Running ‘r_scale.R’”  
\[246\] ” comparing ‘r_scale.Rout’ to ‘r_scale.Rout.save’ … OK”  
\[247\] ” Running ‘r_stanford.R’”  
\[248\] ” comparing ‘r_stanford.Rout’ to ‘r_stanford.Rout.save’ … OK”  
\[249\] ” Running ‘r_strata.R’”  
\[250\] ” comparing ‘r_strata.Rout’ to ‘r_strata.Rout.save’ … OK”  
\[251\] ” Running ‘r_tdist.R’”  
\[252\] ” comparing ‘r_tdist.Rout’ to ‘r_tdist.Rout.save’ … OK”  
\[253\] ” Running ‘r_user.R’”  
\[254\] ” comparing ‘r_user.Rout’ to ‘r_user.Rout.save’ … OK”  
\[255\] ” Running ‘ratetable.R’”  
\[256\] ” comparing ‘ratetable.Rout’ to ‘ratetable.Rout.save’ … OK”  
\[257\] ” Running ‘residsf.R’”  
\[258\] ” comparing ‘residsf.Rout’ to ‘residsf.Rout.save’ … OK”  
\[259\] ” Running ‘royston.R’”  
\[260\] ” comparing ‘royston.Rout’ to ‘royston.Rout.save’ … OK”  
\[261\] ” Running ‘rttright.R’”  
\[262\] ” comparing ‘rttright.Rout’ to ‘rttright.Rout.save’ … OK”  
\[263\] ” Running ‘singtest.R’”  
\[264\] ” comparing ‘singtest.Rout’ to ‘singtest.Rout.save’ … OK”  
\[265\] ” Running ‘strata2.R’”  
\[266\] ” comparing ‘strata2.Rout’ to ‘strata2.Rout.save’ … OK”  
\[267\] ” Running ‘stratatest.R’”  
\[268\] ” comparing ‘stratatest.Rout’ to ‘stratatest.Rout.save’ … OK”  
\[269\] ” Running ‘summary_survfit.R’”  
\[270\] ” comparing ‘summary_survfit.Rout’ to
‘summary_survfit.Rout.save’ … OK”  
\[271\] ” Running ‘surv.R’”  
\[272\] ” comparing ‘surv.Rout’ to ‘surv.Rout.save’ … OK”  
\[273\] ” Running ‘survcheck.R’”  
\[274\] ” comparing ‘survcheck.Rout’ to ‘survcheck.Rout.save’ … OK”  
\[275\] ” Running ‘survfit1.R’”  
\[276\] ” comparing ‘survfit1.Rout’ to ‘survfit1.Rout.save’ … OK”  
\[277\] ” Running ‘survfit2.R’”  
\[278\] ” comparing ‘survfit2.Rout’ to ‘survfit2.Rout.save’ … OK”  
\[279\] ” Running ‘survreg1.R’”  
\[280\] ” comparing ‘survreg1.Rout’ to ‘survreg1.Rout.save’ … OK”  
\[281\] ” Running ‘survreg2.R’”  
\[282\] ” comparing ‘survreg2.Rout’ to ‘survreg2.Rout.save’ … OK”  
\[283\] ” Running ‘survSplit.R’”  
\[284\] ” comparing ‘survSplit.Rout’ to ‘survSplit.Rout.save’ … OK”  
\[285\] ” Running ‘survtest.R’”  
\[286\] ” comparing ‘survtest.Rout’ to ‘survtest.Rout.save’ … OK”  
\[287\] ” Running ‘testci.R’”  
\[288\] ” comparing ‘testci.Rout’ to ‘testci.Rout.save’ … OK”  
\[289\] ” Running ‘testci2.R’”  
\[290\] ” comparing ‘testci2.Rout’ to ‘testci2.Rout.save’ … OK”  
\[291\] ” Running ‘testnull.R’”  
\[292\] ” comparing ‘testnull.Rout’ to ‘testnull.Rout.save’ … OK”  
\[293\] ” Running ‘testreg.R’”  
\[294\] ” comparing ‘testreg.Rout’ to ‘testreg.Rout.save’ … OK”  
\[295\] ” Running ‘tiedtime.R’”  
\[296\] ” comparing ‘tiedtime.Rout’ to ‘tiedtime.Rout.save’ … OK”  
\[297\] ” Running ‘tmerge.R’”  
\[298\] ” comparing ‘tmerge.Rout’ to ‘tmerge.Rout.save’ … OK”  
\[299\] ” Running ‘tmerge2.R’”  
\[300\] ” comparing ‘tmerge2.Rout’ to ‘tmerge2.Rout.save’ … OK”  
\[301\] ” Running ‘tmerge3.R’”  
\[302\] ” comparing ‘tmerge3.Rout’ to ‘tmerge3.Rout.save’ … OK”  
\[303\] ” Running ‘tt.R’”  
\[304\] ” comparing ‘tt.Rout’ to ‘tt.Rout.save’ … OK”  
\[305\] ” Running ‘tt2.R’”  
\[306\] ” comparing ‘tt2.Rout’ to ‘tt2.Rout.save’ … OK”  
\[307\] ” Running ‘turnbull.R’”  
\[308\] ” comparing ‘turnbull.Rout’ to ‘turnbull.Rout.save’ … OK”  
\[309\] ” Running ‘update.R’”  
\[310\] ” comparing ‘update.Rout’ to ‘update.Rout.save’ … OK”  
\[311\] ” Running ‘yates0.R’”  
\[312\] ” comparing ‘yates0.Rout’ to ‘yates0.Rout.save’ … OK”  
\[313\] ” Running ‘yates1.R’”  
\[314\] ” comparing ‘yates1.Rout’ to ‘yates1.Rout.save’ … OK”  
\[315\] ” Running ‘yates2.R’”  
\[316\] ” Running ‘zph.R’”  
\[317\] ” comparing ‘zph.Rout’ to ‘zph.Rout.save’ … OK”  
\[318\] “Running specific tests for package ‘boot’”  
\[319\] ” Running ‘parallel-censboot.R’”  
\[320\] “Running specific tests for package ‘cluster’”  
\[321\] ” Running ‘agnes-ex.R’”  
\[322\] ” comparing ‘agnes-ex.Rout’ to ‘agnes-ex.Rout.save’ … OK”  
\[323\] ” Running ‘clara-ex.R’”  
\[324\] ” comparing ‘clara-ex.Rout’ to ‘clara-ex.Rout.save’ … OK”  
\[325\] ” Running ‘clara-gower.R’”  
\[326\] ” Running ‘clara-NAs.R’”  
\[327\] ” comparing ‘clara-NAs.Rout’ to ‘clara-NAs.Rout.save’ … OK”  
\[328\] ” Running ‘clara.R’”  
\[329\] ” comparing ‘clara.Rout’ to ‘clara.Rout.save’ … OK”  
\[330\] ” Running ‘clusplot-out.R’”  
\[331\] ” comparing ‘clusplot-out.Rout’ to ‘clusplot-out.Rout.save’ …
OK”  
\[332\] ” Running ‘daisy-ex.R’”  
\[333\] ” comparing ‘daisy-ex.Rout’ to ‘daisy-ex.Rout.save’ … OK”  
\[334\] ” Running ‘diana-boots.R’”  
\[335\] ” Running ‘diana-ex.R’”  
\[336\] ” comparing ‘diana-ex.Rout’ to ‘diana-ex.Rout.save’ … OK”  
\[337\] ” Running ‘ellipsoid-ex.R’”  
\[338\] ” comparing ‘ellipsoid-ex.Rout’ to ‘ellipsoid-ex.Rout.save’ …
OK”  
\[339\] ” Running ‘fanny-ex.R’”  
\[340\] ” comparing ‘fanny-ex.Rout’ to ‘fanny-ex.Rout.save’ … OK”  
\[341\] ” Running ‘mona.R’”  
\[342\] ” comparing ‘mona.Rout’ to ‘mona.Rout.save’ … OK”  
\[343\] ” Running ‘pam.R’”  
\[344\] ” comparing ‘pam.Rout’ to ‘pam.Rout.save’ … OK”  
\[345\] ” Running ‘silhouette-default.R’”  
\[346\] ” comparing ‘silhouette-default.Rout’ to
‘silhouette-default.Rout.save’ … OK”  
\[347\] ” Running ‘sweep-ex.R’”  
\[348\] “Running specific tests for package ‘codetools’”  
\[349\] ” Running ‘tests.R’”  
\[350\] “Running specific tests for package ‘foreign’”  
\[351\] ” Running ‘arff.R’”  
\[352\] ” comparing ‘arff.Rout’ to ‘arff.Rout.save’ … OK”  
\[353\] ” Running ‘download.R’”  
\[354\] ” Running ‘minitab.R’”  
\[355\] ” comparing ‘minitab.Rout’ to ‘minitab.Rout.save’ … OK”  
\[356\] ” Running ‘mval_bug.R’”  
\[357\] ” comparing ‘mval_bug.Rout’ to ‘mval_bug.Rout.save’ … OK”  
\[358\] ” Running ‘octave.R’”  
\[359\] ” comparing ‘octave.Rout’ to ‘octave.Rout.save’ … OK”  
\[360\] ” Running ‘S3.R’”  
\[361\] ” comparing ‘S3.Rout’ to ‘S3.Rout.save’ … OK”  
\[362\] ” Running ‘sas.R’”  
\[363\] ” Running ‘spss.R’”  
\[364\] ” comparing ‘spss.Rout’ to ‘spss.Rout.save’ …353c353”  
\[365\] “\< \$ factor_s_duplicated : Factor w/ 5 levels
"A","ä","A_duplicated_b",..: 1 5 2 NA NA”  
\[366\] “—”  
\[367\] “\> \$ factor_s_duplicated : Factor w/ 5 levels
"A","A_duplicated_b",..: 1 5 4 NA NA”  
\[368\] “458c458”  
\[369\] “\< \$ string_500 : Factor w/ 4 levels " "\| **truncated**,..: 2
1 4 1 3” \[370\] “—”  
\[371\] “\> \$ string_500 : Factor w/ 4 levels " "\| **truncated**,..: 2
1 3 1 4” \[372\] “462c462”  
\[373\] “\< \$ factor_s_duplicated : Factor w/ 5 levels
"A","ä","A_duplicated_b",..: 1 5 2 NA NA”  
\[374\] “—”  
\[375\] “\> \$ factor_s_duplicated : Factor w/ 5 levels
"A","A_duplicated_b",..: 1 5 4 NA NA”  
\[376\] ” Running ‘stata.R’”  
\[377\] ” comparing ‘stata.Rout’ to ‘stata.Rout.save’ … OK”  
\[378\] ” Running ‘testEmpty.R’”  
\[379\] ” comparing ‘testEmpty.Rout’ to ‘testEmpty.Rout.save’ … OK”  
\[380\] ” Running ‘writeForeignSPSS.R’”  
\[381\] ” comparing ‘writeForeignSPSS.Rout’ to
‘writeForeignSPSS.Rout.save’ … OK”  
\[382\] ” Running ‘xport.R’”  
\[383\] ” comparing ‘xport.Rout’ to ‘xport.Rout.save’ … OK”  
\[384\] “Running specific tests for package ‘KernSmooth’”  
\[385\] ” Running ‘bkfe.R’”  
\[386\] ” Running ‘locpoly.R’”  
\[387\] “Running specific tests for package ‘rpart’”  
\[388\] ” Running ‘backticks.R’”  
\[389\] ” comparing ‘backticks.Rout’ to ‘backticks.Rout.save’ … OK”  
\[390\] ” Running ‘cost.R’”  
\[391\] ” comparing ‘cost.Rout’ to ‘cost.Rout.save’ … OK”  
\[392\] ” Running ‘cptest.R’”  
\[393\] ” comparing ‘cptest.Rout’ to ‘cptest.Rout.save’ … OK”  
\[394\] ” Running ‘minus_in_formula.R’”  
\[395\] ” comparing ‘minus_in_formula.Rout’ to
‘minus_in_formula.Rout.save’ … OK”  
\[396\] ” Running ‘priors.R’”  
\[397\] ” comparing ‘priors.Rout’ to ‘priors.Rout.save’ … OK”  
\[398\] ” Running ‘rescale.R’”  
\[399\] ” comparing ‘rescale.Rout’ to ‘rescale.Rout.save’ … OK”  
\[400\] ” Running ‘testall.R’”  
\[401\] ” comparing ‘testall.Rout’ to ‘testall.Rout.save’ … OK”  
\[402\] ” Running ‘treble.R’”  
\[403\] ” comparing ‘treble.Rout’ to ‘treble.Rout.save’ … OK”  
\[404\] ” Running ‘treble2.R’”  
\[405\] ” comparing ‘treble2.Rout’ to ‘treble2.Rout.save’ … OK”  
\[406\] ” Running ‘treble3.R’”  
\[407\] ” comparing ‘treble3.Rout’ to ‘treble3.Rout.save’ … OK”  
\[408\] ” Running ‘treble4.R’”  
\[409\] ” comparing ‘treble4.Rout’ to ‘treble4.Rout.save’ … OK”  
\[410\] ” Running ‘usersplits.R’”  
\[411\] ” comparing ‘usersplits.Rout’ to ‘usersplits.Rout.save’ … OK”  
\[412\] ” Running ‘xpred1.R’”  
\[413\] ” comparing ‘xpred1.Rout’ to ‘xpred1.Rout.save’ … OK”  
\[414\] ” Running ‘xpred2.R’”  
\[415\] ” comparing ‘xpred2.Rout’ to ‘xpred2.Rout.save’ … OK”  
\[416\] “Running specific tests for package ‘spatial’”  
\[417\] “”  
\[418\] “”  
\[419\] “Test suite result: PASS”  
\[420\] “”

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
