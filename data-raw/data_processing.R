# Description -------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame
# Load packages -----------------------------------------------------------
library(tidyverse)
library(openwashdata)
library(readxl)
library(janitor)
library(dplyr)

# Read data -------------------------------------------------------------
data_in <- read_csv("data-raw/PA_census_data_processed.csv") |>
  as_tibble()
codebook <- read_csv("data-raw/dictionary_project.csv") |>
  clean_names()

# Tidy data ---------------------------------------------------------------
variable_names <- codebook |>
  select(variable_name)
variable_description <- codebook |>
  select(description)
colnames(data_in)[1] <- "col"

# Split column
data <- data_in |>
  separate(col = col, into = c("id", "sector_code", "municipality_name", "municipality_code",
                                 "sector_situation", "MR_name", "sector_type", "V005_bas",
                                 "V002_h01", "V012_h01", "V013_h01","V014_h01", "V015_h01", "V016_h01",
                                 "V017_h01", "V018_h01", "V019_h01", "V020_h01", "V021_h01", "V022_h01",
                                 "V002_h02"), sep = ";", convert = TRUE)

data <- data |>
  select(-id)

# Modify sector_situation and sector_type variables
data_adjusted_1 <- data |>
  mutate(sector_situation = case_when(
    sector_situation %in% c(1, 2, 3) ~ "urban", sector_situation %in% c(4, 5, 6) ~ "rural"
  )) |>
  mutate(sector_type = case_when(
    sector_type == "slum" ~ 1, sector_type == "not_slum" ~ 0
  ))

wsabrazil <- data_adjusted_1

# Write data -------------------------------------------------------------
usethis::use_data(wsabrazil, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
write_csv(wsabrazil, here::here("inst", "extdata", "wsabrazil.csv"))
openxlsx::write.xlsx(wsabrazil, here::here("inst", "extdata", "wsabrazil.xlsx"))
