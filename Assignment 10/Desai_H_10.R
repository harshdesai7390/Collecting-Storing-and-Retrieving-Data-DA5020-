
rm(list=ls())

getwd()

#Loading required packages
install.packages("RSQLite")
library(RSQLite)
library(RMySQL)
library(dplyr)
#load data from csv file
birdStrike <- read.csv("Bird Strikes.csv",header = T ,sep =",")
head(birdStrike)

#setting databse connection
dbBird<-dbConnect(SQLite(),dbname="birdStrike_HD.sqlite")

#setting source and database connction through dplyr()
db<-src_memdb()
db
db<-src_sqlite("birdStrike_HD.sqlite",create=FALSE)
db

dbSendQuery(conn = dbBird, "PRAGMA foreign_keys= ON")



#creating aircraft dataframe
birdStrike$Aircraft_ID<-1:nrow(birdStrike)
aircraftDf<-select(birdStrike,Aircraft_ID=Aircraft_ID,Aircraft_Type=Aircraft..Type,
                   Aircraft_Model=Aircraft..Make.Model,Num_Engines=Aircraft..Number.of.engines.,
                   Altitude= Altitude.bin)
head(aircraftDf)

#creating airport dataframe 
birdStrike$Airport_ID<-1:nrow(birdStrike)
airportDf<-select(birdStrike,Airport_ID=Airport_ID,Airport_Name=Airport..Name,State=Origin.State)
head(airportDf)

#creating flight dataframe
birdStrike$Flight_ID<-1:nrow(birdStrike)
flightDf<-select(birdStrike,Flight_ID=Flight_ID,Flight_Number=Aircraft..Flight.Number,Flight_Date=FlightDate,
                 Airline=Aircraft..Airline.Operator)
                 
head(flightDf)

#creating wildlife dataframe
birdStrike$Wildlife_ID<-1:nrow(birdStrike)
wildlifeDF<-select(birdStrike,Wildlife_ID=Wildlife_ID,Species=Wildlife..Species,Size=Wildlife..Size)
head(wildlifeDF)


#creating birdstrike dataframe

birdStrikeDF<-select(birdStrike,Record_ID = Record.ID,Aircraft_ID = Aircraft_ID,Airport_ID=Airport_ID,Flight_ID=Flight_ID,
                     Wildlife_ID=Wildlife_ID,When_Time=When..Time..HHMM.,Reported_Date=Reported..Date,Sky_condition=Conditions..Sky,
                     Precipitation=Conditions..Precipitation,Impact_Flight=Effect..Impact.to.flight,Effect_Others=Effect..Other,
                     Damage=Effect..Indicated.Damage,Phase_Flight=When..Phase.of.flight,Remarks=Remarks)
                     
head(birdStrikeDF)


####CREATING TABLES
#AIRCRAFT
#creating AIRCRAFT table

dbSendQuery(conn=dbBird,"DROP TABLE AIRCRAFT")
dbSendQuery(conn=dbBird,"CREATE TABLE AIRCRAFT(Aircraft_ID INT PRIMARY KEY,Aircraft_Type CHAR,
            Aircraft_Model CHAR,Num_Engines CHAR,Altitude TEXT)")

dbWriteTable(conn=dbBird,name="AIRCRAFT",aircraftDf,row.names=FALSE,append=TRUE)

dbGetQuery(conn=dbBird,"SELECT * FROM AIRCRAFT LIMIT 10")

#AIRPORT
#creating AIRPORT table

dbSendQuery(conn=dbBird,"DROP TABLE AIRPORT")
dbSendQuery(conn=dbBird,"CREATE TABLE AIRPORT(Airport_ID INT PRIMARY KEY,Airport_Name CHAR,State CHAR)")

dbWriteTable(conn=dbBird,name="AIRPORT",airportDf,row.names=FALSE,append=TRUE)


dbGetQuery(conn=dbBird,"SELECT * FROM AIRPORT LIMIT 10")

#FLIGHT
#creating FLIGHT table

dbSendQuery(conn=dbBird,"DROP TABLE FLIGHT")
dbSendQuery(conn=dbBird,"CREATE TABLE FLIGHT( Flight_ID INT PRIMARY KEY,Flight_Number CHAR,Flight_Date CHAR,
            Airline CHAR)")

dbWriteTable(conn=dbBird,name="FLIGHT",flightDf,row.names=FALSE,append=TRUE)

dbGetQuery(conn=dbBird,"SELECT * FROM FLIGHT LIMIT 10")

#WILDLIFE
#creating WILDLIFE table

dbSendQuery(conn=dbBird,"DROP TABLE WILDLIFE")
dbSendQuery(conn=dbBird,"CREATE TABLE WILDLIFE( Wildlife_ID INT PRIMARY KEY,Species CHAR ,Size CHAR)")

dbWriteTable(conn=dbBird,name="WILDLIFE",wildlifeDF,row.names=FALSE,append=TRUE)
dbGetQuery(conn=dbBird,"SELECT * FROM WILDLIFE LIMIT 10")

#BIRDSTRIKE
#creating BIRDSTRIKE TABLE

dbSendQuery(conn=dbBird,"DROP TABLE BIRDSTRIKE")
dbSendQuery(conn=dbBird,"CREATE TABLE BIRDSTRIKE(Record_ID INT PRIMARY KEY,Aircraft_ID INT REFERENCES AIRCRAFT(Aircraft_ID),
            Airport_ID INT REFERENCES AIRPORT(Airport_ID),Flight_ID INT REFERENCES FLIGHT(Flight_ID),
            Wildlife_ID INT REFERENCES WILDLIFE(Wildlife_ID),When_Time TEXT,Reported_Date TEXT,Sky_condition TEXT,
            Precipitation TEXT,Impact_Flight TEXT,Effect_Others TEXT,Damage TEXT,Phase_Flight TEXT,Remarks TEXT)")

dbWriteTable(conn = dbBird,name="BIRDSTRIKE",birdStrikeDF,row.names=FALSE,append=TRUE)
dbGetQuery(conn=dbBird,"SELECT * FROM BIRDSTRIKE LIMIT 10")

#### dplyr ###
#fetching tables from the database

BIRDSTRIKE<-tbl(db,"BIRDSTRIKE")
BIRDSTRIKE

AIRCRAFT<-tbl(db,"AIRCRAFT")
AIRCRAFT

AIRPORT<-tbl(db,"AIRPORT")
AIRPORT

FLIGHT<-tbl(db,"FLIGHT")
FLIGHT

WILDLIFE<-tbl(db,"WILDLIFE")
WILDLIFE

#Problem 2
#Number of incident where the incident reported fog during incident
dbGetQuery(conn=dbBird,"SELECT count(*) AS TOTAL FROM BIRDSTRIKE WHERE Precipitation = 'Fog'")

Fog_precipitation<-BIRDSTRIKE %>% filter(Precipitation=='Fog')%>% summarize(Total=n())
Fog_precipitation

show_query(Fog_precipitation)

#Problem 3
#Function CountIncidents(AircraftType) which retuns the number of incidents for the aircraft type

dbGetQuery(conn=dbBird,"SELECT count(*) AS Total_Birdstrike
                        FROM BIRDSTRIKE JOIN AIRCRAFT ON BIRDSTRIKE.Aircraft_ID = AIRCRAFT.Aircraft_ID
                        WHERE Aircraft_Type ='Airplane'")


CountIncidnets<-function(AircraftType){
        BIRDSTRIKE %>% inner_join(AIRCRAFT,by ="Aircraft_ID") %>% filter(Aircraft_Type == AircraftType) %>%  summarize(Total_Incidents=n()) 
}
CountIncidnets('Airplane')

show_query(BIRDSTRIKE %>% inner_join(AIRCRAFT,by ="Aircraft_ID") %>% filter(Aircraft_Type == AircraftType) %>%  summarize(Total_Incidents=n()) )

#Problem 4
#Function Incidents(Airline) which returns a dataframe that contains all incidents for that airline.

dbGetQuery(conn=dbBird,"SELECT Airport_Name,Aircraft_Model,Flight_Date FROM BIRDSTRIKE
                 JOIN AIRPORT ON AIRPORT.Airport_ID = BIRDSTRIKE.Airport_ID
                 JOIN AIRCRAFT ON AIRCRAFT.Aircraft_ID = BIRDSTRIKE.Aircraft_ID               
                 JOIN FLIGHT ON FLIGHT.Flight_ID = BIRDSTRIKE.Flight_ID
                        WHERE Airline = 'AIR 500'")

Incidents<-function(AirlineName){
  BIRDSTRIKE %>% inner_join(AIRCRAFT,by="Aircraft_ID")%>% inner_join(AIRPORT,by="Airport_ID") %>%inner_join(FLIGHT,by="Flight_ID")%>%
    filter (Airline == AirlineName) %>% select(Airport_Name,Aircraft_Model,Flight_Date) 
}
Incidents('NETJETS')

show_query(BIRDSTRIKE %>% inner_join(AIRCRAFT,by="Aircraft_ID")%>% inner_join(AIRPORT,by="Airport_ID") %>%inner_join(FLIGHT,by="Flight_ID")%>%
             filter(Airline == Airline) %>% select(Airport_Name,Aircraft_Model,Flight_Date)) 

#Problem 5
#Function CountIncidentsByAirline() thata creates a dataframe where first column is Name of an Airline and
#second column is total number of incidents by Airline.
 
CountIncidentsByAirline<-function(){
 BIRDSTRIKE %>% left_join(FLIGHT,by="Flight_ID") %>% group_by(Airline) %>% summarize(Total=n()) %>% arrange(desc(Total)) %>% select(Airline,Total)
}
CountIncidentsByAirline()

show_query(BIRDSTRIKE %>% left_join(FLIGHT,by="Flight_ID") %>% group_by(Airline) %>% summarize(Total=n()) %>% arrange(desc(Total)) %>% select(Airline,Total))


#Problem 6


dbGetQuery(conn=dbBird,"SELECT count(*) AS TOTAL FROM BIRDSTRIKE WHERE Precipitation = 'Fog'")

Fog_precipitation<-BIRDSTRIKE %>% filter(Precipitation=='Fog')%>% summarize(Total=n())
Fog_precipitation

show_query(Fog_precipitation)

#SELECT COUNT() AS `Total`
#FROM (SELECT *
#       FROM `BIRDSTRIKE`
#     WHERE (`Precipitation` = 'Fog'))

# After using both data retrieval query, i would say dplyr() is faster and more organized and SQL query is easy to understand as it is like writing statement.


