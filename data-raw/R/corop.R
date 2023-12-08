corop <- read.table("data-raw/data/corop.txt", sep = "\t", header = TRUE)
usethis::use_data(corop, overwrite = TRUE)
