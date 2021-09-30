# qTrade 0.0.1

2021-10-01

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

