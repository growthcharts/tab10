#' Table of Ten scripts
#'
#' Script text used to populate Table of Ten fields.
#'
#' @format
#' A tibble with columns:
#' \describe{
#'   \item{name}{Script name}
#'   \item{outcome}{The outcome of the model}
#'   \item{version}{Character, version number}
#'   \item{language}{Language, ISO 639-1 code}
#'   \item{frame}{Integer, frame number}
#'   \item{framename}{Character, frame name}
#'   \item{frameshow}{Logical, show the frame?}
#'   \item{frametext}{The text of the entry}
#' }
"scripts"

#' Datasets with model predictions
#'
#' @format
#' A tibble with columns:
#' \describe{
#'   \item{outcome}{The outcome of the model}
#'   \item{y}{0 = no case, 1 = case}
#'   \item{p}{Risk estimate, 0 < p < 1}
#' }
"predictions"

#' Dataset with processed risk and rank scores
#'
#' Note 1: 100 random draws per outcome
#'
#' Note 2: Generated with seed = 1
#'
#' @format
#' A data frame with columns:
#' \describe{
#'   \item{outcome}{The outcome of the model}
#'   \item{p}{Risk estimate, 0 < p < 1}
#'   \item{pct}{rank}
#' }
"risk_rank_data"

#' Postal codes (4-digits) of The Netherlands with covariates.
#' @format `pc4`
#' A data frame with 4095 rows and 5 columns:
#' \describe{
#'   \item{pc4}{Postal code}
#'   \item{sted}{Urbanicity, 5 levels 1 = low, 5 = high}
#'   \item{woz}{Average WOZ (house) value in postal code}
#'   \item{gemeente2020}{community identifyer}
#'   \item{COROP}{Administrative region (COROP Netherlands)}
#' }
#' @source Taken from a file named `pc4_woz_corop.csv`.
"pc4"

#' Estimated regression weights for predictive models
#' @format `betas`
#' A data frame with 4052 rows and 3 columns:
#' \describe{
#'   \item{outcome}{Model name}
#'   \item{Voorspeller}{Predictor name}
#'   \item{Categorie}{Category for discrete variables. Empty of numerical variables.}
#'   \item{Gewicht}{Estimated regression weight}
#'   \item{Modelterm}{Name of model term in the original model (for checking)}
#' }
#' @source Constructed from models fitted by Mirthe Hendriks (2023) using CBS-linked data.
"betas"

#' Pre-calculated empty BMI chart
#' @format `emptyplot`
#' An object of class `c("gg", "ggplot")`
"emptyplot"

