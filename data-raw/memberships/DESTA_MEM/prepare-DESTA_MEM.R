# DESTA_MEM Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.

# Stage one: Collecting data
DESTA_MEM <- readxl::read_excel("data-raw/memberships/DESTA_MEM/DESTA.xlsx")

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'DESTA_MEM' object until the object created
# below (in stage three) passes all the tests.
DESTA_MEM <- as_tibble(DESTA_MEM) %>%
  tidyr::pivot_longer(c("c1":"c91"), names_to = "Member", values_to = "Country", values_drop_na = TRUE) %>%
  #arrange columns containing countries into one column, with each country in rows corresponding to the treaty it is party to
  qData::transmutate(DESTA_ID = `base_treaty`,
                     Title = manypkgs::standardise_titles(name),
                     Signature = manypkgs::standardise_dates(as.character(year)),
                     Force = manypkgs::standardise_dates(as.character(entryforceyear))) %>%
  dplyr::mutate(Beg = dplyr::coalesce(Signature, Force)) %>%
  dplyr::select(DESTA_ID, Country, Title, Beg, Signature, Force) %>% #match ISO to country name
  dplyr::arrange(Beg)

#Add a qID column
DESTA_MEM$qID <- manypkgs::code_agreements(DESTA_MEM, DESTA_MEM$Title, DESTA_MEM$Beg) #6598 duplicated IDs

# Add qID_ref column
qID_ref <- manypkgs::condense_qID(qTrade::agreements)
DESTA_MEM <- dplyr::left_join(DESTA_MEM, qID_ref, by = "qID")

# Re-order the columns
DESTA_MEM <- dplyr::relocate(DESTA_MEM, qID_ref)

# manypkgs includes several functions that should help cleaning
# and standardising your data.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make DESTA_MEM available
# within the qPackage.
manypkgs::export_data(DESTA_MEM, database = "memberships",
                     URL = "https://www.designoftradeagreements.org/downloads/")
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
# run `manypkgs::add_bib(memberships, DESTA_MEM)`.

