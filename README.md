# Paired Genome Analysis Between Infected and Uninfected Macrophage Samples

# Introduction

This is an introductory exploratory info gene expression data analysis. The primary goal of this project was to grow familiarity with working with gene expression data.

# Methods

I used a publicly available dataset obtained through the NCBI. The BioProject is available here: https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1091619. The GEO dataset is accessible at this link: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE262379. The dataset contains FPKM for macrophage genes from n=44 macrophage samples which were either infected or uninfected with a strain of tuberculosis. 

## 01_cleandata.R
I conducted basic data cleaning and transformations in R using the tidyverse package. I used the GEOquery package to pull metadata for the GEO dataset and then linked it to the main dataset. After, I conducted basic exploratory data analyses, including identifying the top 50 genes with the highest FPKM.

## 02_visualizations.R
I then created various visualizations of the data including a barplot, density plot, box and violin plots, scatterplot, and heatmaps. The final output is a heatmap of the genes with the highest median FPKM across all 44 samples, stratified by infection status. 

# Results
No significant differences in FPKM were observed between infected and uninfected macrophages.
