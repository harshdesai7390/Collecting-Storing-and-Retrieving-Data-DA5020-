rm(list=ls())

#loading required packages
library(openxlsx)
library(utils)
library(stringr)
library(reshape2)
library(lubridate)


#problem 1
#loading xls data file into dataframe
farmerMarketData<-read.xlsx("2013 Geographric Coordinate Spreadsheet for U S  Farmers Markets 8'3'1013.xlsx",startRow = 3)
head(farmerMarketData)



#taking season1Date column
seasonDates<-farmerMarketData$Season1Date
head(seasonDates)

#clearing data
farmerMarketData<-farmerMarketData[!is.na(farmerMarketData$Season1Date),]
farmerMarketData

#problem 2
#creating levels for data according to seasons
winter<-c(month.name[12],month.name[1],month.name[2])
spring<-c(month.name[3],month.name[4],month.name[5])
summer<-c(month.name[6],month.name[7],month.name[8])
fall<-c(month.name[9],month.name[10],month.name[11])

#function to calculate range of a given Season1Date dates
subtractMonths<-function(month1,month2){
  subtract<-(match(month1,month.name)-match(month2,month.name))
  return(subtract)
}

#function which will check if given month will fall into which season category 
seasonFromMonth<-function(month){
  if(month==winter){
    return('winter')
  }else if(month==spring){
    return('spring')
  }else if(month==summer){
    return('summer')
  }else {
    return('fall')
  }
}

#function to standardize data accordin to decided levels
dataRange<-function(dates){
    dates<-colsplit(string=dates,pattern = " to ",names=c('start','end')) #spliting Season1Date into start and end date
    dates$start<-ifelse(
                        (is.na(as.Date(dates$start,format='%m/%d/%Y'))&is.na(as.Date(dates$start,format='%B %d,%Y'))), #taking month from start date
                        dates$start,
                ifelse(is.na(as.Date(dates$start,format='%m/%d/%Y')),
                       month.name[month(as.Date(dates$start,format='%B %d,%Y'))],
                       month.name[month(as.Date(dates$start,format='%m/%d/%Y'))])
                       )
    dates$end<-ifelse(
                        (is.na(as.Date(dates$end,format='%m/%d/%Y'))&is.na(as.Date(dates$end,format='%B %d,%Y'))),  #taking month from end date
                      dates$end,
                      ifelse(is.na(as.Date(dates$end,format='%m/%d/%Y')),
                      month.name[month(as.Date(dates$end,format='%B %d,%Y'))],
                      month.name[month(as.Date(dates$end,format='%m/%d/%Y'))])
                      )
    dates$range<-subtractMonths(dates$end,dates$start)+1                 #deciding range of given Season1Dates
    dates$categories<-ifelse(is.na(dates$range),'Not Avialabe',
                             ifelse(dates$range >= 10,'Year-Round',       #will return levels according to given range
                                    ifelse(dates$range >= 6,'Half-Year',
                                           seasonFromMonth(dates$start)))) 
                      return(dates$categories)
}

#savinng standardized Season1Date date column as data frame
standardData<-dataRange(seasonDates)
standardData<-as.data.frame(standardData)
standardData


#problem 3
#retrival function acceptsWIC which will return markets which accepts WIC
acceptsWIC<-function(data){
    wic<-data[which(!is.na(data$WIC)& (data$WIC == 'Y')),]
    return(wic)
}

#saving markets that accept WIC into data frame
marketWIC<-acceptsWIC(farmerMarketData)
marketWIC<-as.data.frame(marketWIC)
head(marketWIC)



