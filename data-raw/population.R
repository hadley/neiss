# Read in US census population data, restrict year range and age range
# Data source: https://wonder.cdc.gov/Bridged-Race-v2017.HTML

library(tidyverse)
filter <- dplyr::filter

pop_raw <- read_tsv(
  "data-raw/Bridged-Race Population Estimates 1990-2017.txt",
  col_types = cols(
    .default = col_skip(),
    `Yearly July 1st Estimates` = col_integer(),
    `Age Code` = col_integer(),
    Gender = col_character(),
    Notes = col_character(),
    Population = col_integer()
  )
)

# Failures are expected because there is trailing footnotes at the end of
# the file
population <- pop_raw %>%
  filter(is.na(Notes)) %>%
  select(
    year = "Yearly July 1st Estimates",
    age = "Age Code",
    sex = "Gender",
    n = "Population"
  ) %>%
  filter(year >= 2013, year <= 2017, age >= 0, age <= 84) %>%
  mutate(sex = str_to_lower(sex))

use_data(population, overwrite = TRUE)
