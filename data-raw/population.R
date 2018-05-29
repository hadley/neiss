library(tidyverse)
filter <- dplyr::filter

# http://www.census.gov/popest/data/intercensal/national/nat2010.html
old <- read_csv("data-raw/US-EST00INT-ALLDATA.csv")
names(old) <- tolower(names(old))

old_tidy <- old %>%
  filter(age != 999, month == 7, year != 2010) %>%
  select(year, age, tot_male, tot_female) %>%
  gather(sex, n, starts_with("tot_")) %>%
  mutate(sex = str_replace_all(sex, "tot_", "")) %>%
  arrange(year, age, sex)

# https://www.census.gov/popest/data/state/asrh/2014/SC-EST2014-AGESEX-CIV.html

new <- read_csv("data-raw/SC-EST2014-AGESEX-CIV.csv")
names(new) <- tolower(names(new))

new_tidy <- new %>%
  filter(name == "United States", age != 999, sex != 0) %>%
  select(sex, age, starts_with("popest")) %>%
  gather(year, n, starts_with("popest")) %>%
  mutate(
    sex = c("male", "female")[sex],
    year = as.integer(str_replace_all(year, "popest|_civ", ""))
  ) %>%
  select(year, age, sex, n) %>%
  arrange(year, age, sex)

# I think 85 = 85 and older
population <- bind_rows(old_tidy, new_tidy) %>% filter(age != 85)

library(ggplot2)

population %>%
  filter(age %% 5 == 0) %>%
  ggplot(aes(year, n, colour = sex)) +
  geom_line() +
  facet_wrap(~age)

population %>%
  ggplot(aes(age, n, group = year, colour = year)) +
  geom_line() +
  facet_wrap(~sex)

use_data(population, overwrite = TRUE)
