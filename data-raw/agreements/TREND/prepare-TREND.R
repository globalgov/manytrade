# TREND Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the qPackage.

# Stage one: Collecting data
TREND <- readxl::read_excel("data-raw/agreements/TREND/trend_2_public_version.xlsx", 
                            sheet = "trend (public version)")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'TREND' object until the object created
# below (in stage three) passes all the tests.
TREND <- as_tibble(TREND) %>%
  tidyr::separate(Trade.Agreement, into= c("TREND_ID", "Title", "year1"), sep="_") %>%
  tidyr::separate(TREND_ID, into=c("TREND_ID", "T1", "T2"), sep=" ") %>%
  tidyr::unite(col="Title", c("T1", "T2", "Title", "year1"), na.rm=T) %>%
  qData::transmutate(Signature=qCreate::standardise_dates(as.character(Year)),
                     Force = qCreate::standardise_dates(as.character(Year))) %>%                                     
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>% 
  dplyr::arrange(Beg)

# Add qID column

# qCreate includes several functions that should help cleaning and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make TREND available within the qPackage.
qCreate::export_data(TREND, database = "agreements", URL = "http://www.chaire-epi.ulaval.ca/en/trend", package = "qTrade")
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
# Please make sure that you cite any sources appropriately and fill in as much detail
# about the variables etc as possible.
