#' Code Country Names
#'
#' Standardize country names from other languages.
#' @param name A character vector of country name
#' @return A character vector of country name
#' @examples
#' name <- c("argentine", "albanie", "Bélarus")
#' code_countryname(name)
#' @export
code_countryname <- function(name) {
  # Translates string to ASCII
  name <- stringi::stri_trans_general(name, "Latin-ASCII")
  name <- data.frame(name = as.character(name))
  coment <- data.frame(coment = sapply(countryregex[, 3], function(x) grepl(x, name,
                                                                            ignore.case = TRUE,
                                                                            perl = TRUE) * 1))
  colnames(coment) <- name
  rownames(coment) <- countryregex[, 2]
  out <- apply(coment, 2, function(x) paste(names(x[x == 1])))
  out[out == ""] <- NA
  country <- unname(out)
  country
}

#' Code Abbreviations of Country Names
#' 
#' Insert abbreviations of country names.
#' @param name 
#' @return A character vector of an abbreviation of specified country name
#' @examples
#' name <- c("argentine", "albanie", "Bélarus")
#' code_countryname(name)
#' @export
code_countryabbrv <- function(name) {
  # Translates string to ASCII
  name <- stringi::stri_trans_general(name, "Latin-ASCII")
  name <- data.frame(name = as.character(name))
  coment <- data.frame(coment = sapply(countryregex[, 2], function(x) grepl(x, name,
                                                                            ignore.case = TRUE,
                                                                            perl = TRUE) * 1))
  colnames(coment) <- name
  rownames(coment) <- countryregex[, 1]
  out <- apply(coment, 2, function(x) paste(names(x[x == 1])))
  out[out == ""] <- NA
  abbrv <- unname(out)
  abbrv
}