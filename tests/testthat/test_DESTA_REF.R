# Test if  meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", references[["DESTA_REF"]])))
  expect_false(any(grepl("^N/A$", references[["DESTA_REF"]])))
  expect_false(any(grepl("^\\s$", references[["DESTA_REF"]])))
  expect_false(any(grepl("^\\.$", references[["DESTA_REF"]])))
  expect_false(any(grepl("N\\.A\\.$", references[["DESTA_REF"]])))
  expect_false(any(grepl("n\\.a\\.$", references[["DESTA_REF"]])))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(references[["DESTA_REF"]])))
  expect_false(any(lubridate::is.POSIXct(references[["DESTA_REF"]])))
  expect_false(any(lubridate::is.POSIXlt(references[["DESTA_REF"]])))
})
