rm(list=ls())

#loading required packages
library(XML)
library(stringr)
library(lubridate)
library(XLConnect)


#Problem 1
#loading XML data using xmlTreeParse()
ebayData<-xmlTreeParse("http://www.cs.washington.edu/research/xmldatasets/data/auctions/ebay.xml")
aunctionData<-xmlRoot(ebayData)
xmlSize(aunctionData)


#function moreFiveBids() , will returns the number auctions that had more than five bids.
#it will take data as an argument
#function moreFiveBids(data)
moreFiveBids<-function(data){
  numAuctions<-0
  for(i in 1:xmlSize(data)){
    if(as.integer(xmlValue(data[[i]][[5]][[5]]))>5){
      numAuctions<-numAuctions+1
    }
  }
  paste(numAuctions,"auctions had more than 5 bids.")
}

moreFiveBids(aunctionData)

#Problem 2
#loading XML data using xmlTreeParse()
marketData<-xmlTreeParse("http://www.barchartmarketdata.com/data-samples/getHistory15.xml")
futureTrades<-xmlRoot(marketData)
xmlSize(futureTrades)

#function highestClosingPrice() returns the highest closing price for the security
#it will take data as an argument
#function highestClosingPrice(data)

highestClosingPrice<-function(tradeData){
  closing<-0
  for(i in 2:xmlSize(tradeData)){
    closing[i]<-(as.numeric(xmlValue(tradeData[[i]][[7]])))
  }
  maxClosing<-which.max(closing)
  paste(closing[maxClosing],"was the highest closing price for the security.")
}

highestClosingPrice(futureTrades)

#funtion totalVolume() returns the total volume traded
#function totalVolume(data)
totalVolume<-function(tradeData){
  totalVolume<-0
  for(i in 2:xmlSize(tradeData)){
    totalVolume<-totalVolume + (as.integer(xmlValue(tradeData[[i]][[8]])))
  }
  paste(totalVolume,"is the total volume traded")
}

totalVolume(futureTrades)

#function averageVolume() retuns the average trading volume during each Hour of the trading day
#in the form of data frame and takes dataset as an argument
#function averageVolume(data)

averageVolume<-function(data){
  dataDf<-data.frame(day=rep(0,xmlSize(data)),hour=rep(0,xmlSize(data)),volume=rep(0,xmlSize(data)))
  final<-data.frame(day=0,hour=0,average=0)
  for(i in 1:(xmlSize(data)-1)){
    dataDf[i,1]<-as.numeric(day(ymd_hms(xmlValue(data[[i+1]][[2]]))))
    dataDf[i,2]<-as.numeric(hour(ymd_hms(xmlValue(data[[i+1]][[2]]))))
    dataDf[i,3]<-as.numeric(xmlValue(data[[i+1]][[8]]));
  }
  head(dataDf)
  for(h in 0:23){
    final[h,1]<-29
    final[h,2]<-h
    final[h,3]<-mean(dataDf[((dataDf[,2]==h&dataDf[,1]==29)),3])
  }
  for(h in 0:23){
    if(dataDf[i,1]==30){
      final[h+24,1]<-30
      final[h+24,2]<-h
      final[h+24,3]<-mean(dataDf[((dataDf[,2]==h&dataDf[,1]==30)),3])
    }
  }
  return(na.omit(final))
} 
averageVolume(futureTrades)