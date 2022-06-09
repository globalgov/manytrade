#' references database documentation
#'
#' @format The references database is a list that contains the
#' following 1 datasets: DESTA_REF.
#' The DESTA_REF dataset traces the treaty lineage of the trade agreements
#'   in the DESTA dataset. The relationship between the trade agreements
#'   (amends/amended by and cites/cited by) is derived from the information in 
#'   the variables `entry_type`, `base_treaty`, and `number` of the original 
#'   DESTA dataset. Trade agreements that are listed as 'protocol or amendment'
#'   are ordered with the 'amends/amended by' relationship with their base treaties, 
#'   while agreements that are listed as 'accession', 'withdrawal', 
#'   or 'consolidated' are ordered with the 'cites/cited by' relationship 
#'   with their base treaties.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{DESTA_REF: }{A dataset with 584 observations and the following
#' 3 variables: treatyID1, RefType, treatyID2.}
#' }
#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(references, skimr::skim_without_charts)
#' ```
"references"
