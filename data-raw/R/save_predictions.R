# This script creates the internal variables `predictions` and `riskrank`
# SvB 20231127

library(dplyr)
library(readxl)
library(usethis)

# overweight-4y predictions
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


# premature birth (<32w) predictions
set.seed(81991)
fn <- file.path(path.expand("~/Project/zonmw_kansrijke_start/WP4/modellen_CBS/20231130/voorspeldekansen_vroeggeboorte_logreg_vroeg24_37.xlsx"))
pt_cum <- read_excel(fn)
p1 <- pt_cum$pred1[!is.na(pt_cum$pred1)]
p0 <- pt_cum$pred0[!is.na(pt_cum$pred0)]
predictions_pt <- tibble(outcome = "preterm-32w",
                         y = c(rep(1, length(p1)), rep(0, length(p0))),
                         pr = c(p1, p0)) |>
  slice_sample(n = 10000) |>
  group_by(y) |>
  mutate(p = pr) |>
  select(-pr)

# language model predictions
fn <- file.path(path.expand("~/Project/zonmw_kansrijke_start/WP4/modellen_CBS/20231025/voorspeldekansen_spraaktaal_logistisch.xlsx"))
lg_cum <- read_excel(fn) |>
  select(pred1, pred0)
p1 <- lg_cum$pred1[!is.na(lg_cum$pred1)]
p0 <- lg_cum$pred0[!is.na(lg_cum$pred0)]
predictions_lg <- tibble(outcome = "lang-4y",
                         y = c(rep(1, length(p1)), rep(0, length(p0))),
                         pr = c(p1, p0)) |>
  group_by(y) |>
  mutate(p = pr) |>
  select(-pr)

predictions <- bind_rows(predictions_ov, predictions_pt, predictions_lg)

usethis::use_data(predictions, overwrite = TRUE)

# FIRST UPDATE PACKAGE: R BUILD, then update risk_rank_data
risk_rank_ov <- tab10:::create_framedata("overweight-4y", ntab = 100, seed = 1)
risk_rank_lg <- tab10:::create_framedata("lang-4y", ntab = 100, seed = 1)
risk_rank_pt <- tab10:::create_framedata("preterm-32w", ntab = 1000, seed = 1)

risk_rank_data <-
  dplyr::bind_rows(risk_rank_ov, risk_rank_lg, risk_rank_pt) |>
  dplyr::filter(frame == 1L) |>
  dplyr::select(all_of(c("outcome", "p", "pct"))) |>
  dplyr::arrange(outcome, pct)

usethis::use_data(risk_rank_data, overwrite = TRUE)
