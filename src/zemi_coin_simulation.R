# library
library(ggplot2)

#make this example reproducible
set.seed(3)

num = 100
trials = 100

#define data
data <- data.frame(x=rbinom(num,trials,0.5))

#create histogram and overlay normal curve
ggplot(data, aes(x)) +
  geom_histogram(aes(y = ..density..), fill='lightgray', col='black',binwidth=1) +
  stat_function(fun = dnorm, args = list(mean=mean(data$x), sd=sd(data$x)),col="blue")
