calculate_riskgroup <- function(pri, data, ntab = 100) {
  maxgrp <- ifelse(ntab == 100, 9, 99)
  if (is.null(pri)) {
    return(sample(0:maxgrp, size = 1))
  }
  df <- data |>
    filter(.data$frame == 1L) |>
    mutate(d = abs(!! pri - .data$p))

  candidate <- df$gp[df$d == min(df$d)]
  if (length(candidate) == 1L) {
    return(candidate)
  } else {
    return(sample(candidate, size = 1L))
  }
}
