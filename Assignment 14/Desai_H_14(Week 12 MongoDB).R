rm(list=ls())
getwd()

#installing and loading required package
install.packages("mongolite")
library(mongolite)

#reading Bird Strike.csv file
birdStrikeMongo<-read.csv("Bird Strikes.csv",header = T,sep = ",")
head(birdStrikeMongo)

#loading csv file into mongoDB
mongoBird<-mongo("birdStrikeMongo")

#removing unwanted characters from the column names in dataframe
colnames(birdStrikeMongo)<-c(gsub("[?,:;!.]"," ",colnames(birdStrikeMongo)))
head(birdStrikeMongo)

#loding updated dataframe into mongodb
mongoBird<-mongo("birStrikeMongo")

#inserting data from dataframe into mongodb object
mongoBird$insert(birdStrikeMongo)

#exporting mongobd file 
mongoBird$export(file("birdStirkeMongo.txt"))

#Problem 3
#3(a) Fetch the unique airport names from the database

airportNames<-mongoBird$distinct("Airport  Name")
head(airportNames)

#3(b)Count the number of records where originState equals "New Jersey"

nj<-mongoBird$count('{"Origin State":"New Jersey"}')
nj

#3(c)Fetch the data with conditionsPrecipitation being fog and sort the data in descending order of recordId.

fogPrecipitation<-mongoBird$find('{"Conditions  Precipitation":"Fog"}',sort='{"Record ID":-1}')
head(fogPrecipitation)

#3(d) Fetch only the following columns for aircraftAirlineOperator: "AMERICAN AIRLINES" and "CONTINENTAL AIRLINES"

americanAirlines<-mongoBird$find('{"Aircraft  Airline Operator":"AMERICAN AIRLINES"}',
                                 fields = '{"Record ID":1,
                                 "Origin State":1,
                                 "Airport  Name":1,
                                 "Aircraft  Airline Operator":1,
                                 "_id":0}')
head(americanAirlines)


continentalAirlines<-mongoBird$find('{"Aircraft  Airline Operator":"CONTINENTAL AIRLINES"}',
                                  fields = '{"Record ID":1,
                                  "Origin State":1,
                                  "Airport  Name":1,
                                  "Aircraft  Airline Operator":1,
                                  "_id":0}')
head(continentalAirlines)