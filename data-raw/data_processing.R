# Description -------------------------------------------------------------
# R script to process uploaded raw data into a tidy, analysis-ready data frame
# Load packages -----------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)
library(dplyr)

# Read data -------------------------------------------------------------
# data-raw/PA_census_data.csv (1965 census sectors of the Belém metropolitan
# region, state of Pará) is not used. Every one of its sectors is also in the
# stacked file below with the same household counts and income, so merging it
# only added duplicate rows without geography codes (issue #4). The file stays
# in data-raw/ for provenance.

# The stacked file for all states is Latin-1 encoded (place names such as
# "Rondônia" or "Vale do Juruá"); read it with that encoding so readr converts
# the text to UTF-8.
data_in_2 <- read_csv2(
  "data-raw/all_states_dfs_2010_stacked.csv",
  locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "latin1")
) |>
  as_tibble()

# Tidy data ---------------------------------------------------------------
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
data_adjusted_2 <- data_2 |>
  mutate(sector_situation = case_when(
    sector_situation %in% c(1, 2, 3) ~ "urban", sector_situation %in% c(4, 5, 6) ~ "rural"
  ))

# Put the columns in the published order
merged_data <- data_adjusted_2 |>
  relocate(sector_code, municipality_name, municipality_code,
           sector_situation, MR_name, sector_type, avg_income,
           total_households, piped_water, well_spring_water,
           stored_rainwater, other_water_source, private_bathroom,
           bathroom_sewerage, bathroom_septic_tank, bathroom_cesspit,
           bathroom_ditch, bathroom_waterbodies, bathroom_other)

# Modify some variables' types
wsabrazil <- merged_data |>
  mutate(avg_income = as.integer(avg_income)) |>
  mutate(sector_type = as.integer(sector_type), neighb_code = as.integer(neighb_code),
         subdistrict_code = as.integer(subdistrict_code), district_code = as.integer(district_code),
         municipality_code = as.integer(municipality_code), MR_code = as.integer(MR_code),
         micro_code = as.integer(micro_code), meso_code = as.integer(meso_code))

# FU_code is the 2-digit IBGE code of the state (federative unit). The raw
# column holds "ES" instead of 32 for Espirito Santo, so derive the code from
# the first two digits of the 4-digit mesoregion code, which is the same for
# every other state.
wsabrazil <- wsabrazil |>
  mutate(FU_code = as.integer(meso_code %/% 100))

# Check that all text is valid UTF-8
stopifnot(all(unlist(lapply(
  Filter(is.character, wsabrazil),
  function(x) validUTF8(x[!is.na(x)])
))))

# Write data -------------------------------------------------------------
usethis::use_data(wsabrazil, overwrite = TRUE, version = 2)
fs::dir_create(here::here("inst", "extdata"))
write_csv(wsabrazil, here::here("inst", "extdata", "wsabrazil.csv"))
openxlsx::write.xlsx(wsabrazil, here::here("inst", "extdata", "wsabrazil.xlsx"))
