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

data <- data_in |>
  separate(col = col, into = c("id", "sector_code", "municipality_name", "municipality_code",
                                 "sector_situation", "MR_name", "sector_type", "V005_bas",
                                 "V002_h01", "V012_h01", "V013_h01","V014_h01", "V015_h01", "V016_h01",
                                 "V017_h01", "V018_h01", "V019_h01", "V020_h01", "V021_h01", "V022_h01",
                                 "V002_h02"), sep = ";", convert = TRUE)

data <- data |>
  select(-id)
variable_types <- sapply(data, typeof)

# Write data -------------------------------------------------------------
usethis::use_data(DATASET, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
write_csv(DATASET, here::here("inst", "extdata", "DATASET.csv"))
openxlsx::write.xlsx(DATASET, here::here("inst", "extdata", "DATASET.xlsx"))
