# HUGGO_MEM Preparation Script
# This data contains consolidated membership data from the memberships database,
# specifically the DESTA_MEM and GPTAD_MEM datasets, as well as handcoded data
# to fill in the gaps in these datasets.

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.

# Stage one: Collecting data
HUGGO_MEM <- manydata::consolidate(manytrade::memberships,
                                   key= c("manyID", "stateID"))

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'HUGGO_MEM' object until the object created
# below (in stage three) passes all the tests.
HUGGO_MEM <- HUGGO_MEM %>%
  dplyr::relocate(manyID, stateID, Title, Beg, Signature, Force, StateName) %>%
  dplyr::mutate(across(everything(),
                       ~stringr::str_replace_all(., "^NA$", NA_character_))) %>% 
  dplyr::distinct() %>%
  dplyr::mutate(Signature = messydates::as_messydate(Signature),
                Force = messydates::as_messydate(Force),
                Beg = messydates::as_messydate(Beg)) %>%
  dplyr::arrange(Beg)

# Correcting HUGGO_MEM using agreements$HUGGO
# Load data
HUGGO_MEM <- memberships$HUGGO_MEM
HUGGO <- agreements$HUGGO

# Add new column to HUGGO_MEM to track progress 1 = data corrected
HUGGO_MEM$changes <- NA

# Step 1: Find matching manyIDs in both dataframes
matching_manyIDs <- intersect(HUGGO$manyID, HUGGO_MEM$manyID)

# Step 2: Loop through the matching manyIDs and update the rows in HUGGO_MEM
for (i in matching_manyIDs) {
  # Get the rows in HUGGO and HUGGO_MEM that match the current manyID
  hug_row <- HUGGO[HUGGO$manyID == i, ]
  mem_rows <- HUGGO_MEM[HUGGO_MEM$manyID == i, ]
  
  # Update each matching row in HUGGO_MEM with values from HUGGO
  for (j in 1:nrow(mem_rows)) {
    # Update only columns that exist in both dataframes
    common_cols <- intersect(names(hug_row), names(mem_rows[j, ]))
    mem_rows[j, common_cols] <- hug_row[, common_cols]
    
    # Update the 'changes' column to 1
    mem_rows[j, "changes"] <- 1
  }
  
  # Update the rows in HUGGO_MEM
  HUGGO_MEM[HUGGO_MEM$manyID == i, ] <- mem_rows
}

# identify missing changes
HUGGO_MEM$changes <- ifelse(is.na(HUGGO_MEM$changes), 0, HUGGO_MEM$changes)




# Stage three: Connecting data
# Next run the following line to make HUGGO_MEM available
# within the package.
manypkgs::export_data(HUGGO_MEM, database = "memberships",
                      URL = "Hand-coded by the GGO team")
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
# run `manypkgs::add_bib("memberships", "HUGGO_MEM")`.
