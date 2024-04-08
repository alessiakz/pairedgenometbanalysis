#set working directory
here::i_am("code/02_visualizations.R")

#load libraries
library(tidyverse) #used for data manipulation and cleaning
library(ggplot2) #visualizations

#load data
data_clean <- readRDS(
  file = here::here("data/data_merged.rds")
)

data_filter <- data_clean %>% 
  filter(FPKM != 0)

#explore data
mean_uninfected <- data_filter %>%
  filter(infected == "Uninfected") %>%
  group_by(gene) %>%
  summarize(mean_FPKM = mean(FPKM)) %>% 
  arrange(-mean_FPKM) %>% 
  tail(-4)

mean_infected <- data_filter %>%
  filter(infected == "Infected") %>% 
  group_by(gene) %>%
  summarize(mean_FPKM = mean(FPKM)) %>% 
  arrange(-mean_FPKM) %>% 
  tail(-4)

#barplot

#selected the gene with the highest FPKM
data_clean %>% 
  filter(gene == "ENSG00000087086.15") %>% 
  ggplot(aes(x = samples, y = FPKM, fill = infected)) +
  geom_col()

#density
data_clean %>% 
  filter(gene == "ENSG00000087086.15") %>%
  ggplot(aes(x = FPKM, fill = infected)) +
  geom_density(alpha = 0.3)

#boxplot
data_clean %>% 
  filter(gene == "ENSG00000087086.15") %>%
  ggplot(aes(x = infected, y = FPKM, fill = infected)) +
  geom_boxplot()

#violin
data_clean %>% 
  filter(gene == "ENSG00000087086.15") %>%
  ggplot(aes(x = infected, y = FPKM, fill = infected)) +
  geom_violin()

#scatterplot
data_clean %>% 
  filter(gene == "ENSG00000087086.15" | gene == "ENSG00000167996.16" ) %>%
  spread(key = gene, value = FPKM) %>%
  ggplot(aes(x=ENSG00000087086.15, y = ENSG00000167996.16, color = infected)) +
  geom_point() +
  geom_smooth(method = 'lm', se = FALSE)

#heatmap
genes_of_interest <- c("ENSG00000166710.23", "ENSG00000205542.11", "ENSG00000090382.7",
                       "ENSG00000117984.15", "ENSG00000136235.17",
                       "ENSG00000280614.1", "ENSG00000280800.1", "ENSG00000281181.1",
                       "ENSG00000197746.15", "ENSG00000117984.15")

heatmap <- data_clean %>%
  filter(gene %in% genes_of_interest) %>%
  ggplot(aes(x = samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'dark blue')

heatmap_byinfected <- data_clean %>%
  filter(gene %in% genes_of_interest) %>%
  ggplot(aes(x = infected, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'dark blue')

#saving plots
# ggsave(plot, filename="", width= 10, height = 8)