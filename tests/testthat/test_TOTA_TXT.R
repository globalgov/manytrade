# Test if the dataset meets the many packages universe requirements
# Test that certain columns exist
test_that("datasets have the required variables", {
  expect_col_exists(texts[["TOTA_TXT"]], vars(Title))
  expect_col_exists(texts[["TOTA_TXT"]], vars(Beg))
  expect_true(any(grepl("ID$", colnames(texts[["TOTA_TXT"]]))))
  expect_col_exists(texts[["TOTA_TXT"]], vars(TreatyText))
})

# Date columns should be in messydt class
test_that("Columns are not in date, POSIXct or POSIXlt class", {
  expect_false(any(lubridate::is.Date(texts[["TOTA_TXT"]]$Beg)))
  expect_false(any(lubridate::is.POSIXct(texts[["TOTA_TXT"]]$Beg)))
  expect_false(any(lubridate::is.POSIXlt(texts[["TOTA_TXT"]]$Beg)))
})
