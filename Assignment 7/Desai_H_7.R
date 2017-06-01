#loading required packages
library(dplyr)
library(stringr)
library(rvest) 
library(magrittr)

#I am using www.doctordirectory.com , find a doctor near me search result using pin code as search string
#result shows list which contain hospital name ,address,number and radius from my place, I will be extracting name,address,phone data from the page

#I am using rvest as a scraping tool so i am reading data using read_html from the desired URL
#Now this URL uses GET request as HTTP request method and uses zip code as Query string
hospitalData<-read_html("https://www.doctordirectory.com/findadoctor/hccon-hospital-directory-results.aspx?hosp-city=&hosp-state=&hosp-zipcode=02120")

#creating function which will take data and node as an arguments. This function will take HTML data and searchs for desired node in HTML data and extract
#text using html_nodes and html_text functions,and returns desired node value list as a data frame
#function tableData(data,node)
tableData<-function(data,node){
data %>%
    html_nodes(node) %>%
    html_text() %>%
    str_trim() %>%
    as.data.frame()
}

#now exracting hospital name using tableData() function and giving name to column
hospitalName <-hospitalData %>% tableData(".resultsName")
names(hospitalName)<-"Hospital Name"

#extracing address from the result list and giving name to column
address<-hospitalData %>% tableData(".resultsAddress:nth-child(2)")
names(address)<- "Address"

#extracing phone number from the result list using tableData() function and giving name to column
phoneNum<-hospitalData %>% tableData(".resultsAddress:nth-child(3)")
names(phoneNum) <- "Phone"

#taking three columns Hospital Name ,address and phone number and convering it to final result data frame
df<-data.frame(hospitalName , address ,phoneNum)
View(df)

#Now we can use same code to search Hospitals near different zip code by changing desired zipcode in URL

#For example for zip code 02115
hospitalData<-read_html("https://www.doctordirectory.com/findadoctor/hccon-hospital-directory-results.aspx?hosp-city=&hosp-state=&hosp-zipcode=02115")

hospitalName <-hospitalData %>% tableData(".resultsName")
names(hospitalName)<-"Hospital Name"

address<-hospitalData %>% tableData(".resultsAddress:nth-child(2)")
names(address)<- "Address"

phoneNum<-hospitalData %>% tableData(".resultsAddress:nth-child(3)")
names(phoneNum) <- "Phone"

df<-data.frame(hospitalName , address ,phoneNum)
View(df)




