library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)

library(data.table)


 
df <- read.csv('~/nycds10/scraping_project/final.csv', stringsAsFactors = FALSE)
tickers <- unique(df$ticker)
ratingNames <- df %>% filter(rating != "-1")
ratings <- append(unique(ratingNames$rating), "All")
brokerageNames <- df %>% filter(brokerage_firm != "-1") 
brokerage <- append(unique(brokerageNames$brokerage_firm), "All")
sectorsNames <- df %>% filter(sector != "-1") 
sectors <-  unique(sectorsNames$sector)   
