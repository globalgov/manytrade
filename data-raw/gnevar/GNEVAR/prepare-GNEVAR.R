# GNEVAR Preparation Script

# The GNEVAR dataset collates all the trade agreements listed in the five
# datasets in the manytrade::agreements database. To avoid having duplicate 
# entries in the GNEVAR dataset, `manydata::consolidate()` is used to generate 
# the dataset.
# The GNEVAR dataset contains additional information on the trade agreements
# listed, such as membership conditions and procedures for joining agreements, 
# and increases the precision of Signature dates. These original data are
# derived from the texts of the trade agreements, which are also stored in the
# manytrade::texts database.

# This is a template for importing, cleaning, and exporting data
# ready for many packages universe.

# Stage one: Assembling data

# consolidated version of agreements database
GNEVAR <- manydata::favour(manytrade::agreements, c("GPTAD", "TOTA")) %>% 
  manydata::consolidate("any",
                        "any",
                        "coalesce",
                        key = "manyID") 

# Stage two: Adding membership conditions and procedures columns
AGR_TXT <- manytrade::texts$AGR_TXT
AGR_TXT$Memb.conditions <- manypkgs::code_memberships(AGR_TXT$TreatyText, AGR_TXT$Title, 
                                                      memberships = "condition")
AGR_TXT$Memb.procedures <- manypkgs::code_memberships(AGR_TXT$TreatyText, 
                                                      memberships = "process")
add <- dplyr::select(AGR_TXT, "manyID", "Memb.conditions", "Memb.procedures")
GNEVAR <- dplyr::left_join(GNEVAR, add, by = "manyID")
GNEVAR <- GNEVAR %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Force, AgreementType,
                  DocType, GeogArea, Memb.conditions, Memb.procedures,
                  totaID, gptadID, destaID, labptaID, trendID) %>%
  dplyr::arrange(Beg)

# Add precise dates from texts
AGR_TXT$dates <- lapply(AGR_TXT$TreatyText, function(s){
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

dates <- AGR_TXT %>%
  dplyr::select(manyID, dates) %>%
  dplyr::mutate(dates = as.character(dates))

GNEVAR <- dplyr::left_join(GNEVAR, dates, by = "manyID")

GNEVAR <- GNEVAR %>%
  dplyr::relocate(manyID, Title, Beg, Signature, dates) %>%
  dplyr::mutate(Sign.rev = ifelse(grepl("[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}",
                                         dates, perl = T), dates, NA)) %>%
  dplyr::relocate(manyID, Title, Beg, Signature, Sign.rev) %>%
  dplyr::select(-dates)

# compare dates and replace those in the same year
GNEVAR <- GNEVAR %>%
  dplyr::mutate(Sign.rev = messydates::make_messydate(Sign.rev)) %>%
  dplyr::mutate(Signature = ifelse(!is.na(Sign.rev) & messydates::year(Signature) == messydates::year(Sign.rev), 
                                   Sign.rev, Signature)) %>%
  dplyr::select(-Sign.rev)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GNEVAR available
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
# please run `manypkgs::add_bib(agreements, GNEVAR)`.
manypkgs::export_data(GNEVAR, database = "gnevar", 
                      URL = c("https://www.designoftradeagreements.org/downloads/",
                              "https://wits.worldbank.org/gptad/library.aspx",
                              "https://doi.org/10.1007/s11558-018-9301-z",
                              "http://www.chaire-epi.ulaval.ca/en/trend",
                              "https://github.com/mappingtreaties/tota.git"))
