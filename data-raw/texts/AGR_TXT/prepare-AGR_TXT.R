# TRADE AGREEMENTS TEXTS Preparation Script

# Due to the specificities of the text database,
# the usual script preparation format has been adapted.

# Extract useful columns from original GPTAD dataset
GPTAD_TXT <- read.csv("data-raw/agreements/GPTAD/GPTAD.csv")

GPTAD_TXT <- GPTAD_TXT %>% 
  dplyr::mutate(`Date.of.Signature` = ifelse(`Date.of.Signature`=="n/a", 
                                             NA, `Date.of.Signature`)) %>%
  dplyr::mutate(`Date.of.Entry.into.Force` = ifelse(`Date.of.Entry.into.Force`=="N/A", 
                                                    NA, `Date.of.Entry.into.Force`)) %>%
  manydata::transmutate(Title = manypkgs::standardise_titles(`Common.Name`),
                        Signature = manypkgs::standardise_dates(`Date.of.Signature`),
                        Force = manypkgs::standardise_dates(`Date.of.Entry.into.Force`)) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>% 
  dplyr::select(Title, Beg)

# Add treatyID column
GPTAD_TXT$treatyID <- manypkgs::code_agreements(GPTAD_TXT, GPTAD_TXT$Title, 
                                                GPTAD_TXT$Beg)

# Add manyID column
manyID <- manypkgs::condense_agreements(manytrade::agreements, 
                                        var = c(manytrade::agreements$DESTA$treatyID, 
                                                manytrade::agreements$GPTAD$treatyID,
                                                manytrade::agreements$LABPTA$treatyID, 
                                                manytrade::agreements$TREND$treatyID))
GPTAD_TXT <- dplyr::left_join(GPTAD_TXT, manyID, by = "treatyID")

# Re-order the columns
GPTAD_TXT <- GPTAD_TXT %>%
  dplyr::select(manyID, Title, Beg, D, L, Signature, Force, treatyID, gptadID) %>% 
  dplyr::arrange(Beg)

# Extract URL links that lead to treaty texts from GPTAD website
library(httr)

url <- "https://wits.worldbank.org/gptad/library.aspx#"
page <- httr::GET(url)

output <- httr::content(page, as = "text")

links <- unlist(stringr::str_extract_all(output, "https\\:\\/\\/wits\\.worldbank.org\\/GPTAD\\/PDF\\/archive\\/.+?(?<=')"))
links <- stringr::str_remove_all(links, "'")

# Extract the PDF treaty texts
TreatyText <- lapply(links, function(s) tryCatch(pdftools::pdf_text(s), error = function(e){as.character("Not found")}))

# Add it to GPTAD_TXT and then AGR_TXT
GPTAD_TXT$TreatyText <- TreatyText
AGR_TXT <- as_tibble(GPTAD)

# Extract data from DESTA dataset that does not overlap with GPTAD
DESTA_TXT <- dplyr::full_join(manytrade::agreements$DESTA, manytrade::agreements$GPTAD, 
                          by = c("manyID")) %>%
  subset(is.na(Title.y)) %>%
  dplyr::select(manyID, Title.x, Beg.x, Signature.x, Force.x, WTO, destaID) %>%
  dplyr::rename(Title = Title.x, Beg = Beg.x, Signature = Signature.x,
                Force = Force.x)
DESTA_TXT <- dplyr::full_join(DESTA_TXT, subset(manytrade::agreements$DESTA,
                                        is.na(manytrade::agreements$DESTA$manyID)),
                          by = c("manyID", "Title", "Beg", "Signature", "Force", 
                                "destaID")) %>%
  dplyr::select(manyID, Title, Beg, Signature, Force, destaID) %>%
  dplyr::arrange(Beg)

# Manually input URL links (sourced from WTO RTAs database and EDIT database)
write.csv(DESTA_TXT, file = "/Volumes/128GB/PANARCHIC/manytrade data/DESTA_TXT.csv")
# DESTA_TXT <- read.csv("data-raw/agreements/AGR_TXT/DESTA_TXT.csv")

DESTA_TXT <- readxl::read_xlsx("/Volumes/128GB/PANARCHIC/manytrade data/DESTA_TXT.xlsx")
DESTA_TXT$Text <- lapply(DESTA_TXT$url, function(x) {
  if (grepl("pdf", x, ignore.case = TRUE) == TRUE) {
    pdftools::pdf_text(x)
  }
})

httr::GET("https://edit.wti.org/app.php/document/show/pdf/dab1b96e-fc42-42a9-8737-21246c72accb") %>%
  httr::content(as="text")

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make AGR_TXT available
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
# run `manypkgs::add_bib("texts", "AGR_TXT")`.
manypkgs::export_data(AGR_TXT, database = "texts",
                     URL = c("https://wits.worldbank.org/gptad/library.aspx",
                             "http://rtais.wto.org/UI/PublicMaintainRTAHome.aspx",
                             "https://edit.wti.org/app.php/document/investment-treaty/search")
