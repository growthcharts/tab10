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
      if (length(data) == 0L) {
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
