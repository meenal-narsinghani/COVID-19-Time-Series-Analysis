# COVID-19-Time-Series-Analysis


The R shiny app for this analysis can be found [here](https://meenal-narsinghani.shinyapps.io/shiny_application/)

**Introduction**

The world has recently been affected by the pandemic, Covid-19 that has currently grown to more than 3 million cases in the world. The growth rate has been exponential. Different countries have handled the outbreak in different ways, with varying degrees of success. 
A recent on-going Kaggle competition provides the data and the incentive to competitors around the world to predict the pattern of the disease and the course taken by different countries. The aim is to answer certain key questions regarding the disease and identifying underlying trends.
The time-series data was used in this project to model and forecast the total # of cases into the future. The main aim was to design a model for the time-series data and forecast the number for the future. Data was chosen was a single country, India, for this purpose. A R-Shiny dashboard was designed and built to scale the models to all the countries. This provides the flexibility to the user to select a country and create a model of their choice to achieve a forecast.

**Data**

While the data was provided as part of the Kaggle competition, the original data source is from the John Hopkins database. The key columns in the dataset include the following information. 
•	Province and Country – To identify the country, and in a few cases the province
•	Date – Daily date for when the observation was recorded
•	Confirmed Cases and Fatalities – Total confirmed cases and fatalities on that date

**Approach**

Data was taken for India, and the preliminary plots were visualized. Data was from 30th January to 17th April and contains about 79 data points. This was converted into a time-series data object. It is not surprising to see that there is an increasing trend in the data. Post the initial few days, the number of cases has risen exponentially (which already suggests non-stationarity). The augmented Dickey Fuller test results in a p-value of 0.99, and this implies non-stationarity (failed to reject H0).
By intuition, there cannot be a seasonal component as now (and hopefully will not be in the future!). The ACF suggests slow decay, giving way to a necessity of an ARIMA component, including perhaps a difference operator.
A differencing of the first order suggests that the mean looks relatively stable. There might be non-constant variance but the ADF test results in a p-value of 0.01, which is satisfactory. We could conclude that the data is relatively stationary. This makes the order d = 2.
The new dataset was created with the difference, and once again plotted to visualize the ACF and PACF plots. These provide certain guidelines on the order of p and q, based on which a model could be fit on the dataset.
 
 
 
**Conclusion**

The results of the exercise conclude that an ARIMA(2,2,4) model fits well with the data of total number of cases for India. The model predicts the increase in the total number of cases over days. This increasing trend suggests the path of the disease if no remedial measures are undertaken, suggesting the consequences of the inaction. As more and more data are added, one could compare how the model performs and how the growth rate varies.

The scalable R-Shiny application(described in the next section) serves as a good reference and starting point to building comprehensive models for other countries. While better models might be fit and better diagnostics may be performed, the dashboard allows for a quick starting point and if not, a simple model that serves the purpose. One could improve the models and the forecasts by choosing other measures of making a model stationarity (like log transform, moving average) and with advanced modelling approaches (ARIMA with other predictors). 

 
 
**[R Shiny Application](https://meenal-narsinghani.shinyapps.io/shiny_application/)**
To perform a similar analysis as of that taken for one country, India, the team built an interactive R-Shiny dashboard that provides insight into the time-series and modelling flexibility. The functionality of the app is as explained below - 

**Data Tab**
This tab helps us understand the original data in detail. There are 2 filters in this tab:
•	‘Select a country’ – To choose the country for the COVID 19 forecasts (Default: Afghanistan)
•	‘Select number of rows’ – To choose the number of rows of raw data to be displayed. This will help in viewing cases and fatalities for a country at a date level. (Default: 10)

There are 3 plots in addition to the display of raw data in this tab. The first plot shows the data as a time series object for us to understand the pattern in data. The ACF and the PACF plots are displayed below to understand the lag auto-correlations. These plots also help in building our own model in the next tab where we have an option to build our own model.

**Model Summary Tab**
This tab has an option to either go with the model from the auto.arima function or to build a model by specifying the values of p, d, and q. Auto.arima is chosen to be the default option as this will give a starting reference for further adjustments. The default value for building the model is (0,0,0) and the model will not accept any negative values as input for the values of p, d, and q. Once we make the required choices, the model summary and the results of the Box-Ljung test are displayed in the side panel. The former will provide the coefficients of the AR and MA parts of the model and the latter will check for autocorrelation in the time series residuals.
In addition to this, the residual plots are displayed for diagnostics to check if residuals are uncorrelated, is stationary and are normally distributed. The model fit values are plotted with the data for a comparison of how well the model performs.

**Forecast Tab**
This tab focusses on generating forecasts from the model built. There is an input field to enter the number of days into future that we want to forecast and based on this, the forecast is generated along with the 80% and 95% confidence bands. One can notice how the width of the band increases when the days of forecast to be included increases. 
In addition to this plot, we also have a table in the side panel which shows the values of the forecasts along with the values for upper and lower bands for 80% and 95% confidence. The minimum number of days to look at the forecast is set to 0 and the maximum number is set to 30.
