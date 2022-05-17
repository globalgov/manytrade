# Test if the dataset meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", gnevar[["GNEVAR"]])))
  expect_false(any(grepl("^N/A$", gnevar[["GNEVAR"]])))
  expect_false(any(grepl("^\\s$", gnevar[["GNEVAR"]])))
  expect_false(any(grepl("^\\.$", gnevar[["GNEVAR"]])))
  expect_false(any(grepl("N\\.A\\.$", gnevar[["GNEVAR"]])))
  expect_false(any(grepl("n\\.a\\.$", gnevar[["GNEVAR"]])))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(gnevar[["GNEVAR"]])))
  expect_false(any(lubridate::is.POSIXct(gnevar[["GNEVAR"]])))
  expect_false(any(lubridate::is.POSIXlt(gnevar[["GNEVAR"]])))
})
