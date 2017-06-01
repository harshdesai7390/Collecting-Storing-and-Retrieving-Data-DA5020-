#Assignment 3B

#setting current directory path
getwd()
setwd("C:/Users/Harsh Desai/Documents")

#installing and loading requried packages 
library("lubridate")
library("plyr")

#Extracing data from the zipped file and loading into dataframe 
extractData<-unzip("Bird Strikes.zip")
birdStrikes<-read.csv(extractData,header = TRUE ,sep = ",",fill = TRUE)
head(birdStrikes)

#This 1st function unreportedBirdstrikes will count the number of bird strikes where there is no value for "Reported:Date".
# it will check for the empty value in Repoted:Date column and will return total number of unreported birdstrikes.
#Function unreportedBirdstrikes(dataframe)
#problem 1
unreportedBirdstrikes<-function(dataBird){
  reportedDate<-dataBird$Reported..Date
  unreported<-sum(reportedDate=="")
  return(unreported)
}
unreportedBirdstrikes(birdStrikes)


#This 2nd function maximunBirdstrike will find the which year had most bird strikes.
#It will take year from FlightDate and calculate the maximum occurance of perticular year in the dataset.Will return the year wit the
#maximum occurance.

#Function maximumBirdstrikes(dataframe)
#problem 2
maximumBirdstrike<-function(dataBird){
  flightDate<-dataBird$FlightDate
  year<-year(as.Date(flightDate,format="%m/%d/%Y"))
  yearTable<-aggregate(year,by=list(year),length)
  colnames(yearTable)<-c("Year","Total Birdstrikes")
  maxYear<-yearTable$Year[which(yearTable$`Total Birdstrikes`==max(yearTable$`Total Birdstrikes`))]
  return(maxYear)
}
maximumBirdstrike(birdStrikes)

#This 3rd function birdstrikesYear will calculate the total number of birdstrikes per year and will return dataframe as result.

#Function birdstrikesYear(dataframe)
#problem 3
birdstrikesYear<-function(dataBird){
  flightDate<-dataBird$FlightDate
  year<-year(as.Date(flightDate,format="%m/%d/%Y"))
  yearTable<-aggregate(year,by=list(year),length)
  colnames(yearTable)<-c("Year","Total Birdstrikes")
  yearDataframe<-as.data.frame(yearTable)
  return(yearDataframe)
}
birdstrikesYear(birdStrikes)


#This 4th function birdstrikesPerAirline will calulate the total number of birdstrikes per Airline and will arrange them into decresing order.
#Result of the birdstrikesPerAirline will be stored into AirlineStrikes as data frame.
#Then 5th function maxstrikeAirline will take AirlineStrikes dataframe as an  argument and will return 2nd highest Airline name that has most bird strikes.

#Function birdstrikePerAirline(dataframe)
#         maxstrikeAirline(AirlineStrikes)
          
#problem 4 
birdstrikesPerAirline<-function(dataBird){
  airlines<-as.character(dataBird$Aircraft..Airline.Operator)
  airlineTable<-aggregate(airlines,by=list(airlines),length)
  colnames(airlineTable)<-c("Airline","Total Birdstrikes")
  airlineTable<-arrange(airlineTable,desc(airlineTable$`Total Birdstrikes`))
  return(airlineTable)
}

AirlineStrikes<-birdstrikesPerAirline(birdStrikes)
head(AirlineStrikes)

maxstrikeAirline<-function(AirlineStrikes){
  maxStrike<-AirlineStrikes[2,1]
  return(maxStrike)
}
maxstrikeAirline(AirlineStrikes)


#problem 6 

#Duplicating dataset into 2 times,4 time and 6 time original sized data.
birdStrikes2X<-rbind(birdStrikes,birdStrikes)
birdStrikes4X<-rbind(birdStrikes2X,birdStrikes2X)
birdStrikes6X<-rbind(birdStrikes4X,birdStrikes2X)

#calculating system running time for function unreportedBirdstrikes() for original,2 time ,4 time and 6 time sized data.
system.time(unreportedBirdstrikes(birdStrikes))
system.time(unreportedBirdstrikes(birdStrikes2X))
system.time(unreportedBirdstrikes(birdStrikes4X))
system.time(unreportedBirdstrikes(birdStrikes6X))


#calculating system running time for function maximumBirdstrike() for original,2 time ,4 time and 6 time sized data.
system.time(maximumBirdstrike(birdStrikes))
system.time(maximumBirdstrike(birdStrikes2X))
system.time(maximumBirdstrike(birdStrikes4X))
system.time(maximumBirdstrike(birdStrikes6X))

#calculating system running time for function birdstrikesYear() for original,2 time ,4 time and 6 time sized data.
system.time(birdstrikesYear(birdStrikes))
system.time(birdstrikesYear(birdStrikes2X))
system.time(birdstrikesYear(birdStrikes4X))
system.time(birdstrikesYear(birdStrikes6X))

#calculating system running time for function maxstrikesAirline() for original,2 time ,4 time and 6 time sized data.
system.time(maxstrikeAirline(birdStrikes))
system.time(maxstrikeAirline(birdStrikes2X))
system.time(maxstrikeAirline(birdStrikes4X))
system.time(maxstrikeAirline(birdStrikes6X))

#calculating system running time for function birstrikesPerAirline() for original,2 time ,4 time and 6 time sized data.
system.time(birdstrikesPerAirline(birdStrikes))
system.time(birdstrikesPerAirline(birdStrikes2X))
system.time(birdstrikesPerAirline(birdStrikes4X))
system.time(birdstrikesPerAirline(birdStrikes6X))


