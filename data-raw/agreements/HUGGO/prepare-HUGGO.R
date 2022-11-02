# Trade Agreements HUGGO Dataset Preparation Script

# The HUGGO dataset contains treaty texts scrapped from their websites
# (see 'links.xlsx' file for the links collected)
# or other databases such as TOTA (Alschner, Seiermann, and Skougarevskiy, 2017),
# GPTAD (World Bank Group, 2014),
# and EDIT (Alschner, Elsig, and Polanco, 2021).
# Please see Step 3 and the Bibliography file for the links to these websites.

## Download texts from TEXTS OF TRADE AGREEMENTS (TOTA) database
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
  dplyr::mutate(Signature = messydates::as_messydate(as.character(Signature)),
                Force = messydates::as_messydate(as.character(Force))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::arrange(Beg)
TOTA_TXT$totaID <- rownames(TOTA_TXT)

# Re-order the columns
TOTA_TXT <- TOTA_TXT %>%
  dplyr::rename(url = ID) %>%
  dplyr::select(Title, TreatyText, url, totaID)

# Merge texts from TOTA database with the rest of the datasets in the 
# agreements database
# consolidate agreements database so that entries across datasets are not duplicated
HUGGO <- manydata::favour(manytrade::agreements, c("GPTAD", "TOTA")) %>% 
  manydata::consolidate("any",
                        "any",
                        "coalesce",
                        key = "manyID") 

HUGGO <- dplyr::full_join(HUGGO, TOTA_TXT, by = c("Title", "totaID"))

## Download texts for GPTAD dataset
GPTAD_TXT <- HUGGO %>%
  dplyr::filter(!is.na(gptadID) & is.na(totaID)) %>%
  dplyr::mutate(gptadID = as.numeric(gptadID)) %>%
  dplyr::arrange(gptadID) %>%
  dplyr::distinct(gptadID, .keep_all = TRUE) %>%
  dplyr::select(-TreatyText)

# Extract treaty titles and URL links from GPTAD website
library(httr)

url <- "https://wits.worldbank.org/gptad/library.aspx#"
page <- httr::GET(url)

output <- httr::content(page, as = "text")

Title <- unlist(stringr::str_extract_all(output, "height='12' alt='PDF'/>.+?(?<=')"))
Title <- stringr::str_remove_all(Title, "height='12' alt='PDF'/>")
Title <- stringr::str_remove_all(Title, "</a></td><td><div class='")
Title <- stringr::str_remove_all(Title, "</a></td></tr><tr><td><span style=display:none;></span><a href='")
Title <- stringi::stri_remove_empty(Title)
Title <- manypkgs::standardise_titles(Title)

links <- unlist(stringr::str_extract_all(output, "https\\:\\/\\/wits\\.worldbank.org\\/GPTAD\\/PDF\\/archive\\/.+?(?<=')"))
links <- stringr::str_remove_all(links, "'")

source <- data.frame(Title = Title, links = links)

# Extract the PDF treaty texts and add to GPTAD_TXT
source$TreatyText <- lapply(source$links, function(s){
  out <- tryCatch(pdftools::pdf_text(s), error = function(e){as.character("Not found")})
})

GPTAD_TXT <- dplyr::left_join(GPTAD_TXT, source, by = "Title") %>%
  dplyr::select(manyID, Title, TreatyText, links) %>%
  dplyr::rename(url = links)

# Add treaty texts into HUGGO
HUGGO <- dplyr::left_join(HUGGO, GPTAD_TXT,
                               by = c("manyID", "Title"))

HUGGO <- HUGGO %>%
  dplyr::mutate(TreatyText = ifelse(is.na(totaID), 
                                    TreatyText.y, TreatyText.x)) %>%
  dplyr::select(-TreatyText.x, -TreatyText.y) %>%
  dplyr::mutate(url = ifelse(is.na(totaID),
                             url.y, url.x)) %>%
  dplyr::select(-url.x, -url.y)

## Download remaining texts for agreements listed in DESTA, LABPTA, AND TREND datasets
links <- HUGGO %>%
  dplyr::filter(is.na(totaID) & is.na(gptadID)) %>%
  dplyr::select(manyID, Title, Beg, Signature, Force, destaID, labptaID, 
                trendID, treatyID)

# add links to treaty texts manually
links <- readxl::read_excel("data-raw/agreements/HUGGO/links.xlsx")

# Web scrape treaty texts and clean by format, remove appendices and annexes
links$Text <- lapply(links$url, function(x) {
  if (grepl("pdf", x, ignore.case = TRUE) == TRUE) {
    text <- as.character(tryCatch(pdftools::pdf_text(x), 
                                  error = function(e){as.character("Not found")}))
    text <- unlist(text)
    text <- ifelse(length(text > 1),
                   stringr::str_c(text, collapse = " "), text)
  }
  # scrape web pages
  else {
    if (grepl("dfat.gov.au", x)) {
      page <- httr::GET(x) %>% 
        httr::content(as = "text")
      links <- stringr::str_extract_all(page,
                                        "https://www.dfat.gov.au/sites/default/files/aukfta-official-documents_.*.docx")
      links <- lapply(links, function(s){
        out <- stringr::str_remove_all(s, "title=.*docx")
        out <- stringr::str_remove_all(out, "\\\"")
        out <- stringr::str_remove_all(out, " ")
        out
      })
      text <- lapply(links, function(h){
        out <- tryCatch(readtext::readtext(h),
                        error = function(e){as.character("Not found")})
        y <- ifelse(out != "Not found", out[1,2], "Not found")
        y <- unlist(y)
        y <- ifelse(length(y > 1), stringr::str_c(y, collapse = " "), y)
      })
    } else {
      if (grepl("eur-lex", x)) {
        text <- httr::GET(x) %>%
          httr::content(as = "text")
        text <- as.character(unlist(text))
        text <- ifelse(length(text > 1),
                       stringr::str_c(text, collapse = " "), text)
      } else {
        if (grepl(".doc$|.docx$", x)) {
          out <- tryCatch(readtext::readtext(x),
                          error = function(e){as.character("Not found")}) 
          text <- ifelse(out != "Not found", out[1,2], "Not found")
          text <- ifelse(length(text > 1),
                         stringr::str_c(text, collapse = " "), text)
        } else {
          if (grepl("tid.gov.hk", x)) {
            page <- httr::GET(x) %>% 
              httr::content(as = "text")
            links <- stringr::str_extract_all(page, "english/ita/fta/.*pdf")
            links <- lapply(links, function(s){
              out <- paste0("https://www.tid.gov.hk/",s)
              out <- stringr::str_remove_all(out, ">.*pdf")
              out
            })
            links <- unlist(links)
            text <- lapply(links, function(h){
              y <- as.character(tryCatch(pdftools::pdf_text(h), 
                                         error = function(e){as.character("Not found")}))
            })
            text <- unlist(text)
            text <- ifelse(length(text > 1),
                           stringr::str_c(text, collapse = " "), text)
          } else {
            if(grepl("gc.ca", x)) {
              text <- rvest::read_html(x) %>%
                rvest::html_elements("h2, p, h3, li") %>%
                rvest::html_text()
              text <- unlist(text)
              text <- ifelse(length(text > 1),
                             stringr::str_c(text, collapse = " "), text)
            }
            else {
              text <- tryCatch(httr::content(httr::GET(x), as = "text"),
                               error = function(e){as.character("Not found")})
              text <- unlist(text)
              text <- ifelse(length(text > 1),
                             stringr::str_c(text, collapse = " "), text)
            }
          }
        }
      }
    }
  }
})

# Add treaty texts into HUGGO
links <- links %>%
  dplyr::select(manyID, Title, Text, treatyID, url) %>%
  dplyr::mutate(Text = ifelse(!grepl("^[A-Za-z]+$|[[:digit:]]", Text),
                              "Not found", Text))

HUGGO <- dplyr::left_join(HUGGO, links, by = c("manyID", "Title", "treatyID"))
HUGGO <- HUGGO %>%
  dplyr::mutate(url = ifelse(is.na(url.x), url.y,url.x)) %>%
  dplyr::select(-c("url.x", "url.y"))

# Merge text columns
HUGGO <- HUGGO %>%
  # make sure texts transfer over properly
  dplyr::mutate(TreatyText = ifelse(TreatyText == "NULL", Text, TreatyText)) %>%
  dplyr::select(-Text, -AgreementType, -DocType, -GeogArea) %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Force) %>%
  dplyr::arrange(Beg)

# Change 'Not found' to NA in text column
HUGGO <- HUGGO %>%
  dplyr::mutate(TreatyText = ifelse(TreatyText == "Not found" | TreatyText == "NULL",
                                    gsub("Not found|NULL", NA, TreatyText),
                                    TreatyText))

# Clean texts and remove duplicates
HUGGO <- HUGGO %>%
  dplyr::mutate(TreatyText = manypkgs::standardise_treaty_text(TreatyText)) %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Force, totaID, gptadID, destaID,
                  labptaID, trendID, treatyID)

HUGGO <- HUGGO %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Force) %>%
  dplyr::select(-c(totaID, gptadID, destaID, labptaID, trendID))

HUGGO <- HUGGO %>% 
  dplyr::mutate(across(everything(), ~stringr::str_replace_all(., "^NA$",
                                                               NA_character_))) %>% 
  dplyr::distinct(.keep_all = TRUE) %>% 
  mutate(Signature = messydates::as_messydate(Signature),
         Force = messydates::as_messydate(Force),
         Beg = messydates::as_messydate(Beg)) %>% 
  dplyr::distinct(.keep_all = TRUE)

# Standardising treaty texts
HUGGO <- HUGGO %>%
  dplyr::mutate(MainText = ifelse(!grepl("APPENDIX | ANNEX", unlist(TreatyText), perl = T),
                                  TreatyText,
                                  stringr::str_remove(HUGGO$TreatyText,
                                                      "APPENDIX.* | ANNEX.*")))
HUGGO <- HUGGO %>%
  dplyr::mutate(AppendixText = ifelse(grepl("APPENDIX", unlist(TreatyText), perl = T),
                                      stringr::str_extract(HUGGO$TreatyText,
                                                           "APPENDIX.*"),
                                      NA))
HUGGO <- HUGGO %>%
  dplyr::mutate(AnnexText = ifelse(grepl("ANNEX", unlist(TreatyText), perl = T),
                                   stringr::str_extract(HUGGO$TreatyText,
                                                           "ANNEX.*"),
                                   NA))
# Add End date variable
HUGGO$End <- NA

# Add Parties variable
HUGGO$Parties <- ""

# Checked_HUGGO and Confirmed_HUGGO variables to track progress on manually correcting entries
# Checked_HUGGO: code 1 when the entire row's observations have been verified and updated
# Confirmed_HUGGO: list variables for which the observation could be verified and confirmed.
# Eg. List 'Signature' in `Confirmed_HUGGO` if the Signature date was found and verified in the treaty text or in a manual online search.
HUGGO$Checked_HUGGO <- NA
HUGGO$Confirmed_HUGGO <- NA

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make HUGGO available
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
# run `manypkgs::add_bib("agreements", "HUGGO")`.
manypkgs::export_data(HUGGO, database = "agreements",
                      URL = c("https://wits.worldbank.org/gptad/library.aspx",
                              "http://rtais.wto.org/UI/PublicMaintainRTAHome.aspx",
                              "https://edit.wti.org/app.php/document/investment-treaty/search",
                              "https://github.com/mappingtreaties/tota.git"))

# To reduce size of text data stored in package:
# 1. after exporting HUGGO to agreements database, 
# load 'agreements.rda' in environment.
# 2. Delete 'agreements.rda' in 'data' folder.
# 3. Run `usethis::use_data(agreements, internal = F, overwrite = T, compress = "xz")`
# to save compressed text data.
