####    This script is to filter the whole data on the basis of virus 

##installing and loading dependencies
install.packages("tidyverse")
library(dplyr)

## Loading the metadata
data_frame<-read.table("~/Bipartite/gene_attribute_edges.txt", header = TRUE, sep = "\t") 
data_frame <- data_frame[-1, ]
head(data_frame)

## Here we want to filter the data on the basis of virus, We want to get the host- virus protein interaction of only Epstein-Barr virus (strain B95-8)
new_data_frame <- data_frame %>%
  filter(target_desc == "Epstein-Barr virus (strain B95-8)") %>%  # Filter based on target_desc
  select(source_desc, target, weight)  # Select specific columns
new_data_frame$weight <- as.numeric(new_data_frame$weight)

## processing of the data to convert into matrix 
pivoted_data <- pivot_wider(new_data_frame, names_from = source_desc, values_from = weight , values_fill = 0)
name_row<-as.list( pivoted_data$target)
pivoted_2 <-pivoted_data[,-1]
dimnames(pivoted_2)[[1]]<-name_row
ppi <-as.matrix(pivoted_2)

### One can do all sort of bipartite analysis here we are trying to make user get a idea of how bipartite interaction looks like.
plotweb (ppi, method ="normal", empty = TRUE, low.spacing = 0.035, high.spacing = 0.009, col.high = "sky blue", col.low = "light green", text.rot = 90, labsize = 1.2)
