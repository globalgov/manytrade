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
  dplyr::mutate(M1 = gsub("\\\\r\\\\n", "", Membership)) %>%
  dplyr::mutate(M1a = stringr::str_replace(M1, "China (Taiwan), Nicaragua", "Taiwan, Nicaragua")) %>%
  dplyr::mutate(M2 = gsub("[()]", ",", M1a)) %>%
  dplyr::mutate(M3a = gsub("[;]", ",", M2)) %>%
  dplyr::mutate(M3 = gsub("[-]", ",", M3a)) %>%
  dplyr::mutate(M4 = stringr::str_replace(M3, "Thailand Vietnam", "Thailand, Vietnam")) %>%
  dplyr::mutate(M4a = stringr::str_replace(M4, "Finland France", "Finland, France")) %>%
  dplyr::mutate(M4b = stringr::str_replace(M4a, "Norway and Switzerland", "Norway, Switzerland")) %>%
  dplyr::mutate(M4c = stringr::str_replace(M4b, "Paraguay and Uruguay", "Paraguay, Uruguay")) %>%
  dplyr::mutate(M4d = stringr::str_replace(M4c, "Russian Federation and Ukraine", "Russian Federation, Ukraine")) %>%
  dplyr::mutate(M4e = stringr::str_replace(M4d, "Slovak Republic and Slovenia", "Slovak Republic, Slovenia")) %>%
  dplyr::mutate(M4f = stringr::str_replace(M4e, "Spain Sweden", "Spain, Sweden")) %>%
  dplyr::mutate(M4g = stringr::str_replace(M4f, "Ukraine and Uzbekistan", "Ukraine, Uzbekistan")) %>%
  dplyr::mutate(M4h = stringr::str_replace(M4g, "Uzbekistan and Ukraine", "Ukraine, Uzbekistan")) %>%
  dplyr::mutate(M5 = stringr::str_replace(M4h, "Suriname and Trinidad and Tobago", "Suriname, Trinidad and Tobago")) %>%
  dplyr::mutate(M6 = stringr::str_replace(M5, "and Venezuela", "Venezuela")) %>%
  dplyr::mutate(M7 = stringr::str_replace(M6, "and European Community", "European Community")) %>%
  dplyr::mutate(M8 = stringr::str_replace(M7, "and Lebanon", "Lebanon")) %>%
  dplyr::mutate(M9 = stringr::str_replace(M8, "and Montenegro", "Montenegro")) %>%
  dplyr::mutate(M10 = stringr::str_replace(M9, "and Norway", "Norway")) %>%
  dplyr::mutate(M11 = stringr::str_replace(M10, "and Tunisia", "Tunisia")) %>%
  dplyr::mutate(M12 = stringr::str_replace(M10, "Kitts-Nevis-Anguilla", "Saint Kitts and Nevis, Anguilla")) %>%
  tidyr::separate_rows(M12, sep=",") %>%
  dplyr::mutate(M13 = trimws(M12, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")) %>%
  dplyr::mutate(M14 = ifelse(M13 == "", NA, M13)) %>%
  dplyr::filter(M14 != "NA") %>%
  dplyr::mutate(Country = dplyr::recode(M14, "Autriche" = "Austria", "Belgique" = "Belgium", "Bénin" = "Benin",
                                    "Allemagne" = "Germany", "Buglaria" = "Bulgaria", "Cameroun" = "Cameroon", 
                                    "Centrafricaine" = "Central African Republic", "Communauté européenne" = "European Community",
                                    "Danemark" = "Denmark", "Espagne" = "Spain", "Grèce" = "Greece", 
                                    "Guinée Équatoriale" = "Equitorial Guinea", "Italie" = "Italy", 
                                    "Jordon" = "Jordan", "Lichtenstein" = "Liechtenstein", 
                                    "Malte" = "Malta", "Pays" = "Netherlands", "Royaume" = "United Kingdom",
                                    "Sénégal" = "Senegal", "Suède" = "Sweden", "Tchad" = "Chad",
                                    "Virgin Islands" = "British Virgin Islands", "Yugoslavia." = "Yugoslavia",
                                    "Micronesia" = "the Federated States of Micronesia", "Netherlands Antilles"="Netherlands Antilles",
                                    "EC" = "European Community", "European Communitiy" = "European Community", "BIMST" = "BIMST-EC")) %>%
  dplyr::filter(Country != "Bas",
                Country != "Uni",
                Country != "British",
                Country != "Overseas Countries and Territories") %>% 
  #Kept the names of IOs in the 'country' column because for some treaties the list of countries within the organisation is not listed (eg. CARICOM-Colombia)
  dplyr::mutate(Country_ID = countrycode::countrycode(Country, origin = 'country.name', destination = 'iso3n')) %>%
  #IOs and some countries (Kosovo, Northern Ireland, Sahrawi) do not have their own iso code
  #dplyr::mutate(ID1 = ifelse(Country = "Netherlands Antilles", 530, ID)) %>%
  #dplyr::mutate(Country_ID = ifelse(Country = "Yugoslavia", 891, ID1)) %>%
  #could not detect country names Yugoslavia and Netherlands Antilles
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a", NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A", NA, `Date.of.Entry.into.Force`)) %>%
  qData::transmutate(Title = qCreate::standardise_titles(`Common.Name`),
                     Signature = qCreate::standardise_dates(`Date.of.Signature`),
                     Force = qCreate::standardise_dates(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(Country_ID, Country, Title, Beg, Signature, Force) %>% 
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
