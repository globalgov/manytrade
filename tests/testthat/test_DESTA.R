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
  pointblank::expect_col_exists(agreements[["DESTA"]], pointblank::vars(Title))
  pointblank::expect_col_exists(agreements[["DESTA"]], pointblank::vars(Beg))
  expect_true(any(grepl("ID$", colnames(agreements[["DESTA"]]))))
  pointblank::expect_col_exists(agreements[["DESTA"]], pointblank::vars(Signature))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["DESTA"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["DESTA"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["DESTA"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["DESTA"]]$Beg), "messydt")
  expect_false(any(grepl("/", agreements[["DESTA"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["DESTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["DESTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["DESTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["DESTA"]]$Beg)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["DESTA"]]$Signature), "messydt")
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

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["DESTA"]]$Beg[1] <
                agreements[["DESTA"]]$Beg[10])
  expect_true(agreements[["DESTA"]]$Beg[50] <
                agreements[["DESTA"]]$Beg[75])
  expect_true(agreements[["DESTA"]]$Beg[100] <
                agreements[["DESTA"]]$Beg[120])
})
