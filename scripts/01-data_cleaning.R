#### Preamble ####
# Purpose: Clean the survey data downloaded from the City of Toronto Open Data Portal 
# Author: Qingya Li
# Data: 6 Feb 2022
# Contact: qingya.li@mail.utoronto.ca
# License: UofT
# Pre-requisites: 
# - Need to have downloaded the data and saved it to inputs/data
# - Don't forget to gitignore it!
# - Use ggplot2 and Knitr to make figures and tables 

#### Workspace setup ####
# Use R Projects, not setwd().
library(dplyr)
library(tidyverse)
library(ggplot2)
library(knitr)

# Read in the raw data. 
package <- show_package("7bce9bf4-be5c-4261-af01-abfbc3510309")
resources <- list_package_resources("7bce9bf4-be5c-4261-af01-abfbc3510309")
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))
df<- filter(datastore_resources, row_number()==1) %>% get_resource()

# Just keep some variables that may be of interest
df <- na.omit(df) 
df$OPEN_DATE <- as.Date(df$OPEN_DATE)
df$YEAR <- as.numeric(format(df$OPEN_DATE,'%Y'))

#### What's next? ####
#- summarize some important variables 
tab1 <- df %>% 
  group_by(APPLICATION_FOR, YEAR) %>%
  summarise(sum = sum(POTENTIAL_VOTERS),
            min = min(POTENTIAL_VOTERS),
            max = max(POTENTIAL_VOTERS),
            median = median(POTENTIAL_VOTERS),
            mean = mean(POTENTIAL_VOTERS),
            sd = sd(POTENTIAL_VOTERS))
knitr::kable(tab1, caption = "Summary Table for The Number of Potential Voters")