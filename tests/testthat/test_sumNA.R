test_that("dataset name is declared", {
  expect_error(sumNA(), "You need to name the dataset. We suggest a short, unique name,
         all capital letters, such as 'DESTA'.")
})