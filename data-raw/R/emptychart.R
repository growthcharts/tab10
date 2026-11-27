#' Create an empty BMI plot for months 0-4
#'
#' @export
create_emptyChart <- function() {
  Leeftijd <- SDS <- NULL
  df <- data.frame(Leeftijd = c(-Inf, -Inf), SDS = c(-Inf, -Inf))
  ggplot(df, aes(x = Leeftijd, y = SDS)) +
    theme_light() +
    geom_rect(
      aes(xmin = 0, xmax = 0.5, ymin = -2, ymax = 2),
      fill = rgb(224, 241, 231, maxColorValue = 255)
    ) +
    theme(
      plot.background = element_rect(fill = "transparent"),
      panel.background = element_rect(fill = NA),
      panel.ontop = TRUE,
      panel.grid.minor = element_line(linewidth = 0.0, color = "#00AB66"),
      panel.grid.major = element_line(linewidth = 0.4, color = "#00AB66")
    ) +
    coord_cartesian(xlim = c(0, 5 / 12), ylim = c(-3, 3)) +
    scale_x_continuous(
      breaks = seq(0, 5 / 12, 1 / 12),
      labels = c("", "1", "2", "3", "4", ""),
      name = "Leeftijd (maanden)",
      expand = expansion(mult = c(0.05, 0))
    ) +
    scale_y_continuous(expand = expansion(mult = c(0, 0)))
}

emptyplot <- create_emptyChart()

# using save() instead of usethis::use_data() prevents dropping
# ggplot2 4.x's S7-based class structure from the saved object.
save(emptyplot, file = "data/emptyplot.rda", compress = "xz")
