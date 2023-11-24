#' GIZ app
#'
#' @param ... Any arguments
#' @export
gizapp <- function(...) {

  cards <- list(
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
      )
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
          value_box(title = "Percentiel",
                    value = textOutput("rank"),
                    showcase = bsicons::bs_icon("sort-up"),
                    theme = value_box_theme(
                      bg = rgb(224, 241, 231, maxColorValue = 255), fg = "#0B538E"),)
        )
      )
    )
  )

  ui <- page_navbar(
    title = "GIZ Voorspeller",
    selected = "Gegevens",
    collapsible = TRUE,
    theme = bslib::bs_theme(),
    sidebar = sidebar(
      title = "",
      selectInput(
        inputId = "outcome",
        label = "Model",
        choices = list(
          "Overgewicht 4 jaar" = "overweight-4y",
          "Spraaktaal 4 jaar" = "lang-4y",
          "Vroeggeboorte <37 weken" = "preterm-37w"
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
    nav_panel(
      title = "GIZ",
      bslib::layout_columns(
        imageOutput("gizviz")
      )
    ),
    nav_panel(
      title = "Gegevens",
      bslib::layout_columns(
        layout_column_wrap(cards[["result"]], cards[["growth"]], heights_equal = "row", width = 1),
        cards[["medical"]],
        col_widths = c(8, 4)
      ),
      bslib::layout_columns(cards[["father"]], cards[["mother"]], cards[["environment"]])
    ),
    nav_panel(
      title = "Tafel van Tien",
      bslib::layout_columns(
        plotly::plotlyOutput("tab10")
      ))
  )

  server <- function(input, output) {
    # reactive functions

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

    # beta lookups
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


    sted_beta <- reactive({
      sted <- switch(as.character(pwu()$urb),
                     "1" = "Zeer sterk stedelijk",
                     "2" = "Sterk stedelijk",
                     "3" = "Matig stedelijk",
                     "4" = "Weinig stedelijk",
                     "5" = "Niet stedelijk",
                     "Onbekend")
      beta_lookup(sted, "Stedelijkheid", "overweight-4y")
    })
    woz_beta <- reactive({
      beta <- beta_lookup("", "WOZ woning", "overweight-4y")
      ifelse(is.na(pwu()$woz), 338000 * beta, pwu()$woz * 1000 * beta)
    })

    # calculate overweight risk
    overweight_risk <- reactive({
      lp <- -2.25821890 + sex_beta() + bw_beta() + ga_beta() + parity_beta() +
        father_educ_beta() + father_country_beta() + fa_beta() +
        mother_educ_beta() + mother_country_beta() + ma_beta() +
        sted_beta() + woz_beta() + bmiz_beta()
      expit(lp)
    })

    # calculate overweight rank
    overweight_rank <- reactive(
      p2rank(overweight_risk(), outcome = "overweight-4y")
    )

    # outputs
    output$stedelijkheid <- renderText(
      ifelse(is.na(pwu()$urb),
             "Stedelijkheid: ",
             paste0("Stedelijkheid: ", pwu()$urb)
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
        src = normalizePath(file.path("../images", "CAF_Picto_0-4.svg")),
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
  }

  shinyApp(ui, server)
}
