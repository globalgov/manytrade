# manytrade 0.1.1

2022-03-22

## Package

* Closed #19 by merging `manytrade::code_countryname()` functionality into `manystates::code_states()`.
* Fixed #21 by redirecting reference to master branch to main branch in pushrelease workflow.
* Closed #14 by adding codefactor and lintr to package workflows and as badges.

## Data

* Fixed #23 by amending regex list stored in package and modifying `manystates::code_states()` to return original names if unmatched in regex list.
* Fixed #22 and #24 by renaming variables in databases.
  * Renamed "treaty_ID" and "many_ID" across all databases to "treatyID" and "manyID" respectively.
  * Renamed "L", "D", and "J" in the agreements database "DocType", "AgreementType", and "GeogArea" respectively.
  * Reformatted "Beg", "Signature", "Force" variables from YYYY format to YYYY-MM-DD format in `DESTA`, `TREND`, `LABPTA` datasets to be consistent across the `agreements` database.
  * Recoded `DocType` variable in `GPTAD` dataset to remove ambiguity in coding
  * Added `GeogArea` variable in `GPTAD` dataset to remove
  * Checked for duplicate entries in `agreements` and `memberships` datasets using `manyID`, `treatyID`, `CountryID`, `CountryName` and `Beg` variables and removed duplicate entries

# manytrade 0.1.0

2021-12-03

## Package
* Closed #16 by changing name from qTrade to manytrade
* Closed #10 by updating wording in ReadME files and added new logo with new name

## Data
* Added `references` database and imported treaty lineage data using `DESTA` dataset
* Renamed `qID` column to `treaty_ID` for all datasets in `agreements`, 
`memberships` and `references` databases
* Added `many_ID` column to `agreements`, `memberships` and `references` databases 
using `manypkgs::condense_agreements()`

# qTrade 0.0.1

2021-10-07

## Package

* Closed #7 by setting up qTrade package using `qCreate::setup_package()`
  * Added core package files
  * Added `.github` folder and files
  * Added `tests` folder and files
* Modified description file to add pointblank as dependency
* Closed #12 by adding package website

## Data

* Imported initial `DESTA` and `TREND` datasets in qTrade, cleaned and exported into agreements database.
* Closed #1 by adding `DESTA` dataset to agreements database
* Closed #3 by adding `TREND` dataset to agreements database
* Closed #2 by adding `GPTAD` dataset to agreements database
* Closed #4 by adding `LABPTA` dataset to agreements database
* Cleaned datasets by standardizing titles and dates in databases using `standardise_titles()` and  `standardise_dates()` functions
* Included variables for agreement type, document type, and listing in WTO for datasets in agreements database
* Added tests for datasets with `qCreate::export_data()` in agreements database
* Arranged DESTA and GPTAD datasets to reflect treaty membership data by country
* Added tests for DESTA and GPTAD datasets with `qCreate::export_data()` in memberships database

## Functions
* Added `code_countryname()` function and tests

