test_that("Missing path_save returns error", {
  testthat::expect_error(rqualify(setup_tinytex=FALSE, 
                                  setup_pandoc=FALSE,
                                  verbose=FALSE, 
                                  create_zip=FALSE))
})

