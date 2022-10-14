# manytrade 0.2.0

2022-10-14

## Data
* Added `HUGGO` and `AIGGO` datasets to the `agreements` database.
  * `HUGGO` dataset contains manually coded or verified data and treaty texts,
  replacing the `GNEVAR_TXT` dataset in the texts database.
  * `AIGGO` dataset contains programatically coded information on text treaties
  such as accession conditions and procedures that were coded using `manypkgs::code_accession()`,
  replacing the `GNEVAR` dataset.
* Deleted texts database since all treaty texts are now stored in `HUGGO`.
* Treaty texts were cleaned again using the updated `manypkgs::standardise_treaty_text()`.

# manytrade 0.1.2

2022-07-13

## Data
* Added `GNEVAR` dataset to `agreements` database.
  * The`GNEVAR` dataset builds on existing data in the agreements database 
  (from GPTAD, DESTA, LABPTA, and TREND datasets), adding variables for 
  membership conditions and membership procedures using
  `manypkgs::code_accession_terms()` and more precise dates of signature
  for trade agreements (see bullet point below).
  * Closed #6 by adding more precise dates of signature (in YYYY-MM-DD format) 
  to GNEVAR dataset. These dates are extracted from trade agreements texts 
  stored in the `texts` database, and improve on the dates in the `DESTA`, 
  `LABPTA`, and `TREND` datasets that only contain the year of signature 
  and entry into force. Dates from `TOTA` and `GPTAD` datasets are retained
  since they are precise (YYYY-MM-DD format).
* Added `texts` database with trade agreements texts.
  * Closed #17 by adding texts for trade agreements listed in the `agreements` database. 
  To avoid overlaps, the texts are added to a combined `GNEVAR_TXT` dataset.
  * Closed #9 by incorporating TOTA database to the `GNEVAR_TXT` dataset in the 
  `texts` database and added metadata to `TOTA` dataset in `agreements` database.
* Changed class from 'messydt' to 'mdate' for `Beg`, `Signature`, and `Force` 
variables in datasets in `agreements`, `memberships`, and `texts` databases.
* Overhaul of `DESTA_REF` dataset in `references` database. The dataset traces
the relationship (amends or cites) between the trade agreements in the original DESTA dataset.

# manytrade 0.1.1

2022-03-23

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

