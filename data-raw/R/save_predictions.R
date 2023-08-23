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
predictions_ov <- tibble(outcome = "overweight-4y",
                         y = c(rep(1, length(p1)), rep(0, length(p0))),
                         pr = c(p1, p0)) |>
  group_by(y) |>
  mutate(p = cumsum(pr)) |>
  select(-pr)


# premature birth
set.seed(81991)

fn <- file.path(path.expand("~/Project/zonmw_kansrijke_start/WP4/modellen_CBS/20230817/vroeggeboorte/pretermbirth_cdf_RF.xlsx"))

pt_cum <- read_excel(fn) |>
  rename(pred1 = "pred1_prob",
         pred0 = "pred0_prob") |>
  select(pred1, pred0)
p1 <- pt_cum$pred1[!is.na(pt_cum$pred1)]
p0 <- pt_cum$pred0[!is.na(pt_cum$pred0)]
predictions_pt <- tibble(outcome = "preterm-37w",
                         y = c(rep(1, length(p1)), rep(0, length(p0))),
                         pr = c(p1, p0)) |>
  slice_sample(n = 10000) |>
  group_by(y) |>
  mutate(p = pr) |>
  select(-pr)

predictions <- bind_rows(predictions_ov, predictions_pt)

usethis::use_data(predictions, overwrite = TRUE)
