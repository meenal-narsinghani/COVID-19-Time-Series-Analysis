#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(shinyWidgets)
library(shinythemes)
library(knitr)

#Setting the working directory
#setwd("E:/Spring Sem 2019/BANA 7050 - Time Series/Project/covid19-global-forecasting-week-4/COVID-19_Forecasting/NavbarFile/NavbarFile")

#Reading the input data file
train_data <- read.csv("train.csv")

#Set inital value for number of records to be displayed in Data tab
n <- 10

p <- 0
d <- 0
q <- 0
h <- 20

navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
           id="nav","COVID-19 Predictions",

                      
           tabPanel("Data",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput("Country", "Select a country",
                                    choices=unique(train_data$Country_Region)),
                        numericInput('n', 'Select number of rows', n, min = 0),
                        HTML(paste(h4("Original data"))),
                        verbatimTextOutput("data")),
                      mainPanel(
                        plotOutput("plot"),
                        fluidRow(
                          column(width = 6, plotOutput("acfplot")),
                          column(width = 6, plotOutput("pacfplot"))
                        )
                        ))), #Plot tab ends

           

           tabPanel("Model Summary",
                    sidebarLayout(
                      sidebarPanel(
                        radioButtons("ChooseModel", "Choose Model",
                                     c("Auto Arima"="Auto Arima", "Build your own model"="Build your own model")),
                        
                        conditionalPanel(condition= "input.ChooseModel == 'Build your own model'",
                          numericInput('p', 'Select value of p', p, min = 0)),
                        
                        conditionalPanel(condition= "input.ChooseModel == 'Build your own model'",
                                         numericInput('d', 'Select value of d', d, min = 0)),
                        
                        conditionalPanel(condition= "input.ChooseModel == 'Build your own model'",
                                         numericInput('q', 'Select value of q', q, min = 0)),

                        verbatimTextOutput("summary"),
                        verbatimTextOutput("boxout")
                        ),
                      mainPanel(
                        plotOutput("fitted"),
                        plotOutput("residuals")))), #Model Summary ends
           
           
           tabPanel("Forecasting",
                    sidebarLayout(
                      sidebarPanel(
                        numericInput('h', 'Number of days to forecast', h, min = 0, max = 30),
                        HTML(paste(h4("Forecasted values with 80 and 95 percentiles"))),
                        verbatimTextOutput("forecastvalues")),
                      mainPanel(
                        plotOutput("forecast", height = "700px")
                      )))
           
           # tabPanel("Forecasting",
           #          plotOutput("forecast")) #Forecasting tab ends
           

) #NavBar ends
