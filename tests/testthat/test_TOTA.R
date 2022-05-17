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
  pointblank::expect_col_exists(agreements[["TOTA"]], pointblank::vars(Title))
  pointblank::expect_col_exists(agreements[["TOTA"]], pointblank::vars(Beg))
  expect_true(any(grepl("ID$", colnames(agreements[["TOTA"]]))))
  pointblank::expect_col_exists(agreements[["TOTA"]], 
                                pointblank::vars(Signature))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["TOTA"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["TOTA"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["TOTA"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["TOTA"]]$Beg), "messydt")
  expect_false(any(grepl("/", agreements[["TOTA"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["TOTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["TOTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["TOTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["TOTA"]]$Beg)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["TOTA"]]$Signature), "messydt")
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

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["TOTA"]]$Beg[1] <
                agreements[["TOTA"]]$Beg[10])
  expect_true(agreements[["TOTA"]]$Beg[50] <
                agreements[["TOTA"]]$Beg[75])
  expect_true(agreements[["TOTA"]]$Beg[100] <
                agreements[["TOTA"]]$Beg[120])
})
