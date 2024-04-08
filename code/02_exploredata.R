#set working directory
here::i_am("code/02_exploredata.R")

#load libraries
library(tidyverse) #used for data manipulation and cleaning

#import data from RDS
data_merged <- readRDS(
  file = here::here("data/data_merged.rds"))
