#set working directory
here::i_am("code/02_visualizations.R")

#load libraries
library(tidyverse) #used for data manipulation and cleaning
library(ggplot2) #visualizations

#load data
data_clean <- readRDS(
  file = here::here("data/data_merged.rds")
)
