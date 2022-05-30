#' texts database documentation
#'
#' @format The texts database is a list that contains the
#' following 1 datasets: AGR_TXT.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{AGR_TXT: }{A dataset with 1503 observations and the following
#' 13 variables: manyID, Title, Beg, Signature, Force, totaID, gptadID,
#' trendID, labptaID, treatyID, destaID, TreatyText, url.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(texts, skimr::skim_without_charts)
#' ```
"texts"
