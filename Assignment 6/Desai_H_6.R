rm(list=ls())

#loading reaquired packages

library(rvest)
library(XML)
library(xlsx)

#First ToolKit rvest()

#storing web url from whihc we want to extract data 
url<-"http://www.espn.com/nfl/superbowl/history/mvps"

#reading HTML data from the url
superbowlData<-read_html(url) 

#extracting HTML table element using html_nodes and html_table 
tables<-html_nodes(superbowlData,'table')

mvpTable<-html_table(tables)[[1]]
mvpTable

#removing first two row and setting column names
mvpTable<-mvpTable[-(1:2),]
names(mvpTable)<-c("Number","Player","Highlights")
mvpTable

#coverting superBowl number from Roman numeral to Numbers
mvpTable$Number<- 1:50

#converting to dataframe 
mvpTable<-data.frame(mvpTable,row.names = NULL)
mvpTable


#Second Toolkit Import.io

#importing xlsx file extracted using Import.io
importMvp<-read.xlsx("superBowl_import.xlsx",1)

#cleaning data and converting to data frame
importMvp<-data.frame(importMvp)
importMvp<-importMvp[2:51,]
importMvp$superbowl_number<-1:50
FinalMvp<-data.frame(importMvp,row.names = NULL)

FinalMvp


#Third ToolKit Google Chrome Extension(Instant Data Scraper)

#importing and reading xlsx file extracted using Instant Data Scraper 
instantMvp<-read.xlsx("Instant_data_scraper.xlsx",1)
instantMvp
#cleaning and converting to data frame
instantMvp<-data.frame(instantMvp,row.names = NULL)
instantMvp$Number<-1:50

instantMvp