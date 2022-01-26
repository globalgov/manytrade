# Test if  meets the many packages universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("^N/A$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("^\\s$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("^\\.$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("N\\.A\\.$", memberships[["DESTA_MEM"]])))
  expect_false(any(grepl("n\\.a\\.$", memberships[["DESTA_MEM"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  expect_col_exists(memberships[["DESTA_MEM"]], c("Beg", ".*ID$"))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(memberships[["DESTA_MEM"]])))
  expect_false(any(lubridate::is.POSIXct(memberships[["DESTA_MEM"]])))
  expect_false(any(lubridate::is.POSIXlt(memberships[["DESTA_MEM"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(memberships[["DESTA_MEM"]]$Beg), "messydt")
  expect_false(any(grepl("/", memberships[["DESTA_MEM"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         memberships[["DESTA_MEM"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         memberships[["DESTA_MEM"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         memberships[["DESTA_MEM"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         memberships[["DESTA_MEM"]]$Beg)))
})

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by the `Beg` variable", {
  expect_true(memberships[["DESTA_MEM"]]$Beg[1] <
                memberships[["DESTA_MEM"]]$Beg[100])
  expect_true(memberships[["DESTA_MEM"]]$Beg[120] <
                memberships[["DESTA_MEM"]]$Beg[220])
  expect_true(memberships[["DESTA_MEM"]]$Beg[250] <
                memberships[["DESTA_MEM"]]$Beg[350])
})
