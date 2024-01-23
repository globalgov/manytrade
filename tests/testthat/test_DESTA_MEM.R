# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("^N/A$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("^\\s$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("^\\.$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("N\\.A\\.$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("n\\.a\\.$", memberships[["DESTA_MEM"]])))
})

# Uniformity tests (agreements have a stateID and Begin columns)
test_that("datasets have the required variables", {
  pointblank::expect_col_exists(memberships[["DESTA_MEM"]],
                                pointblank::vars(stateID))
  pointblank::expect_col_exists(memberships[["DESTA_MEM"]],
                                pointblank::vars(Begin))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(memberships[["DESTA_MEM"]])))
  expect_false(any(lubridate::is.POSIXct(memberships[["DESTA_MEM"]])))
  expect_false(any(lubridate::is.POSIXlt(memberships[["DESTA_MEM"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Begin` has standardised dates", {
  expect_equal(class(memberships[["DESTA_MEM"]]$Begin), "mdate")
  expect_false(any(grepl("/", memberships[["DESTA_MEM"]]$Begin)))
  expect_false(any(grepl("^[:alpha:]$",
                         memberships[["DESTA_MEM"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         memberships[["DESTA_MEM"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         memberships[["DESTA_MEM"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         memberships[["DESTA_MEM"]]$Begin)))
})

# Dataset should be ordered according to the "Begin" column
test_that("dataset is arranged by the `Begin` variable", {
  expect_true(memberships[["DESTA_MEM"]]$Begin[1] <
                memberships[["DESTA_MEM"]]$Begin[100])
  expect_true(memberships[["DESTA_MEM"]]$Begin[120] <
                memberships[["DESTA_MEM"]]$Begin[220])
  expect_true(memberships[["DESTA_MEM"]]$Begin[250] <
                memberships[["DESTA_MEM"]]$Begin[350])
})
