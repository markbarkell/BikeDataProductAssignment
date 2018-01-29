#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)


worthyDayParameters <- c("season", "mnth", "holiday", "weekday", "workingday", "weathersit", "temp", "atemp", "hum", "windspeed")

dayReader <- function () {
  dayData <- read.csv("./day.csv")
  weekdayFactor <- as.factor(c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
  seasonFactor <- as.factor(c("spring", "summer", "fall", "winter"))
  weathersitFactor <- as.factor(c("ClearOrFewCloudsOrPartyCloudy", "MistCloudyOrMistBrokenCloudsOrMistFewCloudsOrMist", "LightSnowOrLightRainOrThunderStormOrScatteredCloudsOrLightRainOrScatteredClouds", "HeavyRainOrIcePalletsOrThunderstormOrMistOrSnowOrFog"))
  dayData$season <- seasonFactor[dayData$season]
  dayData$weathersit <- weathersitFactor[dayData$weathersit]
  dayData$weekday <- as.factor(1 + dayData$weekday)
  return (dayData)
}


makeTheModel <- function() {
set.seed(0x86d36f8)
  dayData <- dayReader()
  dayPart <- createDataPartition(y = dayData$casual, p = .7, list=FALSE)
  trainingDay <- dayData[dayPart,] 
  treeBagDayModel <- caret::train(y = (trainingDay$casual+1)/(trainingDay$registered+1), x = trainingDay[,worthyDayParameters], method = "treebag", preProcess = c("scale", "center", "BoxCox"))
  return (treeBagDayModel)
}

doforthprediction <- function(model, season, mnth, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed) {
   
  df <-data.frame(
    season = season,
    mnth = mnth,
    holiday = holiday,
    weekday = weekday,
    workingday = workingday,
    weathersit = weathersit,
    temp = temp,
    atemp = atemp,
    hum = hum,
    windspeed = windspeed)
  prediction <- predict(model, df)
  return (prediction)                                                        
}

monthArray <- c("Jan", "Feb", "Apr", "May", "Jun", "Jul", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

weekdayArray <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday")

functionality <- function(input, output) {
  treeBagDayModel <- makeTheModel()
  
  innerPredict <- reactive({
    laMnth <- which(monthArray == input$mnth)
    return (doforthprediction(treeBagDayModel, season = input$season, mnth = laMnth, holiday = input$holiday, workingday = input$workingday, weathersit = input$weathersit, temp = input$temp, atemp = input$atemp, hum = input$hum, windspeed = input$windspeed, weekday = as.factor(2)))
    #return ( doforthprediction(treeBagDayModel,
    #                           season = as.factor(input$season),
    #                           mnth = (which(monthArray == input$mnth)),
    #                           holiday = input$holiday,
    #                           weekday = (which(weekdayArray == input$weekday)),
    #                           workingday = input$workingday,
    #                           weathersit = as.factor(input$whethersit),
    #                           temp = input$temp,
    #                           atemp = input$atemp,
    #                           hum = input$hum,
    #                           windspeed = input$windspeed
    #) )
  }
  
  )
  
  output$predictionInfo = renderText({innerPredict()})
  
}

# Define server logic required to draw a histogram
shinyServer(function(input, output)
  {
  functionality(input,output)
})
   
# doforthprediction(m, season = "spring", mnth = 4, holiday = 1, workingday = 1, weathersit = "ClearOrFewCloudsOrPartyCloudy", temp = 23, atemp = 27, hum = 20, windspeed = 3, weekday = as.factor(2))
theinput <- data.frame(
  season = "spring", 
  mnth = 4, 
  holiday = 1, 
  workingday = 1, 
  weathersit = "ClearOrFewCloudsOrPartyCloudy", 
  temp = 23, 
  atemp = 27, 
  hum = 20, 
  windspeed = 3, 
  weekday = as.factor(2)
)
theoutput <- list()
# functionality(m, theinput, theoutput)