library(dplyr)
library(magrittr)
library(leaflet)

whisky_data <- CodeClanData::whisky

regions <- sort(unique(whisky_data$Region))
