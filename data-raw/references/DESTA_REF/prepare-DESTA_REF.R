# DESTA_REF Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the qPackage.

# Stage one: Collecting data
DESTA_REF <- readxl::read_excel("data-raw/references/DESTA_REF/DESTA.xlsx")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA_REF' object until the object created
# below (in stage three) passes all the tests.
DESTA_REF <- as_tibble(DESTA_REF) %>%
  dplyr::filter(typememb != "5" , typememb != "6",  typememb != "7", entry_type != "accession", entry_type != "withdrawal") %>%
  #categories removed because they relate to changes in membership that are reflected in the memberships database
  qData::transmutate(DESTA_ID = `base_treaty`,
                     Title = manypkgs::standardise_titles(name)) %>%
  dplyr::mutate(beg = dplyr::coalesce(year, entryforceyear)) %>%
  dplyr::arrange(beg) %>%
  qData::transmutate(Beg = manypkgs::standardise_dates(as.character(beg))) %>%
  dplyr::filter(entry_type=="protocol or amendment" | entry_type=="base_treaty")

# add qID column
# DESTA_REF$qID <- manypkgs::code_agreements(DESTA_REF, DESTA_REF$Title, DESTA_REF$Beg) # 1 duplicate for CARIFTA (first entry no EIF date)
destaid<- qTrade::agreements$DESTA %>%
  dplyr::select(Title, DESTA_ID, qID)

DESTA_REF <- dplyr::left_join(DESTA_REF, destaid, by = c("Title", "DESTA_ID")) %>%
  dplyr::rename(qID1 = "qID") %>%
  dplyr::select(number, DESTA_ID, qID1, entry_type, Beg) %>%
  dplyr::group_by(DESTA_ID) %>%
  dplyr::mutate(num_rows = sum(dplyr::n())) %>% 
  dplyr::mutate(RefType = ifelse(num_rows > 1, "Amends", "")) %>%
  dplyr::mutate(RefType = ifelse(entry_type == "base_treaty", dplyr::recode(RefType, "Amends" = "Amended by"), RefType))

# add qID2 column
DESTA_REF <- DESTA_REF %>%
  dplyr::mutate(idref = ifelse(num_rows > 1 & RefType == "Amends", "a", "b")) %>%
  dplyr::mutate(idref = ifelse(RefType == "", NA, idref))

ref <- DESTA_REF %>%
  dplyr::select(DESTA_ID, qID1, num_rows, RefType) %>%
  dplyr::group_by(DESTA_ID) %>%
  dplyr::mutate(idref = ifelse(num_rows > 1 & RefType == "Amends", "b", "a")) %>%
  dplyr::mutate(idref = ifelse(RefType == "", NA, idref)) %>%
  dplyr::rename(qID2 = "qID1") %>%
  dplyr::mutate(qID2 = ifelse(idref == "NA", NA, qID2)) %>%
  dplyr::select(DESTA_ID, idref, qID2)

DESTA_REF <- dplyr::left_join(DESTA_REF, ref, by = c("DESTA_ID", "idref")) %>%
  dplyr::ungroup() %>%
  dplyr::select(qID1, RefType, qID2) #check matches, seems to add more entries?

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA_REF available
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
# # This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence
# to certain standards.You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows)
# to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and may require
# you to return to stage two and further clean, standardise, or wrangle
# your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please note that the export_data() function requires a .bib file to be
# present in the data_raw folder of the package for citation purposes.
# Please make sure that you have permission to use the dataset.
# To add a template of .bib file to package,
# run `manypkgs::add_bib(references, DESTA_REF)`.
manypkgs::export_data(DESTA_REF, database = "references",
                     URL = "https://www.designoftradeagreements.org/downloads/")