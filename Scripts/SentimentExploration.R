library(tidyverse)
library(tidytext)
library(lubridate)


# If this file doesn't exist yet - run TokeniseData. 

NoSleep <- read_csv('./ProcessedData/Tokenised_NoSleep.csv')

# Most common words

NoSleep %>%
  count(word, sort = TRUE)

# Sentiment positivity over time

NoSleep %>%
  inner_join(get_sentiments("bing"))  %>% 
  count('month' = floor_date(Created, "month"), sentiment) %>% 
  spread(sentiment, n) %>%
  mutate(positivity = positive/(positive + negative)) %>%
  ggplot(aes(x = month, y = positivity)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 1))


# total emotions

NoSleep %>%
  inner_join(get_sentiments("nrc"))  %>% 
  count(sentiment) %>% 
  filter(!sentiment %in% c('positive', 'negative')) %>%
  mutate(sentiment = reorder(sentiment, n)) %>%
  ggplot(aes( y = n, x = sentiment, fill = sentiment)) +
  geom_bar(stat = 'identity')


# Is number of words correlated with score? - Not really - weak positive

total_words <- NoSleep %>%
  count(Title, word, sort = TRUE)  %>%
  group_by(Title) %>% 
  summarize(total = sum(n))

left_join(total_words, NoSleep %>% group_by(Title) %>% summarise(score = max(Score))) %>%
  ggplot(aes(x = total, y = score)) +
  geom_point()

with(left_join(total_words, NoSleep %>% group_by(Title) %>% summarise(score = max(Score))), cor(total, score))


# tf_idf

left_join(NoSleep %>% group_by(Title) %>% filter(Score == max(Score)), total_words) %>%
  bind_tf_idf(word, Title, total) %>%
  arrange(desc(tf_idf))
