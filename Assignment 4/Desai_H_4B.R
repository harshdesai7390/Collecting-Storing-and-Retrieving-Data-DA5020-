rm(list=ls())

#loading required packages
library(XML)

#loading XMl oducment at the URL directly into a dat frame
senatorData<-xmlToDataFrame("https://www.senate.gov/general/contact_information/senators_cfm.xml")
senatorData

#function senatorName(),which takes a state name as an argument and returns the names of the
#senators for the state in vector
#function senatorName("State")

senatorName<-function(state){
    if(!(state %in% senatorData$state)){
      stop(paste("Invalid State Name"))
    }
    senator<-senatorData[which(senatorData$state==state),c(2,3)]
    return(senator)
}
#test case
senatorName("MA")

#function senatorPhone() which takes first and Last name of the senaotr as an arguments and retunrs
#the phone number for the senator
#function senatorPhone("Firstname Lastname") fullName = "Fistname Lastname"

senatorPhone<-function(fullName){
  senatorName<-which(paste(senatorData$first_name,senatorData$last_name) == fullName)
  phoneNum<-paste(senatorData$phone[senatorName])
  return(phoneNum)
}
#test case
senatorPhone("Richard Burr")