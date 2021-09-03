test_that("dataset name is declared", {
  expect_error(sumNA(), "Please declare a dataset")
})

data <- data.frame(a = c("a", NA),
                   b = c(NA, NA))

test_that("SumNA function works", {
  expect_equal(as.character(sumNA(data)), c("1", "2"))
})
