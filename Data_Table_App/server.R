#Shiny Server for Data Tables

#Install these packages and also install the 'DT' package
library(shiny)
library(ggplot2)
library(readxl)
library(data.table)
library(gdata)
library(dplyr)

#Load data sets
cfs_2012 <- fread("cfs_2012.txt", data.table = FALSE)
foreign_trade <- read_excel("country.xlsx")
country <- c("Canada", "Mexico")
years <- c("1985", "2015")

shinyServer(function(input, output) {
  
  # choose columns to display
  output$cfs <- DT::renderDataTable({
    DT::datatable(cfs_2012[, input$show_vars, drop = FALSE])
  })
  
  output$trade <- DT::renderDataTable({
    DT::datatable(subset(
      subset(foreign_trade, foreign_trade$year %in% input$years & foreign_trade$CTYNAME %in% input$country)
      )[, input$show_vars2, drop = FALSE])
  })
  
})