# Test if  meets the many universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", agreements[["LABPTA"]])))
  expect_false(any(grepl("^N/A$", agreements[["LABPTA"]])))
  expect_false(any(grepl("^\\s$", agreements[["LABPTA"]])))
  expect_false(any(grepl("^\\.$", agreements[["LABPTA"]])))
  expect_false(any(grepl("N\\.A\\.$", agreements[["LABPTA"]])))
  expect_false(any(grepl("n\\.a\\.$", agreements[["LABPTA"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  expect_col_exists(agreements[["LABPTA"]], vars(Title))
  expect_col_exists(agreements[["LABPTA"]], vars(Beg))
  expect_true(any(grepl("ID$", colnames(agreements[["LABPTA"]]))))
  expect_col_exists(agreements[["LABPTA"]], vars(Signature))
  expect_col_exists(agreements[["LABPTA"]], vars(Force))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["LABPTA"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["LABPTA"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["LABPTA"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["LABPTA"]]$Beg), "messydt")
  expect_false(any(grepl("/", agreements[["LABPTA"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["LABPTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["LABPTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["LABPTA"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["LABPTA"]]$Beg)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["LABPTA"]]$Signature), "messydt")
  expect_false(any(grepl("/", agreements[["LABPTA"]]$Signature)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["LABPTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["LABPTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["LABPTA"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["LABPTA"]]$Signature)))
})

test_that("Column `Force` has standardised dates", {
  expect_equal(class(agreements[["LABPTA"]]$Force), "messydt")
  expect_false(any(grepl("/", agreements[["LABPTA"]]$Force)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["LABPTA"]]$Force)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["LABPTA"]]$Force)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["LABPTA"]]$Force)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["LABPTA"]]$Force)))
})

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["LABPTA"]]$Beg[1] <
                agreements[["LABPTA"]]$Beg[10])
  expect_true(agreements[["LABPTA"]]$Beg[50] <
                agreements[["LABPTA"]]$Beg[75])
  expect_true(agreements[["LABPTA"]]$Beg[100] <
                agreements[["LABPTA"]]$Beg[120])
})
