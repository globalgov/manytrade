# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", agreements[["DESTA"]])))
  expect_false(any(grepl("^N/A$", agreements[["DESTA"]])))
  expect_false(any(grepl("^\\s$", agreements[["DESTA"]])))
  expect_false(any(grepl("^\\.$", agreements[["DESTA"]])))
  expect_false(any(grepl("N\\.A\\.$", agreements[["DESTA"]])))
  expect_false(any(grepl("n\\.a\\.$", agreements[["DESTA"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  pointblank::expect_col_exists(agreements[["DESTA"]],
                                pointblank::vars(Title))
  pointblank::expect_col_exists(agreements[["DESTA"]],
                                pointblank::vars(Begin))
  expect_true(any(grepl("ID$", colnames(agreements[["DESTA"]]))))
  pointblank::expect_col_exists(agreements[["DESTA"]],
                                pointblank::vars(Signature))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["DESTA"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["DESTA"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["DESTA"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["DESTA"]]$Begin), "mdate")
  expect_false(any(grepl("/", agreements[["DESTA"]]$Begin)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["DESTA"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["DESTA"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["DESTA"]]$Begin)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["DESTA"]]$Begin)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["DESTA"]]$Signature), "mdate")
  expect_false(any(grepl("/", agreements[["DESTA"]]$Signature)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["DESTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["DESTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["DESTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["DESTA"]]$Signature)))
})

# Dataset should be ordered according to the "Begin" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["DESTA"]]$Begin[1] <
                agreements[["DESTA"]]$Begin[10])
  expect_true(agreements[["DESTA"]]$Begin[50] <
                agreements[["DESTA"]]$Begin[75])
  expect_true(agreements[["DESTA"]]$Begin[100] <
                agreements[["DESTA"]]$Begin[120])
})
