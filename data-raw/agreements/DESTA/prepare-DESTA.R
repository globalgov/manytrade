# DESTA Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the qPackage.

# Stage one: Collecting data
DESTA <- readxl::read_excel("data-raw/agreements/DESTA/DESTA.xlsx")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA' object until the object created
# below (in stage three) passes all the tests.
DESTA <- as_tibble(DESTA) %>%
  dplyr::filter(typememb != "5" , typememb != "6",  typememb != "7", entry_type != "accession", entry_type != "withdrawal") %>%
  dplyr::rename("Document type" = "typememb", "Agreement type" = "entry_type") %>%
  dplyr::mutate(`Document type` = dplyr::recode(`Document type`, "1" = "B", "2"= "P", "3"="P+3", "4"="PP")) %>%
  dplyr::mutate(`Agreement type` = dplyr::recode(`Agreement type`, "base_treaty" = "A", "protocol or amendment" = "P/E", "consolidated" = "P/E", "negotiation" = "A")) %>%
  dplyr::rename("WTO" = "wto_listed", "Geographic area" = "regioncon") %>%
  dplyr::mutate(`WTO` = dplyr::recode(`WTO`, "0" = "N", "1" = "Y")) %>%
  dplyr::mutate(`Geographic area` = dplyr::recode(`Geographic area`, "Intercontinental" = "G", "Asia" = "R", "Africa" = "R", "Americas" = "R", "Europe" = "R", "Oceania" = "R")) %>%
  qData::transmutate(DESTA_ID = `base_treaty`,
                     Title = qCreate::standardise_titles(name),
                     Signature = qCreate::standardise_dates(as.character(year)),
                     Force = qCreate::standardise_dates(as.character(entryforceyear))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(DESTA_ID, Title, Beg, Signature, Force, `Agreement type`, `Document type`, `Geographic area`, WTO) %>% 
  dplyr::arrange(Beg)

# Add qID column
DESTA$qID <- qCreate::code_agreements(DESTA, DESTA$Title, DESTA$Beg)

# qCreate includes several functions that should help cleaning and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA available within the qPackage.
qCreate::export_data(DESTA, database = "agreements", URL = "https://www.designoftradeagreements.org/downloads/")
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
