#' agreements database documentation
#'
#' @format The agreements database is a list that contains the
#' following 4 datasets: TREND, LABPTA, GPTAD, DESTA.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{TREND: }{A dataset with 729 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, trendID.}
#' \item{LABPTA: }{A dataset with 483 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, labptaID.}
#' \item{GPTAD: }{A dataset with 340 observations and the following
#' 10 variables: manyID, Title, Beg, AgreementType, DocType, GeogArea, 
#' Signature, Force, treatyID, gptadID.}
#' \item{DESTA: }{A dataset with 959 observations and the following
#' 10 variables: manyID, Title, Beg, AgreementType, DocType, GeogArea, 
#' Signature, Force, treatyID, destaID.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(agreements, skimr::skim_without_charts)
#' ```
"agreements"
