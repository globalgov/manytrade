# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", agreements[["TOTA"]])))
  expect_false(any(grepl("^N/A$", agreements[["TOTA"]])))
  expect_false(any(grepl("^\\s$", agreements[["TOTA"]])))
  expect_false(any(grepl("^\\.$", agreements[["TOTA"]])))
  expect_false(any(grepl("N\\.A\\.$", agreements[["TOTA"]])))
  expect_false(any(grepl("n\\.a\\.$", agreements[["TOTA"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  pointblank::expect_col_exists(agreements[["TOTA"]],
                                pointblank::vars(Title))
  pointblank::expect_col_exists(agreements[["TOTA"]],
                                pointblank::vars(Begin))
  expect_true(any(grepl("ID$", colnames(agreements[["TOTA"]]))))
  pointblank::expect_col_exists(agreements[["TOTA"]],
                                pointblank::vars(Signature))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["TOTA"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["TOTA"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["TOTA"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["TOTA"]]$Begin), "mdate")
  expect_false(any(grepl("/", agreements[["TOTA"]]$Begin)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["TOTA"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["TOTA"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["TOTA"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["TOTA"]]$Begin)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["TOTA"]]$Signature), "mdate")
  expect_false(any(grepl("/", agreements[["TOTA"]]$Signature)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["TOTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["TOTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["TOTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["TOTA"]]$Signature)))
})

# Dataset should be ordered according to the "Begin" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["TOTA"]]$Begin[1] <
                agreements[["TOTA"]]$Begin[10])
  expect_true(agreements[["TOTA"]]$Begin[50] <
                agreements[["TOTA"]]$Begin[75])
  expect_true(agreements[["TOTA"]]$Begin[100] <
                agreements[["TOTA"]]$Begin[120])
})
