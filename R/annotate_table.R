annotate_table <- function(fig, script, colors, riskgroup,
                           frametext_size = 16, nhigh = 3,
                           ntab = 100) {
  outcome <- script$outcome[1L]
  if (outcome == "preterm-37w") {
    nhigh <- 1
  }

  z <- lapply(1:length(fig$x$frames),
              function(i) {
                name <- fig$x$frames[[i]]$name

                #background rectangle
                my_rectangle <- list(
                  type = "rect",
                  fillcolor = colors[1L],
                  line = list(color = "black"),
                  opacity = 0.3,
                  x0 = "0",
                  x1 = "101",
                  xref = "x",
                  y0 = 0,
                  y1 = 101,
                  yref = "y",
<<<<<<< HEAD
                  visible = ifelse(i <= 4 && ntab == 10000, TRUE, FALSE)
=======
                  visible = ifelse(i <= 4, TRUE, FALSE)
>>>>>>> c7495afc1f7b495a1721dfa88a6f17f246a09332
                )


                # cut-off line
                vline <- list(
                  type = "line", y0 = nhigh - 0.5, y1 = nhigh - 0.5,
                  x0 = 0.5, x1 = 10.5,
                  line = list(color = colors[4L], dash = "dot", width = 3),
                  visible = ifelse(name == "hoog" && ntab == 100, TRUE, FALSE)
                )
                vline <- list(
                  type = "line", y0 = nhigh - 0.5, y1 = nhigh - 0.5,
                  x0 = 0.5, x1 = 100.5,
                  line = list(color = colors[4L], dash = "dot", width = 1),
                  visible = ifelse(name == "hoog" && ntab == 10000, TRUE, FALSE)
                )

                # rounded rectangle
                rr <- list(
                  type = "path",
                  path = rounded_rectangle(x0 = riskgroup - 0.52,
                                           x1 = riskgroup + 0.52,
                                           y0 = 0.2,
                                           y1 = ifelse(ntab == 100, 10.8, 108),
                                           h = 0.55),
                  fillcolor = colors[5L],
                  opacity = 0.3,
                  line = list(width = 0),
                  layer = "below",
                  visible = ifelse(name %in% c("uitslag", "vervolg"), TRUE, FALSE)
                )

                shapes <- list(my_rectangle, vline, rr)

                textcolor.rg <- ifelse(i <= 3, "transparent", "black")
                textcolor.ti <- ifelse(i == 3, "transparent", "black")
                gridcolors <- ifelse(i == 1 | i == 3, "#f0f1f2", "transparent")
                gridcolors <- ifelse(i == 2, "#b8b8b8", gridcolors)
                xaxis <- list(
                  title = list(font = list(color = textcolor.rg)),
                  tickfont = list(color = textcolor.ti),
                  gridcolor = gridcolors
                )

                textcolor.tiy <- ifelse(i > 2 && ntab == 10000, "transparent", "black")
                yaxis <- list(
                  tickfont = list(color = textcolor.tiy),
                  gridcolor = gridcolors
                )


                ann <- list(
                  text = script$frametext[i],
                  align = ifelse(name == "kind", "centre", "left"),
                  valign = ifelse(name == "kind", "centre", "top"),
                  font = list(size = ifelse(name == "kind",
                                            frametext_size + 8,
                                            frametext_size))
                )
                fig$x$frames[[i]]$layout <<- list(shapes = shapes,
                                                  xaxis = xaxis,
                                                  yaxis = yaxis,
                                                  annotations = list(ann))
                invisible()
              })
  fig
}
