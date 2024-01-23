# AIGGO Preparation Script

# The AIGGO dataset lists the trade agreements
# listed in the other five datasets in the manytrade::agreements datacube
# (DESTA, GPTAD, TOTA, LABPTA, TREND) and adds additional information,
# such as accession conditions and procedures for joining agreements,
# and increases the precision of Signature dates.
# This information is coded from the texts of the trade agreements,
# which are stored in the HUGGO dataset.

# This is a template for importing, cleaning, and exporting data
# ready for many packages universe.

# Stage one: Assembling data

# consolidated version of agreements datacube
AIGGO <- manytrade::agreements$HUGGO

# Stage two: Adding membership conditions and procedures columns
AIGGO$accessionC <- manypkgs::code_accession_terms(AIGGO$TreatyText,
                                                   AIGGO$Title,
                                                   accession = "condition")
AIGGO$accessionC <- gsub("NA", NA, AIGGO$accessionC)
AIGGO$accessionP <- manypkgs::code_accession_terms(AIGGO$TreatyText,
                                                   accession = "process")
AIGGO$accessionP <- gsub("NA", NA, AIGGO$accessionP)

AIGGO <- AIGGO %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Force,
                  accessionC, accessionP) %>%
  dplyr::arrange(Beg)

# Add precise dates from texts
AIGGO$dates <- lapply(AIGGO$TreatyText, function(s){
  s <- unlist(s)
  s <- stringr::str_c(s, collapse = " ")
  s <- tolower(s)
  s <- stringr::str_extract_all(s, "signed by.*on.* [.]|
                                |signed on (?!behalf).*[.]|
                                |signed at.*on.*[.]|
                                |witness whereof.*done.*at.*this.*[.]")
  s <- unlist(s)
  s <- tryCatch(messydates::as_messydate(s),
                error = function(e){as.character("Not found")})
  s <- paste0(unlist(s), collapse = "")
})

AIGGO <- AIGGO %>%
  dplyr::relocate(manyID, Title, Begin, Signature, dates) %>%
  dplyr::mutate(Sign.rev = ifelse(grepl("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}",
                                        dates, perl = TRUE), dates, NA)) %>%
  dplyr::mutate(Sign.rev = unlist(Sign.rev)) %>%
  dplyr::mutate(Signature = ifelse(!is.na(Sign.rev) & messydates::year(Signature) == messydates::year(Sign.rev),
                                   Sign.rev, Signature)) %>%
  dplyr::mutate(Signature = messydates::as_messydate(Signature)) %>%
  dplyr::select(-c(dates, Sign.rev, TreatyText, url,
                   totaID, gptadID, destaID, labptaID, trendID))

# Remove duplicates and convert NAs
AIGGO <- AIGGO %>%
  mutate(
    across(everything(), ~stringr::str_replace_all(.,
                                                   "^NA$", NA_character_))) %>%
  mutate(Signature = messydates::as_messydate(Signature),
         Force = messydates::as_messydate(Force),
         Begin = messydates::as_messydate(Begin)) %>%
  dplyr::distinct(.keep_all = TRUE)


# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make AIGGO available within the package.
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence
# to certain standards
# You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows)
# to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and
# may require you to return to stage two and further clean,
# standardise, or wrangle your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please note that the export_data() function requires a .bib file to be
# present in the data_raw folder of the package for citation purposes.
# Therefore, please make sure that you have permission to use the dataset
# that you are including in the package.
# To add a template of .bib file to the package,
# please run `manypkgs::add_bib("agreements", "AIGGO")`.
manypkgs::export_data(AIGGO, datacube = "agreements",
                      URL = c("https://www.designoftradeagreements.org/downloads/",
                              "https://wits.worldbank.org/gptad/library.aspx",
                              "https://doi.org/10.1007/s11558-018-9301-z",
                              "http://www.chaire-epi.ulaval.ca/en/trend",
                              "https://github.com/mappingtreaties/tota.git"))
