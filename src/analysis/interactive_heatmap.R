here::i_am("src/analysis/interactive_heatmap.R")
library(tidyverse)
library(plotly)
library(yaml)
args = commandArgs(trailingOnly=TRUE)
#config <- yaml.load_file(here(args[1]))
config <- yaml.load_file(here('config/YYYY_MM_DD/YYYY_MM_DD_config.yaml'))

# Load config -------------------------------------------------------------
date <- config$date
project <- config$project_name
file_path <- config$sample_summary_csv


# reformat matrix ---------------------------------------------------------
samp_sum <- read.csv(here(file_path)) %>% 
  dplyr::slice(-1:-2) %>% 
  dplyr::rename("Sample.ID"="MIP") %>%
  column_to_rownames("Sample.ID") %>% 
  mutate(across(everything(),as.numeric)) %>% 
  mutate(across(where(is.numeric), ~ log2(. + 1)))


# Get sample IDs and MIPs -------------------------------------------------
samps <- rownames(samp_sum)
mips <- colnames(samp_sum)


# create graph ------------------------------------------------------------
fig <- plot_ly(
  z = as.matrix(samp_sum),
  x = mips,
  y = samps,
  type = "heatmap",
  colorscale = "Viridis",
  colorbar = list(title = list(text = "<b>log2(UMI_Counts + 1)</b>", side = "top"))) %>%
  plotly::layout(
    xaxis = list(title = "mips", side = "bottom"),
    yaxis = list(title = "samples"))
htmlwidgets::saveWidget(fig,
                        here(paste0('plots/',date,'/',date,'_sample_probe_UMI.html')),
                        selfcontained = F, libdir = "lib")
