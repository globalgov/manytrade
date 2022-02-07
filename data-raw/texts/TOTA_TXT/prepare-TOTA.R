# TEXTS OF TRADE AGREEMENTS (TOTA) Database Preparation Script

# Due to the specificities of the TOTA database,
# the usual script preparation format has been adapted.

url <- "https://raw.github.com/mappingtreaties/tota/master/xml/"

# Prepare URL column
TOTA_ID <- tibble::as_tibble(1:450)
colnames(TOTA_ID) <- "num"
TOTA_ID$head <- "pta"
TOTA_ID$tail <- ".xml"
TOTA_TXT <- TOTA_ID %>%
  dplyr::select(head, num, tail) %>%
  tidyr::unite(col = "ID", head, num) %>%
  tidyr::unite(col = "ID", ID, tail, sep = "")

TOTA_TXT$ID <- paste0(url, TOTA_TXT$ID)

# Web scrape texts into database
TOTA_TXT$TreatyText <- lapply(TOTA_TXT$ID,
                             function(s) purrr::map(s,
                                                    . %>%
                                                      httr::GET() %>%
                                                      httr::content(as = "text")))

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make TOTA_TXT available
# within the manypackage.
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
# run `manypkgs::add_bib("texts", "TOTA_TXT")`.
manypkgs::export_data(TOTA_TXT, database = "texts",
                      URL = "https://github.com/mappingtreaties/tota.git")
