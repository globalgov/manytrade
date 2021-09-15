# qTrade 0.0.1

2021-09-15

## Data

* Closes #2 by adding GPTAD dataset
* Closes #4 by adding LABPTA dataset
* Cleaned datasets by standardizing titles and dates
* Included variables for agreement type, document type, and listing in WTO
* Added tests for LABPTA and GPTAD datasets with `qCreate::export_data()`

2021-09-01

## Package

* Closed #7 by setting up qTrade package using `qCreate::setup_package()`
  * Added core package files
  * Added `.github` folder and files
  * Added `tests` folder and files
* Modified description file to add pointblank as dependency
  
## Data

* Imported initial `DESTA` and `TREND` datasets in qTrade, cleaned and exported into databases.
* Closed #1 by adding `DESTA` dataset
* Closed #3 by adding `TREND` dataset
* Cleaned datasets by standardising the dates
* Added `standardise_titles()` function to the Title variables
* Added tests for `DESTA` and `TREND` datasets with `qCreate::export_data()`

