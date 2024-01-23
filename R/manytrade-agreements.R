#' agreements datacube documentation
#'
#' @format The agreements datacube is a list that contains the
#' following 7 datasets: DESTA, GPTAD, LABPTA, TOTA, TREND, HUGGO, AIGGO.
#' For more information and references to each of the datasets used,
#' please use the `manydata::call_sources()` and
#' `manydata::compare_dimensions()` functions.
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
#' \item{HUGGO: }{A dataset with 610 observations and the following
#' 11 variables: manyID, treatyID, Title, Begin, Signature, Force, End, url,
#' Citation, TreatyText, Coder.}
#' \item{AIGGO: }{A dataset with 1389 observations and the following
#' 8 variables: manyID, treatyID, Title, Begin, Signature, Force, accessionC,
#' accessionP.}
#' }
#' @source
#' \itemize{
#' \item{DESTA: }{
#' A. Dür, L. Baccini, and M. Elsig.
#' “The Design of International Trade Agreements: Introducing a NewDatabase”.
#' In: _The Review of International Organizations_ 9.3 (2014), pp. 353-375.}
#' \item{GPTAD: }{
#' W. B. Group. _Global Preferential Trade Agreement Database (GPTAD)_.
#' Online database. publisher: WorldBank Group. 2014.
#' <https://wits.worldbank.org/gptad/library.aspx>.}
#' \item{LABPTA: }{
#' D. Raess, A. Dür, and D. Sari.
#' “Protecting labor rights in preferential trade agreements: The role of trade unions, left governments, and skilled labor”.
#' In: _The Review of International Organizations_ 2.13(2018), pp. 143-162.
#' DOI: 10.1007/s11558-018-9301-z.}
#' \item{TOTA: }{
#' W. Alschner, J. Seiermann, and D. Skougarevskiy.
#' _Text-as-data analysis of preferential tradeagreements: Mapping the PTA landscape_.
#' 2017. <https://github.com/mappingtreaties/tota.git>.}
#' \item{TREND: }{
#' J. Morin, A. Dür, and L. Lechner.
#' “Mapping the trade and environment nexus: Insights from a newdataset”.
#' In: _Global Environmental Politics_ 18.1 (2018), pp. 122-139.}
#' \item{HUGGO: }{
#' J. Hollway. Trade agreements for manydata. 2021.}
#' \item{AIGGO: }{
#' J. Hollway. Trade agreements for manydata. 2021.}
#' }
#' @section URL:
#' \itemize{
#' \item{DESTA: }{
#' \url{https://www.designoftradeagreements.org/downloads/}
#' }
#' \item{GPTAD: }{
#' \url{https://wits.worldbank.org/gptad/library.aspx}
#' }
#' \item{LABPTA: }{
#' \url{https://doi.org/10.1007/s11558-018-9301-z}
#' }
#' \item{TOTA: }{
#' \url{https://github.com/mappingtreaties/tota.git}
#' }
#' \item{TREND: }{
#' \url{http://www.chaire-epi.ulaval.ca/en/trend}
#' }
#' \item{HUGGO: }{Hand-coded data by the GGO team}
#' \item{AIGGO: }{Machine-generated data by the GGO team}
#' }
#' @section Mapping:
#' \itemize{
#' \item{DESTA: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | base_treaty | destaID |
#' | name | Title |
#' | year | Signature |
#' | entryforceyear | Force |
#' | typememb | DocType |
#' | entry_type | AgreementType |
#' | regioncon | GeogArea |
#' 
#' }
#' \item{GPTAD: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | Common.Name | Title |
#' | Date.of.Signature | Signature |
#' | Date.of.Entry.into.Force | Force |
#' | Type | DocType |
#' | Type | AgreementType |
#' | Type | GeogArea |
#' 
#' }
#' \item{LABPTA: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | Number | labptaID |
#' | Name | Title |
#' | year | Signature |
#' | year | Force |
#' 
#' }
#' \item{TOTA: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | name | Title |
#' | date_signed | Signature |
#' | date_into_force | Force |
#' 
#' }
#' \item{TREND: }{
#' Variable Mapping
#' 
#' |  *from*  | *to*
#' |:------------:|:------------:|
#' | Trade.Agreement | Title |
#' | Year | Signature |
#' | Year | Force |
#' 
#' }
#' }
#' @md
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(agreements, messydates::mreport)
#' ```
"agreements"
