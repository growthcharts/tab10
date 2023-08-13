#' Create a "table of 10" animation from data
#'
#' @param script  Name of script
#' @param y       Vector of 0 and 1, indicating a non-case and case, respectively
#' @param p       Vector of predicted probabilities. Same length as `y`
#' @param palet   Name of table10 color palette
#' @param centile Logical. Tooltips as centiles (default) or as absolute risk
#' @param seed    Seed value
#' @param width   With of display (px)
#' @param height  Height of display (px)
#' @param size    Circle size
#' @export
create_table10 <- function(script = "overweight-4y-2",
                           y = NULL,
                           p = NULL,
                           palet = "mandarin",
                           centile = TRUE,
                           seed = 123,
                           width = 700,
                           height = 900,
                           size = 1100) {
  palettes <- list(
    mandarin = c("#33B882", "#D55E00", "#FF0000BB", "black", "blue"),
    redgrey = c("#999999", "#FF0000", "#D55E00", "black","blue"))
  colors <- palettes[[palet]]

  scripts <- table10::scripts
  scripts$frametext <- stringr::str_wrap(scripts$frametext, width = 75)

  script <- scripts %>%
    filter(.data$name == !! script)
  y <- as.integer(c4po::ovp$ov)
  p <- c4po::ovp$cm

  yp <- draw_cases(y, p)
  data <- make_coordinates(script = script, case = as.logical(yp$y), p = yp$p,
                           centile = centile, seed = seed)
  f1 <- initialise_table(data, script, colors)
  f2 <- annotate_table(f1, script, colors)
  f2
}
