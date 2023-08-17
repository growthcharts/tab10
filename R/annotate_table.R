#' Annotate an initialised table table of 20
#'
#' @param fig     Object created by `initialise_table()`
#' @inheritParams initialise_table
#' @export
annotate_table <- function(fig, script, colors,
                           frametext_size = 16) {
  z <- lapply(1:length(fig$x$frames),
              function(i) {
                name <- fig$x$frames[[i]]$name

                # cut-off line
                vline <- list(
                  type = "line", y0 = 2.5, y1 = 2.5, x0 = 0.5, x1 = 10.5,
                  line = list(color = colors[4L], dash = "dot", width = 3),
                  visible = ifelse(name == "hoog", TRUE, FALSE)
                )

                # rect: not used
                rect <- list(
                  type = "rect", y0 = 0, y1 = 11, x0 = 9.5, x1 = 10.5,
                  layer = "below",
                  fillcolor = colors[3L],
                  opacity = 0.3,
                  line = list(width = 0, color = colors[3L], dash = "dot"),
                  visible = ifelse(name %in% c("uitslag", "vervolg"), TRUE, FALSE)
                )

                # rounded rectangle
                rr <- list(
                  type = "path",
                  path = rounded_rectangle(x0 = 9.48, x1 = 10.52, y0 = 0.2, y1 = 10.8, h = 0.6),
                  fillcolor = colors[5L],
                  opacity = 0.3,
                  line = list(width = 0),
                  layer = "below",
                  visible = ifelse(name %in% c("uitslag", "vervolg"), TRUE, FALSE)
                )

                textcolor <- ifelse(i <= 3, "transparent", "black")
                xaxis <- list(
                  title = list(font = list(color = textcolor)),
                  tickfont = list(color = textcolor)
                )

                ann <- list(
                  text = script$frametext[i],
                  align = ifelse(name == "kind", "centre", "left"),
                  valign = ifelse(name == "kind", "centre", "top"),
                  font = list(size = ifelse(name == "kind",
                                            frametext_size + 8,
                                            frametext_size))
                )
                fig$x$frames[[i]]$layout <<- list(shapes = list(vline, rr),
                                                  xaxis = xaxis,
                                                  annotations = list(ann))
                invisible()
              })
  fig
}
