# Generates a wordcloud of the entire dataset, and generates a CSV of data concatenated by user

# Install
install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

setwd("D:/Dev/osunigstats")
dataset_original <- read.csv('osu!nichat24092019-actual.csv', stringsAsFactors = FALSE)
colnames(dataset_original) <- c("User", "Message")

dataset <- dataset_original

# Remove emoji (Other_Symbol and Unassigned)
dataset$Message <- gsub("\\p{So}|\\p{Cn}", "", dataset$Message, perl = TRUE)
dataset$Message <- iconv(dataset$Message, "UTF-8", "latin1")

dataset_agg <- aggregate(Message ~ User, data=dataset, toString, sep=' ') # Can also use paste
write.csv(file="osu!nichat24092019-processed-aggregate.csv", x=dataset_agg)

#user.df <- dataset_original
#user.df <- within(user.df, rm(Message))
#user.df <- unique(user.df$User)

cleanSpanishCorpus <- function(corpus) {
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("spanish"))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
}

# Don't use DataframeSource
# See https://stackoverflow.com/a/49241705
wordCorpus <- Corpus(VectorSource(dataset$Message))
wordCorpus <- cleanSpanishCorpus(wordCorpus)

# Text stemming
wordCorpus <- tm_map(wordCorpus, stemDocument)

# Create the word cloud
dtm <- TermDocumentMatrix(wordCorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

set.seed(123456789)
#Generate WordCloud
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
     max.words=200, random.order=FALSE, rot.per=0.35, 
     colors=brewer.pal(8, "Dark2"))
