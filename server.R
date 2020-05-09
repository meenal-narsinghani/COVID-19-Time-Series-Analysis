#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Loading the required libraries
library(shiny)
library(shinyWidgets)
library(tseries)
library(forecast)
library(dplyr)
library(knitr)

#Setting the working directory
#setwd("E:/Spring Sem 2019/BANA 7050 - Time Series/Project/covid19-global-forecasting-week-4/COVID-19_Forecasting/NavbarFile/NavbarFile")

#Reading the input data file
train_data <- read.csv("train.csv")


function(input, output, session) {
    
    #Creating "country" dataset to filter data based on the country selected
    country <- reactive ({
        
        train_data[train_data$Country_Region == toString(input$Country),]
    })
    
    
    #Rolling up the total confirmed cases at Country level
    new_cases <- reactive ({
        country() %>% dplyr::select(Date, ConfirmedCases) %>%
                                group_by(Date) %>% 
                                    mutate(TotalConfirmedCases = sum(ConfirmedCases)) %>%
                                        ungroup()%>%
                                            dplyr::select(Date, TotalConfirmedCases) %>% 
                                                distinct() %>% 
                                                    dplyr::select(TotalConfirmedCases)
    
    })
    
    
    #Converting the COnfirmed Cases data into TS object
    original_ts <- reactive({
        as.ts(new_cases())
    })
    
    
    #Fitting ARIMA model based on user selection
    ts_fit <- reactive ({
        if(input$ChooseModel == "Auto Arima")
        {
                auto.arima(original_ts())
        }
        else
            if(input$ChooseModel == "Build your own model")
            {
                arima(original_ts(),c(input$p,input$d,input$q))
            }   
    })
    
    
    #Output the original TS plot - "plot"
    output$plot <- renderPlot({
        plot(original_ts(), main = "Time Series", lwd = 3, col = "darkblue")})
    
    
    #Output the ACF of original TS plot - "acfplot"
    output$acfplot <- renderPlot({
        plot(Acf(original_ts()), main = "ACF Plot", lwd = 3, col = "darkblue")})

    
    #Output the PACF of original TS plot - "pacfplot"
    output$pacfplot <- renderPlot({
        plot(pacf(original_ts()), main = "PACF Plot", lwd = 3, col = "darkblue")})
    
    
    #Output the forcasting results plot - "forecast"
    output$forecast <- renderPlot({
        plot(forecast(ts_fit(), input$h), lwd = 3, col = "darkblue")
    })
    
    
    #Output the forcasting results values - "forecast"
    output$forecastvalues <- renderPrint({
        data.frame(Forecast = as.numeric(round(forecast(ts_fit(), input$h)$mean, 0)),
                   Lower80 = as.numeric(round(forecast(ts_fit(), input$h)$lower[,1], 0)),
                   Upper80 = as.numeric(round(forecast(ts_fit(), input$h)$upper[,1], 0)),
                   Lower95 = as.numeric(round(forecast(ts_fit(), input$h)$lower[,2], 0)),
                   Upper95 = as.numeric(round(forecast(ts_fit(), input$h)$upper[,2], 0)))
    })
    
    
    #Output the fitted model summary - "summary"
    output$summary <- renderPrint({ 
        ts_fit()
    })
    

    #Output the model adequacy test results - "boxout"
    output$boxout <- renderPrint({ 
        Box.test(resid(ts_fit()),  type = "Ljung-Box")
    })
    
        
    #Output the fitted model output - "fitted"
    output$fitted <- renderPlot({ 
        plot(original_ts(), main = "Time series with model fit", lwd = 2, col = "darkblue")
        points(fitted(ts_fit()), pch = 20, col = "grey")
        points(fitted(ts_fit()), type = "l", col = "red")
    })
    
    
    #Output the residuals - "residuals"
    output$residuals <- renderPlot({ 
        checkresiduals(ts_fit())
    })
    
    
    #Output the raw data - "data"
    output$data <- renderPrint({
        kable(head(train_data %>% 
                    select(Country_Region, Date, ConfirmedCases, Fatalities) %>%
                       filter(Country_Region == toString(input$Country)) %>%
                        group_by(Country_Region, Date) %>%
                            mutate(TotalCases = sum(ConfirmedCases),
                                   TotalFatalities = sum(Fatalities)) %>%
                                    select(-c(ConfirmedCases, Fatalities)) %>%
                                        filter(TotalCases > 0) %>%
                                         rename(Country = Country_Region), input$n))
        
    })
    
}



