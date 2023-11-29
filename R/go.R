#' GIZ app
#'
#' @param ... Arguments passed to `shinyApp(ui, server, ...)`
#' @export
go <- function(...) {
  cards_ov <- list(
    father = card(
      card_header("Vader"),
      selectInput(
        "father_educ", "Opleiding vader",
        c(
          "Geen, Basis", "VMBO-P", "VMBO-T, MAVO", "MBO", "HAVO, VWO",
          "HBO", "WO, MASTER", "Onbekend"
        ),
        selected = "Onbekend",
        selectize = FALSE
      ),
      selectInput(
        "father_country", "Geboorteland vader",
        c(
          "Nederland", "Marokko", "Turkije", "Suriname",
          "Antillen en Aruba", "Overige niet-westers", "Overige westers",
          "Onbekend"
        ),
        selected = "Onbekend",
        selectize = FALSE
      ),
      textInput("father_age", "Leeftijd vader", value = "")
    ),
    mother = card(
      card_header("Moeder"),
      selectInput(
        "mother_educ", "Opleiding moeder",
        c(
          "Geen, Basis", "VMBO-P", "VMBO-T, MAVO", "MBO", "HAVO, VWO",
          "HBO", "WO, MASTER", "Onbekend"
        ),
        selected = "Onbekend",
        selectize = FALSE
      ),
      selectInput(
        "mother_country", "Geboorteland moeder",
        c(
          "Nederland", "Marokko", "Turkije", "Suriname",
          "Antillen en Aruba", "Overige niet-westers", "Overige westers",
          "Onbekend"
        ),
        selected = "Onbekend",
        selectize = FALSE
      ),
      textInput("mother_age", "Leeftijd moeder", value = "")
    ),
    environment = card(
      card_header("Leefomgeving"),
      numericInput("pc4", "Postcode 4-cijfers", value = "", min = 1011, max = 9999, step = 1),
      textOutput("stedelijkheid"),
      textOutput("woz")
    ),
    medical = card(
      card_header("Medisch"),
      selectInput(
        "sex", "Geslacht",
        c("Jongen", "Meisje", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      ),
      textInput("ga", "Zwangerschapsduur (w)", value = ""),
      selectInput(
        "par", "Pariteit",
        c("0", "1", "2", "3", "4", "5", "6+", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      ),
    ),
    growth = card(
      card_header("Groei"),
      rHandsontableOutput("hot")
    ),
    result = card(
      card_header("Resultaat"),
      layout_columns(
        tab10::bmiChartUI("bmichart"),
        layout_columns(
          col_widths = c(12, 12),
          value_box(title = "Kans overgewicht, 4 jaar",
                    value = textOutput("probability"),
                    showcase = bsicons::bs_icon("person-lines-fill"),
                    theme = value_box_theme(
                      bg = rgb(224, 241, 231, maxColorValue = 255), fg = "#0B538E"),),
          value_box(title = "Rang",
                    value = textOutput("rank"),
                    showcase = bsicons::bs_icon("sort-up"),
                    theme = value_box_theme(
                      bg = rgb(224, 241, 231, maxColorValue = 255), fg = "#0B538E"),)
        )
      )
    )
  )

  cards_lg <- list(
    result = card(
      card_header("Resultaat"),
      layout_columns(
        col_widths = c(6, 6),
        value_box(title = "Kans taalachterstand, 4 jaar",
                  value = textOutput("probability_lg"),
                  showcase = bsicons::bs_icon("person-lines-fill"),
                  theme = value_box_theme(
                    bg = rgb(224, 241, 231, maxColorValue = 255), fg = "#0B538E"),),
        value_box(title = "Rang",
                  value = textOutput("rank_lg"),
                  showcase = bsicons::bs_icon("sort-up"),
                  theme = value_box_theme(
                    bg = rgb(224, 241, 231, maxColorValue = 255), fg = "#0B538E"),)
      )
    ),
    medical = card(
      card_header("Medisch"),
      selectInput(
        "sex_lg", "Geslacht",
        c("Jongen", "Meisje", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      )
    ),
    father = card(
      card_header("Vader"),
      selectInput(
        "father_educ_lg", "Opleiding vader",
        c(
          "Geen, Basis", "VMBO-P", "VMBO-T, MAVO", "MBO", "HAVO, VWO",
          "HBO", "WO, MASTER", "Onbekend"
        ),
        selected = "Onbekend",
        selectize = FALSE
      )
    ),
    mother = card(
      card_header("Moeder"),
      selectInput(
        "mother_educ_lg", "Opleiding moeder",
        c(
          "Geen, Basis", "VMBO-P", "VMBO-T, MAVO", "MBO", "HAVO, VWO",
          "HBO", "WO, MASTER", "Onbekend"
        ),
        selected = "Onbekend",
        selectize = FALSE
      )
    ),
    language = card(
      card_header("Taal"),
      selectInput(
        "opinion_lg", "Indruk 2 jaar",
        c("Adequaat of sneller", "Langzaam", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      ),
      selectInput(
        "sentences_lg", "Zinnen 2 woorden",
        c("-", "M", "+", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      ),
      selectInput(
        "doll_lg", "Pop 6 lichaamsdelen",
        c("-", "M", "+", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      ),
      selectInput(
        "langenv_lg", "Taalomgeving",
        c("Onvoldoende", "Matig", "Voldoende", "Onbekend"),
        selected = "Onbekend",
        selectize = FALSE
      )
    )
  )

  ui <- page_sidebar(
    useShinyjs(),
    collapsible = TRUE,
    fillable = TRUE,
    theme = bslib::bs_theme(),
    sidebar = sidebar(
      title = "",
      selectInput(
        inputId = "outcome",
        label = "Model",
        choices = list(
          "Overgewicht 4 jaar" = "overweight-4y",
          "Spraaktaal 4 jaar" = "lang-4y"
          #        , "Vroeggeboorte <32 weken" = "preterm-32w"
        )
      ),
      selectInput(
        inputId = "color",
        label = "Kleur",
        choices = list(
          "Rood-blauw" = "softred",
          "Mandarijn" = "mandarin",
          "Rood-grijs" = "redshadow"
        )
      )
    ),
    card(
      id = "card1",
      card_header("Bezoek: 4 maanden | Uitkomst: Overgewicht 4 jaar"),
      navset_tab(
        nav_panel(
          title = "GIZ",
          bslib::layout_columns(
            imageOutput("gizviz")
          )
        ),
        nav_panel(
          title = "Gegevens",
          bslib::layout_columns(
            layout_column_wrap(cards_ov[["result"]], cards_ov[["growth"]], heights_equal = "row", width = 1),
            cards_ov[["medical"]],
            col_widths = c(8, 4), fill = FALSE
          ),
          bslib::layout_columns(cards_ov[["father"]], cards_ov[["mother"]], cards_ov[["environment"]],
                                fill = FALSE)
        ),
        nav_panel(
          title = "Tafel van Tien",
          bslib::layout_columns(
            plotly::plotlyOutput("tab10")
          )
        )
      ),
      selected = "Gegevens"
    ),
    card(
      id = "card2",
      card_header("Bezoek: 24 maanden | Uitkomst: Taalontwikkeling 4 jaar"),
      navset_tab(
        nav_panel(
          title = "GIZ",
          bslib::layout_columns(
            imageOutput("gizviz_lg")
          )
        ),
        nav_panel(
          title = "Gegevens",
          bslib::layout_columns(cards_lg[["result"]], cards_lg[["language"]],
                                col_widths = c(8, 4), row_heights = c(2, 1),
                                fill = FALSE),
          bslib::layout_columns(cards_lg[["father"]], cards_lg[["mother"]], cards_lg[["medical"]],
                                fill = FALSE)
        ),
        nav_panel(
          title = "Tafel van Tien",
          bslib::layout_columns(
            plotly::plotlyOutput("tab10_lg")
          )
        ),
        selected = "GIZ"
      )
    )
  )

  server <- function(input, output, session) {

    observeEvent(input$outcome, {
      if (input$outcome == "overweight-4y") {
        hide("card2"); show("card1");
      }
      if (input$outcome == "lang-4y") {
        hide("card1"); show("card2");
      }
    })

    ### ---- reactives

    # table lookup for postal code attributes
    pwu <- reactive(
      tab10::pc4[match(input$pc4, tab10::pc4$pc4), ]
    )

    # length-weight table
    values <- reactiveValues()
    data <- reactive({
      if (!is.null(input$hot)) {
        DF <- hot_to_r(input$hot)
        DF$Leeftijd <- {
          dates <- as.Date(DF$Datum, format = "%d-%m-%Y")
          as.numeric(dates - dates[1]) / 365.25
        }
        DF$BMI <- DF$Gewicht/1000 / (DF$Lengte/1000)^2
        DF$SDS <- AGD::y2z(y = DF$BMI,
                           x = DF$Leeftijd,
                           sex = ifelse(input$sex == "Meisje", "F", "M"),
                           ref = AGD::nl4.bmi)
      } else {
        if (is.null(values[["DF"]]))
          DF <- data.frame(
            Bezoek = c("Geboorte", "4 wk", "8 wk", "3 mnd", "4 mnd"),
            Datum = format(c(0, 28, 56, 91, 122) + (Sys.Date() - 122), "%d-%m-%Y"),
            Leeftijd = c(0, 28, 56, 91, 122) / 365.25,
            Lengte = rep(NA_integer_, 5),
            mm = rep("mm", 5),
            Gewicht = rep(NA_integer_, 5),
            g = rep("g", 5),
            BMI = rep(NA_real_, 5),
            SDS = rep(NA_real_, 5))
        else
          DF <- values[["DF"]]
      }
      values[["DF"]] <- DF
      DF
    })

    bmidata <- reactive(
      na.omit(hot_to_r(input$hot)[, c("Leeftijd", "SDS")])
    )

    # OVERWEIGHT: beta lookups
    bmiz_beta <- reactive({
      beta <- beta_lookup("", c("BMI-Z 4 weken", "BMI-Z 8 weken",
                                "BMI-Z 3 maanden", "BMI-Z 4 maanden"))
      DF <- hot_to_r(input$hot)
      bmiz <- DF$SDS[-1L]
      bmiz[is.na(bmiz)] <- 0
      sum(bmiz * beta)
    })
    sex_beta <- reactive(
      beta_lookup(input$sex, "Geslacht", "overweight-4y")
    )
    bw_beta <- reactive({
      beta <- beta_lookup("", "Geboortegewicht", "overweight-4y")
      DF <- values[["DF"]]
      bw <- as.numeric(DF$Gewicht[1L])
      ifelse(is.na(bw), 3300 * beta, bw * beta)
    })
    ga_beta <- reactive({
      beta <- beta_lookup("", "Zwangerschapsduur", "overweight-4y")
      ga <- as.numeric(input$ga)
      ifelse(is.na(ga), 40 * beta, ga * beta)
    })
    parity_beta <- reactive(
      beta_lookup(input$par, "Pariteit", "overweight-4y")
    )
    father_educ_beta <- reactive(
      beta_lookup(input$father_educ, "Opleiding vader", "overweight-4y")
    )
    father_country_beta <- reactive(
      beta_lookup(input$father_country, "Geboorteland vader", "overweight-4y")
    )
    fa_beta <- reactive({
      beta <- beta_lookup("", "Leeftijd vader", "overweight-4y")
      fa <- as.numeric(input$father_age)
      ifelse(is.na(fa), 34 * beta, fa * beta)
    })
    mother_educ_beta <- reactive(
      beta_lookup(input$mother_educ, "Opleiding moeder", "overweight-4y")
    )
    mother_country_beta <- reactive(
      beta_lookup(input$mother_country, "Geboorteland moeder", "overweight-4y")
    )
    ma_beta <- reactive({
      beta <- beta_lookup("", "Leeftijd moeder", "overweight-4y")
      ma <- as.numeric(input$mother_age)
      ifelse(is.na(ma), 32 * beta, ma * beta)
    })
    sted <- reactive({
      switch(as.character(pwu()$urb),
             "1" = "Zeer sterk stedelijk",
             "2" = "Sterk stedelijk",
             "3" = "Matig stedelijk",
             "4" = "Weinig stedelijk",
             "5" = "Niet stedelijk",
             "Onbekend")
    })
    sted_beta <- reactive({
      beta_lookup(sted(), "Stedelijkheid", "overweight-4y")
    })
    woz_beta <- reactive({
      beta <- beta_lookup("", "WOZ woning", "overweight-4y")
      ifelse(is.na(pwu()$woz), 338000 * beta, pwu()$woz * 1000 * beta)
    })

    # OVERWEIGHT: calculate risk
    overweight_risk <- reactive({
      lp <- -2.25821890 + sex_beta() + bw_beta() + ga_beta() + parity_beta() +
        father_educ_beta() + father_country_beta() + fa_beta() +
        mother_educ_beta() + mother_country_beta() + ma_beta() +
        sted_beta() + woz_beta() + bmiz_beta()
      expit(lp)
    })

    # OVERWEIGHT: calculate rank
    overweight_rank <- reactive(
      p2rank(overweight_risk(), outcome = "overweight-4y")
    )

    # LANGUAGE: beta lookups
    sex_lg_beta <- reactive(
      beta_lookup(input$sex_lg, "Geslacht", "lang-4y")
    )
    father_educ_lg_beta <- reactive(
      beta_lookup(input$father_educ_lg, "Opleiding vader", "lang-4y")
    )
    mother_educ_lg_beta <- reactive(
      beta_lookup(input$mother_educ_lg, "Opleiding moeder", "lang-4y")
    )
    opinion_lg_beta <- reactive(
      beta_lookup(input$opinion_lg, "Indruk 2 jaar", "lang-4y")
    )
    sentences_lg_beta <- reactive(
      beta_lookup(input$sentences_lg, "Zin 2 woorden", "lang-4y")
    )
    doll_lg_beta <- reactive(
      beta_lookup(input$doll_lg, "Pop 6 lichaamsdelen", "lang-4y")
    )
    langenv_lg_beta <- reactive(
      beta_lookup(input$langenv_lg, "Taalomgeving", "lang-4y")
    )

    # LANGUAGE: calculate risk
    language_risk <- reactive({
      lp <- -0.28651335 + sex_lg_beta() +
        father_educ_lg_beta() + mother_educ_lg_beta() +
        opinion_lg_beta() + sentences_lg_beta() + doll_lg_beta() +
        langenv_lg_beta()
      expit(lp)
    })

    # LANGUAGE: calculate rank
    language_rank <- reactive(
      p2rank(language_risk(), outcome = "lang-4y")
    )

    ### ---- outputs
    output$stedelijkheid <- renderText(
      ifelse(is.na(pwu()$urb),
             "Bebouwing: ",
             paste0("Bebouwing: ", sted())
      )
    )
    output$woz <- renderText(
      ifelse(is.na(pwu()$woz),
             "WOZ: ",
             paste0(
               "WOZ: ",
               format(pwu()$woz * 1000,
                      big.mark = ".",
                      decimal.mark = ",",
                      scientific = FALSE
               )
             )
      )
    )

    output$probability <-
      renderText(format(round(overweight_risk(), digits = 2), nsmall = 2))
    output$rank <-
      renderText(format(round(overweight_rank())))
    output$probability_lg <-
      renderText(format(round(language_risk(), digits = 2), nsmall = 2))
    output$rank_lg <-
      renderText(format(round(language_rank())))

    output$hot <- renderRHandsontable({
      DF <- data()
      if (!is.null(DF)) {
        rhandsontable(DF,
                      rowHeaders = NULL,
                      width = 610) |>
          hot_col(col = "Datum", type = "date", dateFormat = "DD-MM-YYYY") |>
          hot_col(col = "Leeftijd", format = "0.000") |>
          hot_col(col = "BMI", format = "00.0") |>
          hot_col(col = "SDS", format = "0.00") |>
          hot_col(col = c("Bezoek", "Leeftijd", "mm", "g", "BMI", "SDS"), readOnly = TRUE) |>
          hot_cols(colWidths = c(90, 120, 60, 70, 40, 70, 20, 70, 70))
        ## Code below colors columns, but deactivates the datepicker
        # hot_cols(renderer =
        # "function(instance, td, row, col, prop, value, cellProperties) {
        #    Handsontable.renderers.TextRenderer.apply(this, arguments);
        #    if (col == 3) {
        #       td.style.background = '#00000011';
        #    }
        #    if (col == 5) {
        #       td.style.background = '#00000011';
        #    }
        #    return td;
        #  }")
      }
    })

    tab10::bmiChartServer(id = "bmichart", bmidata, tab10::emptyplot)

    output$gizviz <- renderImage({
      list(
        src = system.file("extdata", "CAF_Picto_0-4.svg", package = "tab10"),
        alt = "Figuur dat de GIZ-methodiek 0-4 jaar samenvat"
      )},
      deleteFile = FALSE
    )
    output$gizviz_lg <- renderImage({
      list(
        src = system.file("extdata", "CAF_Picto_0-4.svg", package = "tab10"),
        alt = "Figuur dat de GIZ-methodiek 0-4 jaar samenvat"
      )},
      deleteFile = FALSE
    )

    output$tab10 <- renderPlotly({
      create_tab10(pri = overweight_risk(),
                   outcome = input$outcome,
                   palet = input$color,
                   seed = 1)
    })
    output$tab10_lg <- renderPlotly({
      create_tab10(pri = language_risk(),
                   outcome = input$outcome,
                   palet = input$color,
                   seed = 1)

    })
  }

  shinyApp(ui, server, ...)
}
