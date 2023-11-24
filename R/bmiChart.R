#' UI element for BMI chart
#'
#' @param id string, shiny id
#' @export
bmiChartUI <- function(id) {
  plotOutput(NS(id, "bmichart"))
}


#' Server element for BMI chart
#'
#' @param id string, shiny id
#' @param bmidata reactive data frame
#' @param emptyplot the chart canvas to draw on
#' @export
bmiChartServer <- function(id, bmidata, emptyplot) {
  stopifnot(is.reactive(bmidata))
  stopifnot(!is.reactive(emptyplot))

  moduleServer(id, function(input, output, session) {

    output$bmichart <- renderPlot({
      data <- bmidata()
      if (nrow(data) == 0L) {
        emptyplot
      }
      else if (nrow(data) == 1L) {
        emptyplot +
          geom_point(data = data, col = "red", size = 3)
      } else {
        emptyplot +
          geom_line(data = data, col = "red") +
          geom_point(data = data, col = "red", size = 3)
      }
    })
  })
}

#' Create an empty BMI plot for months 0-4
#'
#' @export
create_emptyChart <- function() {
  inputdata <- data.frame(Leeftijd = -9, SDS = -9)
  ggplot(inputdata, aes(x = Leeftijd, y = SDS)) +
    theme_light() +
    geom_rect(aes(xmin = 0, xmax = 0.5, ymin = -2, ymax = 2),
              fill = rgb(224, 241, 231, maxColorValue = 255)) +
    theme(plot.background = element_rect(fill = "transparent"),
          panel.background = element_rect(fill = NA),
          panel.ontop = TRUE,
          panel.grid.minor = element_line(linewidth = 0.0, color = "#00AB66"),
          panel.grid.major = element_line(linewidth = 0.4, color = "#00AB66")) +
    coord_cartesian(xlim = c(0, 5/12), ylim = c(-3, 3)) +
    scale_x_continuous(breaks = seq(0, 5/12, 1/12),
                       labels = c("", "1", "2", "3", "4", ""),
                       name = "Leeftijd (maanden)",
                       expand = expansion(mult = c(0.05, 0))) +
    scale_y_continuous(expand = expansion(mult = c(0, 0)))
}
