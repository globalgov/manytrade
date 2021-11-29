# GPTAD_MEM Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.

# Stage one: Collecting data 
GPTAD_MEM <- read.csv("data-raw/memberships/GPTAD_MEM/GPTAD.csv")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'GPTAD_MEM' object until the object created
# below (in stage three) passes all the tests.
GPTAD_MEM <- as_tibble(GPTAD_MEM) %>%
  dplyr::mutate(Country = gsub("\\\\r\\\\n", "", Membership)) %>% #remove \r\n line break entries
  dplyr::mutate(Country = stringr::str_replace(Country, "China (Taiwan), Nicaragua", "Taiwan, Nicaragua")) %>%
  #standardize delimitation of values by commas
  dplyr::mutate(Country = stringr::str_replace(Country, "St. Kitts-Nevis-Anguilla", "Saint Kitts and Nevis, Anguilla")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Singapore - Korea", "Singapore, Korea")) %>%
  dplyr::mutate(Country = gsub("[()]", ",", Country)) %>%
  dplyr::mutate(Country = gsub("[;]", ",", Country)) %>%
  dplyr::mutate(Country = gsub("[.]", "", Country)) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Thailand Vietnam", "Thailand, Vietnam")) %>% #add comma between country names
  dplyr::mutate(Country = stringr::str_replace(Country, "Finland France", "Finland, France")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Paraguay and Uruguay", "Paraguay, Uruguay")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Russian Federation and Ukraine", "Russian Federation, Ukraine")) %>% 
  dplyr::mutate(Country = stringr::str_replace(Country, "Slovak Republic and Slovenia", "Slovak Republic, Slovenia")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Spain Sweden", "Spain, Sweden")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Ukraine and Uzbekistan", "Ukraine, Uzbekistan")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Uzbekistan and Ukraine", "Ukraine, Uzbekistan")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Suriname and Trinidad and Tobago", "Suriname, Trinidad and Tobago")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Norway and Switzerland", "Norway, Switzerland")) %>%
  #remove 'and' between country names
  tidyr::separate_rows(Country, sep=",") %>% #separate column into rows by each country
  dplyr::mutate(Country = gsub("^and | and$", "", Country)) %>%
  dplyr::mutate(Country = ifelse(Country == "", NA, Country)) %>% #standardize empty rows and 
  dplyr::mutate(Country = ifelse(Country == " ", NA, Country)) %>% #rows with only whitespace to NA
  dplyr::filter(Country != "NA") %>% #remove missing rows
  dplyr::mutate(Country = trimws(Country, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")) %>% #remove whitespace
  dplyr::mutate(Country = ifelse(Country == "", NA, Country)) %>%
  dplyr::filter(Country != "NA",
                Country != "British") %>% #remove empty rows and redundant 'British' in data
  dplyr::mutate(Country = qTrade::code_countryname(Country)) %>% #translate French country names and correct spelling
  dplyr::mutate(Country = dplyr::recode(Country, "EC" = "European Community")) %>% #not included in regex list because of overlaps with other country names
  dplyr::mutate(Country_ID = countrycode::countrycode(Country, origin = 'country.name', destination = 'iso3n')) %>% #add iso code for country names
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a", NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A", NA, `Date.of.Entry.into.Force`)) %>%
  qData::transmutate(Title = manypkgs::standardise_titles(`Common.Name`),
                     Signature = manypkgs::standardise_dates(`Date.of.Signature`),
                     Force = manypkgs::standardise_dates(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(Country_ID, Country, Title, Beg, Signature, Force) %>% 
  dplyr::arrange(Beg)

#Add a qID column
GPTAD_MEM$qID <- manypkgs::code_agreements(GPTAD_MEM, GPTAD_MEM$Title, GPTAD_MEM$Beg) #1877 duplicated IDs

# Add qID_ref column
qID_ref <- manypkgs::condense_qID(qTrade::agreements)
GPTAD_MEM <- dplyr::left_join(GPTAD_MEM, qID_ref, by = "qID")

# Re-order the columns
GPTAD_MEM <- dplyr::relocate(GPTAD_MEM, qID_ref)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GPTAD_MEM available
# within the qPackage.
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
