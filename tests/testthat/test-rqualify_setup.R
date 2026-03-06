test_that("Missing path_save returns error", {
  testthat::expect_error(rqualify_setup(setup_tinytex = FALSE,
                                        setup_pandoc = FALSE,
                                        verbose = FALSE))
})
