#' Create a "table of 10" animation from data
#'
#' @param pri     Numeric. Personal risk estimate (0 < `pri` < 1).
#' @param name    Name of script within built-in scripts `tab10::scripts`.
#'                `name` is ignored if the `script` argument is specified.
#' @param script  A tibble with the structure of `tab10::scripts`.
#' @param palet   Name of table10 color palette
#' @param display Display size, either `"medium"` or `"large"`)
#' @param centile Logical. Tooltips as centiles (default) or as absolute risk
#' @param seed    Seed value
#' @param \dots   Arguments passed down to [`initialise_table()`]
#' @export
create_tab10 <- function(pri = NULL,
                         name = "overweight-4y-3",
                         script = NULL,
                         palet = c("mandarin", "redgrey"),
                         display = c("medium", "large", "default"),
                         centile = TRUE,
                         seed = NULL,
                         ...) {
  pri <- pri[1L]
  if (!is.null(pri)) {
    stopifnot(pri >= 0 & pri <= 1)
  }

  # Set colors
  palettes <- list(
    mandarin = c("#33B882", "#D55E00", "#FF0000BB", "black", "blue"),
    redgrey = c("#999999", "red", "#D55E00", "black", "blue")
  )
  palet <- match.arg(palet)
  colors <- palettes[[palet]]

  # Set display size
  display <- match.arg(display)
  dpar <- switch(
    display,
    default = list(width = NULL, height = NULL, size = 800,
                   frametext = list(size = 16, yshift = NULL),
                   xaxis_tickfont = list(size = 16),
                   xaxis_titlefont = list(size = 20)),
    medium = list(width = 700,
                  height = 800 + 150,
                  size = 1400,
                  wrap = 80,
                  frametext = list(size = 16, yshift = -100),
                  xaxis_tickfont = list(size = 24),
                  xaxis_titlefont = list(size = 16)),
    large =  list(width = 900,
                  height = 1200,
                  size = 2500,
                  wrap = 90,
                  frametext = list(size = 20, yshift = -180),
                  xaxis_tickfont = list(size = 20),
                  xaxis_titlefont = list(size = 24))
  )

  # Set script
  if (is.null(script)) {
    script <- tab10::scripts |>
      filter(.data$name == !!name)
  }
  stopifnot(all(hasName(script, names(tab10::scripts))))

  # Set data
  if (!is.null(seed)) {
    set.seed(seed)
  }
  yp <- load_predictions(script$outcome[1L])
  yp <- draw_cases(y = as.integer(yp$y), p = yp$p)
  data <- make_coordinates(script = script,
                           case = as.logical(yp$y),
                           p = yp$p,
                           centile = centile)
  riskgroup <- calculate_riskgroup(pri, data)

  # Process frame text
  script <- glue_frametext(data, script, colors, riskgroup)
  if (!is.null(dpar$width)) {
    script <- script |>
      mutate(
        frametext = str_wrap(.data$frametext, width = !!dpar$wrap)
      )
  }

  # Create display
  f1 <- initialise_table(data = data,
                         script = script,
                         colors = colors,
                         width = dpar$width,
                         height = dpar$height,
                         size = dpar$size,
                         xaxis_tickfont_size = dpar$xaxis_tickfont$size,
                         xaxis_titlefont_size = dpar$xaxis_titlefont$size,
                         frametext_size = dpar$frametext$size,
                         yshift = dpar$frametext$yshift)
  f2 <- annotate_table(f1,
                       script = script,
                       colors = colors,
                       riskgroup = riskgroup)
  f2
}
