# Test if  meets the many universe requirements

# Report missing values
test_that("missing observations are reported correctly", {
  expect_false(any(grepl("^n/a$", memberships[["GPTAD_MEM"]])))
  expect_false(any(grepl("^N/A$", memberships[["GPTAD_MEM"]])))
  expect_false(any(grepl("^\\s$", memberships[["GPTAD_MEM"]])))
  expect_false(any(grepl("^\\.$", memberships[["GPTAD_MEM"]])))
  expect_false(any(grepl("N\\.A\\.$", memberships[["GPTAD_MEM"]])))
  expect_false(any(grepl("n\\.a\\.$", memberships[["GPTAD_MEM"]])))
})

# Uniformity tests (agreements have a source ID, a string title, a signature and
# entry into force date)
test_that("datasets have the required variables", {
  expect_col_exists(memberships[["GPTAD_MEM"]], vars(Country))
  expect_col_exists(memberships[["GPTAD_MEM"]], vars(Beg))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(memberships[["GPTAD_MEM"]])))
  expect_false(any(lubridate::is.POSIXct(memberships[["GPTAD_MEM"]])))
  expect_false(any(lubridate::is.POSIXlt(memberships[["GPTAD_MEM"]])))
})

# Dates are standardized for mandatory column
test_that("Column `Beg` has standardised dates", {
  expect_equal(class(memberships[["GPTAD_MEM"]]$Beg), "messydt")
  expect_false(any(grepl("/", memberships[["GPTAD_MEM"]]$Beg)))
  expect_false(any(grepl("^[:alpha:]$",
                         memberships[["GPTAD_MEM"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{2}$",
                         memberships[["GPTAD_MEM"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{3}$",
                         memberships[["GPTAD_MEM"]]$Beg)))
  expect_false(any(grepl("^[:digit:]{1}$",
                         memberships[["GPTAD_MEM"]]$Beg)))
})

# Dataset should be ordered according to the "Beg" column
test_that("dataset is arranged by the `Beg` variable", {
  expect_true(memberships[["GPTAD_MEM"]]$Beg[1] <
                memberships[["GPTAD_MEM"]]$Beg[100])
  expect_true(memberships[["GPTAD_MEM"]]$Beg[120] <
                memberships[["GPTAD_MEM"]]$Beg[220])
  expect_true(memberships[["GPTAD_MEM"]]$Beg[250] <
                memberships[["GPTAD_MEM"]]$Beg[350])
})
