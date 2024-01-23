# GPTAD_MEM Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many package.

# Stage one: Collecting data
GPTAD_MEM <- read.csv("data-raw/memberships/GPTAD_MEM/GPTAD_MEM.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'GPTAD_MEM' object until the object created
# below (in stage three) passes all the tests.
library(dplyr)
GPTAD_MEM <- tibble::as_tibble(GPTAD_MEM) %>%
  dplyr::mutate(gptadID = as.character(dplyr::row_number())) %>%
  dplyr::mutate(StateName = gsub("\\\\r\\\\n", "", Membership)) %>%
  #remove \r\n line break entries
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "China (Taiwan), Nicaragua",
                                                 "Taiwan, Nicaragua")) %>%
  #standardize delimitation of values by commas
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "St. Kitts-Nevis-Anguilla",
                                                 "Saint Kitts and Nevis, Anguilla")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Singapore - Korea",
                                                 "Singapore, Korea")) %>%
  dplyr::mutate(StateName = gsub("[()]", ",", StateName)) %>%
  dplyr::mutate(StateName = gsub("[;]", ",", StateName)) %>%
  dplyr::mutate(StateName = gsub("[.]", "", StateName)) %>%
  #add comma between country names
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Thailand Vietnam",
                                                 "Thailand, Vietnam")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Finland France",
                                                 "Finland, France")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Paraguay and Uruguay",
                                                 "Paraguay, Uruguay")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Russian Federation and Ukraine",
                                                 "Russian Federation, Ukraine")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Slovak Republic and Slovenia",
                                                 "Slovak Republic, Slovenia")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Spain Sweden",
                                                 "Spain, Sweden")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Ukraine and Uzbekistan",
                                                 "Ukraine, Uzbekistan")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Uzbekistan and Ukraine",
                                                 "Ukraine, Uzbekistan")) %>%
  #remove 'and' between country names
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Suriname and Trinidad and Tobago",
                                                 "Suriname, Trinidad and Tobago")) %>%
  dplyr::mutate(StateName = stringr::str_replace(StateName,
                                                 "Norway and Switzerland",
                                                 "Norway, Switzerland")) %>%
  tidyr::separate_rows(StateName, sep=",") %>%
  #separate column into rows by each country
  dplyr::mutate(StateName = gsub("^and | and$", "", StateName)) %>%
  dplyr::mutate(StateName = ifelse(StateName == "", NA, StateName)) %>%
  #standardize empty rows and rows with only whitespace to NA
  dplyr::mutate(StateName = ifelse(StateName == " ", NA, StateName)) %>%
  dplyr::filter(StateName != "NA") %>% #remove missing rows
  dplyr::mutate(StateName = trimws(StateName,
                                   which = c("both", "left", "right"),
                                   whitespace = "[ \t\r\n]")) %>%
  #remove whitespace
  dplyr::mutate(StateName = ifelse(StateName == "", NA, StateName)) %>%
  dplyr::filter(StateName != "NA",
                StateName != "British") %>%
  #remove empty rows and redundant 'British' in data
  dplyr::mutate(StateName = manypkgs::code_states(StateName, activity = FALSE,
                                                  replace = "names")) %>%
  #translate French country names and correct spelling
  dplyr::mutate(StateName = dplyr::recode(StateName,
                                          "EC" = "European Community")) %>%
  #not included in regex list because of overlaps with other country names
  dplyr::mutate(stateID = manypkgs::code_states(StateName, activity = FALSE,
                                                replace = "ID")) %>%
  #add iso code for country names
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a",
                                             NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A",
                                                    NA, `Date.of.Entry.into.Force`)) %>%
  manydata::transmutate(Title = manypkgs::standardise_titles(`Common.Name`),
                        Signature = messydates::as_messydate(`Date.of.Signature`),
                        Force = messydates::as_messydate(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Begin = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(gptadID, stateID, StateName, Title, Begin, Signature, Force) %>%
  dplyr::arrange(Begin) %>%
  dplyr::distinct()

#Add treatyID column
GPTAD_MEM$treatyID <- manypkgs::code_agreements(GPTAD_MEM, GPTAD_MEM$Title, 
                                                GPTAD_MEM$Begin)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::memberships)
GPTAD_MEM <- dplyr::left_join(GPTAD_MEM, manyID, by = "treatyID") %>%
  dplyr::distinct()

# Re-order the columns
GPTAD_MEM <- dplyr::relocate(GPTAD_MEM, manyID, stateID, Title, Begin,
                             Signature, Force, StateName, gptadID)

# Check for duplicates in manyID
# duplicates <- GPTAD_MEM %>%
#   dplyr::mutate(duplicates = duplicated(GPTAD_MEM[, c(1,2)])) %>%
#   dplyr::relocate(manyID, stateID,  duplicates)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GPTAD_MEM available
# within the many universe.
manypkgs::export_data(GPTAD_MEM, datacube = "memberships",
                      URL = "https://wits.worldbank.org/gptad/library.aspx")
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
