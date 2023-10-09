#' Return a vector of five colors
#'
#' @param name The name of the palette
#' @export
pick_palette <- function(name = c("mandarin", "redshadow", "softred")) {
  # Set colors
  palettes <- list(
    mandarin = c("#33B882", "#D55E00", "#FF0000BB", "black", "blue"),
    redshadow = c("#999999", "red", "#D55E00", "black", "blue"),
    softred = c(grDevices::hcl(240, 100, 40, 0.5), grDevices::hcl(0, 100, 40, 0.5),
             "#D55E00", "black", "blue"))
  name <- match.arg(name)
  palettes[[name]]
}
