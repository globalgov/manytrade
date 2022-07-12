# DESTA_MEM Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many universe.

# Stage one: Collecting data
# Note that the original data (in excel format) has been converted and saved as
# a csv file with the same variables and data.
DESTA_MEM <- read.csv2("data-raw/memberships/DESTA_MEM/DESTA_MEM.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA_MEM' object until the object created
# below (in stage three) passes all the tests.
DESTA_MEM <- tibble::as_tibble(DESTA_MEM) %>%
  tidyr::pivot_longer(c("c1":"c91"), names_to = "Member", values_to = "stateID", 
                      values_drop_na = TRUE) %>%
  #arrange columns containing countries into one column, with each stateID in rows corresponding to the treaty it is party to
  manydata::transmutate(destaID = as.character(`base_treaty`),
                        Title = manypkgs::standardise_titles(name),
                        Signature = messydates::as_messydate(as.character(year)),
                        Force = messydates::as_messydate(as.character(entryforceyear))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(destaID, stateID, Title, Beg, Signature, Force) %>%
  dplyr::arrange(Beg)

DESTA_MEM$StateName <- countrycode::countrycode(DESTA_MEM$stateID, 
                                                  origin = "iso3n", destination = "country.name")
DESTA_MEM <- DESTA_MEM %>%
  dplyr::mutate(StateName = ifelse(stateID == 530, "Netherlands Antilles", StateName)) %>%
  dplyr::mutate(StateName = ifelse(stateID == 900, "Kosovo", StateName))

#Change iso numeric to iso character code
DESTA_MEM$stateID <- countrycode::countrycode(DESTA_MEM$stateID, origin = "iso3n", destination = "iso3c")

#Add a treatyID column
DESTA_MEM$treatyID <- manypkgs::code_agreements(DESTA_MEM, DESTA_MEM$Title, 
                                                DESTA_MEM$Beg)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::memberships,
                                        var = c(DESTA_MEM$treatyID, 
                                                GPTAD_MEM$treatyID))
DESTA_MEM <- dplyr::left_join(DESTA_MEM, manyID, by = "treatyID")

# Re-order the columns
DESTA_MEM <- dplyr::relocate(DESTA_MEM, manyID, stateID, Title, Beg, 
                             Signature, Force, StateName, destaID)

# Check for duplicates in manyID
# duplicates <- DESTA_MEM %>%
#   dplyr::mutate(duplicates = duplicated(DESTA_MEM[, c(1,2)])) %>%
#   dplyr::relocate(manyID, stateID,  duplicates)

# delete rows that only have diff title but same Beg and other variables
DESTA_MEM <- subset(DESTA_MEM, subset = !duplicated(DESTA_MEM[, c(1,2,4,7,9)]))


# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA_MEM available
# within the many universe.
manypkgs::export_data(DESTA_MEM, database = "memberships",
                     URL = "https://www.designoftradeagreements.org/downloads/")
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
# To add a template of .bib file to package,
# run `manypkgs::add_bib(memberships, DESTA_MEM)`.

