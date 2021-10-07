# GPTAD Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the qPackage.
library(qCreate)

# Stage one: Collecting data
GPTAD <- read.csv("data-raw/agreements/GPTAD/GPTAD.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'GPTAD' object until the object created
# below (in stage three) passes all the tests.
GPTAD <- as_tibble(GPTAD) %>%
  dplyr::filter(Type != "Customs Union Accession Agreement" ) %>% #removing entries relating to membership as membership changes will be logged in memberships database
  dplyr::mutate(GPTAD_ID = dplyr::row_number()) %>%
  dplyr::mutate(L = dplyr::recode(`Type`, "Association Free Trade Agreement" = "P", "Bilateral Free Trade Agreement"= "B", "Customs Union Primary Agreement"="P", "Regional/Plurilateral Free Trade Agreement"="R/P", "Framework Agreement" = "M")) %>%
  dplyr::mutate(D = dplyr::recode(`Type`, "Association Free Trade Agreement" = "A", "Bilateral Free Trade Agreement"= "A", "Customs Union Primary Agreement"="A", "Regional/Plurilateral Free Trade Agreement"="A", "Framework Agreement" = "A")) %>%
  dplyr::mutate(WTO = dplyr::recode(`WTO.notified`, "no" = "N", "yes" = "Y")) %>%
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a", NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A", NA, `Date.of.Entry.into.Force`)) %>%
  qData::transmutate(Title = qCreate::standardise_titles(`Common.Name`),
                     Signature = qCreate::standardise_dates(`Date.of.Signature`),
                     Force = qCreate::standardise_dates(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(GPTAD_ID, Title, Beg, Signature, Force, D, L, WTO) %>% 
  dplyr::arrange(Beg)

# Add qID column
GPTAD$qID <- qCreate::code_agreements(GPTAD, GPTAD$Title, GPTAD$Beg)

# qData includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GPTAD available
# within the qPackage.
qCreate::export_data(GPTAD, database = "agreements", URL="https://wits.worldbank.org/gptad/library.aspx")
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence
# to certain standards.You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows)
# to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and may require
# you to return to stage two and further clean, standardise, or wrangle
# your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please make sure that you cite any sources appropriately and fill in as
# much detail about the variables etc as possible.
