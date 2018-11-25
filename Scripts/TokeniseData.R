library(tidyverse)
library(tidytext)


# Will need to create the ProcessedData folder first -----------------------

# dir.create("./ProcessedData", showWarnings = FALSE)

# If this file doesn't exist yet - run NoSleepScrape. 
read_csv('./Data/NoSleep.csv') %>%
  mutate(Text = gsub("[^[:print:]]","", Text)) %>%
  mutate(Created = as.POSIXct(Created, origin="1970-01-01")) %>%
  unnest_tokens(word, Text) %>%
  anti_join(stop_words) %>%
  write_csv('./ProcessedData/Tokenised_NoSleep.csv')



# Only run this part if you want stop words - this takes a while
read_csv('./Data/NoSleep.csv') %>%
  mutate(Text = gsub("[^[:print:]]","", Text)) %>%
  mutate(Created = as.POSIXct(Created, origin="1970-01-01")) %>%
  unnest_tokens(word, Text) %>%
  write_csv('./ProcessedData/Tokenised_NoSleep_With_Stopwords.csv')
