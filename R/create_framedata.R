#' Create frame data
#'
#' Creates a data frame with 800 rows divided over 8 animation frames
#' @param outcome Character
#' @param seed    Seed value
#' @param ntab    Integer, either 100 or 1000
#' @export
create_framedata <- function(outcome = "overweight-4y",
                             seed = NULL,
                             ntab = 100) {
  yp <- tab10::predictions |>
    filter(.data$outcome == !! outcome)
  script <- tab10::scripts |>
    filter(.data$outcome == !! outcome & .data$last)
  yp <- draw_cases2(y = as.integer(yp$y), p = yp$p, seed = seed, ntab = ntab)
  framedata <- make_coordinates(script = script,
                                case = as.logical(yp$y),
                                p = yp$p,
                                ntab = ntab)
  framedata$outcome <- outcome
  return(framedata)
}
