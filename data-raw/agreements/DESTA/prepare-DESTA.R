# DESTA Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.
library(manypkgs)

# Stage one: Collecting data
DESTA <- readxl::read_excel("data-raw/agreements/DESTA/DESTA.xlsx")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA' object until the object created
# below (in stage three) passes all the tests.
DESTA <- as_tibble(DESTA) %>%
  dplyr::filter(typememb != "5" , typememb != "6",  typememb != "7", entry_type != "accession", entry_type != "withdrawal") %>%
  #categories removed because they relate to changes in membership that are reflected in the memberships database
  dplyr::rename("L" = "typememb", "D" = "entry_type") %>%
  dplyr::mutate(L = dplyr::recode(L, "1" = "B", "2"= "P", "3"="P+3", "4"="PP")) %>%
  dplyr::mutate(D = dplyr::recode(D, "base_treaty" = "A", "protocol or amendment" = "P/E", "consolidated" = "P/E", "negotiation" = "A")) %>%
  dplyr::rename("WTO" = "wto_listed", "J" = "regioncon") %>%
  dplyr::mutate(`WTO` = dplyr::recode(`WTO`, "0" = "N", "1" = "Y")) %>%
  dplyr::mutate(J = dplyr::recode(J, "Intercontinental" = "G", "Asia" = "R", "Africa" = "R", "Americas" = "R", "Europe" = "R", "Oceania" = "R")) %>%
  manydata::transmutate(DESTA_ID = `base_treaty`,
                     Title = manypkgs::standardise_titles(name)) %>%
  dplyr::mutate(beg = dplyr::coalesce(year, entryforceyear)) %>%
  dplyr::arrange(beg) %>%
  manydata::transmutate(Beg = manypkgs::standardise_dates(as.character(beg)),
                     Signature = manypkgs::standardise_dates(as.character(year)),
                     Force = manypkgs::standardise_dates(as.character(entryforceyear))) %>%
  dplyr::select(DESTA_ID, Title, Beg, Signature, Force, D, L, J, WTO)
  

# Add qID column
DESTA$qID <- manypkgs::code_agreements(DESTA, DESTA$Title, DESTA$Beg) # 30 duplicated IDs mostly from consolidated version/amendments of treaty

# Add qID_ref column
qID_ref <- manypkgs::condense_qID(manytrade::agreements)
DESTA <- dplyr::left_join(DESTA, qID_ref, by = "qID")

# Re-order the columns
DESTA <- DESTA %>% 
  dplyr::select(qID_ref, Title, Beg, D, L, J, Signature, Force, qID, DESTA_ID, WTO) %>% 
  dplyr::arrange(Beg)

# add missing dates


# manypkgs includes several functions that should help cleaning and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA available within the many packages universe.
manypkgs::export_data(DESTA, database = "agreements", URL = "https://www.designoftradeagreements.org/downloads/")
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence to certain standards.
# You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows) to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and may require you to return 
# to stage two and further clean, standardise, or wrangle your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please note that the export_data() function requires a .bib file to be
# present in the data_raw folder of the package for citation purposes.
# Therefore, please make sure that you have permission to use the dataset
# that you're including in the package.
# Please make sure that you cite any sources appropriately and fill in as much detail
# about the variables etc as possible.
