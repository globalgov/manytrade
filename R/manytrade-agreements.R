#' agreements database documentation
#'
#' @format The agreements database is a list that contains the
#' following 4 datasets: DESTA, TREND, LABPTA, GPTAD.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{DESTA: }{A dataset with 987 observations and the following
#' 11 variables: manyID, Title, Beg, D, L, J, Signature, Force, treatyID, DESTA_ID, WTO.}
#' \item{TREND: }{A dataset with 730 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, TREND_ID.}
#' \item{LABPTA: }{A dataset with 483 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, LABPTA_ID.}
#' \item{GPTAD: }{A dataset with 346 observations and the following
#' 9 variables: manyID, Title, Beg, D, L, Signature, Force, treatyID, GPTAD_ID.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(agreements, skimr::skim_without_charts)
#' ```
"agreements"
