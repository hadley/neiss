library(tidyverse)
library(readxl)
library(fs)

# Ensure we have local copy -----------------------------------------------

# only take last five years to keep data in GitHub's limits
latest <- 2017
year <- (latest - 5 + 1):latest

names <- str_glue("{year}/neiss{year}.xlsx")
local <- path("data-raw", path_file(names))
remote <- paste0("https://www.cpsc.gov/cgibin/NEISSQuery/Data/Archived%20Data/", names)

# Download missing files
missing <- !file_exists(local)
walk2(remote[missing], local[missing], download.file)

# Read excel files --------------------------------------------------------

col_types <- c(
  case_num    = "text",
  trmt_date   = "date",
  age         = "numeric",
  sex         = "text",
  race        = "text",
  race_other  = "text",
  body_part   = "numeric",
  diag        = "numeric",
  diag_other  = "text",
  disposition = "numeric",
  location    = "numeric",
  fmv         = "numeric",
  prod1       = "numeric",
  prod2       = "numeric",
  narrative1  = "text",
  narrative2  = "text",
  stratum     = "text",
  psu         = "numeric",
  weight      = "numeric"
)

raw <- local %>% map(read_excel, col_types = col_types)

all <- bind_rows(raw)
names(all) <- names(col_types)

# Convert codes to values -------------------------------------------------

lookups <- readRDS("data-raw/lookups.rds")
lookup <- function(needle, haystack) {
  unname(haystack[as.character(needle)])
}

injuries <- all %>%
  mutate(
    trmt_date =   as.Date(trmt_date),
    sex =         lookup(sex, lookups$sex),
    race =        lookup(race, lookups$race),
    body_part =   lookup(body_part, lookups$body_part),
    diag =        lookup(diag, lookups$diag),
    diag_other =  tolower(diag_other),
    location =    lookup(location, lookups$location),
    fmv =         lookup(fmv, lookups$fmv),
    prod2 =       na_if(prod2, 0),
    disposition = lookup(disposition, lookups$disposition),
    race_other =  tolower(race_other),
    narrative =   paste0(narrative1, coalesce(narrative2, "")),
    narrative1 =  NULL,
    narrative2 =  NULL,
  ) %>%
  arrange(case_num)

# Ages above 200 = (age - 200) / 12
injuries$age[injuries$age > 200] <- (injuries$age[injuries$age > 200] - 200) / 12

injuries %>% count(sex)
injuries %>% count(race)
injuries %>% count(race_other, sort = TRUE)
injuries %>% count(diag, sort = TRUE)
injuries %>% count(location, sort = TRUE)

usethis::use_data(injuries, overwrite = TRUE, compress = "gzip")
