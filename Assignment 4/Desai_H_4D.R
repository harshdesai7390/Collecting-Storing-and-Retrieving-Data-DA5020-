
#Loading required packages
library(R.utils)
library(stringr)
library(stringi)

#Problem 1
#loading compressed movie file and reading data from it
file<-gunzip("movies.list.gz")
extractData<-readLines("movies.list")

#function extractString() which extracts string from the data file using regex
extractString<-function(data){
  grep('^(([0-9])|([A-Z])|([a-z]))+',data,perl=T)
}

#applying extractString function to our movie database and extract movienames
movieList<-extractData[which(lapply(extractData,extractString)==1)]

#removing unneccessary information
movieList<-movieList[7:length(movieList)]
head(movieList)

#Problem 2
#parse and split movie name and year
#function nameYear to split name and year
nameYear<-function(list){
  splitData<-sub('\\(([0-9]+)\\)','',list)
  splitData<-strsplit(splitData,'(\\t)+',perl= T)
  splitData<-as.data.frame(splitData[[1]])
}

#applying function nameYear to our extracted string data
movieDatabase<-lapply(movieList,nameYear)
#converting into dataframe
movieDatabase<-data.frame(movieDatabase)
movieDatabase<-t(movieDatabase)

#giving columnnames into dataframe
colnames(movieDatabase)<-c('Name','Year')
rownames(movieDatabase)<-1:nrow(movieDatabase)

#cleaning database
movieDatabase<-na.omit(movieDatabase)

#converting year into numeric type
movieDatabase[,2]<-as.numeric(movieDatabase[,2])
head(movieDatabase)