#Assignment 3(a)

#setting path for current working directory
getwd()
setwd("C:/Users/Harsh Desai/Documents")

#installing and loading package lubridate required for date and time functions
install.packages("lubridate")
library("lubridate")
require("lubridate")

#loading the data file Acuisitions.csv into data frame using read.csv function
Acquisitions <- read.csv("Acquisitions.csv", header = TRUE, sep = ",")
head(Acquisitions)


#This function leastInvInterval will count the smallest interval between successive investments
#in this function it will take dates as numeric format than calculate difference between successive dates using diff()
#Function leastInvInterval(dataframe)

leastInvInterval <- function(dataframe) {
  dates <- as.numeric(as.Date(dataframe$Date, format = "%m/%d/%Y"))
  interval <- min(diff(dates))
  print(c( "Smallest difference between successive investment is",  interval ))
}
leastInvInterval(Acquisitions)