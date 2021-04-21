library(quantmod)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(DT)
library(tidyverse)
library(lubridate)

master_df <- read.csv('amazon.csv')
state_list <- c('Acre', 'Alagoas', 'Amapa', 'Amazonas', 'Bahia',
                'Ceara', 'Distrito Federal', 'Espirito Santo', 'Goias',
                'Maranhao', 'Mato Grosso', 'Minas Gerais', 'Pará', 'Paraiba',
                'Pernambuco', 'Piau', 'Rio', 'Rondonia', 'Roraima',
                'Santa Catarina', 'Sao Paulo', 'Sergipe', 'Tocantins')

master_df$X <- NULL

master_df <- master_df %>% drop_na()
master_df$year <- strptime(master_df$year, format='%Y')