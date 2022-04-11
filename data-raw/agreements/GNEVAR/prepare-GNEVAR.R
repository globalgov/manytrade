# GNEVAR Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for many packages universe.

# Stage one: Assembling data

# consolidated version of agreements database
GNEVAR <- manydata::favour(manytrade::agreements, "GPTAD") %>% 
  manydata::consolidate("any",
                        "any",
                        "coalesce",
                        key = "manyID")
# add TOTA database agreements
GNEVAR <- dplyr::full_join(GNEVAR, manytrade::texts$TOTA_TXT,
                           by = c("manyID", "Title", "Beg", "Signature", "Force", "treatyID"))

GNEVAR <- GNEVAR %>%
  dplyr::select(-"TreatyText", -"url") %>%
  dplyr::relocate("manyID", "Title", "Beg", "Signature", "Force", 
                  "AgreementType", "DocType", "GeogArea")

# Stage two: Adding membership conditions and procedures columns
TOTA_TXT <- manytrade::texts$TOTA_TXT
TOTA_TXT$Memb.conditions <- manypkgs::code_memberships(TOTA_TXT$TreatyText, 
                                                       TOTA_TXT$Title, 
                                                       memberships = "condition")
TOTA_TXT$Memb.procedures <- manypkgs::code_memberships(TOTA_TXT$TreatyText, 
                                                       memberships = "process")
TOTA_TXT <- dplyr::select(TOTA_TXT, "manyID", "totaID", "Memb.conditions", "Memb.procedures")
GNEVAR <- dplyr::left_join(GNEVAR, TOTA_TXT,
                            by = c("manyID", "totaID"))

AGR_TXT <- manytrade::texts$AGR_TXT
AGR_TXT$Memb.conditions <- manypkgs::code_memberships(AGR_TXT$TreatyText, 
                                                      AGR_TXT$Title, 
                                                      memberships = "condition")
AGR_TXT$Memb.procedures <- manypkgs::code_memberships(AGR_TXT$TreatyText, 
                                                       memberships = "process")
AGR_TXT <- dplyr::select(AGR_TXT, "manyID", "gptadID", "destaID", "labptaID", 
                         "trendID", "Memb.conditions", "Memb.procedures")
GNEVAR <- dplyr::left_join(GNEVAR, AGR_TXT,
                           by = c("manyID", "gptadID", "destaID", "labptaID", 
                                  "trendID", "Memb.conditions", "Memb.procedures"))

GNEVAR <- GNEVAR %>%
  dplyr::arrange(Beg)

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
manypkgs::export_data(GNEVAR, database = "agreements", 
                      URL = c("https://www.designoftradeagreements.org/downloads/",
                              "https://wits.worldbank.org/gptad/library.aspx",
                              "https://doi.org/10.1007/s11558-018-9301-z",
                              "http://www.chaire-epi.ulaval.ca/en/trend",
                              "https://github.com/mappingtreaties/tota.git"))
