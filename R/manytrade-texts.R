#' texts database documentation
#'
#' @format The texts database is a list that contains the
#' following dataset: TOTA_TXT.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{TOTA_TXT: }{A dataset with 450 observations and the following
#' 8 variables: manyID, Title, Beg, Signature, Force, TreatyText, treatyID, url.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(texts, skimr::skim_without_charts)
#' ```
"texts"
