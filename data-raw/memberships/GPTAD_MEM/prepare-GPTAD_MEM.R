# GPTAD_MEM Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the qPackage.

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
  dplyr::mutate(Country = stringr::str_replace(Country, "Kitts-Nevis-Anguilla", "Saint Kitts and Nevis, Anguilla")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, " St. Saint Kitts Nevis", "Saint Kitts and Nevis")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "Singapore - Korea", "Singapore, Korea")) %>%
  dplyr::mutate(Country = gsub("[()]", ",", Country)) %>%
  dplyr::mutate(Country = gsub("[;]", ",", Country)) %>%
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
  dplyr::mutate(Country = stringr::str_replace(Country, "and Venezuela", "Venezuela")) %>% #remove 'and' before country name
  dplyr::mutate(Country = stringr::str_replace(Country, "and European Community", "European Community")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "and Lebanon", "Lebanon")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "and Montenegro", "Montenegro")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "and Norway", "Norway")) %>%
  dplyr::mutate(Country = stringr::str_replace(Country, "and Tunisia", "Tunisia")) %>%
  dplyr::mutate(Country = ifelse(Country == "", NA, Country)) %>% #standardize empty rows and 
  dplyr::mutate(Country = ifelse(Country == " ", NA, Country)) %>% #rows with only whitespace to NA
  dplyr::filter(Country != "NA") %>% #remove missing rows
  dplyr::mutate(Country = qCreate::standardise_titles(Country)) %>%
  dplyr::mutate(Country = dplyr::recode(Country, "Communauté européenne" = "European Community", "Lichtenstein" = "Liechtenstein", 
                                        "Virgin Islands" = "British Virgin Islands", "Yugoslavia." = "Yugoslavia", 
                                        "Micronesia" = "the Federated States of Micronesia", "EC" = "European Community",
                                        "European Communitiy" = "European Community")) %>% #corrected spelling of country and IO names
  dplyr::mutate(Country = qTrade::code_countryname(Country)) %>% #translate French country names
  dplyr::mutate(Country_ID = countrycode::countrycode(Country, origin = 'country.name', destination = 'iso3n')) %>% #add iso code for country names
  dplyr::mutate(Abbrv = qTrade::code_countryabbrv(Country)) %>% #insert abbreviation of country name
  dplyr::mutate(IO = ifelse(Country_Abbrv == "NA", Country, NA)) %>%
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a", NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A", NA, `Date.of.Entry.into.Force`)) %>%
  qData::transmutate(Title = qCreate::standardise_titles(`Common.Name`),
                     Signature = qCreate::standardise_dates(`Date.of.Signature`),
                     Force = qCreate::standardise_dates(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(Country_ID, Abbrv, Country, Title, Beg, Signature, Force) %>% 
  dplyr::arrange(Beg)
# qCreate includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GPTAD_MEM available
# within the qPackage.
qCreate::export_data(GPTAD_MEM, database = "memberships",
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
