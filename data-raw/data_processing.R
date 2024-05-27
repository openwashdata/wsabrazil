# Description -------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame
# Load packages -----------------------------------------------------------
library(tidyverse)
library(openwashdata)
library(readxl)
library(janitor)
library(dplyr)
library(cctu)

# Read data -------------------------------------------------------------
data_in <- read_csv2("data-raw/PA_census_data.csv") |>
  as_tibble()

data_in_2 <- read_csv2("data-raw/all_states_dfs_2010_stacked.csv") |>
  as_tibble()

# Tidy data ---------------------------------------------------------------
data <- data_in |>
  select(-...1, -V002_h02)

data_2 <- data_in_2 |>
  select(sector_code,great_region_name,FU_code,FU_name,
         meso_code,meso_name,micro_code,micro_name,
         MR_code,MR_name,municipality_code,municipality_name,
         district_code,district_name,subdistrict_code,
         subdistrict_name,neighb_code,neighb_name,
         sector_situation,sector_type,V005_bas,V002_h01,
         V012_h01,V013_h01,V014_h01,V015_h01,V016_h01,
         V017_h01,V018_h01,V019_h01,V020_h01,V021_h01,V022_h01)

# Change column names
colnames(data) <- c("sector_code", "municipality_name", "municipality_code",
                    "sector_situation", "MR_name", "sector_type", "avg_income",
                    "total_households", "piped_water", "well_spring_water","stored_rainwater", "other_water_source", "private_bathroom",
                    "bathroom_sewerage", "bathroom_septic_tank", "bathroom_cesspit", "bathroom_ditch", "bathroom_waterbodies", "bathroom_other")
colnames(data_2) <- c("sector_code","great_region_name","FU_code","FU_name",
                      "meso_code","meso_name","micro_code","micro_name",
                      "MR_code","MR_name","municipality_code","municipality_name",
                      "district_code","district_name","subdistrict_code",
                      "subdistrict_name","neighb_code","neighb_name",
                      "sector_situation","sector_type", "avg_income",
                      "total_households", "piped_water", "well_spring_water",
                      "stored_rainwater", "other_water_source", "private_bathroom",
                      "bathroom_sewerage", "bathroom_septic_tank", "bathroom_cesspit",
                      "bathroom_ditch", "bathroom_waterbodies", "bathroom_other")

# Modify sector_situation and sector_type variables
data_adjusted_1 <- data |>
  mutate(sector_situation = case_when(
    sector_situation %in% c(1, 2, 3) ~ "urban", sector_situation %in% c(4, 5, 6) ~ "rural"
  )) |>
  mutate(sector_type = case_when(
    sector_type == "slum" ~ 0, sector_type == "not_slum" ~ 1
  ))

data_adjusted_2 <- data_2 |>
  mutate(sector_situation = case_when(
    sector_situation %in% c(1, 2, 3) ~ "urban", sector_situation %in% c(4, 5, 6) ~ "rural"
  ))

# Merge the two data sets
merged_data <- full_join(data_adjusted_1, data_adjusted_2, by = c("sector_code", "municipality_name", "municipality_code",
                                              "sector_situation", "MR_name", "sector_type", "avg_income",
                                              "total_households", "piped_water", "well_spring_water","stored_rainwater", "other_water_source", "private_bathroom",
                                              "bathroom_sewerage", "bathroom_septic_tank", "bathroom_cesspit", "bathroom_ditch", "bathroom_waterbodies", "bathroom_other"))

# Modify some variables' types
wsabrazil <- merged_data |>
  mutate(avg_income = as.integer(avg_income)) |>
  mutate(sector_type = as.integer(sector_type))

# Remove non-UTF8 entries
cctu::detect_invalid_utf8(wsabrazil)
wsabrazil_utf8 <- cctu::remove_invalid_utf8(wsabrazil)

# Write data -------------------------------------------------------------
usethis::use_data(wsabrazil, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
write_csv(wsabrazil, here::here("inst", "extdata", "wsabrazil.csv"))
openxlsx::write.xlsx(wsabrazil_utf8, here::here("inst", "extdata", "wsabrazil.xlsx"))
