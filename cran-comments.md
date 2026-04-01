## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* Addressed several initial submission CRAN comments as follows:
* Replaced \dontrun with \donttest and added TinyTeX and Pandoc availability conditions on the function example.
* Altered functions in examples/vignettes/tests to save output to tempdir().
* Fixed verbose argument  so that messages to console can be easily suppressed.
* Altered functions examples and the vignette so that by default, external packages are not installed. 
* Altered vignette to partially execute code chunks by default, while code chunks with long run time are set to eval = FALSE and pre-computed output is displayed.