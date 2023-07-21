# DESTA_REF Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many package.

# Stage one: Collecting data
# Note that the original data (in excel format) has been converted and saved as
# a csv file with the same variables and data.
DESTA_REF <- read.csv2("data-raw/references/DESTA_REF/DESTA_REF.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA_REF' object until the object created
# below (in stage three) passes all the tests.
DESTA_REF <- as_tibble(DESTA_REF) %>%
  dplyr::select(number, base_treaty, name, entry_type, year, entryforceyear) %>%
  manydata::transmutate(destaID = as.character(`base_treaty`),
                        Title = manypkgs::standardise_titles(name)) %>%
  dplyr::mutate(beg = dplyr::coalesce(year, entryforceyear)) %>%
  dplyr::arrange(beg) %>%
  manydata::transmutate(Beg = messydates::as_messydate(as.character(beg)),
                        Signature = messydates::as_messydate(as.character(year)),
                        Force = messydates::as_messydate(as.character(entryforceyear)))

# add treatyID
DESTA_REF$treatyID <- manypkgs::code_agreements(DESTA_REF, DESTA_REF$Title,
                                                DESTA_REF$Beg)

# if entry_type = protocol or amendment:"Amends"
# if entry_type = accession, withdrawal or consolidated = "Cites"
DESTA_REF <- DESTA_REF %>%
  dplyr::rename(treatyID1 = treatyID) %>%
  dplyr::group_by(destaID) %>%
  dplyr::mutate(num_rows = sum(dplyr::n())) %>%
  dplyr::filter(num_rows > 1) %>%
  dplyr::mutate(RefType = ifelse(destaID != number & entry_type == "protocol or amendment",
                                 "Amends",
                                 ifelse(destaID != number & entry_type != "base_treaty",
                                        "Cites", NA)))

basetreaties <- DESTA_REF %>%
  dplyr::filter(entry_type == "base_treaty")

subsqtreaties <- DESTA_REF %>%
  dplyr::filter(entry_type != "base_treaty")

# Amends and Cites set
set1 <- dplyr::left_join(subsqtreaties, basetreaties, by = "destaID") %>%
  dplyr::ungroup() %>%
  dplyr::select(number.x, destaID, entry_type.x, treatyID1.x, RefType.x, treatyID1.y) %>%
  dplyr::rename(treatyID1 = treatyID1.x) %>%
  dplyr::rename(treatyID2 = treatyID1.y) %>%
  dplyr::rename(RefType = RefType.x)

treatyID2_NA <- set1 %>% # fill in treatyID2 NAs where treatyID1 agreements cite subsequent agreements instead of the original treaty
  dplyr::filter(is.na(treatyID2)) %>%
  dplyr::select(-treatyID2) %>%
  dplyr::rename(number = destaID) %>%
  dplyr::left_join(subsqtreaties, by = "number") %>%
  dplyr::select(treatyID1.x, RefType.x, treatyID1.y) %>%
  dplyr::rename(treatyID1 = treatyID1.x) %>%
  dplyr::rename(treatyID2 = treatyID1.y) %>%
  dplyr::rename(RefType = RefType.x)

set1 <- set1 %>%
  dplyr::filter(!is.na(treatyID2)) %>%
  dplyr::bind_rows(treatyID2_NA) %>%
  dplyr::select(treatyID1, RefType, treatyID2)

# Amended by and Cited by set
set2 <- set1 %>%
  dplyr::rename(treatyID2 = treatyID1, treatyID1 = treatyID2) %>%
  dplyr::mutate(RefType = recode(RefType,"Amends" = "Amended by",
                                 "Cites" = "Cited by")) %>%
  dplyr::select(treatyID1, RefType, treatyID2)

# Combine the two sets
DESTA_REF <- dplyr::bind_rows(set1, set2) %>%
  dplyr::relocate(treatyID1, treatyID2, RefType)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA_REF available
# within the many package.
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
# run `manypkgs::add_bib(references, DESTA_REF)`.
manypkgs::export_data(DESTA_REF, datacube = "references",
                     URL = "https://www.designoftradeagreements.org/downloads/")
