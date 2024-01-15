# HUGGO_MEM Preparation Script
# This data contains handcoded membership data for trade agreements,
# which builds upon the DESTA_MEM and GPTAD_MEM datasets,
# adding state-specific dates for signature, ratification, entry into force,
# and termination of agreements, as well as making dates more precise.

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.

# Stage one: Collecting data
HUGGO_MEM <- readr::read_csv("data-raw/memberships/HUGGO_MEM/HUGGO_MEM_additional.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'HUGGO_MEM' object until the object created
# below (in stage three) passes all the tests.

# Format data correctly
HUGGO_MEM <- HUGGO_MEM %>%
  dplyr::mutate(Begin = dplyr::coalesce(Signature, Force)) %>%
  dplyr::mutate(
    stateID = ifelse(is.na(stateID),
                     manypkgs::code_states(StateName, activity = FALSE,
                                           replace = "ID"),
                     stateID),
    across(everything(),
                       ~stringr::str_replace_all(., "^NA$", NA_character_))) %>% 
  dplyr::distinct() %>%
  dplyr::mutate(Begin = messydates::as_messydate(Begin),
                Signature = messydates::as_messydate(Signature),
                Force = messydates::as_messydate(Force),
                End = messydates::as_messydate(End),
                StateRatification = messydates::as_messydate(StateRatification),
                StateSignature = messydates::as_messydate(StateSignature),
                StateForce = messydates::as_messydate(StateForce),
                StateEnd = messydates::as_messydate(StateEnd),
                Accession = messydates::as_messydate(Accession)) %>%
  dplyr::arrange(Begin)

# Add manyIDs and treatyIDs for newly added entries
HUGGO_MEM$treatyID <- manypkgs::code_agreements(HUGGO_MEM, HUGGO_MEM$Title, 
                                                HUGGO_MEM$Begin)

manyID <- manypkgs::condense_agreements(manytrade::memberships)
HUGGO_MEM <- dplyr::left_join(HUGGO_MEM, manyID, by = "treatyID") %>%
  dplyr::distinct()
HUGGO_MEM <- HUGGO_MEM %>%
  dplyr::mutate(manyID = ifelse(!is.na(manyID.x), manyID.x, manyID.y)) %>%
  dplyr::select(-c(manyID.x, manyID.y)) %>%
  dplyr::relocate(manyID, treatyID)

# Stage three: Connecting data
# Next run the following line to make HUGGO_MEM available
# within the package.
manypkgs::export_data(HUGGO_MEM, datacube = "memberships",
                      URL = "Hand-coded by the GGO team")
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
# run `manypkgs::add_bib("memberships", "HUGGO_MEM")`.
