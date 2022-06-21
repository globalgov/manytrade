#' texts database documentation
#'
#' @format The texts database is a list that contains the
#' following 1 datasets: GNEVAR_TXT.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{GNEVAR_TXT: }{A dataset with 1440 observations and the following
#' 13 variables: manyID, Title, Beg, Signature, Force, totaID, gptadID, destaID,
#' labptaID, trendID, treatyID, TreatyText, url.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(texts, skimr::skim_without_charts)
#' ```
"texts"
