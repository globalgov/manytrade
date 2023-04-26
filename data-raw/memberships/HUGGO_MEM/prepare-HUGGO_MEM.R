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


# Correcting data for rows that have matching title + year date
# add a new column to HUGGO_MEM
HUGGO_MEM$HUGGO_row <- NA

# loop through each row in HUGGO_MEM
for(i in seq(nrow(HUGGO_MEM))) {
  # check if the changes column is 0 and if the Title value in HUGGO_MEM exists in the Title column of HUGGO
  if(HUGGO_MEM$changes[i] == 0 && HUGGO_MEM$Title[i] %in% HUGGO$Title) {
    # find the row number in HUGGO where the Title matches
    match_row <- match(HUGGO_MEM$Title[i], HUGGO$Title)
    # check if the Signature of HUGGO_MEM and HUGGO match for the first 4 digits and are not missing
    if(!is.na(HUGGO_MEM$Signature[i]) && !is.na(HUGGO$Signature[match_row]) && substr(HUGGO_MEM$Signature[i], 1, 4) == substr(HUGGO$Signature[match_row], 1, 4)) {
      # if all conditions are met, record the row number in HUGGO_MEM's new column
      HUGGO_MEM$HUGGO_row[i] <- match_row
      
      # update Signature and Force columns in HUGGO_MEM
      HUGGO_MEM$Signature[i] <- HUGGO$Signature[match_row]
      HUGGO_MEM$Force[i] <- HUGGO$Force[match_row]
      
      # update changes column in HUGGO_MEM
      HUGGO_MEM$changes[i] <- 1
    }
  }
}

# remove HUGGO_row column
HUGGO_MEM <- subset(HUGGO_MEM, select = -HUGGO_row)

# Create a new column in HUGGO_MEM that indicates if manyID exists in HUGGO when changes=0
HUGGO_MEM$manyID_in_HUGGO <- ifelse(HUGGO_MEM$changes != 0, NA, ifelse(HUGGO_MEM$manyID %in% HUGGO$manyID, TRUE, FALSE))

# Update the rows in HUGGO_MEM where manyID exists in HUGGO
affected_rows <- !is.na(HUGGO_MEM$manyID_in_HUGGO) & HUGGO_MEM$manyID_in_HUGGO

if (sum(affected_rows) > 0) {
  HUGGO_MEM$Signature[affected_rows] <- HUGGO$Signature[match(HUGGO_MEM$manyID[affected_rows], HUGGO$manyID)]
  HUGGO_MEM$Force[affected_rows] <- HUGGO$Force[match(HUGGO_MEM$manyID[affected_rows], HUGGO$manyID)]
  HUGGO_MEM$changes[affected_rows] <- 1
}

# remove manyID_in_HUGGO
HUGGO_MEM <- subset(HUGGO_MEM, select = -manyID_in_HUGGO)

# create subset of agreements to be manually checked and coded (save as.csv)
HUGGO_MEM_changes_0 <- subset(HUGGO_MEM, changes == 0)

write.csv(HUGGO_MEM_changes_0, file = "HUGGO_MEM_changes_0.csv", row.names = FALSE)

# create dataframe with identified corresponding manyIDs between HUGGO and HUGGO_MEM

HUGGO_MEMIDS <- data.frame(
  HUGGO_MEMID = c("ECISRL_1975O", "ECLBNN_1977O", "STPTEO_1980A", "LAO-THA[LAS]_1991O", "ERPNEA_1992O", "RUS-TJK[RSS]_1992O", "RUS-UZB[RSS]_1992O", "ECSLVK_1993O", "RUS-UKR[RSU]_1993O", "MDA-ROU[MLN]_1994O", "GEO-RUS[RSS]_1994O", "ECESTN_1994O", "ECLATV_1995O", "ECISRL_1995O", "CNTADR_1998O", "ARE-JOR[UAE]_2000O", "MKD-UKR[FYU]_2001O", "BIH-MKD[BHM]_2002O", "MEX-URY[NA]_2004O", "PSE-TUR[PLS]_2004O", "ALBNES_2006O", "ELSLHT_2007O", "CAN-PAN[NA]_2009O", "ECJAPN_2018O"),
  HUGGOID = c("ECISRL_1975O:ECISRL_1970A", "ECLBNN_1977O:ECLBNC_1977A", "SPRTEC_1980A", "LAO-THA[LPD]_1991O", "EEA_1992O", "RUS-TJK[RSF]_1992O", "RUS-UZB[RSF]_1992O", "ECSLRE_1993A", "RUS-UKR[URF]_1993O", "MDA-ROU[MLD]_1994O", "GEO-RUS[RSF]_1994O", "ECESTN_1994O:ECESTN_1994A", "ECLTVE_1995A", "EUE-ISR[NA]_1995O", "DMNRCA_1998O", "ARE-JOR[NA]_2000O", "MKD-UKR[UYM]_2001O", "BIH-MKD[MCD]_2002O", "MEX-URY[NA]_2003O", "PSE-TUR[PLA]_2004O", "ECALBN_2006O", "ELSHCT_2007O", "CAN-PAN[NA]_2010O", "ECJAPN_2017O")
)
# Add Signature, Force, Title to HUGGO_MEMIDS
HUGGO_MEMIDS$Title <- NA
HUGGO_MEMIDS$Signature <- NA
HUGGO_MEMIDS$Force <- NA

# loop through unique manyIDs in HUGGO_MEMIDS
for (i in unique(HUGGO_MEMIDS$HUGGOID)) {
  
  # identify rows in HUGGO and HUGGO_MEMIDS with matching manyID
  hugo_row <- HUGGO$manyID == i
  memids_row <- HUGGO_MEMIDS$HUGGOID == i
  
  # extract Title, Signature, and Force values from HUGGO and insert into HUGGO_MEMIDS
  HUGGO_MEMIDS[memids_row, "Title"] <- HUGGO[hugo_row, "Title"]
  HUGGO_MEMIDS[memids_row, "Signature"] <- HUGGO[hugo_row, "Signature"]
  HUGGO_MEMIDS[memids_row, "Force"] <- HUGGO[hugo_row, "Force"]
}
# remove HUGGOID column
HUGGO_MEMIDS <- HUGGO_MEMIDS %>% select(-HUGGOID)

HUGGO_MEMIDS$changes <- 1
HUGGO_MEMIDS <- HUGGO_MEMIDS %>%
  rename(manyID = HUGGO_MEMID)

# find matching rows
match_rows <- which(HUGGO_MEM$manyID %in% HUGGO_MEMIDS$manyID)

# loop through matching manyID values
for (id in unique(HUGGO_MEM$manyID[match_rows])) {
  # find rows in HUGGO_MEM and HUGGO_MEMIDS with matching manyID
  mem_rows <- which(HUGGO_MEM$manyID == id)
  id_rows <- which(HUGGO_MEMIDS$manyID == id)
  # replace values in HUGGO_MEM with values from HUGGO_MEMIDS
  HUGGO_MEM$Signature[mem_rows] <- HUGGO_MEMIDS$Signature[id_rows]
  HUGGO_MEM$Force[mem_rows] <- HUGGO_MEMIDS$Force[id_rows]
  HUGGO_MEM$Title[mem_rows] <- HUGGO_MEMIDS$Title[id_rows]
  HUGGO_MEM$changes[mem_rows] <- HUGGO_MEMIDS$changes[id_rows]
}


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
