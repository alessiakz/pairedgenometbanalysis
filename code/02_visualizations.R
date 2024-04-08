#set working directory
here::i_am("code/02_visualizations.R")

#load libraries
library(tidyverse) #used for data manipulation and cleaning
library(ggplot2) #visualizations
library(car) #for qqplot and density plots
library(patchwork) #put plots together
library(RColorBrewer) #color palettes

#load data
data_clean <- readRDS(
  file = here::here("data/data_merged.rds")
)

#explore data

median <- data_filter %>% 
  group_by(gene, infected) %>% 
  summarize(median_FPKM = median(FPKM)) %>% 
  arrange(-median_FPKM)

median_50 <- data_filter %>% 
  group_by(gene, infected) %>% 
  summarize(median_FPKM = median(FPKM)) %>% 
  arrange(-median_FPKM) %>% 
  head(50)

median_uninfected <- data_filter %>%
  filter(infected == "Uninfected") %>%
  group_by(gene) %>%
  summarize(median_FPKM = median(FPKM)) %>% 
  arrange(-median_FPKM) %>% 
  tail(-4)

median_infected <- data_filter %>%
  filter(infected == "Infected") %>% 
  group_by(gene) %>%
  summarize(median_FPKM = median(FPKM)) %>% 
  arrange(-median_FPKM) %>% 
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
genes_of_interest <- c("ENSG00000087086.15", "ENSG00000167996.16", 
                       "ENSG00000164733.22", "ENSG00000166710.22",
                       "ENSG00000164733.22", "")

genes_of_interest <- unique(median_50$gene)

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

heatmap_50 <- data_clean %>% 
  filter(gene %in% genes_of_interest) %>% 
  ggplot(aes(x=samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'dark blue')

heatmap_50_infected <- data_clean %>% 
  filter(gene %in% genes_of_interest & infected == "Infected") %>% 
  ggplot(aes(x=samples, y = gene, fill = FPKM)) +
  geom_tile(show.legend = FALSE) +
  scale_fill_gradient(low = 'white', high = 'dark blue') +
  theme_minimal() +
  xlab("Infected") + ylab("Gene") +
  scale_x_discrete(guide = guide_axis(n.dodge=2))

heatmap_50_uninfected <- data_clean %>% 
  filter(gene %in% genes_of_interest & infected == "Uninfected") %>% 
  ggplot(aes(x=samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'dark blue') +
  theme_minimal() +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank()) +
  xlab("Uninfected")

heatmap <- heatmap_50_infected + heatmap_50_uninfected + 
  plot_annotation("Gene Expression in Macrophages by Infected and Uninfected TB Groups (n=44 samples)",
                  theme=theme(plot.title=element_text(size=18, hjust=0.5)))

#saving plots
ggsave(heatmap, filename = here::here("output/heatmap.png"), width = 15, height = 9)
