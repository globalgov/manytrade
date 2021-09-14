# LABPTA Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the qPackage.

# Stage one: Collecting data
LABPTA <- readr::read_csv("data-raw/agreements/LABPTA/LABPTA.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'LABPTA' object until the object created
# below (in stage three) passes all the tests.
LABPTA <- as_tibble(LABPTA) %>%
  qData::transmutate(ID = `Number`,
                     Title = qCreate::standardise_titles(Name),
                     Signature = qCreate::standardise_dates(as.character(year)),
                     Force = qCreate::standardise_dates(as.character(year))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>% 
  dplyr::arrange(Beg)

# Add qID column
LABPTA$qID <- qCreate::code_agreements(LABPTA, LABPTA$Title, LABPTA$Beg)

# qCreate includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make LABPTA available
# within the qPackage.
qCreate::export_data(LABPTA, database = "agreements")
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
