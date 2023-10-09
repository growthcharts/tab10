#' Create frame data
#'
#' Creates a data frame with 800 rows divided over 8 animation frames
#' @param outcome Character
#' @param seed    Seed value
#' @export
create_framedata <- function(outcome = "overweight-4y",
                             seed = NULL) {
  yp <- tab10::predictions |>
    filter(.data$outcome == !! outcome)
  script <- tab10::scripts |>
    filter(.data$outcome == !! outcome & .data$last)
  yp <- draw_cases(y = as.integer(yp$y), p = yp$p, seed = seed)
  framedata <- make_coordinates(script = script,
                                case = as.logical(yp$y),
                                p = yp$p)
  framedata$outcome <- outcome
  return(framedata)
}
