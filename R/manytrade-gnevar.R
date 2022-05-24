#' gnevar database documentation
#'
#' @format The gnevar database is a list that contains the
#' following 1 datasets: GNEVAR.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{GNEVAR: }{A dataset with 67723 observations and the following
#' 16 variables: manyID, Title, Beg, Signature, Force, AgreementType,
#' DocType, GeogArea, Memb.conditions, Memb.procedures, totaID, gptadID,
#' destaID, labptaID, trendID, treatyID.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(gnevar, skimr::skim_without_charts)
#' ```
"gnevar"
