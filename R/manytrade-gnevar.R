#' gnevar database documentation
#'
#' @format The gnevar database is a list that contains the
#' following 1 datasets: GNEVAR.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{GNEVAR: }{A dataset with 4447 observations and the following
#' 16 variables: manyID, Title, Beg, AgreementType, DocType, GeogArea,
#' Signature, Force, treatyID, destaID, gptadID, labptaID, trendID, totaID,
#' Memb.conditions, Memb.procedures.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(gnevar, skimr::skim_without_charts)
#' ```
"gnevar"
