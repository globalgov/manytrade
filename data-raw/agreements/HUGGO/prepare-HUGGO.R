# Trade Agreements HUGGO Dataset Preparation Script

# The HUGGO dataset contains reconciled data that resolves conflicts among data
# in the DESTA, GPTAD, LABPTA, TREND, and TOTA datasets (stored in
# the agreements database).
# Agreements were matched by their manyIDs,
# and conflicts in the data were resolved for the Title, Signature, Force dates.
# End dates, or the date of termination for each agreement,
# were also added where applicable.
# For agreements that remain in force, the End date is coded as '9999-12-31'.
# For more information on coding rules, please see the GGO codebook.
# Treaty texts for the agreements listed in the database were also downloaded
# and formatted. These texts are stored in the 'TreatyTexts' folder.
# The source urls for the treaties are listed in the file 'links.csv',
# as well as in the HUGGO dataset for the agreements listed.

# Stage one: Collecting data
# Import hand-coded verified data
HUGGO_reconciled <- readr::read_csv("data-raw/agreements/HUGGO/HUGGO_reconciled.csv")
HUGGO_additional <- readr::read_csv("data-raw/agreements/HUGGO/HUGGO_additional.csv")

HUGGO <- dplyr::bind_rows(HUGGO_reconciled, HUGGO_additional)

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'HUGGO' object until the object created
# below (in stage three) passes all the tests.

# Add updated 'Begin' column
HUGGO <- HUGGO %>%
  dplyr::mutate(Begin = dplyr::coalesce(Signature, Force))

# Standardise class of date variables ('mdate')
HUGGO <- HUGGO %>%
  dplyr::mutate(Begin = messydates::as_messydate(Begin),
                Signature = messydates::as_messydate(Signature),
                Force = messydates::as_messydate(Force),
                End = messydates::as_messydate(End))

# Add new TreatyText column to mark status of collection of texts
# TreatyText: 0 = No text collected, 1 = Treaty text collected in
# 'data-raw/agreements/HUGGO/TreatyTexts' folder
HUGGO$TreatyText <- 0
HUGGO$TreatyText[is.na(HUGGO$No_source)] <- 1

# Add treatyID and manyID for new entries
HUGGO$treatyID <- manypkgs::code_agreements(HUGGO, HUGGO$Title, HUGGO$Begin)
manyID <- manypkgs::condense_agreements(manytrade::agreements)
HUGGO <- dplyr::left_join(HUGGO, manyID, by = "treatyID")
HUGGO <- HUGGO %>%
  dplyr::mutate(manyID = ifelse(!is.na(manyID.x), manyID.x, manyID.y)) %>%
  dplyr::select(-c(manyID.x, manyID.y)) %>%
  dplyr::relocate(manyID, treatyID)

# Reorder columns and arrange observations by 'Begin' variable for export
HUGGO <- HUGGO %>%
  dplyr::select(manyID, Title, Begin, Signature, Force, End,
                url, Citation, TreatyText, treatyID, Coder) %>%
  dplyr::mutate(across(everything(),
                       ~stringr::str_replace_all(.,
                                                 "^NA$", NA_character_))) %>%
  dplyr::mutate(Begin = messydates::as_messydate(Begin),
                Signature = messydates::as_messydate(Signature),
                Force = messydates::as_messydate(Force),
                End = messydates::as_messydate(End)) %>%
  dplyr::distinct() %>%
  dplyr::arrange(Begin)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make HUGGO available
# within the manypackage.
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
# run `manypkgs::add_bib("agreements", "HUGGO")`.
manypkgs::export_data(HUGGO, datacube = "agreements",
                      URL = "Hand-coded data by the GGO team")
