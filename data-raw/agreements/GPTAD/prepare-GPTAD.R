# GPTAD Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many package.
library(manypkgs)

# Stage one: Collecting data
GPTAD <- read.csv("data-raw/agreements/GPTAD/GPTAD.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'GPTAD' object until the object created
# below (in stage three) passes all the tests.
GPTAD <- tibble::as_tibble(GPTAD) %>%
  dplyr::mutate(gptadID = as.character(dplyr::row_number())) %>%
  dplyr::filter(Type != "Customs Union Accession Agreement" ) %>%
  #removing entries relating to membership as
  # membership changes will be logged in memberships datacube
  dplyr::mutate(DocType = dplyr::recode(`Type`,
                                        "Association Free Trade Agreement" = "P",
                                        "Bilateral Free Trade Agreement"= "B",
                                        "Customs Union Primary Agreement"="P", 
                                        "Regional/Plurilateral Free Trade Agreement"="P",
                                        "Framework Agreement" = "M")) %>%
  dplyr::mutate(AgreementType = dplyr::recode(`Type`,
                                              "Association Free Trade Agreement" = "A",
                                              "Bilateral Free Trade Agreement"= "A",
                                              "Customs Union Primary Agreement"="A",
                                              "Regional/Plurilateral Free Trade Agreement"="A",
                                              "Framework Agreement" = "A")) %>%
  dplyr::mutate(GeogArea = dplyr::recode(`Type`,
                                         "Association Free Trade Agreement" = "NA",
                                         "Bilateral Free Trade Agreement" = "L",
                                         "Customs Union Primary Agreement" = "NA",
                                         "Regional/Plurilateral Free Trade Agreement" = "R",
                                         "Framework Agreement" = "NA")) %>%
  dplyr::mutate(GeogArea = ifelse(GeogArea == "NA", NA, GeogArea)) %>%
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a",
                                             NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A",
                                                    NA, `Date.of.Entry.into.Force`)) %>%
  manydata::transmutate(Title = manypkgs::standardise_titles(`Common.Name`),
                     Signature = messydates::as_messydate(`Date.of.Signature`),
                     Force = messydates::as_messydate(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Begin = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(gptadID, Title, Begin, Signature, Force, AgreementType, DocType,
                GeogArea) %>%
  dplyr::arrange(Begin)

# Add treatyID column
GPTAD$treatyID <- manypkgs::code_agreements(GPTAD, GPTAD$Title, GPTAD$Begin)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::agreements)
GPTAD <- dplyr::left_join(GPTAD, manyID, by = "treatyID")

# Re-order the columns
GPTAD <- GPTAD %>%
  dplyr::select(manyID, Title, Begin, AgreementType, DocType, GeogArea,
                Signature, Force, treatyID, gptadID) %>% 
  dplyr::arrange(Begin)

# Check for duplicates in manyID
# duplicates <- GPTAD %>%
#   dplyr::mutate(duplicates = duplicated(GPTAD[, 1])) %>%
#   dplyr::relocate(manyID, duplicates)

# delete rows that only have diff title but same Beg and other variables
GPTAD <- subset(GPTAD, subset = !duplicated(GPTAD[, c(1,3,4,9)]))

# manydata includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GPTAD available
# within the many universe.
manypkgs::export_data(GPTAD, datacube = "agreements",
                      URL="https://wits.worldbank.org/gptad/library.aspx")
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence
# to certain standards.You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows)
# to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and may require
# you to return to stage two and further clean, standardise, or wrangle
# your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please make sure that you cite any sources appropriately and fill in as
# much detail about the variables etc as possible.
