plot_densities <- function(data = tab10::predictions,
                           outcome = c("overweight-4y", "preterm-37w"),
                           colors = c(grDevices::hcl(240, 100, 40, 0.5),
                                      grDevices::hcl(0, 100, 40, 0.5)),
                           as_plotly = FALSE) {
  outcome <- match.arg(outcome)

  data <- data |>
    filter(.data$outcome %in% !! outcome) |>
    group_by(.data$y) |>
    mutate(status = case_match(.data$y,
                               0 ~ "Heeft geen overgewicht op 4 jaar",
                               1 ~ "Heeft overgewicht op 4 jaar"),
           fill = case_match(.data$y,
                             0 ~ colors[1],
                             1 ~ colors[2])
    )

  fig <- suppressWarnings(
    ggplot2::ggplot(data,
                    aes(x = .data$p, y = after_stat(density),
                        fill = .data$fill)) +
      ggplot2::scale_fill_manual(values = colors, guide = "none") +
      ggplot2::geom_histogram(colour = NA, binwidth = 0.01) +
      ggplot2::geom_density(color = "grey20", fill = NA) +
      facet_wrap(~ status, ncol = 1, as.table = FALSE) +
      scale_x_continuous(breaks = seq(0, 1, 0.1), limits = c(0, 1),
                         name = "Risico score",
                         expand = c(0, 0)) +
      scale_y_continuous(breaks = seq(0, 10, 2),
                         name = "Dichtheid") +
      theme_minimal() +
      theme(strip.text = element_text(face = "bold", size = rel(1.1)),
            strip.background = element_rect(fill = "grey80", colour = "transparent"))
  )

  if (as_plotly) {
    fig <- ggplotly(fig)
  }
  fig
}

