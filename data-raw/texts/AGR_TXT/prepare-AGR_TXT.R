# TRADE AGREEMENTS TEXTS Preparation Script

# Due to the specificities of the text database,
# the usual script preparation format has been adapted.

# Stage one: create a consolidated version of the qTrade agreements database
AGR_TXT <- dplyr::full_join(qTrade::agreements$DESTA, qTrade::agreements$GPTAD, 
                            by = c("qID")) %>%
  dplyr::select(qID, Title.x, Beg.x, Signature.x, Force.x, WTO.x, DESTA_ID, 
                 Title.y, Beg.y, Signature.y, Force.y, WTO.y, GPTAD_ID) %>%
  dplyr::mutate(Title = ifelse(Title.x == "NA", Title.y, Title.x)) %>%
  dplyr::mutate(Beg = ifelse(Beg.y != "NA", Beg.y, Beg.x))

# qData::consolidate doesn't seem to work - issue with 'resolve' argument?

# Step two: extract treaty texts from GLOBAL PREFERENTIAL TRADE AGREEMENTS 
# DATABASE online
GPTAD_original <- readr::read_csv("data-raw/agreements/GPTAD/GPTAD.csv")
GPTAD_original <- as_tibble(GPTAD_original) %>%
  dplyr::mutate(GPTAD_ID = dplyr::row_number()) %>%
  dplyr::rename(Title = `Common.Name`) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Title, "Macedonia (FYROM)", "FYROM")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "Andean Community", "Andean")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "Andean Community (CAN)", "Cartagena")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "ASEAN (AFTA)", "ASEAN")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "ASEAN - Australia - New Zealand", "ASEAN-Australia-NZ")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "Australia - New Zealand (ANZCERTA)", "CER")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "Australia - Papua New Guinea (PATCRA)", "Australia-PapuaNewGuinea")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "Arab Maghreb Union", "MAGHREB")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, "Armenia - Kyrgyz", "Armenia-Kyrgyz Rep")) %>%
  dplyr::mutate(Treaty_ID = stringr::str_replace(Treaty_ID, " - ", "-")) %>%
  dplyr::select(GPTAD_ID, Title, Treaty_ID)
# rvest package is used to web scrap GPTAD treaty texts page
# src <- "https://wits.worldbank.org/gptad/library.aspx"
# GPTAD_original$TreatyText <- lapply(GPTAD_original$GPTAD_ID, function(s) tryCatch(rvest::read_html(paste0(src, s)) %>%
#                                                                                     rvest::html_elements('.yui-dt-data .yui-dt-sortable.yui-dt-first a' | '#yui-rec0 .yui-dt-first a') %>% 
#                                                                                     rvest::html_text(), error = function(e){as.character("Not found")} %>% 
#                                                                                     paste(collapse = ",")))
src <- "https://wits.worldbank.org/GPTAD/PDF/archive/"
GPTAD_original$TreatyText <- lapply(GPTAD_original$Treaty_ID, function(s) tryCatch(pdftools::pdf_text(paste0(src, s, ".pdf")), error = function(e){as.character("Not found")}))
# add source column
GPTAD_original$Source <- lapply(IEADB_original$GPTAD_ID, function(s) tryCatch(rvest::read_html(paste0(src, s)) %>%
                                                                                rvest::html_nodes(".views-field-views-conditional") %>% 
                                                                                rvest::html_text(), error = function(e){as.character("Not found")} %>% 
                                                                                paste(collapse = ",")))


# Step three: join GPTAD treaty text column with the consolidated version of qTrade
AGR_TXT <- dplyr::left_join(AGR_TXT, GPTAD_original, by = "GPTAD_ID")
AGR_TXT <- as_tibble(AGR_TXT) %>% 
  dplyr::select(qID, DESTA_ID, GPTAD_ID, Title, Beg, TreatyText, Source)
  
# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make AGR_TXT available
# within the qPackage.
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
                     URL = c("https://www.designoftradeagreements.org/downloads/", 
                             "https://wits.worldbank.org/gptad/library.aspx"))
