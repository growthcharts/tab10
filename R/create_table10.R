#' Create a "table of 10" animation from data
#'
#' @param pri     Numeric. Personal risk estimate (0 < `pri` < 1).
#' @param name    Name of script
#' @param palet   Name of table10 color palette
#' @param centile Logical. Tooltips as centiles (default) or as absolute risk
#' @param seed    Seed value
#' @param width   With of display (px)
#' @param height  Height of display (px)
#' @param size    Circle size
#' @param wrap    Integer. Number of character per line
#' @export
create_table10 <- function(pri,
                           name = "overweight-4y-2",
                           palet = "mandarin",
                           centile = TRUE,
                           seed = NULL,
                           width = 700,
                           height = 900,
                           size = 1100,
                           wrap = 75) {
  if (!is.null(seed)) {
    set.seed(seed)
  }

  palettes <- list(
    mandarin = c("#33B882", "#D55E00", "#FF0000BB", "black", "blue"),
    redgrey = c("#999999", "#FF0000", "#D55E00", "black", "blue")
  )
  colors <- palettes[[palet]]

  script <- table10::scripts |>
    filter(.data$name == !!name) |>
    mutate(
      frametext = str_wrap(.data$frametext, width = !!wrap)
    )

  yp <- load_predictions(outcome = script$outcome[1L])
  y <- as.integer(yp$y)
  p <- yp$p

  yp <- draw_cases(y, p)
  data <- make_coordinates(
    script = script, case = as.logical(yp$y), p = yp$p,
    centile = centile)
  f1 <- initialise_table(data, script, colors)
  f2 <- annotate_table(f1, script, colors)
  f2
}
