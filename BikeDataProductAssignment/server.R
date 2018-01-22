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
  worthyDayParameters <- c("season", "mnth", "holiday", "weekday", "workingday", "weathersit", "temp", "atemp", "hum", "windspeed")  
  treeBagDayModel <- caret::train(y = (trainingDay$casual+1)/(trainingDay$registered+1), x = trainingDay[,worthyDayParameters], method = "treebag", preProcess = c("scale", "center", "BoxCox"))
  return (treeBagDayModel)
}

doforthprediction <- function(model, season, mnth, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed) {
  
  prediction <- caret::predict(model, data.frame(
    season = season,
    holiday = holiday,
    weekday = weekday,
    workingday = workingday,
    weathersit = weathersit,
    temp = temp,
    atemp = atemp,
    hum = hum,
    windspeed = windspeed)
    )
  return (prediction)                                                        
}

monthArray <- c("Jan", "Feb", "Apr", "May", "Jun", "Jul", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   treeBagDayModel <- makeTheModel()
   reactive({
	output$predictionInfo <- dotheprediction(treeBagDayModel,
	season = as.factor(input$season),
	mnth = (which(monthArray == input$mnth)),
	season = (as.factor(input$season)),
	holiday = input$holiday,
	workingday = input$workingday,
	weathersit = input$whethersit,
	temp = input$temp,
	atemp = input$atemp,
	hum = input$hum,
	windspeed = input$windspeed
   )})
  
})
   
