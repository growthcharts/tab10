load_predictions <- function(outcome) {
  table10::predictions |>
    filter(.data$outcome == !! outcome)
}
