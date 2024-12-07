library(googlesheets4)
library(tidyverse)

in_link <- "https://docs.google.com/spreadsheets/d/1f_r4A7FlqURfNhFSUu9mfHxl-y2UWC2qsOpcD3KCr3U"

in_forms <- read_sheet(ss = in_link) |>  rename(research = `Investigador / Investigadora`)

in_forms <- in_forms |> 
  mutate(
    H1 = str_replace_all(H1, ",\\s+", ","),
    H2 = str_replace_all(H2, ",\\s+", ","),
    H3 = str_replace_all(H3, ",\\s+", ",")
  )

in_nodes <- read_sheet(ss = in_link, sheet = "nodos" )

in_data <- in_forms |> left_join(in_nodes, by = join_by(research == Investigador  ))

in_data<- in_data |> 
  select(research,H1,H2,H3,logo_viz) |> 
  rename(platform = research, conocimiento = H1, técnica = H2, blanda = H3 ) |> 
  mutate(year = 2024)

write.csv(in_data, "cefb.csv")


h_conocimiento <- in_data |> 
  select(conocimiento) |> 
  separate_rows(conocimiento, sep = ",") |> 
  gather(key = "tipo_habilidad", value = "habilidad")

h_tecnica <- in_data |> 
  select(técnica) |> 
  separate_rows(técnica, sep = ",") |> 
  gather(key = "tipo_habilidad", value = "habilidad")

h_blanda <- in_data |> 
  select(blanda) |> 
  separate_rows(blanda, sep = ",") |> 
  gather(key = "tipo_habilidad", value = "habilidad")

skills_count <- rbind(h_conocimiento,h_tecnica,h_blanda)

skills_count<- skills_count |> 
  count(tipo_habilidad,habilidad, name = "cantidad") |> 
  arrange(tipo_habilidad,desc(cantidad))

write.csv(skills_count,"skills_count.csv", row.names = F)
