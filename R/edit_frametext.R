glue_frametext <- function(data, script, colors) {
  ncase <- sum(data[data$frame == 1L, "case"])

  case_color <- "afwijkende"
  if (colors[2L] == "#D55E00") case_color <- "oranje"
  if (colors[2L] == "red") case_color <- "rode"

  outcome_age <- "4-jarige"

  script$frametext[1L] <-
    glue::glue(script$frametext[1L],
               ncase = ncase,
               case_color = case_color,
               outcome_age = outcome_age)

  mod <- ncase / 4
  base <- trunc(ncase / 4)
  approx <- as.character(base)
  if (mod != 0L) approx <- paste(base, "tot", base + 1)
  script$frametext[2L] <-
    glue::glue(script$frametext[2L],
               outcome_age = outcome_age,
               approx = approx)

  script
}
