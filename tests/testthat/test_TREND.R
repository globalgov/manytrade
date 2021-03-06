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
                                pointblank::vars(Beg))
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
  expect_equal(class(agreements[["TREND"]]$Beg), "mdate")
  expect_false(any(grepl("/", agreements[["TREND"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["TREND"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["TREND"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["TREND"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["TREND"]]$Beg)))
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

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["TREND"]]$Beg[1] <
                agreements[["TREND"]]$Beg[10])
  expect_true(agreements[["TREND"]]$Beg[50] <
                agreements[["TREND"]]$Beg[75])
  expect_true(agreements[["TREND"]]$Beg[100] <
                agreements[["TREND"]]$Beg[120])
})
