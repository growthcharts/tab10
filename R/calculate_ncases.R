#' Draws 100 labeled records from the case and prediction vector
#'
#' @inheritParams create_table10
#' @param probs Vector of cut points to define group quantiles
#' @param ntab  Total n in the table of 10
#' @author Stef van Buuren, Aug 2023
draw_cases <- function(y, p, probs = seq(0, 1, 0.1), ntab = 100L) {
  op <- options(dplyr.summarise.inform = FALSE)
  on.exit(options(op))

  y <- as.integer(y)
  n <- length(y)
  stopifnot(length(y) == length(p))

  q <- quantile(p, probs = probs)
  q[length(q)] <- q[length(q)] + 0.01
  df <- data.frame(y = y, p = p) |>
    mutate(g = cut(.data$p, breaks = q, labels = FALSE)) |>
    filter(!is.na(.data$g))
  nc <- df |>
    group_by(.data$g, .data$y) |>
    summarise(n = as.integer(round(sum(.data$y) / n * ntab)),
              gid = cur_group_id()) |>
    mutate(n = ifelse(.data$y == 0L, 10L - lead(.data$n), .data$n))
  draw <- df |>
    group_by(.data$g, .data$y) |>
    dplyr::slice_sample(n = 10L) |>
    mutate(gid = cur_group_id(),
           id = 1L:n()) |>
    filter(nc$n[cur_group_id()] > 0 & .data$id %in% 1L:nc$n[cur_group_id()])
  draw
}
