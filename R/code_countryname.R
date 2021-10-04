#' Code Country Names
#' 
#' Standardize country names from other languages, abbreviations, or codes
#'
#' @param name A character vector of country name
#'
#' @return A character vector of country name
#' @export
#'
#' @examples
code_countryname <- function(name) {
  
  name <- as.character(name)
  coment <- sapply(countryregex[, 3], function(x) grepl(x, name,
                                                      ignore.case = T,
                                                      perl = T) * 1)
  colnames(coment) <- countryregex[, 2]
  rownames(coment) <- name
  out <- apply(coment, 1, function(x) paste(names(x[x == 1])))
  out[out == ""] <- NA
  country <- unname(out)
  country
}
