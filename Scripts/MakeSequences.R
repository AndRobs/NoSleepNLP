
library(tidyverse)


# If this file doesn't exist yet - run TokeniseData. 

NoSleep <- read_csv('./ProcessedData/Tokenised_NoSleep_With_Stopwords.csv')


words <- NoSleep$word

seq <- character(length(51:length(words)))


for(i in 51:length(words)){
  
  seq[i - 50] <- paste(words[(i-50):i], collapse = " ")
  

  if( i %% 100000 == 0){
    print(i)
  }

}


writeLines(seq, "./ProcessedData/Sequences.txt")

seq
