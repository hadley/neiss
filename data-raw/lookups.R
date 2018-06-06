library(rvest)
library(purrr)

builder <- read_html("data-raw/query-builder.html")

selects <- builder %>% html_nodes("select")

options <- selects %>% map(. %>% html_nodes("option"))
names(options) <- selects %>% html_attr("name")

desc <- options %>% map(. %>% html_text())
val <- options %>% map(. %>% html_attr("value") %>% as.integer())

raw_lookups <- map2(desc, val, setNames) %>% map(~ ifelse(. == "", NA, .))

disposition <- c(
  "0" = "No injury",
  "1" = "Released",
  "2" = "Transferred",
  "4" = "Admitted",
  "5" = "Observation",
  "6" = "Left",
  "8" = "Died",
  "9" = NA
)

fmv <- c(
  "0" = "No fire/flame/smoke",
  "1" = "Fire dept attended",
  "2" = "Fire dept did not attend",
  "3" = "Fire dept attendence not recorded"
)

race <- c(
  "0" = "Not stated",
  "1" = "White",
  "2" = "Black",
  "3" = "Other",
  "4" = "Asian",
  "5" = "Hispanic",
  "6" = "Pacific Islander"
)

lookups <- list(
  body_part = raw_lookups$ddlBodyPart,
  diag = raw_lookups$ddlDiagnosis,
  location = raw_lookups$ddlLocation,
  sex = raw_lookups$ddlSex,
  fmv = fmv,
  disposition = disposition,
  race = race
)

saveRDS(lookups, "data-raw/lookups.rds")
