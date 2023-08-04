rounded_rectangle <- function(x0 = 0, y0 = 0, x1 = 1, y1 = 1, h = 0.2) {

  bottom_left <- paste0(" M ", x0 + h, ",", y0, " Q ", x0, ",", y0,
                        " ", x0, ",", y0 + h)
  top_left <-    paste0(" L ", x0, ",", y1 - h, " Q ", x0, ",", y1,
                        " ", x0 + h, ",", y1)
  top_right <-   paste0(" L ", x1 - h, ",", y1, " Q ", x1, ",", y1,
                        " ", x1, ",", y1 - h)
  bottom_right <- paste0(" L ", x1, ",", y0 + h, " Q ", x1, ",", y0,
                         " ", x1 - h, ",", y0)

  paste0(bottom_left, top_left, top_right, bottom_right)
}
