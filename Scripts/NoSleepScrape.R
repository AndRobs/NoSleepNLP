library(httr)
library(tidyverse)
library(jsonlite)


URLBuilder <- function(pageNumber, after){
  
  pageNumber = (pageNumber - 1) * 25
  
  if(pageNumber == 0){
    
    link <- 'https://www.reddit.com/r/nosleep/top/.json?sort=top&t=all'
    
  } else {
    
    link <- paste0('https://www.reddit.com/r/nosleep/top/.json?sort=top&t=all&count=',pageNumber,'&after=',after)
    
  }
  
  return(link)
  
}



for(pageNumber in 1:200){
  
  if(pageNumber == 1){
    
    output <- tibble("Title" = character(), "Author" = character() , 'Score' = numeric(), 'Created' = numeric( ), 'Text' = character())
    
    data <- GET(URLBuilder(pageNumber) , add_headers(`User-agent` = "NoSleep Miner")) %>%
      content('text') %>%
      fromJSON()
    
  } else {
    
    data <- GET(URLBuilder(pageNumber, After) , add_headers(`User-agent` = "NoSleep Miner")) %>%
      content('text') %>%
      fromJSON()
    
  }
  
  Title   <- data$data$children$data$title
  Text    <- data$data$children$data$selftext
  Score   <- data$data$children$data$score
  Created <- data$data$children$data$created
  Author  <- data$data$children$data$author
  
  After   <- data$data$after
  
  output <- bind_rows(output, tibble(Title, Author, Score, Created, Text))
  
  Sys.sleep(1)
}

write.csv(output, "./Data/NoSleep.csv", row.names = F)
          
          
          