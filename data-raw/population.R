# Read in US census population data, restrict year range and age range
# Data source: https://wonder.cdc.gov/Bridged-Race-v2016.HTML

library(tidyverse)
filter <- dplyr::filter

file_in <- "Bridged-Race Population Estimates 1990-2016.txt"
year_min <- 2000
year_max <- 2014
age_min <- 0
age_max <- 84

#===============================================================================

population <-
  read_tsv(
    file,
    col_types = cols(
      .default = col_integer(),
      Notes = col_character(),
      Gender = col_character()
    )
  ) %>%
  filter(is.na(Notes)) %>%
  select(
    year = "Yearly July 1st Estimates",
    age = "Age Code",
    sex = "Gender",
    n = "Population"
  ) %>%
  filter(year >= year_min, year <= year_max, age >= age_min, age <= age_max) %>%
  mutate(sex = str_to_lower(sex))

use_data(population, overwrite = TRUE)
