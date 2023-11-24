#' Lookup regression weight for fitted models
#'
#' This function consults the internal `betas` data frame
#' @param input Elected category
#' @param predictor Elected predictor name
#' @param outcome Elected model name
#' @return One or more regression weights
#' @examples
#' beta_lookup("Meisje", "Geslacht", "overweight-4y")
#' beta_lookup("", "Leeftijd vader", "overweight-4y")
#' @export
beta_lookup <- function(input, predictor, outcome = "overweight-4y") {
  betas <- tab10::betas
  idx <-
    betas$Voorspeller %in% predictor &
    betas$Categorie %in% input &
    betas$outcome %in% outcome
  if (!any(idx)) message("Combination not found: ", outcome, predictor, input)
  betas$Gewicht[idx]
}
