#' agreements database documentation
#'
#' @format The agreements database is a list that contains the
#' following 8 datasets: DESTA, GPTAD, LABPTA, TOTA, TREND, GNEVAR, HUGGO, AIGGO.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{DESTA: }{A dataset with 959 observations and the following
#' 10 variables: manyID, Title, Beg, AgreementType, DocType, GeogArea, Signature, Force, treatyID, destaID.}
#' \item{GPTAD: }{A dataset with 340 observations and the following
#' 10 variables: manyID, Title, Beg, AgreementType, DocType, GeogArea, Signature, Force, treatyID, gptadID.}
#' \item{LABPTA: }{A dataset with 483 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, labptaID.}
#' \item{TOTA: }{A dataset with 450 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, totaID.}
#' \item{TREND: }{A dataset with 729 observations and the following
#' 7 variables: manyID, Title, Beg, Signature, Force, treatyID, trendID.}
#' \item{HUGGO: }{A dataset with 1440 observations and the following
#' 8 variables: manyID, Title, Beg, Signature, Force, treatyID, TreatyText, url.}
#' \item{AIGGO: }{A dataset with 1440 observations and the following
#' 8 variables: manyID, Title, Beg, Signature, Force, accessionC, accessionP, treatyID.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(agreements, messydates::mreport)
#' ```
"agreements"
