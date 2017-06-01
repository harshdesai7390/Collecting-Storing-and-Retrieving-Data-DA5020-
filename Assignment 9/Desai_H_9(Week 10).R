getwd()

#Loading required packages
install.packages("RSQLite")
library(RSQLite)
library(RMySQL)
#load data from csv file
birdStrike <- read.csv("Bird Strikes.csv",header = T ,sep =",")
head(birdStrike)

#setting databse connection
dbBird<-dbConnect(SQLite(),dbname="birdStrike_HD.sqlite")

dbSendQuery(conn = dbBird, "PRAGMA foreign_keys= ON")

#creating birdstrike dataframe
birdStrikeDF<-select(birdStrike,Record_ID = Record.ID,Remarks=Remarks,
                     Reported_Date=Reported..Date,Wildlife_Type=Wildlife..Species,
                     Wildlife_Size=Wildlife..Size,When=When..Time..HHMM.)
head(birdStrikeDF)

#creating aircraft dataframe
birdStrike$Aircraft_ID<-1:nrow(birdStrike)
aircraftDf<-select(birdStrike,Aircraft_Number=Aircraft_ID,Aircraft_Type=Aircraft..Type,
                   Aircraft_Model=Aircraft..Make.Model,Num_Engines=Aircraft..Number.of.engines.)
aircraftDf

#creating airline dataframe
birdStrike$Airline_ID<-1:nrow(birdStrike)
airlineDf<-select(birdStrike,Airline_ID=Airline_ID,Airline=Aircraft..Airline.Operator)
airlineDf

#creating airport dataframe 
birdStrike$Airpot_ID<-1:nrow(birdStrike)
airportDf<-select(birdStrike,Airport_ID=Airpot_ID,Airport_Name=Airport..Name,State=Origin.State)
airportDf

#creating flight dataframe
birdStrike$Flight_ID<-1:nrow(birdStrike)
flightDf<-select(birdStrike,Flight_ID=Flight_ID,Flight_Number=Aircraft..Flight.Number,Flight_Date=FlightDate,
                  Airport_Name=Airport..Name,Airline=Aircraft..Airline.Operator,
                 Aircraft_Type=Aircraft..Type,Aircraft_Model=Aircraft..Make.Model)
flightDf

#creating condition dataframe
birdStrike$Condition_ID<-1:nrow(birdStrike)
conditionDf<-select(birdStrike,Condition_ID=Condition_ID,Precipitation=Conditions..Precipitation,Sky_condition=Conditions..Sky)
conditionDf

#creating BIRDSTRIKE database table and writing data to the table
dbSendQuery(conn=dbBird,"DROP TABLE BIRDSTRIKE")
dbSendQuery(conn=dbBird,"CRATE TABLE BIRDSTRIKE(Record_ID INT PRIMARY KEY,Remarks CHAR,
                        Reported_Date CHAR,Wildlife_Type CHAR,Wildlife_Size CHAR,When_Time INT)")

dbWriteTable(conn = dbBird,name="BIRDSTRIKE",birdStrikeDF,row.names=FALSE,append=TRUE)

#creating AIRCRAFT database table and writing data to the table
dbSendQuery(conn=dbBird,"DROP TABLE AIRCRAFT")
dbSendQuery(conn=dbBird,"CREATE TABLE AIRCRAFT(Aircraft_Number INT PRIMARY KEY,Aircraft_Type CHAR,
                        Aircraft_Model CHAR,Num_Engines CHAR)")

dbWriteTable(conn=dbBird,name="AIRCRAFT",aircraftDf,row.names=FALSE,append=TRUE)

#creating AIRLINE database table and writing data to the table
dbSendQuery(conn=dbBird,"DROP TABLE AIRLINE")
dbSendQuery(conn=dbBird,"CREATE TABLE AIRLINE(Airline_ID INT PRIMARY KEY,Airline CHAR)")

dbWriteTable(conn=dbBird,name="AIRLINE",airlineDf,row.names=FALSE,append=TRUE)

#creating AIRPORT database table and writing data to the table
dbSendQuery(conn=dbBird,"DROP TABLE AIRPORT")
dbSendQuery(conn=dbBird,"CREATE TABLE AIRPORT(AIRPORT_ID INT PRIMARY KEY,Airport_Name CHAR,State CHAR)")

dbWriteTable(conn=dbBird,name="AIRPORT",airportDf,row.names=FALSE,append=TRUE)

#creating FLIGHT database table and writing data to the table
dbSendQuery(conn=dbBird,"DROP TABLE FLIGHT")
dbSendQuery(conn=dbBird,"CREATE TABLE FLIGHT( Flight_ID INT PRIMARY KEY,Flight_Number CHAR,Flight_Date CHAR,
                                              Airport_Name CHAR REFERENCE AIRPORT Airport_Name,
                                              Airline CHAR REFERENCE AIRLINE Airline,Aircraft_Type CHAR REFERENCE AIRCRAFT Aircraft_Type ,
                                              Aircraft_Model CHAR REFERENCE AIRCRAFT Aircraft_Model)")

dbWriteTable(conn=dbBird,name="FLIGHT",flightDf,row.names=FALSE,append=TRUE)

#creating CONDITION database table and writing data to the table
dbSendQuery(conn=dbBird,"DROP TABLE CONDITION")
dbSendQuery(conn=dbBird,"CREATE TABLE CONDITION(Condition_ID INT PRIMARY KEY,Precipitation CHAR,Sky_condition CHAR)")

dbWriteTable(conn=dbBird,name="CONDITION",conditionDf,row.names=FALSE,append=TRUE)



#Problem 2
#Number of incident where the incident reported fog during incident
dbGetQuery(conn=dbBird,"SELECT count(*)FROM CONDITION WHERE Precipitation ='Fog'")

#Problem 3
#Function CountIncidents(AircraftType) which retuns the number of incidents for the aircraft type

dbGetQuery(conn=dbBird,"SELECT count(*) FROM AIRCRAFT WHERE Aircraft_Type ='Airplane'")
  
CountIncidnets<-function(AircraftType){
  numAircraftType<-sprintf("SELECT COUNT(*) FROM AIRCRAFT WHERE Aircraft_Type ='%s'",AircraftType)
  data<-dbGetQuery(conn=dbBird,numAircraftType)
  return(data)

}
CountIncidnets('Airplane')


#Problem 4
#Function Incidents(Airline) which returns a dataframe that contains all incidents for that airline.

dbGetQuery(conn=dbBird,"SELECT Airport_Name,Aircraft_Model,Flight_Date FROM FLIGHT WHERE Airline = 'BUSINESS'")

Incidents<-function(Airline){
  incident<-sprintf("SELECT Airport_Name,Aircraft_Model,Flight_Date FROM FLIGHT WHERE Airline = '%s'",Airline)
  data<-dbGetQuery(conn=dbBird,incident)
  data<-data.frame(data)
  return(data)
}
Incidents('BUSINESS')


#Problem 5
#Function CountIncidentsByAirline() thata creates a dataframe where first column is Name of an Airline and
#second column is total number of incidents by Airline.

CountIncidentsByAirline<-function(){
                        byAirline<-dbGetQuery(conn=dbBird,"SELECT Airline ,COUNT(Airline) as Total FROM AIRLINE GROUP BY Airline ORDER BY Total")
                        byAirline<-data.frame(byAirline)
                        return(byAirline)
}
CountIncidentsByAirline()

CountIncidentsByAirline<-function(){
  data<- dbGetQuery(conn=dbBird,"SELECT Airline, COUNT(Airline) As TOTAL
                    FROM AIRLINE JOIN BIRDSTRIKE ON
                    AIRLINE.Airline_ID = BIRDSTRIKE.Airline_ID
                    GROUP by (Airline)")
  data<-data.frame(data)
}

            

dbGetQuery(conn=dbBird,"SELECT Airline, COUNT(*) 
           FROM AIRLINE JOIN BIRDSTRIKE ON
Airline_ID =Record_ID 
WHERE Airline NOT IN ('UNKNOWN','MILITARY') 
GROUP by (Airline)")

dbGetQuery(conn=dbBird,"SELECT Record_ID,Reported_Date
FROM AIRCRAFT JOIN BIRDSTRIKE ON
Aircraft_Number = Record_ID
WHERE Aircraft_Type ='Helicopter'")