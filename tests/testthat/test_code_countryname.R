data <- data.frame(name = c("argentine", "argentin", "Australie", "Bélarus", 
                            "ivory Coast", "ivory", "tchad", "niger", "Philippines"))

# test that name is returned only when regex matches and original name is returned otherwise
testthat::test_that("code_countryname returns name only when regex matches", {
  expect_equal(code_countryname(data$name), 
               c("Argentina", "argentin", "Australia", "Belarus", "Cote d'Ivoire", "ivory", "Chad", "Niger", "Philippines"))
})

# test that abbreviation is returned when `abbrev=TRUE`
testthat::test_that("code_countryname returns abbreviation when `abbrev=TRUE`", {
  expect_equal(code_countryname(data$name, abbrev = TRUE), 
               c("ARG", "argentin", "AUS", "BLR", "CIV", "ivory", "TCD", "NER", "PHL"))
})
