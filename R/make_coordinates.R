make_coordinates <- function(script, case, p, centile = TRUE, ntab = 100) {
  if (ntab == 100) {
    return(make_coordinates_100(script = script, case = case, p = p, centile = centile))
  }
  if (ntab == 1000) {
    return(make_coordinates_1000(script = script, case = case, p = p, centile = centile))
  }
}

make_coordinates_1000 <- function(script, case, p, centile = TRUE) {
  return(NULL)
}

make_coordinates_100 <- function(script, case, p, centile = TRUE) {
  outcome <- script$outcome[1L]
  nhigh <- switch(outcome,
                  "overweight-4y" = 3,
                  "preterm-37w" = 1,
                  "lang-4y" = 3,
                  NA_integer_)

  nr <- 10L
  nc <- 10L
  prv <- sum(case)
  stopifnot(is.logical(case))
  stopifnot(length(case) == 100L || length(p) == 100L)

  # shuffle records
  idx <- sample(100L)
  case <- case[idx]
  pct <- p <- p[idx]

  # transform absolute probability into centile
  if (centile) {
    pct[order(pct)] <- seq_len(length(pct))
  }
  framenames <- script$framename

  data1 <- expand.grid(y = seq_len(nr), x = seq_len(nc)) |>
    mutate(
      frame = 1L,
      framename = framenames[.data$frame],
      p = p,
      pct = pct,
      pt = paste("P:", formatC(.data$pct, width = 2L, format = "d")),
      gp = (.data$pct - 1) %/% 10,
      case = case,
      hit = ifelse(.data$pct > quantile(.data$pct, probs = 1 - !!prv / 100),
                   TRUE, FALSE
      )
    )

  data2 <- data1 |>
    mutate(
      frame = 2L,
      framename = framenames[.data$frame],
      x = ifelse(.data$x <= 5, .data$x - 0.5, .data$x + 0.5),
      y = ifelse(.data$y <= 5, .data$y - 0.5, .data$y + 0.5)
    )

  data3 <- data1 |>
    mutate(
      frame = 3L,
      framename = framenames[.data$frame]
    )

  data4 <- data1 |>
    arrange(.data$pct) |>
    mutate(x = data1$x) |>
    group_by(.data$x) |>
    arrange(desc(case), .by_group = TRUE) |>
    ungroup() |>
    mutate(
      frame = 4L,
      framename = framenames[.data$frame],
      y = data1$y
    )

  data5 <- data4 |>
    mutate(
      frame = 5L,
      framename = framenames[.data$frame],
      y = ifelse(.data$y <= nhigh - 1, .data$y - 0.25, .data$y + 0.25)
    )

  data6 <- data4 |>
    mutate(
      frame = 6L,
      framename = framenames[.data$frame]
    )

  data7 <- data6 |>
    mutate(
      frame = 7L,
      framename = framenames[.data$frame]
    )

  data8 <- data7 |>
    mutate(
      frame = 8L,
      framename = framenames[.data$frame]
    )

  data <- bind_rows(data1, data2, data3, data4, data5, data6, data7, data8)
  data$framename <- factor(data$framename, levels = framenames)
  return(data)
}

set_case_label <- function(case, language) {
  noyes <- switch(language,
                  nl = c("nee", "ja"),
                  en = c("no", "yes")
  )
  return(noyes[1L + case])
}
