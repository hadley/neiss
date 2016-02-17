library(readr)
library(dplyr)
library(stringr)

all <- read_csv("data-raw/product-codes-tabula.csv") %>%
  filter(Code != "Code", Title != "Notes")

products <- all %>%
  select(code = Code, title = Title) %>%
  filter(title != "") %>%
  mutate(
    deleted = str_detect(code, fixed("*")),
    code = as.integer(str_replace_all(code, fixed("*"), ""))
  )

all_codes <- unique(c(injuries$prod1, injuries$prod2))
setdiff(all_codes, products$code)

use_data(products, overwrite = TRUE)
