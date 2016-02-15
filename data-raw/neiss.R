library(readxl)
library(purrr)
library(dplyr)

files <- dir("data-raw", pattern = "\\.xlsx$", full.names = TRUE)

col_types <- c(
  case_num    = "text",
  trmt_date   = "date",
  psu         = "numeric",
  weight      = "numeric",
  stratum     = "text",
  age         = "numeric",
  sex         = "text",
  race        = "text",
  race_other  = "text",
  diag        = "numeric",
  diag_other  = "text",
  body_part   = "numeric",
  disposition = "numeric",
  location    = "numeric",
  fmv         = "numeric",
  prod1       = "numeric",
  prod2       = "numeric",
  narrative   = "text"
)
raw <- files %>% map(read_excel, col_types = col_types)

all <- bind_rows(raw)
names(all)[1] <- "case_num"


lookups <- readRDS("data-raw/lookups.rds")
lookup <- function(needle, haystack) {
  unname(haystack[as.character(needle)])
}

injuries <- all %>%
  mutate(
    case_num =    as.integer(case_num),
    trmt_date =   as.Date(trmt_date),
    body_part =   lookup(body_part, lookups$body_part),
    diag =        lookup(diag, lookups$diag),
    diag_other =  tolower(diag_other),
    location =    lookup(location, lookups$location),
    disposition = lookup(disposition, lookups$disposition),
    race_other =  tolower(race_other)
  ) %>%
  arrange(case_num)

# Ages above 200 = (age - 200) / 12
injuries$age[injuries$age > 200] <- (injuries$age[injuries$age > 200] - 200) / 12

devtools::use_data(injuries, overwrite = TRUE)
