#### practice with probability distributions ####

# calculating the likelihood requires understanding how to work
# with probability distributions. let's start with the binomial
# distribution.

# the binomial distribution describes the number of "success" in
# some number of "trials" given some probability of success. it 
# is the "coin flipping" distribution. 

# in R, we can draw a sample from a binomial distribution with rbinom()
# this isn't the first time you've seen rbinom, but here it is again, 
# with the parameters spelled out. you can try changing these to explore
# how the function works.

number.of.samples <- 2
number.of.trials.per.sample <- 100
probability.of.success <- 0.7


rbinom(number.of.samples, number.of.trials.per.sample, probability.of.success)

# below, use rbinom to create sample data for the following scenario.
# an experiment tests whether subjects have ESP. 100 subjects are each given
# the opportunity to predict whether a randomly generated number is odd or even.
# each subject makes 20 guesses.
# of course, ESP doesn't exist, so the probability of a successful guess is 0.50.
# store the result in a vector called esp.data

esp.data <- rbinom(100, 20, 0.5)

# a quick way to visualize a distribution is with the hist() function:
hist(esp.data)

# what if we want to know the probability of someone getting exactly 10 guesses
# correct out of 20, if they are randomly guessing? for that we use the density
# function of the binomial: dbinom()

value.to.check <- 10
number.of.trials <- 20
probability.of.success <- 0.5

dbinom(value.to.check, number.of.trials, probability.of.success)

# use dbinom to find out the probability of someone answering 87 out of 100
# questions correctly, if they have a 0.9 probability of giving a correct answer
# for each individual question.

dbinom(87, 100, 0.9)

# with dbinom, you can use a vector as the first argument, to check the probability
# of multiple values at the same time:

values <- c(3, 4, 5)
dbinom(values, 8, 0.5)

# using this shortcut, *plot* the full distribution (probability mass function)
# for flipping 16 fair coins, counting the total number of heads.
# hint: create one vector for the different possible outcomes
#       then use dbinom to calculate the probability of all of the elements in the vector


#a probability mass function plots outcomes on the x, probability of those outcomes on the y

heads<-seq(0, 16)
prob<-dbinom(heads, 16, 0.50)
plot(heads,prob)

# quick detour #

# here's a quick tip about plot() or hist()
# if you want to change the range on the x-axis, you can use the xlim argument:

hist.sample <- rbinom(100, 100, 0.5)
hist(hist.sample)
hist(hist.sample, xlim=c(0,100)) # compare this plot to the line above.

# the normal distribution ##

# normal (gaussian) distributions are characterized by two parameters: mean and standard deviation
# the mean is the the location of the peak of the distribution, and the sd controls the width.
# the smaller the sd, the more peaked the distribution is in the center.

# like the binomial, there are rnorm() and dnorm() functions.

# generate 100 samples from a normal distribution with mean 0 and standard deviation 10.
# then use hist() to create a histogram of these samples.

rnorm.prob<- rnorm(100, 0, 10)
hist(rnorm.prob)

# now plot the probability density function of this distribution.
# use the same strategy as you did above with the binomial to find the density of the normal
# distribution with mean 0 and sd 10 for values between -50 and 50. the distribution is continuous
# so, choose a reasonably small step size between values (remember the seq() function).

samples<-seq(-50, 50, 0.25)
prob.density<-dnorm(samples, 0, 10)
plot(samples, prob.density, type="l")


#### practice calculating likelihoods ####

# here's some data from 10 participants in an ESP experiment like the one described
# above. each subject had 20 guesses. the number of correct guesses is reported.

esp.practice.data <- data.frame(subject=1:10, n.correct=c(11,10,6,10,6,12,10,8,9,11))

# calculate the likelihood (regular, not log) for this data for three different values
# of the probability of success parameter: 0.4, 0.5, and 0.6.
# hint: prod() will multiple all elements of a vector together.

prod(dbinom(esp.practice.data$n.correct, 20, 0.4))
prod(dbinom(esp.practice.data$n.correct, 20, 0.5))
prod(dbinom(esp.practice.data$n.correct, 20, 0.6))

# which parameter value of those options is most likely?

#0.5 is the most likely value

# here is a sample of response times for a single subject from a rapid decision making experiment.
rt.sample <- c(391.5845, 411.9970, 358.6373, 505.3099, 616.2892, 481.0751, 422.3132, 511.7213, 205.2692, 522.3433, 370.1850,
               517.4617, 332.3344, 316.8760, 395.5431, 231.7831, 399.8646, 238.9064, 299.7924, 474.7512, 271.6326, 423.4861,
               379.7867, 212.7789, 233.8291, 472.4591, 534.2131, 453.9655, 408.3443, 352.3001)

# calculate the **log** likelihood for this data assuming that it is generated by a normal
# distribution for each of the following parameters. 
# hint: sum() adds the numbers in a vector. log() is the natural log function, or log=T for dnorm().

# 1) mean 350, sd 50
sum(dnorm(rt.sample, 350, 50, log=TRUE))

# 2) mean 400, sd 50
sum(dnorm(rt.sample, 400, 50, log=TRUE))

# 3) mean 450, sd 50
sum(dnorm(rt.sample, 450, 50, log=TRUE))

# 4) mean 350, sd 100
sum(dnorm(rt.sample, 350, 100, log=TRUE))

# 5) mean 400, sd 100
sum(dnorm(rt.sample, 400, 100, log=TRUE))

# 6) mean 450, sd 100
sum(dnorm(rt.sample, 450, 100, log=TRUE))

# which parameter set has the highest likelihood?

#mean of 400, standard deviation of 100


# here is a set of data for a subject in a categorization experiment, modeled with GCM.
# calculate the log likelihood of the parameters in the model (which i am not showing you).
# the point here is to know what to do when the model gives you a predicted probability
# of a response, and the data is either that response or not that response.
# hint: add a new column indicating the likelihood of each response, using mapply. then convert to log and add.
# if you do this correctly, the answer is -10.84249.

gcm.practice.data <- data.frame(correct.response = c(T, T, T, T, F, T, T, F, T, T, T, F, F, T, T, F, T, T, T, T),
                                gcm.probability.correct = c(0.84, 0.80, 0.84, 0.80, 0.79, 0.86, 0.89, 0.87, 0.69, 0.85, 0.75,
                                                            0.74, 0.82, 0.85, 0.87, 0.69, 0.83, 0.87, 0.80, 0.76))

gcm.practice.data$individual.likelihood <- mapply(
  function(prob, response){
  if (response == T){
    return(prob)
  }else{
    return(1-prob)
  }
}, gcm.practice.data$gcm.probability.correct, gcm.practice.data$correct.response)

gcm.practice.data$log.likelihood <- log(gcm.practice.data$individual.likelihood)

sum(gcm.practice.data$log.likelihood)

#we need to be returning a part of a vector, but not a vector

#### maximum likelihood estimation ####

# the same search strategies we used for parameter fitting with rmse can be used with likelihoods,
# including grid search.

# here are the number of correct responses each subject gave in an experiment in which they had to
# decide if two images were the same or different. there were 40 trials for each subject
same.diff.data <- c(32, 29, 31, 34, 26, 29, 31, 34, 29, 31, 30, 29, 31, 34, 33, 27, 32, 29, 29, 27)

# we can model this experiment's data as 40 coin flips for each subject. use grid search to plot the likelihood
# function for values of theta (probability of a correct response) between 0.5 and 0.9, in steps of 0.01.
# start by writing a function that calculates the likelihood (not log) for the entire set of data given a value of theta.

same.diff.data.likelihood <- function(theta){
  sum(dbinom(same.diff.data, 40, theta))
}

theta<-seq(from=0.5, to = 0.9, by= 0.01)



# then use sapply to run the function for each possible value of theta in the set. use seq() to generate the
# set of possible values. plot the set of values on the x axis and the corresponding likelihoods on the y axis.

same.diff.data.theta <- sapply(theta, same.diff.data.likelihood)
plot(theta, same.diff.data.theta)
# the "true" underlying value i used to generate the data was 0.75. does that match up with the grid search?
max(same.diff.data.theta)
theta[match(max(same.diff.data.theta), same.diff.data.theta)]

#the max of the grid search is 0.76 so it almost matches

## mle with optim()

# in this section, you'll do model recovery for a descriptive model of the linear relationship 
# between two continuous variables.

# let's assume that variable y is a linear function of variable x, such that:
# y = 4 + 0.8x

# create a vector of x values from 0 to 100, and the corresponding vector of y values,
# then plot these with x values on the x axis, and y values on the y axis.

x<-seq(0, 100)
y <- function(x){
  return(4+(0.8*x))
}

plot(x,y(x), type="l")

# now let's assume that the relationship between x and y isn't perfect. there's a bit of random
# noise. add a random sample from a normal distribution with mean 0 and sd 10 to each y value.
# hint: there are 101 y values, so you need 101 samples.

y.noise <- function(x){
  return(4+(0.8*x)+rnorm(101, mean=0, sd=10))
}


# plot the data again, with the new noisy y values.


plot(x,y.noise(x))

# there are three parameter values that control this plot,
# the intercept of the line: 4
# the slope of the line: 0.8
# the sd of the normal distribution: 10

# say that we observe a point of data, x = 20 and y = 27.
# the linear equation, y <- 4 + 0.8*x, predicts that when x is 20 y should also be 20.
4 + 0.8*20

# our model of this data assumes that the relationship is not perfect.
# we assume that there is noise so that when x is 20, the most likely value of y should be 4 + 0.8*x,
# but other values of y are possible. we describe the probability of different values of y with a normal
# distribution. when x is 20, then the normal distribution of y values is centered on 20, because the line
# says that y is 4 + 0.8x. using the normal distribution is helpful because it gives us a way to quantify
# how likely a value of 19 is compared to a value of 16, when x is 20.

# here's an example
x.observed <- 20
y.predicted <- 4 + 0.8*x.observed

# to find out the probability of y.observed=20, use dnorm()
# the mean of the normal distribution should be y.predicted (the distribution is centered on the line)
# and the sd of the normal is a parameter we will estimate, but for the demo below, is set to 10.
y.observed <- 20
dnorm(y.observed, y.predicted, 10)

# write the code to see how likely it is that y will be 33 when x is 29? (assuming sd = 10)
# the correct answer is 0.03371799...

x.observ <- 29
y.observ <- 33
y.predicted <- 4 + 0.8*x.observed
dnorm(y.observ, y.predicted, 10)

# now generalize your solution to compute the likelihood of each value of y that you generated above.
# in other words, write the code that takes a vector of x and y values, and returns the probability
# of each pair given that the relationship between x and y is y <- 4 + 0.8*x and the normal distribution has an sd of 10.
x<-seq(0,100)
y.noise.predicted <- 4+ 0.8*x + rnorm(101, 0, 10)
dnorm(y.noise(x), y.noise.predicted, 10)


# now generalize your solution one step further. write a function that takes in a vector of parameters,
# where parameters[1] is the intercept, parameters[2] is the slope, and parameters[3] is the sd of the normal,
# and returns the total **negative log likelihood**. remember, we want the negative log likelihood because
# optim() will find the set of parameters that minimizes a function.

parameter.optimize <- function(parameters){
  intercept<-parameters[1]
  slope<-parameters[2]
  sd<-parameters[3]
  
  y.noise.gen<-function(x){return(intercept+ slope*x + rnorm(101, 0, sd))}
  y.noise.predicted.gen <- intercept+ slope*x + rnorm(101, 0, sd)
  return(sum(-1*(dnorm(y.noise.gen(x), y.noise.predicted.gen, sd, log = T))))
  }




# use optim() and Nelder-Mead to search for the best fitting parameters. remember to ensure that sd > 0
# and return NA if it is not.
parameter.optimize.optim<- optim(c(1,1,1), parameter.optimize, method="Nelder-Mead")
parameter.optimize.optim$par
parameter.optimize.optim$value

# finally, plot the best fitting line on your points by using the abline() function, and the parameters that optim() found.
abline(parameter.optimize.optim$par[1], parameter.optimize.optim$par[2])
