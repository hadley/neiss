library(readxl)
library(dplyr)
library(stringr)

# Retrieved via personal correspondence
all <- read_excel("data-raw/NEISS-formats.xlsx")

products <- all %>%
  filter(FORMAT_NAME == "PROD") %>%
  select(code = FORMAT, title = LABEL) %>%
  mutate(title = tolower(title), code = as.integer(code))

all_codes <- unique(c(injuries$prod1, injuries$prod2))
setdiff(all_codes, products$code)

use_data(products, overwrite = TRUE)
