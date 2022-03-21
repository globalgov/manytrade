# DESTA Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many universe.
library(manypkgs)

# Stage one: Collecting data
DESTA <- readxl::read_excel("data-raw/agreements/DESTA/DESTA.xlsx")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA' object until the object created
# below (in stage three) passes all the tests.
DESTA <- as_tibble(DESTA) %>%
  dplyr::filter(typememb != "5", typememb != "6",  typememb != "7", 
                entry_type != "accession", entry_type != "withdrawal") %>%
  #categories removed because they relate to changes in membership that are 
  #reflected in the memberships database
  dplyr::rename("DocType" = "typememb", "AgreementType" = "entry_type") %>%
  dplyr::mutate(DocType = dplyr::recode(DocType, "1" = "B", "2"= "P", "3"="P", "4"="M")) %>%
  dplyr::mutate(AgreementType = dplyr::recode(AgreementType, "base_treaty" = "A", 
                                              "protocol or amendment" = "P/E", 
                                              "consolidated" = "P/E", 
                                              "negotiation" = "A")) %>%
  dplyr::rename("GeogArea" = "regioncon") %>%
  dplyr::mutate(GeogArea = dplyr::recode(GeogArea, "Intercontinental" = "G", 
                                         "Asia" = "R", "Africa" = "R", 
                                         "Americas" = "R", "Europe" = "R",
                                         "Oceania" = "R")) %>%
  manydata::transmutate(destaID = as.character(`base_treaty`),
                        Title = manypkgs::standardise_titles(name)) %>%
  dplyr::mutate(beg = dplyr::coalesce(year, entryforceyear)) %>%
  dplyr::arrange(beg) %>%
  # standardise date formats across agreements database
  dplyr::mutate(beg = ifelse(beg == "NA", "NA", paste0(beg, "-01-01"))) %>%
  dplyr::mutate(year = ifelse(year == "NA", "NA", paste0(year, "-01-01"))) %>%
  dplyr::mutate(entryforceyear = ifelse(entryforceyear == "NA", "NA", paste0(entryforceyear, "-01-01"))) %>%
  manydata::transmutate(Beg = manypkgs::standardise_dates(as.character(beg)),
                        Signature = manypkgs::standardise_dates(as.character(year)),
                        Force = manypkgs::standardise_dates(as.character(entryforceyear))) %>%
  dplyr::select(destaID, Title, Beg, Signature, Force, AgreementType, DocType, 
                GeogArea)

# Add treatyID column
DESTA$treatyID <- manypkgs::code_agreements(DESTA, DESTA$Title, DESTA$Beg) # 30 duplicated IDs mostly from consolidated version/amendments of treaty

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::agreements,
                                        var=c(DESTA$treatyID, 
                                              GPTAD$treatyID,
                                              LABPTA$treatyID, 
                                              TREND$treatyID))

DESTA <- dplyr::left_join(DESTA, manyID, by = "treatyID")

# Re-order the columns
DESTA <- DESTA %>% 
  dplyr::select(manyID, Title, Beg, AgreementType, DocType, GeogArea, Signature, 
                Force, treatyID, destaID) %>% 
  dplyr::arrange(Beg)

# Check for duplicates in manyID
# duplicates <- DESTA %>%
#   dplyr::mutate(duplicates = duplicated(DESTA[, 1])) %>%
#   dplyr::relocate(manyID, duplicates)

# delete rows that only have diff title but same Beg and other variables
DESTA <- subset(DESTA, subset = !duplicated(DESTA[, c(1,3,4,9)]))

# manypkgs includes several functions that should help cleaning and 
# standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA available within the many universe.
manypkgs::export_data(DESTA, database = "agreements", 
                      URL = "https://www.designoftradeagreements.org/downloads/")
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence to 
# certain standards.
# You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows) to run these tests 
# locally at any point.
# Any test failures should be pretty self-explanatory and may require you to 
# return to stage two and further clean, standardise, or wrangle your data into 
# the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please note that the export_data() function requires a .bib file to be
# present in the data_raw folder of the package for citation purposes.
# Therefore, please make sure that you have permission to use the dataset
# that you're including in the package.
# Please make sure that you cite any sources appropriately and fill in as much 
# detail about the variables etc as possible.
