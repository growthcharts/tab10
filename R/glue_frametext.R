glue_frametext <- function(data, script, colors, riskgroup,
                           high = 3) {
  ncase <- sum(data[data$frame == 1L, "case"])

  case_color <- "afwijkende"
  if (colors[2L] == "#D55E00") case_color <- "oranje"
  if (colors[2L] == "red") case_color <- "rode"

  control_color <- "onopvallende"
  if (colors[1L] == "#33B882") control_color <- "groene"
  if (colors[1L] == "#999999") control_color <- "grijze"

  aproblem <- "overgewicht"
  outcome_age <- "4-jarige"

  counts <- data |>
    filter(.data$frame == 1L) |>
    group_by(.data$gp) |>
    summarise(casesum = sum(.data$case),
              controlsum = sum(!.data$case))
  casecounts <- pull(counts, "casesum")
  controlcounts <- pull(counts, "controlsum")

  # frame 1
  script$frametext[1L] <-
    glue(script$frametext[1L],
         ncase = ncase,
         case_color = case_color,
         aproblem = aproblem,
         outcome_age = outcome_age)

  # frame 2
  mod <- ncase / 4
  base <- trunc(ncase / 4)
  approx <- as.character(base)
  if (mod != 0L) approx <- paste(base, "tot", base + 1)
  script$frametext[2L] <-
    glue(script$frametext[2L],
         aproblem = aproblem,
         outcome_age = outcome_age,
         approx = approx)

  # frame 3
  script$frametext[3L] <-
    glue(script$frametext[3L],
         aproblem = aproblem)

  # frame 4
  script$frametext[4L] <-
    glue(script$frametext[4L],
         aproblem = aproblem,
         control_color = control_color,
         casecounts = casecounts,
         controlcounts = controlcounts)

  # frame 5
  nhigh <- sum(casecounts >= high)
  nriskgroup <- switch(
    as.character(nhigh),
    "0" = "voldoet geen enkele risicogroup aan dit criterium",
    "1" = "voldoet alleen groep 10 aan dit criterium",
    "2" = "voldoen groepen 9 en 10 aan dit criterium",
    "3" = "voldoen groepen 8, 9 en 10 aan dit criterium",
    "4" = "voldoen groepen 7 tot 10 aan dit criterium",
    "5" = "voldoen groepen 6 tot 10 aan dit criterium",
    "voldoen er meer dan vijf groepen aan dit criterium")
  script$frametext[5L] <-
    glue(script$frametext[5L],
         aproblem = aproblem,
         control_color = control_color,
         nriskgroup = nriskgroup)

  # frame 7
  riskgrouplabel <- switch(
    as.character(casecounts[riskgroup]),
    "0" = "laag",
    "1" = "laag, maar niet verwaarloosbaar",
    "2" = "behoorlijk",
    "3" = "hoog",
    "4" = "hoog",
    "5" = "zeer hoog",
    "6" = "zeer hoog",
    "7" = "zeer hoog",
    "8" = "zeer hoog",
    "9" = "zeer hoog",
    "10" = "zeer hoog")
  riskgrouptext <- switch(
    as.character(casecounts[riskgroup]),
    "0" = "Geen",
    "1" = "E\u00e9n",
    "2" = "Twee",
    "3" = "Drie",
    "4" = "Vier",
    "5" = "Vijf",
    "6" = "Zes",
    "7" = "Zeven",
    "8" = "Acht",
    "9" = "Negen",
    "10" = "Tien"
    )
  script$frametext[7L] <-
    glue(script$frametext[7L],
         aproblem = aproblem,
         riskgroup = riskgroup,
         riskgroulabel = riskgrouplabel,
         riskgrouptext = riskgrouptext)

  script
}
