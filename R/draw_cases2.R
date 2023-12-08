#' Draws 100 labeled records from the case and prediction vector
#'
#' @param y       Vector of 0 and 1, indicating a non-case and case, respectively
#' @param p       Vector of predicted probabilities. Same length as `y`
#' @param ntab    Total n in the table of 10
#' @param seed    Random generated seed for `set.seed()`
#' @author Stef van Buuren, Aug 2023
#' @examples
#' pred <- tab10::predictions
#' y <- pred[pred$outcome == "preterm-32w", "y"]
#' p <- pred[pred$outcome == "preterm-32w", "p"]
#' cc <- tab10:::draw_cases2(y, p, ntab = 10000)
#' sum(cc$y)
draw_cases2 <- function(y, p, ntab = 10000L, seed = NULL) {
  op <- options(dplyr.summarise.inform = FALSE)
  on.exit(options(op))

  if (ntab == 100L) {
    probs <- seq(0, 1, 0.1)
    correction <- 0.01
    row_height <- 10
  }
  if (ntab == 10000L) {
    probs <- seq(0, 1, 0.01)
    correction <- 0.001
    row_height <- 100
  }

  if (!is.null(seed)) {
    set.seed(seed)
  }

  y <- as.integer(y)
  n <- length(y)
  stopifnot(length(y) == 10000)
  stopifnot(length(y) == length(p))

  q <- quantile(p, probs = probs)
  q[1L] <- q[1L] - correction
  q[length(q)] <- q[length(q)] + correction
  df <- data.frame(y = y, p = p) |>
    mutate(g = cut(.data$p, breaks = q, labels = FALSE)) |>
    filter(!is.na(.data$g))

  draw <- df |>
    arrange(.data$p) |>
    mutate(g = rep(0:99, each = 100)) |>
    group_by(.data$g, .data$y) |>
    mutate(gid = cur_group_id(),
           id = 1:n())
  draw
}

