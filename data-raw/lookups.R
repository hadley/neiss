library(rvest)
library(purrr)

builder <- read_html("data-raw/query-builder.html")

selects <- builder %>% html_nodes("select")

options <- selects %>% map(. %>% html_nodes("option"))
names(options) <- selects %>% html_attr("name")

desc <- options %>% map(. %>% html_text())
val <- options %>% map(. %>% html_attr("value") %>% as.integer())

lookups <- map2(desc, val, setNames) %>% map(~ ifelse(. == "", NA, .))

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

lookups <- list(
  body_part = lookups$ddlBodyPart,
  diag = lookups$ddlDiagnosis,
  location = lookups$ddlLocation,
  fmv = fmv,
  disposition = disposition
)

saveRDS(lookups, "data-raw/lookups.rds")
