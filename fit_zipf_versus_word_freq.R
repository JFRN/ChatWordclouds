# Generate a Zipf distribution vs actual word frequency chart
install.packages('ggplot2')
install.packages('VGAM')

library('tm')
library('ggplot2')
library('reshape2')
library('VGAM')

# Based on https://chengjunwang.com/post/en/2014-03-17-fit-power-law/

setwd("D:/Dev/osunigstats")
f <- read.table('words.csv',sep=',',header=T)

freq <- f[['count']]
word <- f[['word']]

Rank <- rank(-freq, ties.method=c('first'))
data <- data.frame(word, freq, Rank)
data$prob <- data$freq/sum(data$freq)

get_dist = function(freq){
  Rank = rank(-freq, ties.method = c("first"))
  p = freq/sum(as.numeric(freq))
  # get the log form
  log.f = log(freq)
  log.p = log(p)
  log.rank = log(Rank)
  log.inverse.rank = log(length(Rank)+1-Rank)
  
  # linear regression of Zipf: for frequency
  cozf=coef(lm(log.f~log.rank))
  zipf.f = function(x) exp(cozf[[1]] + cozf[2]*log(x))
}

zipf.f = get_dist(data$freq)

plot(freq~Rank,log="xy", xlab = "Rank", ylab = "Frequencia", data = data, main = "Word Frequency vs Zipf's Law")
curve(zipf.f, col="red", add = T, n = length(data$Rank))

ggplot(data=data, aes(x=Rank, y=freq, label = word)) + geom_point() +
  coord_trans(x = "log10", y = "log10")+
  stat_function(fun = zipf.f, n = length(Rank), colour = 'red', size = 1) +
  geom_text(aes(label=word),hjust=1.5, vjust=0, angle = 45, size = 3) +
  ggtitle("Word Frequency vs Zipf's Law")

