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
