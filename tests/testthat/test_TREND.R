# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", agreements[["TREND"]])))
  expect_false(any(grepl("^N/A$", agreements[["TREND"]])))
  expect_false(any(grepl("^\\s$", agreements[["TREND"]])))
  expect_false(any(grepl("^\\.$", agreements[["TREND"]])))
  expect_false(any(grepl("N\\.A\\.$", agreements[["TREND"]])))
  expect_false(any(grepl("n\\.a\\.$", agreements[["TREND"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  pointblank::expect_col_exists(agreements[["TREND"]],
                                pointblank::vars(Title))
  pointblank::expect_col_exists(agreements[["TREND"]],
                                pointblank::vars(Begin))
  expect_true(any(grepl("ID$", colnames(agreements[["TREND"]]))))
  pointblank::expect_col_exists(agreements[["TREND"]],
                                pointblank::vars(Signature))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["TREND"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["TREND"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["TREND"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["TREND"]]$Begin), "mdate")
  expect_false(any(grepl("/", agreements[["TREND"]]$Begin)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["TREND"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["TREND"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["TREND"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["TREND"]]$Begin)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["TREND"]]$Signature), "mdate")
  expect_false(any(grepl("/", agreements[["TREND"]]$Signature)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["TREND"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["TREND"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["TREND"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["TREND"]]$Signature)))
})

# Dataset should be ordered according to the "Begin" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["TREND"]]$Begin[1] <
                agreements[["TREND"]]$Begin[10])
  expect_true(agreements[["TREND"]]$Begin[50] <
                agreements[["TREND"]]$Begin[75])
  expect_true(agreements[["TREND"]]$Begin[100] <
                agreements[["TREND"]]$Begin[120])
})
