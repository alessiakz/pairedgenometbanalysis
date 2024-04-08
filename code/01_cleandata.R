#set working directory
here::i_am("code/01_cleandata.R")

#load libraries
library(tidyverse) #used for data manipulation and cleaning
library(GEOquery) #used to obtain metadata

#import data
data_raw <- read.csv(here::here("data/GSE262379_TPM.csv"))

#get metadata using GEOquery package
gse <- getGEO(GEO = 'GSE262379', GSEMatrix = TRUE)

metadata <- pData(phenoData(gse[[1]]))

metadata_subset <- metadata %>% 
  select(title, characteristics_ch1.3, description) %>% 
  rename(infected = characteristics_ch1.3) %>% 
  mutate(infected = gsub("treatment: ", "", infected))

#transform raw genome data from wide to long
data_long <- data_raw %>% 
  rename(gene = gene_id) %>% 
  gather(key = 'samples', value = 'FPKM', -gene)

#merge genome data to metadata
data_merged <- data_long %>% 
  left_join(., metadata_subset, by = c("samples" = "description"))

#export dataframe
saveRDS(
  data_merged,
  file = here::here("data/data_merged.rds"))

