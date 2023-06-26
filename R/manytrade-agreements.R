#' agreements database documentation
#'
#' @format The agreements database is a list that contains the
#' following 7 datasets: DESTA, GPTAD, LABPTA, TOTA, TREND, HUGGO, AIGGO.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{DESTA: }{A dataset with 959 observations and the following
#' 10 variables: manyID, treatyID, Title, Begin, AgreementType, DocType,
#' GeogArea, Signature, Force, destaID.}
#' \item{GPTAD: }{A dataset with 340 observations and the following
#' 10 variables: manyID, treatyID, Title, Begin, AgreementType, DocType,
#' GeogArea, Signature, Force, gptadID.}
#' \item{LABPTA: }{A dataset with 483 observations and the following
#' 7 variables: manyID, treatyID, Title, Begin, Signature, Force, labptaID.}
#' \item{TOTA: }{A dataset with 442 observations and the following
#' 7 variables: manyID, treatyID, Title, Begin, Signature, Force, totaID.}
#' \item{TREND: }{A dataset with 710 observations and the following
#' 7 variables: manyID, treatyID, Title, Begin, Signature, Force, trendID.}
#' \item{HUGGO: }{A dataset with 548 observations and the following
#' 10 variables: manyID, treatyID, Title, Begin, Signature, Force, End, url,
#' TreatyTextStatus, Coder.}
#' \item{AIGGO: }{A dataset with 1389 observations and the following
#' 8 variables: manyID, treatyID, Title, Begin, Signature, Force, accessionC,
#' accessionP.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(agreements, messydates::mreport)
#' ```
"agreements"
