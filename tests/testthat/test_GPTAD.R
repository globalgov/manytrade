# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", agreements[["GPTAD"]])))
  expect_false(any(grepl("^N/A$", agreements[["GPTAD"]])))
  expect_false(any(grepl("^\\s$", agreements[["GPTAD"]])))
  expect_false(any(grepl("^\\.$", agreements[["GPTAD"]])))
  expect_false(any(grepl("N\\.A\\.$", agreements[["GPTAD"]])))
  expect_false(any(grepl("n\\.a\\.$", agreements[["GPTAD"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  pointblank::expect_col_exists(agreements[["GPTAD"]],
                                pointblank::vars(Title))
  pointblank::expect_col_exists(agreements[["GPTAD"]],
                                pointblank::vars(Beg))
  expect_true(any(grepl("ID$", colnames(agreements[["GPTAD"]]))))
  pointblank::expect_col_exists(agreements[["GPTAD"]],
                                pointblank::vars(Signature))
})

# Date columns should be in mdate class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(agreements[["GPTAD"]])))
  expect_false(any(lubridate::is.POSIXct(agreements[["GPTAD"]])))
  expect_false(any(lubridate::is.POSIXlt(agreements[["GPTAD"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(agreements[["GPTAD"]]$Beg), "mdate")
  expect_false(any(grepl("/", agreements[["GPTAD"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["GPTAD"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["GPTAD"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["GPTAD"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["GPTAD"]]$Beg)))
})

test_that("Column `Signature` has standardised dates", {
  expect_equal(class(agreements[["GPTAD"]]$Signature), "mdate")
  expect_false(any(grepl("/", agreements[["GPTAD"]]$Signature)))
  expect_false(any(grepl("^[:alpha:]$",
                         agreements[["GPTAD"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         agreements[["GPTAD"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         agreements[["GPTAD"]]$Signature)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         agreements[["GPTAD"]]$Signature)))
})

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by date variable", {
  expect_true(agreements[["GPTAD"]]$Beg[1] <
                agreements[["GPTAD"]]$Beg[10])
  expect_true(agreements[["GPTAD"]]$Beg[50] <
                agreements[["GPTAD"]]$Beg[75])
  expect_true(agreements[["GPTAD"]]$Beg[100] <
                agreements[["GPTAD"]]$Beg[120])
})
