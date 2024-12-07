library(googlesheets4)
library(tidyverse)

in_link <- "https://docs.google.com/spreadsheets/d/1f_r4A7FlqURfNhFSUu9mfHxl-y2UWC2qsOpcD3KCr3U"

in_forms <- read_sheet(ss = in_link) |>  rename(research = `Investigador / Investigadora`)
in_nodes <- read_sheet(ss = in_link, sheet = "nodos" )

in_data <- in_forms |> left_join(in_nodes, by = join_by(research == Investigador  ))

in_data<- in_data |> 
  select(research,H1,H2,H3,logo_viz) |> rename(platform = research ) |> 
  mutate(year = 2024)

write.csv(in_data, "cefb.csv")
