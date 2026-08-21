test_that("Error when missing path_save", {
  testthat::expect_error(rqualify(setup_tinytex=FALSE, 
                                  setup_pandoc=FALSE,
                                  verbose=FALSE))
})

