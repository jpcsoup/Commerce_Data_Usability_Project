#UI for Data Table

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

shinyUI(fluidPage(
  title = 'Data Table for Datasets',
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "cfs_2012"',
        checkboxGroupInput('show_vars', 'Check the columns you want to display:',
                           names(cfs_2012), selected = names(cfs_2012))
      ),
      conditionalPanel(
        'input.dataset === "foreign_trade"',
        checkboxGroupInput('show_vars2', 'Test',
                           names(foreign_trade), selected = names(foreign_trade)),
        helpText('The I indicates imports whereas the E indicates exports'),
        selectizeInput(
          "country", "Select the countries to compare:", 
          choices = unique(foreign_trade$CTYNAME), selected = c("Canada", "Mexico"),
          multiple = TRUE
        ),
        selectizeInput(
          "years", "Select the years to compare:",
          choices = unique(foreign_trade$year), selected = unique(foreign_trade$year),
          multiple = TRUE
        )
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel('cfs_2012', DT::dataTableOutput('cfs')),
        tabPanel('foreign_trade', DT::dataTableOutput('trade'))
      )
    )
  )
))