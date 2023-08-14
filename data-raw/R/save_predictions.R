library(dplyr)
library(readxl)
library(usethis)

# add classifcation of stedelijkheid as an predictor
fn <- file.path("data-raw/data/cdf_data.xlsx")
ov_cum <- read_excel(fn) %>%
  rename(pred1 = "ecdf_pred1",
         pred0 = "ecdf_pred0") |>
  select(pred1, pred0)
p1 <- ov_cum$pred1[!is.na(ov_cum$pred1)]
p0 <- ov_cum$pred0[!is.na(ov_cum$pred0)]
predictions <- tibble(outcome = "overweight-4y",
                      y = c(rep(1, length(p1)), rep(0, length(p0))),
                      pr = c(p1, p0)) |>
  group_by(y) |>
  mutate(p = cumsum(pr)) |>
  select(-pr)

usethis::use_data(predictions, overwrite = TRUE)
