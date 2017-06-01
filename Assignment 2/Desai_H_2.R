#Check the working directory location and to set the working directory
getwd()
setwd("C:/Users/Harsh Desai/Documents")

#1 Loading the data file into data object
ExtractData <- unzip("AirlineDelays.zip") #unzip the data
AirlineDelays <-read.table(ExtractData, header = TRUE, sep = ",") #store the data into dataframe
head(AirlineDelays)

#2 This block of code will make TotalNUmDelays(Carrier) function whihc will return total number of Delays by perticular Carrier
#check for the NA values and replace it with -
AirlineDelays[is.na(AirlineDelays)] <- 0

#Delay means positive value in any of the 7 delay columns for periticular Airline(which is row)

#Function TotalNumDelays(Carrier)
TotalNumDelays <- function(Carrier) {
  Delays <- 0
  n <- nrow(AirlineDelays)
  for (i in 1:n) {
    if (AirlineDelays[i, 3] == Carrier) {
      if ((AirlineDelays[i, 6] > 0) |
          (AirlineDelays[i, 7] > 0) |
          (AirlineDelays[i, 9] > 0) |
          (AirlineDelays[i, 10] > 0) |
          (AirlineDelays[i, 11] > 0) |
          (AirlineDelays[i, 12] > 0) | (AirlineDelays[i, 13] > 0)) {
        Delays <- Delays + 1
      }
    }
  }
  return(Delays)
}
TotalNumDelays()


#3 This block of code will make TotalNumDelayByOrigin funation which will return total number of Delays by pertiv=cular Origin or Airport
#Function TotalNumDelayByOrigin(Origin)
TotalNumDelaysByOrigin <- function(Origin) {
  Delays <- 0
  n <- nrow(AirlineDelays)
  
  for (i in 1:n) {
    if (AirlineDelays[i, 4] == Origin) {
      if ((AirlineDelays[i, 6] > 0) |
          (AirlineDelays[i, 7] > 0) |
          (AirlineDelays[i, 9] > 0) |
          (AirlineDelays[i, 10] > 0) |
          (AirlineDelays[i, 11] > 0) |
          (AirlineDelays[i, 12] > 0) | (AirlineDelays[i, 13] > 0)) {
        Delays <- Delays + 1
      }
    }
  }
  return(Delays)
}
TotalNumDelaysByOrigin()

#4 This block of code will create function AVgDelay(Carrier,Dest) that calculates and return
# average arrival delay for carrier flying to the specified destination
#Function AvgDelay(Carrier,Dest)

AvgDelay <- function(Carrier, Dest) {
  Total = 0
  Count = 0
  for (i in 1:dim(AirlineDelays)[1]) {
    if (AirlineDelays$CARRIER[i] == Carrier &
        AirlineDelays$ARR_DELAY[i] > 0 &
        AirlineDelays$DEST[i] == Dest) {
      Total <- Total + AirlineDelays$ARR_DELAY[i]
      Count <- Count + 1
    }
  }
  return(Total / Count)
}
AvgDelay()

#5 To check if dataframe has been already loaded or not 
if (!exists("AirlineDelays")) {
  ExtractData <- unzip("AirlineDelays.zip")
  AirlineDelays <- read.table(ExtractData, header = TRUE, sep = ",")
}


#Examples
TotalNumDelays("AA")
TotalNumDelaysByOrigin("JFK")
AvgDelay("AA", "LAX")
