# TOTA Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many package.

# Stage one: Collecting data
# Download texts from TEXTS OF TRADE AGREEMENTS (TOTA) database
url <- "https://raw.github.com/mappingtreaties/tota/master/xml/"

# Prepare URL column
TOTA_ID <- tibble::as_tibble(1:450)
colnames(TOTA_ID) <- "num"
TOTA_ID$head <- "pta"
TOTA_ID$tail <- ".xml"
TOTA <- TOTA_ID %>%
  dplyr::select(head, num, tail) %>%
  tidyr::unite(col = "ID", head, num) %>%
  tidyr::unite(col = "ID", ID, tail, sep = "")

TOTA$ID <- paste0(url, TOTA$ID)

# Web scrape texts
TOTA$TreatyText <- apply(TOTA, 1, function(x) xml2::as_list(xml2::read_xml(x)))

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'TOTA' object until the object created
# below (in stage three) passes all the tests.
# We recommend that you avoid using one letter variable names to keep
# away from issues with ambiguous names down the road.

# Extract title and date information
texts <- TOTA[[2]]
TOTA$Title <- lapply(texts, function(x) paste0(x$treaty$meta$name))
TOTA$Signature <- lapply(texts, function(x) paste0(x$treaty$meta$date_signed))
TOTA$Force <- lapply(texts, function(x) paste0(x$treaty$meta$date_into_force))
TOTA <- TOTA %>%
  dplyr::mutate(Title = manypkgs::standardise_titles(as.character(Title))) %>%
  dplyr::mutate(Signature = messydates::as_messydate(as.character(Signature)),
                Force = messydates::as_messydate(as.character(Force))) %>%
  dplyr::mutate(Begin = dplyr::coalesce(Signature, Force))

# Remove accession observations
TOTA <- TOTA %>%
  dplyr::filter(!stringr::str_detect(TOTA$Title, "Accession"))

# Add treatyID column
TOTA$treatyID <- manypkgs::code_agreements(TOTA, TOTA$Title, TOTA$Begin)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::agreements)
TOTA <- dplyr::left_join(TOTA, manyID, by = "treatyID")

# Re-order the columns
TOTA <- TOTA %>%
  dplyr::select(manyID, Title, Begin, Signature, Force, treatyID) %>%
  dplyr::arrange(Begin)

# Add totaID column
TOTA$totaID <- rownames(TOTA)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make TOTA available
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
# To add a template of .bib file to the package,
# please run `manypkgs::add_bib("agreements", "TOTA")`.
manypkgs::export_data(TOTA, datacube = "agreements",
                      URL = "https://github.com/mappingtreaties/tota.git")
