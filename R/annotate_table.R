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

                # cut-off line
                vline <- list(
                  type = "line", y0 = nhigh - 0.5, y1 = nhigh - 0.5,
                  x0 = 0.5, x1 = 10.5,
                  line = list(color = colors[4L], dash = "dot", width = 3),
                  visible = ifelse(name == "hoog" && ntab == 100, TRUE, FALSE)
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
