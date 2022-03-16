#' texts database documentation
#'
#' @format The texts database is a list that contains the
#' following 2 datasets: AGR_TXT, TOTA_TXT.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{AGR_TXT: }{A dataset with 1170 observations and the following
#' 9 variables: manyID, Title, Beg, Signature, Force, treatyID, destaID, gptadID, TreatyText.}
#' \item{TOTA_TXT: }{A dataset with 450 observations and the following
#' 8 variables: manyID, Title, Beg, Signature, Force, TreatyText, treatyID, url.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(texts, skimr::skim_without_charts)
#' ```
"texts"
