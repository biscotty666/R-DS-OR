
# Exploratory Data Analysis -----------------------------------------------



# Generate questions about your data.
# 
# Search for answers by visualizing, transforming, and modelling your data.
# 
# Use what you learn to refine your questions and/or generate new questions.


# 
# What type of variation occurs within my variables?
#   
# What type of covariation occurs between my variables?
  

library(tidyverse)


# Variation ---------------------------------------------------------------

ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth = 0.5)

# Typical Values
