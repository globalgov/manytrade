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
TOTA_TXT$TreatyText <- apply(TOTA_TXT, 1, function(x) xml2::as_list(xml2::read_xml(x)))

# Extract title and date information
texts <- TOTA_TXT[[2]]
TOTA_TXT$Title <- lapply(texts, function(x) paste0(x$treaty$meta$name))
TOTA_TXT$Signature <- lapply(texts, function(x) paste0(x$treaty$meta$date_signed))
TOTA_TXT$Force <- lapply(texts, function(x) paste0(x$treaty$meta$date_into_force))
TOTA_TXT <- TOTA_TXT %>%
  dplyr::mutate(Title = manypkgs::standardise_titles(as.character(Title))) %>%
  dplyr::mutate(Signature = manypkgs::standardise_dates(as.character(Signature)),
                Force = manypkgs::standardise_dates(as.character(Force))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force))

# Add treatyID column
TOTA_TXT$treatyID <- manypkgs::code_agreements(TOTA_TXT, TOTA_TXT$Title, TOTA_TXT$Beg)

# Add manyID column

# Re-order the columns
TOTA_TXT <- TOTA_TXT %>%
  dplyr::rename(url = ID) %>%
  dplyr::select(Title, Beg, Signature, Force, TreatyText, treatyID, url) %>% 
  dplyr::arrange(Beg)

TOTA_TXT <- tibble::as_tibble(TOTA_TXT)

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
