# GPTAD_MEM Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many universe.

# Stage one: Collecting data 
GPTAD_MEM <- read.csv("data-raw/memberships/GPTAD_MEM/GPTAD.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'GPTAD_MEM' object until the object created
# below (in stage three) passes all the tests.
GPTAD_MEM <- as_tibble(GPTAD_MEM) %>%
  dplyr::mutate(gptadID = as.character(dplyr::row_number())) %>%
  dplyr::mutate(CountryName = gsub("\\\\r\\\\n", "", Membership)) %>%
  #remove \r\n line break entries
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "China (Taiwan), Nicaragua", "Taiwan, Nicaragua")) %>%
  #standardize delimitation of values by commas
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "St. Kitts-Nevis-Anguilla", "Saint Kitts and Nevis, Anguilla")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Singapore - Korea", "Singapore, Korea")) %>%
  dplyr::mutate(CountryName = gsub("[()]", ",", CountryName)) %>%
  dplyr::mutate(CountryName = gsub("[;]", ",", CountryName)) %>%
  dplyr::mutate(CountryName = gsub("[.]", "", CountryName)) %>%
  #add comma between country names
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Thailand Vietnam", "Thailand, Vietnam")) %>% 
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Finland France", "Finland, France")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Paraguay and Uruguay", "Paraguay, Uruguay")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Russian Federation and Ukraine", "Russian Federation, Ukraine")) %>% 
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Slovak Republic and Slovenia", "Slovak Republic, Slovenia")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Spain Sweden", "Spain, Sweden")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Ukraine and Uzbekistan", "Ukraine, Uzbekistan")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Uzbekistan and Ukraine", "Ukraine, Uzbekistan")) %>%
  #remove 'and' between country names
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Suriname and Trinidad and Tobago", "Suriname, Trinidad and Tobago")) %>%
  dplyr::mutate(CountryName = stringr::str_replace(CountryName, "Norway and Switzerland", "Norway, Switzerland")) %>%
  tidyr::separate_rows(CountryName, sep=",") %>%
  #separate column into rows by each country
  dplyr::mutate(CountryName = gsub("^and | and$", "", CountryName)) %>%
  dplyr::mutate(CountryName = ifelse(CountryName == "", NA, CountryName)) %>%
  #standardize empty rows and 
  dplyr::mutate(CountryName = ifelse(CountryName == " ", NA, CountryName)) %>%
  #rows with only whitespace to NA
  dplyr::filter(CountryName != "NA") %>% #remove missing rows
  dplyr::mutate(CountryName = trimws(CountryName, which = c("both", "left", "right"), 
                                 whitespace = "[ \t\r\n]")) %>%
  #remove whitespace
  dplyr::mutate(CountryName = ifelse(CountryName == "", NA, CountryName)) %>%
  dplyr::filter(CountryName != "NA",
                CountryName != "British") %>%
  #remove empty rows and redundant 'British' in data
  dplyr::mutate(CountryName = manystates::code_states(CountryName)) %>%
  #translate French country names and correct spelling
  dplyr::mutate(CountryName = dplyr::recode(CountryName, "EC" = "European Community")) %>%
  #not included in regex list because of overlaps with other country names
  dplyr::mutate(CountryID = countrycode::countrycode(CountryName, 
                                                     origin = 'country.name',
                                                     destination = 'iso3c')) %>%
  #add iso code for country names
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a", 
                                             NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A", 
                                                    NA, `Date.of.Entry.into.Force`)) %>%
  manydata::transmutate(Title = manypkgs::standardise_titles(`Common.Name`),
                     Signature = manypkgs::standardise_dates(`Date.of.Signature`),
                     Force = manypkgs::standardise_dates(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(gptadID, CountryID, CountryName, Title, Beg, Signature, Force) %>%
  dplyr::arrange(Beg)

#Add treatyID column
GPTAD_MEM$treatyID <- manypkgs::code_agreements(GPTAD_MEM, GPTAD_MEM$Title, 
                                                GPTAD_MEM$Beg)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::memberships,
                                        var = c(DESTA_MEM$treatyID, 
                                                GPTAD_MEM$treatyID))
GPTAD_MEM <- dplyr::left_join(GPTAD_MEM, manyID, by = "treatyID")

# Re-order the columns
GPTAD_MEM <- dplyr::relocate(GPTAD_MEM, manyID, CountryID, Title, Beg, 
                             Signature, Force, CountryName, gptadID)

# Check for duplicates in manyID
# duplicates <- GPTAD_MEM %>%
#   dplyr::mutate(duplicates = duplicated(GPTAD_MEM[, c(1,2)])) %>%
#   dplyr::relocate(manyID, CountryID,  duplicates)

# delete rows that only have diff title but same Beg and other variables
GPTAD_MEM <- subset(GPTAD_MEM, subset = !duplicated(GPTAD_MEM[, c(1,2,4,7,9)]))

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GPTAD_MEM available 
# within the many universe.
manypkgs::export_data(GPTAD_MEM, database = "memberships",
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
