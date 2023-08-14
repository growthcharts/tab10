#' Table of Ten scripts
#'
#' Script text used to populate Table of Ten fields.
#'
#' @format ## `scripts`
#' A tibble with columns:
#' \describe{
#'   \item{name}{Script name}
#'   \item{outcome}{The outcome of the model}
#'   \item{version}{Character, version number}
#'   \item{language}{Language, ISO 639-1 code}
#'   \item{frame}{Integer, frame number}
#'   \item{show}{Logical, show the frame?}
#'   \item{label}{Label of entry}
#'   \item{text}{The text of the entry}
#' }
"scripts"

#' Datasets with model predictions
#'
#' @format ## `scripts`
#' A tibble with columns:
#' \describe{
#'   \item{outcome}{The outcome of the model}
#'   \item{y}{0 = no overweight 4y, 1 = overweight 4y}
#'   \item{p}{Risk estimate, 0 < p < 1}
#' }
"predictions"
