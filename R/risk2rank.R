risk2rank <- function(outcome, risk) {
  df <- tab10::risk_rank_data |>
    dplyr::filter(.data$outcome == !! outcome)
  approx(x = df$p, y = df$pct, xout = risk, rule = 2)$y
}

rank2risk <- function(outcome, rank) {
  df <- tab10::risk_rank_data |>
    dplyr::filter(.data$outcome == !! outcome)
  approx(x = df$pct, y = df$p, xout = rank, rule = 2)$y
}

calculate_gauge_sectors <- function(
    outcome = c("overweight-4y", "preterm-37w")) {
  outcome <- match.arg(outcome)
  riskgroup <- switch(outcome,
                      "overweight-4y" = c(8, 10),
                      "preterm-37w" = c(6, NA))
  rank <- 0.5 + (riskgroup - 1) * 10
  risk <- rank2risk(outcome, rank)
  # post process NA's to extremes
  if (is.na(rank[1L])) rank[1L] <- 1
  if (is.na(rank[2L])) rank[2L] <- 100
  if (is.na(risk[1L])) risk[1L] <- 0
  if (is.na(risk[2L])) risk[2L] <- 1
  list(risk = risk, rank = rank)
}
