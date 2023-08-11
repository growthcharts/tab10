#' Initialise a table of 10
#'
#' @param data    Dataset created by `make_coordinates()`
#' @param script  Subset of `scripts`
#' @param colors  Vector of colors
#' @param width   With of display (px)
#' @param height  Height of display (px)
#' @param size    Circle size
#' @export
initialise_table <- function(
    data, script, colors, width = 700, height = 900, size = 1100) {
  fig <- data %>%
    plot_ly(
      x = ~x,
      y = ~y,
      size = I(size),
      color = ~case,
      colors = colors[c(4, 8)],
      frame = ~framename,
      text = ~pt,
      hoverinfo = "text",
      type = "scatter",
      mode = "markers",
      showlegend = FALSE,
      width = width,
      height = height
    ) %>%
    animation_opts(frame = 1400, transition = 700)

  fig <- fig %>%
    layout(
      xaxis = list(
        title = "",
        tickvals = 1:10,
        ticklabelstep = 1,
        ticktext = rep("", 10),
        scaleratio = 1,
        scaleanchor = "y",
        showgrid = FALSE,
        zeroline = FALSE
      ),
      yaxis = list(
        visible = FALSE
      ),
      annotations = list(
        xref = "x",
        yref = "y",
        x = 0,
        y = 0,
        yshift = -100,
        xanchor = "left",
        yanchor = "top",
        align = "left",
        valign = "top",
        height = 130,
        width = width - 50,
        text = script$frametext[1L],
        font = list(size = 16)
      )
    ) %>%
    hide_colorbar()
  fig <- fig %>%
    animation_button(
      x = 0.1, y = 0.1,
      label = "Go",
      fromcurrent = TRUE,
      visible = FALSE
    ) %>%
    animation_slider(
      currentvalue = list(
        prefix = "Beeld ", font = list(color = "black"),
        visible = FALSE
      ),
      y = -0.25
    ) %>%
    config(displayModeBar = FALSE)
  fig
}
