load_predictions <- function(outcome) {
  tab10::predictions |>
    filter(.data$outcome == !! outcome)
}
