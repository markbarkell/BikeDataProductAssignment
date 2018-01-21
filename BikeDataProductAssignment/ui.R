#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Biker Ratio Prediction"),
  sidebarLayout(
    p("This application predicts the ratio of casual to registered users for a bicycle sharing system.")
    ,p("To use the system, one must select Season, Day Of Week, Weather Forecast, Month, weekday, weather situation, real temp, air temp, humidity, and windspeed.  In addition, one must indicate whether the day is a holiday wheter a workday")
    ,sliderInput(inputId = "temp", label = "temperature", min = -100, max = 100, step = 1)
    ,silderInput(inputId = "atemp", label = "air temperature", min = -100, max = 100, step = 1)
    ,silderInput(inputId = "hum", label = "humidity",min = 0, max = 100, step = 1)
    ,radioButtons(inputId = "season",
                  label = "season",
                  choices = c("spring", "summer", "fall", "winter"))
    ,radioButtons(inputId = "weathersit", 
                  label = "weather situation",
                  choices = c(
                    "ClearOrFewCloudsOrPartyCloudy", 
                    "MistCloudyOrMistBrokenCloudsOrMistFewCloudsOrMist", 
                    "LightSnowOrLightRainOrThunderStormOrScatteredCloudsOrLightRainOrScatteredClouds", 
                    "HeavyRainOrIcePalletsOrThunderstormOrMistOrSnowOrFog"
                  ))
    ,radioButtons(inputId = "mnth",
                  label = "month",
                  choices = c("Jan", "Feb", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
    ,radioButtons(inputId = "weekday", 
                  label = "day of week",
                  choices = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday")
                  )
    ,checkboxInput(inputId = "holiday", label="is holiday")
    ,checkboxInput(inputId = "workday", label="is workday")
  ),
  mainPanel(
    verbatimTextOutput(outputId = "predictionInfo")
  )
))
