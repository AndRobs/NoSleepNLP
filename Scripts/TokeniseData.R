library(tidyverse)
library(tidytext)


NoSleep <- read_csv('./Data/NoSleep.csv') %>%
  mutate(Text = gsub("[\r\n]", "", Text)) %>%
  mutate(Text = gsub("[[:punct:]]", "", Text)) %>%
  mutate(Text = gsub("㤼㸲", "", Text)) 




# Will need to create the ProcessedData folder first -----------------------

# dir.create("./ProcessedData", showWarnings = FALSE)


NoSleep %>%
  mutate(Created = as.POSIXct(Created, origin="1970-01-01")) %>%
  unnest_tokens(Word, Text) %>%
  write_csv('./ProcessedData/Tokenised_NoSleep.csv')
