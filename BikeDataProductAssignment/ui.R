#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

titlePanelVar <- titlePanel("Biker Ratio Prediction")
mainbarPanelVar <- mainPanel(
  verbatimTextOutput(outputId = "predictionInfo")
)

pDescription1 <- p("This application predicts the ratio of casual to registered users for a bicycle sharing system.")
pDescription2 <- p("To use the system, one must select Season, Day Of Week, Weather Forecast, Month, weekday, weather situation, real temp, air temp, humidity, and windspeed.  In addition, one must indicate whether the day is a holiday wheter a workday") 

tempInput <- sliderInput(inputId = "temp", label = "temperature", min = -100, max = 100, step = 1, value = 0)

atempInput <- sliderInput(inputId = "atemp", label = "air temperature", min = -100, max = 100, step = 1, value = 0)
humInput <- sliderInput(inputId = "hum", label = "humidity",min = 0, max = 100, step = 1, value = 0)


sidebarPanelVar <- sidebarPanel(
  pDescription1
  ,pDescription2
  ,tempInput
  ,atempInput
  ,humInput 
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
)

sidebarLayoutVar <- sidebarLayout(
  sidebarPanelVar, mainbarPanelVar
)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanelVar,
  sidebarLayoutVar
  )
)
