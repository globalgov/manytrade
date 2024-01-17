# TREND Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many package.
library(manypkgs)

# Stage one: Collecting data
# Note that the original data (in excel format) has been converted and saved as
# a csv file with the same variables and data.
TREND <- read.csv2("data-raw/agreements/TREND/TREND.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'TREND' object until the object created
# below (in stage three) passes all the tests.
TREND <- tibble::as_tibble(TREND) %>%
  tidyr::separate(Trade.Agreement, into = c("trendID", "name", "year1"),
                  sep ="_") %>%
  #variable is split to generate ID for each treaty and the title of the treaty
  # as two separate variables
  tidyr::separate(trendID, into = c("trendID", "T1", "T2"), sep = " ") %>%
  #combining variables to obtain full name of treaty
  tidyr::unite(col = "name", c("T1", "T2", "name", "year1"), na.rm = TRUE) %>%
  # standardise date formats across agreements datacube
  dplyr::mutate(Year = ifelse(Year == "NA", "NA", paste0(Year, "-01-01"))) %>%
  manydata::transmutate(Title = manypkgs::standardise_titles(name),
                        Signature = messydates::as_messydate(as.character(Year)),
                        Force = messydates::as_messydate(as.character(Year))) %>%
  dplyr::mutate(Begin = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(trendID, Title, Begin, Signature, Force) %>%
  dplyr::arrange(Begin)

# Remove accession observations
TREND <- TREND %>%
  dplyr::filter(!stringr::str_detect(Title, "Accession|Enlargement"))

# Add treatyID column
TREND$treatyID <- manypkgs::code_agreements(TREND, TREND$Title, TREND$Begin)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::agreements)
TREND <- dplyr::left_join(TREND, manyID, by = "treatyID")

# Re-order the columns
TREND <- TREND %>%
  dplyr::select(manyID, Title, Begin, Signature, Force, treatyID, trendID) %>%
  dplyr::arrange(Begin)

# Check for duplicates in manyID
# duplicates <- TREND %>%
#   dplyr::mutate(duplicates = duplicated(TREND[, 1])) %>%
#   dplyr::relocate(manyID, duplicates)

# delete rows that only have diff title but same Beg and other variables
TREND <- subset(TREND, subset = !duplicated(TREND[, c(1, 3, 6)]))

# manypkgs includes several functions that should help cleaning and
# standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make TREND available within the many universe.
manypkgs::export_data(TREND, datacube = "agreements",
                      URL = "http://www.chaire-epi.ulaval.ca/en/trend")
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence
# to certain standards.You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows)
# to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and may require
# you to return to stage two and further clean, standardise, or wrangle
# your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please note that the export_data() function requires a .bib file to be
# present in the data_raw folder of the package for citation purposes.
# Therefore, please make sure that you have permission to use the dataset
# that you're including in the package.
# Please make sure that you cite any sources appropriately and fill in as much
# detail about the variables etc as possible.
