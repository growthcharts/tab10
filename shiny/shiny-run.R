# This script is used to run the application defined in app.R in the background
options(shiny.autoreload = TRUE)
shiny::runApp("../shiny", port = 4276)
# rstudioapi::viewer(<URL>)
