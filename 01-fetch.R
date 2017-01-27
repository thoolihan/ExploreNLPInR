library(twitteR)
library(dplyr)
library(tm)

source('./auth.R')

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

tweets <- twListToDF(userTimeline('thoolihan', n=25))

clean <- function(txt) {
  txt <- iconv(txt, to='UTF-8')
  txt <- sub('\\bRT\\b', '', txt)
  return(txt)
}

tweets <- mutate(tweets,
                 text = clean(text)) %>%
          select(id, created, favoriteCount, retweetCount, text)

head(tweets)

tw_corp <- VCorpus(VectorSource(tweets$text)) %>%
            tm_map(stripWhitespace) %>%
            tm_map(content_transformer(tolower)) %>%
            tm_map(removeWords, stopwords('english')) 

lapply(tw_corp[1:4], as.character)

dtm <- DocumentTermMatrix(tw_corp)

print(findFreqTerms(dtm, 2))

new_cols <- as.matrix(dtm)
dim(new_cols)



