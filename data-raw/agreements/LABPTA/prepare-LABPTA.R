# LABPTA Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.

# Stage one: Collecting data
LABPTA <- read.csv("data-raw/agreements/LABPTA/LABPTA.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'LABPTA' object until the object created
# below (in stage three) passes all the tests.
LABPTA <- as_tibble(LABPTA) %>%
  manydata::transmutate(LABPTA_ID = `Number`,
                     Title = manypkgs::standardise_titles(Name),
                     Signature = manypkgs::standardise_dates(as.character(year)),
                     Force = manypkgs::standardise_dates(as.character(year))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>% 
  dplyr::select(LABPTA_ID, Title, Beg, Signature, Force) %>% 
  dplyr::arrange(Beg)

# Add treaty_ID column
LABPTA$treaty_ID <- manypkgs::code_agreements(LABPTA, LABPTA$Title, LABPTA$Beg)

# Add many_ID column
many_ID <- manypkgs::condense_agreements(manytrade::agreements, var = c(DESTA$treaty_ID, GPTAD$treaty_ID,
                                                                        LABPTA$treaty_ID, TREND$treaty_ID))
LABPTA<- dplyr::left_join(LABPTA, many_ID, by = "treaty_ID")

# Re-order the columns
LABPTA <- LABPTA %>% 
  dplyr::select(many_ID, Title, Beg, Signature, Force, treaty_ID, LABPTA_ID) %>% 
  dplyr::arrange(Beg)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make LABPTA available
# within the many packages universe.
manypkgs::export_data(LABPTA, database = "agreements", URL = "https://doi.org/10.1007/s11558-018-9301-z")
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
