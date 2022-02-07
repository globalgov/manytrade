# DESTA_TXT Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for many packages universe.

# Stage one: Collecting data
DESTA_TXT <- readr::read_csv2("data-raw/texts/DESTA_TXT/DESTA_TXT.csv")

# Stage two: preparing URLs links
DESTA_TXT$Location <- stringr::str_remove_all(DESTA_TXT$Location, "^WTO\\s\\(|^WTO\\(")
DESTA_TXT$Location <- stringr::str_remove_all(DESTA_TXT$Location, "\\)")

# Remove NAs
DESTA_TXT <- DESTA_TXT %>% 
  dplyr::filter(!is.na(Location)) %>% 
  dplyr::filter(Location != "--") %>% 
  dplyr::filter(Location != "WTO")

#Web scrape page where URL to treaty texts stands
DESTA_TXT$url_page <- lapply(DESTA_TXT$Location,
                             function(s) purrr::map(s,
                                                    . %>% 
                                                      httr::GET() %>%
                                                      httr::content(as = "text")))


# Extract URL to treaty text
DESTA_TXT$url_page <- gsub(".*EngTOAHyperLink_0", "", DESTA_TXT$url_page)
DESTA_TXT$url_page <- gsub("target.*", "", DESTA_TXT$url_page)

DESTA_TXT$url_page <- stringr::str_remove_all(DESTA_TXT$url_page, "\\\\")
DESTA_TXT$url_page <- stringr::str_remove_all(DESTA_TXT$url_page, "\"\\s")
DESTA_TXT$url_page <- stringr::str_remove_all(DESTA_TXT$url_page, "href")
DESTA_TXT$url_page <- stringr::str_remove_all(DESTA_TXT$url_page, "\\=\"")

DESTA_TXT$url_page <- gsub("^\\.\\.", "http://rtais.wto.org", DESTA_TXT$url_page)

# Web scrape treaty texts from url_page column


# Select columns and arrange by date
DESTA_TXT <- as_tibble(DESTA_TXT) %>% 
  dplyr::select(Title, Beg, Location, url_page) %>% 
  dplyr::arrange(Beg)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA_TXT available
# within the package.
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
# run `manypkgs::add_bib(texts, DESTA_TXT)`.
manypkgs::export_data(DESTA_TXT, database = "texts",
                     URL = NULL)
