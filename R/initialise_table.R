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
#' @param ntab    Number of elements, either 100 or 10000
#' @export
initialise_table <- function(
    data, script, colors,
    width = 700, height = 900, size = 1100,
    frametext_size = 16,
    xaxis_tickfont_size = 16,
    xaxis_titlefont_size = 20,
    yshift = -100,
    ntab = 100) {
  if (ntab == 100) {
    return(initialise_table_100(
      data, script, colors,
      width, height, size,
      frametext_size,
      xaxis_tickfont_size,
      xaxis_titlefont_size,
      yshift))
  }
  if (ntab == 10000) {
    return(initialise_table_1000(
      data, script, colors,
      width, height, size,
      frametext_size,
      xaxis_tickfont_size,
      xaxis_titlefont_size,
      yshift))
  }
}

initialise_table_100 <- function(
    data, script, colors,
    width, height, size,
    frametext_size,
    xaxis_tickfont_size,
    xaxis_titlefont_size,
    yshift) {
  x_range <- c(0, 11)
  x_tickvals <- 1:10
  x_ticktxt <- as.character(1:10)
  y_range <- c(0, 11)
  anim_frame <- 1400
  anim_transition <- 700

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
    animation_opts(frame = anim_frame, transition = anim_transition)

  fig <- fig |>
    plotly::layout(
      xaxis = list(
        range = x_range,
        title = list(text = "<b>Risicogroep</b>",
                     font = list(size = xaxis_titlefont_size,
                                 color = "transparent"),
                     standoff = 0),
        ticktext = sprintf("<b>%s</b>", x_ticktxt),
        tickfont = list(size = xaxis_tickfont_size,
                        color = "transparent"),
        tickvals = x_tickvals,
        scaleratio = 1,
        scaleanchor = "y",
        visible = TRUE,
        showgrid = FALSE,
        zeroline = FALSE
      ),
      yaxis = list(
        range = y_range,
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

initialise_table_1000 <- function(
    data, script, colors,
    width, height, size,
    frametext_size,
    xaxis_tickfont_size,
    xaxis_titlefont_size,
    yshift) {
  x_range <- c(0, 101)
  x_tickvals <- seq(0, 101, by = 10.1) #tick values for added grid lines
  x_ticktxt <- as.character(seq(0, 100, by = 10))
  y_range <- c(0, 101)
  y_tickvals <- seq(0, 101, by = 10.1) ##tick values for added grid lines
  y_ticktxt <- as.character(seq(0, 100, by = 10))
  size <- size / 100
  anim_frame <- 4000
  anim_transition <- 3000

  #add rectangle
  my_rectangle <- list(
    type = "rect",
    fillcolor = colors[1L],
    line = list(color = "transparent"),
    opacity = 0.1,
    x0 = "0",
    x1 = "101",
    xref = "x",
    y0 = 0,
    y1 = 101,
    yref = "y"
  )



  fig <- data |>
    #add filter to remove controls to speed up visual
    dplyr::filter(.data$case == TRUE) |>
   # dplyr::filter(!frame == 5 & y < 3) |>
    plot_ly(
      x = ~x,
      y = ~y,
      size = I(size),
      color = ~case,
      #colors = colors[1L:2L],
      colors = colors[2L], #use only color of cases
      frame = ~framename,
      text = ~pt,
      hoverinfo = "text",
      type = "scatter",
      mode = "markers",
      showlegend = FALSE,
      width = width,
      height = height
    ) |>
    animation_opts(frame = anim_frame, transition = anim_transition)


  fig <- fig |>


    plotly::layout(
      shapes = list(my_rectangle),
      xaxis = list(
        range = x_range,
        title = list(text = "<b>Risicogroep</b>",
                     font = list(size = xaxis_titlefont_size,
                                 color = "transparent"),
                     standoff = 0),
        ticktext = x_ticktxt,
        tickfont = list(size = xaxis_tickfont_size/2,
                        color = "black"),
        tickvals = x_tickvals,
        scaleratio = 1,
        scaleanchor = "y",
        visible = TRUE,
        showgrid = TRUE, #show gridlines
        zeroline = FALSE,
        gridwith = 10,
        gridcolor = "#f0f1f2"
      ),
      yaxis = list(
        range = y_range,
        #add tickvalues to make sure gridlines appear
        ticktext = y_ticktxt, #sprintf("<b>%s</b>", y_ticktxt),
        tickfont = list(size = xaxis_tickfont_size/2,
                        color = "black"),
        tickvals = y_tickvals,
        title = "",
        visible = TRUE,
        showgrid = TRUE, #show gridlines
        zeroline = FALSE,
        gridwith = 10,
        gridcolor = "#f0f1f2"

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
