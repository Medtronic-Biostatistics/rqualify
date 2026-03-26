# Introduction to the rqualify Package

Please see
<https://medtronic-biostatistics.github.io/rqualify/index.html> for the
full documentation. Here is only a minimal example:

``` r
library(rqualify)
rqualify(path_save     = tempdir(),
         setup_tinytex = TRUE,
         setup_pandoc  = TRUE,
         verbose       = TRUE)
```
