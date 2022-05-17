#' texts database documentation
#'
#' @format The texts database is a list that contains the
#' following 1 datasets: AGR_TXT.
#' To avoid overlaps in texts stored, AGR_TXT is based on a consolidated 
#' version of the agreements database, to avoid duplicate entries. 
#' Texts from the TOTA database (Alschner, Seiermann, and Skougarevskiy, 2017) 
#' are given precedence.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{AGR_TXT: }{A dataset with 1740 observations and the following
#' 13 variables: manyID, Title, Beg, Signature, Force, treatyID, totaID, 
#' gptadID, trendID, labptaID, destaID, TreatyText, url.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(texts, skimr::skim_without_charts)
#' ```
"texts"
