getwd()
setwd("C:/Users/Harsh Desai/Documents")

#loading required packages 
library(RCurl)
library(ROAuth)
library(streamR)
library(twitteR)

#download certificate needed for authentication, creates a certificate file on desktop
download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile = "cacert.pem")

#create a file to collect all the Twitter JSON data recevied from the API call
outFile <-"tweets_sample.json"

# Set all the Configuration details to authorize your application to access Twitter data.
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL  <- "https://api.twitter.com/oauth/access_token"
authURL    <- " https://api.twitter.com/oauth/authorize"
consumerKey <- "zrk0geauEWK5zyBZvhuYJ4mnm"
consumerSecret <- "w0HqyJ3S5iv5KRYwK3mJ5Drf6Fn8s5F4qvo2r2JRhIIUw4Xxbh"
accessToken <- " 63168799-Q5Tkn035KzhPnYxjL3y4ebssqaofjfSxqH7dp1p7w"
accessTokenSecret <- " rooBn666oU249HWPoDvlKvV9yHJPSXEcJSOgFFt8IGdKW"

#obtain oauth by handshaking and save the oauth to the local disk for future connections
my_oauth <- OAuthFactory$new (consumerKey = consumerKey,
                              consumerSecret = consumerSecret,
                              requestURL = requestURL,
                              accessURL = accessURL,
                              authURL = authURL)

# returns the oauth 
my_oauth$handshake(cainfo ="cacert.pem")


# set up the OAuth credentials for a twitterR session 
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)

# sampleStream opens a connection to Twitter’s Streaming API that will return a random 
# sample of public statuses.
sampleStream(file =outFile,oauth = my_oauth ,tweets = 100)

##Alternative: a little more advanced if you want to filter for things
# TwitterIDs (not screennames!) of people to follow
follow <-""
# Comma-separated list of words to filter
track <-"Boston,Redsox"
# Geolocation of tweets to filter for (see documentation)
location <- c(23.786699 ,60.878590 ,37.097000,77.840813)
# This creates a file on the desktop tweets_sample.json in which the tweet data will be stored.    
filterStream(file.name=outFile ,follow=follow,track=track,locations = location,oauth = my_oauth,timeout = 5)
