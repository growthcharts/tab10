glue_frametext <- function(data, script, colors, riskgroup,
                           high = 3, ntab = 100) {
  ncase <- sum(data[data$frame == 1L, "case"])

  case_color <- "afwijkende"
  if (colors[2L] == "#D55E00") case_color <- "oranje"
  if (colors[2L] == "red") case_color <- "rode"
  if (colors[2L] == grDevices::hcl(0, 100, 40, 0.5)) case_color <- "rode"

  control_color <- "onopvallende"
  if (colors[1L] == "#33B882") control_color <- "groene"
  if (colors[1L] == "#999999") control_color <- "grijze"
  if (colors[1L] == grDevices::hcl(240, 100, 40, 0.5)) control_color <- "blauwe"

  outcome <- script$outcome[1L]
  if (outcome == "overweight-4y") {
    aproblem <- "overgewicht"
    outcome_age <- "4-jarige"
  }
  if (outcome == "lang-4y") {
    aproblem <- "een taalachterstand"
    outcome_age <- "4-jarige"
    high <- 3
  }
  if (outcome == "preterm-37w") {
    aproblem <- "vroeggeboorte"
    outcome_age <- ""
    high <- 1
  }
  if (outcome == "preterm-32w") {
    aproblem <- "vroeggeboorte"
    outcome_age <- ""
    high <- 3
  }

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
  if (ntab == 100) {
    nriskgroup <- switch(
      as.character(nhigh),
      "0" = "voldoet geen enkele risicogroup aan dit criterium",
      "1" = "voldoet alleen groep 10 aan dit criterium",
      "2" = "voldoen groepen 9 en 10 aan dit criterium",
      "3" = "voldoen groepen 8, 9 en 10 aan dit criterium",
      "4" = "voldoen groepen 7, 8, 9 en 10 aan dit criterium",
      "5" = "voldoen groepen 6, 7, 8, 9 en 10 aan dit criterium",
      "voldoen er meer dan vijf groepen aan dit criterium")
  }
  if (ntab == 10000) {
    nriskgroup <- switch(
      as.character(nhigh),
      "0" = "voldoet geen enkele risicogroup aan dit criterium",
      "1" = "voldoet \u00e9\u00e9n risicogroep aan dit criterium",
      "2" = "voldoen twee risicogroepen aan dit criterium",
      "3" = "voldoen drie risicogroepen aan dit criterium",
      "4" = "voldoen vier risicogroepen aan dit criterium",
      "5" = "voldoen vijf risicogroepen aan dit criterium",
      "voldoen er meer dan vijf groepen aan dit criterium")
  }
  script$frametext[5L] <-
    glue(script$frametext[5L],
         aproblem = aproblem,
         control_color = control_color,
         nriskgroup = nriskgroup)

  # frame 7
  relax <- 1
  if (outcome %in% c("preterm-37w", "preterm-32w")) relax <- 10
  riskgrouplabel <- switch(
    as.character(floor(casecounts[riskgroup] / relax)),
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
    "0" = "heeft geen kind",
    "1" = "heeft \u00e9\u00e9n kind",
    "2" = "hebben twee kinderen",
    "3" = "hebben drie kinderen",
    "4" = "hebben vier kinderen",
    "5" = "hebben vijf kinderen",
    "6" = "hebben zes kinderen",
    "7" = "hebben zeven kinderen",
    "8" = "hebben acht kinderen",
    "9" = "hebben negen kinderen",
    "10" = "hebben alle kinderen"
  )
  if (outcome %in% c("preterm-37w", "preterm-32w")) {
    riskgrouptext <- switch(
      as.character(casecounts[riskgroup]),
      "0" = "geen van de 100 zwangerschappen",
      "1" = "\u00e9\u00e9n van de 100 zwangerschappen",
      "2" = "twee van de 100 zwangerschappen",
      "3" = "drie van de 100 zwangerschappen",
      "4" = "vier van de 100 zwangerschappen",
      "5" = "vijf van de 100 zwangerschappen",
      "6" = "zes van de 100 zwangerschappen",
      "7" = "zeven van de 100 zwangerschappen",
      "8" = "acht van de 100 zwangerschappen",
      "9" = "negen van de 100 zwangerschappen",
      "10" = "10 van de 100 zwangerschappen",
      "meer dan 10 van de 100 zwangerschappen"
    )
  }
  script$frametext[7L] <-
    glue(script$frametext[7L],
         aproblem = aproblem,
         riskgroup = riskgroup,
         riskgroulabel = riskgrouplabel,
         riskgrouptext = riskgrouptext)

  script
}
