here::i_am("src/analysis/create_samp_table.R")
library(stringr)
library(tidyverse)
library(officer)
library(flextable)
library(yaml)
library(here)
args = commandArgs(trailingOnly=TRUE)
config <- yaml.load_file(here(args[1]))

# Load config -------------------------------------------------------------
date <- config$date
project <- config$project_name
file_path <- config$sample_summary_csv

# Reformat sample ID column -----------------------------------------------
samp_sum <- read.csv(file_path) %>% 
  dplyr::slice(-1:-2) %>% 
  dplyr::rename("Sample.ID"="MIP") %>% 
  mutate(ID = stringr::str_split_fixed(Sample.ID, "-(?=[A-Z])",2)[,1],
         location=stringr::str_split_fixed(Sample.ID, "-(?=[A-Z])",2)[,2]) 

# Summarize location data -------------------------------------------------
sum_tbl <- samp_sum %>% 
  select(ID,location) %>% 
  group_by(location) %>% 
  summarise(n = n())

# Create table ------------------------------------------------------------
border_style <-  officer::fp_border(color="black", width=3)
table_plt <- sum_tbl %>%  
  flextable::flextable() %>% 
  flextable::autofit() %>% 
  flextable::width(j=c(1,2), width = 2) %>% 
  flextable::set_header_labels(
    location = "Location",
    n  = "Sample Size") %>% 
  flextable::border_remove() %>% 
  # add  box theme
  flextable::theme_box() %>%
  # change borders
  flextable::border(border = border_style) %>% 
  flextable::border(border = border_style, part = "header") %>% 
  flextable::align(align = "center",part = "all")
flextable::save_as_image(table_plt, path = here(paste0('plots/',date,'/',date,'_tbl.png')), webshot = "webshot2")
