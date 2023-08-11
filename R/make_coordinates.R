make_coordinates <- function(script, case, p, centile = TRUE, seed = 123) {
  set.seed(seed)
  nr <- 10L
  nc <- 10L
  prv <- sum(case)
  stopifnot(is.logical(case))
  stopifnot(length(case) == 100 || length(p) == 100)

  # shuffle records
  idx <- sample(100L)
  case <- case[idx]
  p <- p[idx]

  # transform absolute probability into centile
  if (centile) {
    p[order(p)] <- seq_len(length(p))
  }
  framenames <- script$framename

  data1 <- expand.grid(y = seq_len(nr), x = seq_len(nc)) %>%
    mutate(
      frame = 1L,
      framename = framenames[.data$frame],
      p = p,
      pt = paste0("R", formatC(.data$p, width = 2,
                               format = "d", flag = "0")),
      case = case,
      hit = ifelse(.data$p > quantile(.data$p, probs = 1 - !! prv/100),
                   TRUE, FALSE))
  # data1 <- data1[sample(100L), ]

  data2 <- data1 %>%
    mutate(
      frame = 2L,
      framename = framenames[.data$frame],
      x = ifelse(.data$x <= 5, .data$x - 0.5, .data$x + 0.5),
      y = ifelse(.data$y <= 5, .data$y - 0.5, .data$y + 0.5))

  data3 <- data1 %>%
    mutate(
      frame = 3L,
      framename = framenames[.data$frame])

  data4 <- data1 %>%
    arrange(.data$p) %>%
    mutate(x = data1$x) %>%
    group_by(.data$x) %>%
    arrange(dplyr::desc(case), .by_group = TRUE) %>%
    ungroup() %>%
    mutate(
      frame = 4L,
      framename = framenames[.data$frame],
      y = data1$y)

  data5 <- data4 %>%
    mutate(
      frame = 5L,
      framename = framenames[.data$frame],
      y = ifelse(.data$y <= 2, .data$y - 0.25, .data$y + 0.25))

  data6 <- data4 %>%
    mutate(
      frame = 6L,
      framename = framenames[.data$frame])

  data7 <- data6 %>%
    mutate(
      frame = 7L,
      framename = framenames[.data$frame])

  data8 <- data7 %>%
    mutate(
      frame = 8L,
      framename = framenames[.data$frame])

  data <- bind_rows(data1, data2, data3, data4, data5, data6, data7, data8)
  data$framename <- factor(data$framename, levels = framenames)
  return(data)
}

set_case_label <- function(case, language) {
  noyes <- switch(language,
                  nl = c("nee", "ja"),
                  en = c("no", "yes"))
  return(noyes[1 + case])
}
