# TRADE AGREEMENTS TEXTS Preparation Script

# Due to the specificities of the text database,
# the usual script preparation format has been adapted.

# Create consolidated version of agreements database
AGR_TXT <- manydata::favour(manytrade::agreements, "GPTAD") %>% 
  manydata::consolidate("any",
                        "any",
                        "coalesce",
                        key = "manyID")

# Download texts for GPTAD dataset
GPTAD_TXT <- AGR_TXT %>%
  dplyr::filter(!is.na(gptadID)) %>%
  dplyr::mutate(gptadID = as.numeric(gptadID)) %>%
  dplyr::arrange(gptadID) %>%
  dplyr::distinct(gptadID, .keep_all = TRUE)

# Extract URL links that lead to treaty texts from GPTAD website
library(httr)

url <- "https://wits.worldbank.org/gptad/library.aspx#"
page <- httr::GET(url)

output <- httr::content(page, as = "text")

links <- unlist(stringr::str_extract_all(output, "https\\:\\/\\/wits\\.worldbank.org\\/GPTAD\\/PDF\\/archive\\/.+?(?<=')"))
links <- stringr::str_remove_all(links, "'")
# remove entries that were excluded from agreements database
links <- links[-(3:4)] # remove duplicate entries for Afghanistan-India
links <- links[-(122:127)] # remove customs union accession agreements
links <- links[-85] # remove entry in alternative language
links <- links[-287] # remove duplicate entry for india-mercosur
links <- links[-327] # remove duplicate entry for israel-turkey
links <- links[-314] # remove duplicate entry for New Zealand - Singapore

# Extract the PDF treaty texts and add to GPTAD_TXT
TreatyText <- lapply(links, function(s){
  out <- tryCatch(pdftools::pdf_text(s), error = function(e){as.character("Not found")})
  out <- stringr::str_remove_all(out, "\\\n") 
})
GPTAD_TXT$TreatyText <- TreatyText
GPTAD_TXT <- GPTAD_TXT %>%
  dplyr::select(manyID, TreatyText)

# Add treaty texts into AGR_TXT
AGR_TXT <- dplyr::left_join(AGR_TXT, GPTAD_TXT,
                            by = "manyID")

# Extract remaining treaty texts from manually added URLs 
# (sourced from WTO RTAs database, EDIT database and country/IGO websites)
REM_TXT <- readxl::read_excel("data-raw/texts/AGR_TXT/REM_TXT.xlsx")
REM_TXT <- REM_TXT %>%
  dplyr::filter(!is.na(url))

# Web scrape treaty texts and clean by type
REM_TXT$Text <- lapply(REM_TXT$url, function(x) {
  if (grepl("pdf", x, ignore.case = TRUE) == TRUE) {
      as.character(tryCatch(pdftools::pdf_text(x), error = function(e){as.character("Not found")}))
  }
  # scrap web pages
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
        y <- as.character(y)
        y <- stringr::str_remove_all(y, "\\\n")
      })
    } else {
      if (grepl("eur-lex", x)) {
        text <- httr::GET(x) %>%
          httr::content(as = "text")
        text <- stringr::str_remove_all(text, "<p>ANNEX I.*")
        as.character(text)
      } else {
        if (grepl(".doc", x)) {
          out <- tryCatch(readtext::readtext(x),
                          error = function(e){as.character("Not found")}) 
          text <- ifelse(out != "Not found", out[1,2], "Not found")
          text <- stringr::str_remove_all(text, "\\\n")
          as.character(text)
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
              y <- stringr::str_remove_all(y, "\\\n")
            })
          } else {
            if(grepl("PAN_ISR", x)){
              page <- httr::GET(x) %>% 
                httr::content(as = "text")
              links <- stringr::str_extract_all(page, "English/.*pdf")
              links <- lapply(links, function(s){
                out <- paste0("http://www.sice.oas.org/Trade/PAN_ISR/",s)
                out
              })
              links <- unlist(links)
              text <- lapply(links, function(h){
                y <- as.character(tryCatch(pdftools::pdf_text(h), 
                                           error = function(e){as.character("Not found")}))
                y <- stringr::str_remove_all(y, "\\\n")
              })
            } else {
              text <- httr::GET(x) %>%
                httr::content(as = "text")
              text <- stringr::str_remove_all(text, "\\\n")
              text <- stringr::str_remove_all(text, "\\\r")
              text <- stringr::str_remove_all(text, "\\\t")
              text <- stringr::str_remove_all(text, "<h3>")
              text <- stringr::str_remove_all(text, "</h3>")
              text <- stringr::str_remove_all(text, "</p>")
              text <- stringr::str_remove_all(text, "<p>")
              text <- stringr::str_remove_all(text, "summary=\"Table1.*")
              text <- stringr::str_remove_all(text, "java script|javascript")
              as.character(text)
            }
          }
        }
      }
    }
  }
})

# Add treaty texts into AGR_TXT
REM_TXT <- REM_TXT %>%
  dplyr::select(manyID, Text)

AGR_TXT <- dplyr::left_join(AGR_TXT, REM_TXT,
                            by = "manyID")
# merge text columns from GPTAD_TXT (TreatyText) and REM_TXT (Text)
AGR_TXT <- AGR_TXT %>%
  dplyr::mutate(TreatyText = ifelse(!is.na(TreatyText), TreatyText, Text)) %>%
  dplyr::select(-Text) %>%
  dplyr::arrange(Beg)

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
                             "https://edit.wti.org/app.php/document/investment-treaty/search"))

# To reduce size of text data stored in package:
# 1. after exporting AGR_TXT and TOTA_TXT to texts database, 
# load 'texts.rda' in environment.
# 2. Delete 'texts.rda' in 'data' folder.
# 3. Run `usethis::use_data(texts, internal = F, overwrite = T, compress = "xz")`
# to save compressed text data.
