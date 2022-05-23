# Trade Agreements Texts Database Preparation Script

# Due to the specificities of the texts database,
# the usual script preparation format has been adapted.
# To avoid overlaps in texts stored, AGR_TXT is based on a consolidated 
# version of the agreements database, to avoid duplicate entries. 
# Texts from the TOTA database (Alschner, Seiermann, and Skougarevskiy, 2017) 
# are given precedence.

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
  dplyr::mutate(Signature = messydates::make_messydate(as.character(Signature)),
                Force = messydates::make_messydate(as.character(Force))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::arrange(Beg)

# Re-order the columns
TOTA_TXT <- TOTA_TXT %>%
  dplyr::rename(url = ID) %>%
  dplyr::select(Title, TreatyText, url)

# Merge texts from TOTA database with the rest of the datasets in the 
# agreements database
# consolidate agreements database so that entries across datasets are not duplicated
AGR_TXT <- manydata::favour(manytrade::agreements, c("GPTAD", "TOTA")) %>% 
  manydata::consolidate("any",
                        "any",
                        "coalesce",
                        key = "manyID") 

AGR_TXT <- dplyr::full_join(AGR_TXT, TOTA_TXT, 
                            by = "Title")

## Download texts for GPTAD dataset
GPTAD_TXT <- AGR_TXT %>%
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

# Add treaty texts into AGR_TXT
AGR_TXT <- dplyr::left_join(AGR_TXT, GPTAD_TXT,
                            by = c("manyID", "Title"))

AGR_TXT <- AGR_TXT %>%
  dplyr::mutate(TreatyText = ifelse(is.na(totaID), 
                                    TreatyText.y, TreatyText.x)) %>%
  dplyr::select(-TreatyText.x, -TreatyText.y) %>%
  dplyr::mutate(url = ifelse(is.na(totaID),
                             url.y, url.x)) %>%
  dplyr::select(-url.x, -url.y)

## Download remaining texts for agreements listed in DESTA, LABPTA, AND TREND datasets
REM_TXT <- AGR_TXT %>%
  dplyr::filter(is.na(totaID) & is.na(gptadID)) %>%
  dplyr::select(manyID, Title, Beg, Signature, Force, destaID, labptaID, 
                trendID, treatyID)

# add links to treaty texts manually
REM_TXT <- readxl::read_excel("data-raw/texts/AGR_TXT/REM_TXT.xlsx")

# Web scrape treaty texts and clean by format, remove appendices and annexes
REM_TXT$Text <- lapply(REM_TXT$url, function(x) {
  if (grepl("pdf", x, ignore.case = TRUE) == TRUE) {
    text <- as.character(tryCatch(pdftools::pdf_text(x), 
                                  error = function(e){as.character("Not found")}))
    text <- unlist(text)
    text <- ifelse(length(text > 1),
                   stringr::str_c(text, collapse = " "), text)
    text <- stringr::str_remove_all(text, "\n")
    text <- stringr::str_remove_all(text, "\r")
    text <- stringr::str_remove_all(text, "\t")
    text <- stringr::str_squish(text)
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
        y <- as.character(unlist(y))
        y <- ifelse(length(y > 1), stringr::str_c(y, collapse = " "), y)
        y <- stringr::str_remove_all(y, "\n")
        y <- stringr::str_remove_all(y, "\r")
        y <- stringr::str_remove_all(y, "\t")
        y <- stringr::str_squish(y)
      })
    } else {
      if (grepl("eur-lex", x)) {
        text <- httr::GET(x) %>%
          httr::content(as = "text")
        text <- as.character(unlist(text))
        text <- ifelse(length(text > 1),
                       stringr::str_c(text, collapse = " "), text)
        text <- stringr::str_remove_all(text, "\n")
        text <- stringr::str_remove_all(text, "\r")
        text <- stringr::str_remove_all(text, "\t")
        text <- stringr::str_squish(text)
      } else {
        if (grepl(".doc$|.docx$", x)) {
          out <- tryCatch(readtext::readtext(x),
                          error = function(e){as.character("Not found")}) 
          text <- ifelse(out != "Not found", out[1,2], "Not found")
          text <- ifelse(length(text > 1),
                         stringr::str_c(text, collapse = " "), text)
          text <- tolower(as.character(text))
          text <- stringr::str_remove_all(text, "\n")
          text <- stringr::str_remove_all(text, "\r")
          text <- stringr::str_remove_all(text, "\t")
          text <- stringr::str_squish(text)
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
            text <- stringr::str_remove_all(text, "\n")
            text <- stringr::str_remove_all(text, "\r")
            text <- stringr::str_remove_all(text, "\t")
            text <- stringr::str_squish(text)
          } else {
            if(grepl("gc.ca", x)) {
              text <- rvest::read_html(x) %>%
                rvest::html_elements("h2, p, h3, li") %>%
                rvest::html_text()
              text <- unlist(text)
              text <- ifelse(length(text > 1),
                             stringr::str_c(text, collapse = " "), text)
              text <- stringr::str_remove_all(text, "\n")
              text <- stringr::str_remove_all(text, "\r")
              text <- stringr::str_remove_all(text, "\t")
              text <- stringr::str_squish(text)
            }
            else {
              text <- tryCatch(httr::content(httr::GET(x), as = "text"),
                               error = function(e){as.character("Not found")})
              text <- unlist(text)
              text <- ifelse(length(text > 1),
                             stringr::str_c(text, collapse = " "), text)
              text <- stringr::str_remove_all(text, "\r")
              text <- stringr::str_remove_all(text, "\t")
              text <- stringr::str_remove_all(text, "<.*>")
              text <- stringr::str_remove_all(text, "<h3>")
              text <- stringr::str_remove_all(text, "</h3>")
              text <- stringr::str_remove_all(text, "</p>")
              text <- stringr::str_remove_all(text, "<p>")
              text <- stringr::str_remove_all(text, "\n")
              text <- stringr::str_squish(text)
            }
          }
        }
      }
    }
  }
})

# Add treaty texts into AGR_TXT
REM_TXT <- REM_TXT %>%
  dplyr::select(manyID, Text) %>%
  dplyr::mutate(Text = ifelse(!grepl("^[A-Za-z]+$|[[:digit:]]", Text),
                              "Not found", Text))

AGR_TXT <- dplyr::left_join(AGR_TXT, REM_TXT,
                            by = "manyID")

# Merge text columns
AGR_TXT <- AGR_TXT %>%
  # make sure texts transfer over properly
  dplyr::mutate(TreatyText = ifelse(TreatyText == "NULL", Text, TreatyText)) %>%
  dplyr::select(-Text, -AgreementType, -DocType, -GeogArea) %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Force) %>%
  dplyr::arrange(Beg)

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
# run `manypkgs::add_bib("texts", "AGR_TXT")`.
manypkgs::export_data(AGR_TXT, database = "texts",
                      URL = c("https://wits.worldbank.org/gptad/library.aspx",
                              "http://rtais.wto.org/UI/PublicMaintainRTAHome.aspx",
                              "https://edit.wti.org/app.php/document/investment-treaty/search",
                              "https://github.com/mappingtreaties/tota.git"))

# To reduce size of text data stored in package:
# 1. after exporting AGR_TXT to texts database, 
# load 'texts.rda' in environment.
# 2. Delete 'texts.rda' in 'data' folder.
# 3. Run `usethis::use_data(texts, internal = F, overwrite = T, compress = "xz")`
# to save compressed text data.
