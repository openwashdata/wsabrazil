# Description -------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame
# Load packages -----------------------------------------------------------
library(tidyverse)
library(openwashdata)
library(readxl)
library(janitor)
library(dplyr)

# Read data -------------------------------------------------------------
data_in <- read_csv2("data-raw/PA_census_data.csv") |>
  as_tibble()

# Tidy data ---------------------------------------------------------------
data <- data_in |>
  select(-...1, -V002_h02)

# Change column names
colnames(data) <- c("sector_code", "municipality_name", "municipality_code",
                    "sector_situation", "MR_name", "sector_type", "avg_income",
                    "total_households", "piped_water", "well_spring_water","stored_rainwater", "other_water_source", "private_bathroom",
                    "bathroom_sewerage", "bathroom_septic_tank", "bathroom_cesspit", "bathroom_ditch", "bathroom_waterbodies", "bathroom_other")

# Modify sector_situation and sector_type variables
data_adjusted_1 <- data |>
  mutate(sector_situation = case_when(
    sector_situation %in% c(1, 2, 3) ~ "urban", sector_situation %in% c(4, 5, 6) ~ "rural"
  )) |>
  mutate(sector_type = case_when(
    sector_type == "slum" ~ 0, sector_type == "not_slum" ~ 1
  ))

wsabrazil <- data_adjusted_1

wsabrazil <- wsabrazil |>
  mutate(avg_income = str_replace_all(avg_income, ",", ".")) |>
  mutate(avg_income = as.integer(avg_income)) |>
  mutate(sector_type = as.integer(sector_type))

# Write data -------------------------------------------------------------
usethis::use_data(wsabrazil, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
write_csv(wsabrazil, here::here("inst", "extdata", "wsabrazil.csv"))
openxlsx::write.xlsx(wsabrazil, here::here("inst", "extdata", "wsabrazil.xlsx"))
