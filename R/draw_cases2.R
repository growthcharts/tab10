#' Draws 100 labeled records from the case and prediction vector
#'
#' @param y       Vector of 0 and 1, indicating a non-case and case, respectively
#' @param p       Vector of predicted probabilities. Same length as `y`
#' @param ntab    Total n in the table of 10
#' @param seed    Random generated seed for `set.seed()`
#' @author Stef van Buuren, Aug 2023
#' @examples
#' set.seed(1)
#' y <- rbinom(2716, 1, 0.2)
#' p <- runif(2716, max = 0.5)
#' cc <- tab10:::draw_cases2(y, p)
#'
draw_cases2 <- function(y, p, ntab = 100L, seed = NULL) {
  op <- options(dplyr.summarise.inform = FALSE)
  on.exit(options(op))

  if (ntab == 100L) {
    probs <- seq(0, 1, 0.1)
    correction <- 0.01
    col_height <- 10
  }
  if (ntab == 1000L) {
    probs <- seq(0, 1, 0.01)
    correction <- 0.001
    col_height <- 100
  }

  if (!is.null(seed)) {
    set.seed(seed)
  }

  y <- as.integer(y)
  n <- length(y)
  stopifnot(length(y) == length(p))

  q <- quantile(p, probs = probs)
  q[length(q)] <- q[length(q)] + correction
  df <- data.frame(y = y, p = p) |>
    mutate(g = cut(.data$p, breaks = q, labels = FALSE)) |>
    filter(!is.na(.data$g))

  nc <- df |>
    group_by(.data$g, as.factor(.data$y), .drop = FALSE) |>
    summarise(size = n(),
              n = as.integer(round(sum(.data$y) / n * ntab)),
              gid = cur_group_id()) |>
    mutate(n = ifelse(.data$`as.factor(.data$y)` == "0", 10L - lead(.data$n), .data$n))
  nc <- nc |>
    mutate(y = as.numeric(.data$`as.factor(.data$y)`) - 1)

  # create records for empty g/y combinations in the data
  pad <- nc[nc$size == 0, c("g", "y")]
  pad$p <- NA
  for (i in seq_len(nrow(pad))) {
    pad$p[i] <- sample(df[df$g == pad$g[i] & df$y == (1 - pad$y[i]), "p"], size = 1)
  }
  df <- bind_rows(df, pad)

  draw <- df |>
    group_by(.data$g, .data$y) |>
    dplyr::slice_sample(n = 10L, replace = TRUE) |>
    mutate(gid = cur_group_id(),
           id = 1L:n()) |>
    filter(nc$n[cur_group_id()] > 0 & .data$id %in% 1L:nc$n[cur_group_id()])
  draw
}
