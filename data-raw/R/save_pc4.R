# add mapping of postal code to woz and urbanicity
# fn <- file.path("data-raw/data/pc4.csv")
# pc4 <- read.csv2(fn) |>
#   dplyr::mutate(woz = ifelse(woz == "-99997", NA_integer_, woz),
#                 woz = as.numeric(woz),
#                 urb = as.numeric(urb))

fn <- file.path("data-raw/data/pc4_woz_corop.csv")
pc4 <- read.csv2(fn) |>
  dplyr::mutate(woz = ifelse(woz == "-99997", NA_integer_, woz),
                woz = as.numeric(woz),
                urb = as.numeric(urb)) |>
  dplyr::select(-X)

usethis::use_data(pc4, overwrite = TRUE)

