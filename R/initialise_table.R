#' Initialise a table of 10
#'
#' @param data    Dataset created by `make_coordinates()`
#' @param script  Subset of `scripts`
#' @param colors  Vector of colors
#' @param width   With of display (px)
#' @param height  Height of display (px)
#' @param size    Circle size
#' @param frametext_size Frame-text font size
#' @param yshift  Frame-text box vertical parameter
#' @param xaxis_titlefont_size X-axis title font size
#' @param xaxis_tickfont_size X-axis tick font size
#' @export
initialise_table <- function(
    data, script, colors,
    width = 700, height = 900, size = 1100,
    frametext_size = 16,
    xaxis_tickfont_size = 16,
    xaxis_titlefont_size = 20,
    yshift = -100) {

  fig <- data |>
    plot_ly(
      x = ~x,
      y = ~y,
      size = I(size),
      color = ~case,
      colors = colors[1L:2L],
      frame = ~framename,
      text = ~pt,
      hoverinfo = "text",
      type = "scatter",
      mode = "markers",
      showlegend = FALSE,
      width = width,
      height = height
    ) |>
    animation_opts(frame = 1400, transition = 700)

  fig <- fig |>
    plotly::layout(
      xaxis = list(
        range = c(0, 11),
        title = list(text = "<b>Risicogroep</b>",
                     font = list(size = xaxis_titlefont_size,
                                 color = "transparent"),
                     standoff = 0),
        ticktext = sprintf("<b>%s</b>", as.character(0:9)),
        tickfont = list(size = xaxis_tickfont_size,
                        color = "transparent"),
        tickvals = 1:10,
        scaleratio = 1,
        scaleanchor = "y",
        visible = TRUE,
        showgrid = FALSE,
        zeroline = FALSE
      ),
      yaxis = list(
        range = c(0, 11),
        title = "",
        visible = FALSE,
        showgrid = FALSE,
        zeroline = FALSE
      ),
      margin = list(
        b = 80 + 150
      ),
      annotations = list(
        xref = "x",
        yref = "y",
        x = 0,
        y = 0,
        yshift = yshift,
        xanchor = "left",
        yanchor = "top",
        align = "left",
        valign = "top",
        height = 130,
        width = width - 50,
        text = script$frametext[1L],
        font = list(size = frametext_size)
      )
    )
  fig <- fig |>
    hide_colorbar()
  fig <- fig |>
    animation_button(
      x = 0.1, y = 0.1,
      label = "Go",
      fromcurrent = TRUE,
      visible = FALSE
    ) |>
    animation_slider(
      currentvalue = list(
        prefix = "Beeld ", font = list(color = colors[4L]),
        visible = FALSE
      ),
      x = 0,
      y = 1.2,
    ) |>
    config(displayModeBar = FALSE)
  fig
}
