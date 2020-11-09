# Created by Yixin Sun on November 6th, 2020

library(tidyverse)
library(Matrix)
library(Rfast)
library(tictoc)

gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/eee1/computational"

# part a Set up ---------------------------------------
p_high <- 80
P <- seq(0, p_high, 1)
profit <- function(p) p*100000 - 3000000
delta <- 1 / 1.05

# part b Transition matrix ----------------------------
# function that calculates, for a given price, the probability that
# next period's price will be in the column state j
price_prob <- function(p_i){
  P_low <- P - 0.5
  P_low[1] <- -Inf
  P_high <- P + 0.5
  P_high[length(P)] <- Inf
  P_bounds <-
    tibble(P_low = P_low, P = P, P_high = P_high) %>%
    mutate(P_prob = pnorm(P_high, p_i, 4) - pnorm(P_low, p_i, 4))

  return(P_bounds$P_prob)
}

price_transition <-
  map(P, price_prob) %>%
  reduce(rbind) %>%
  as.matrix()

# check that I constructed this correctly
rowSums(price_transition)

# part c ----------------------------------------------
# generate profits flows matrix
profits <-
  map_dbl(P, profit) %>%
  cbind(0, .) %>%
  as.matrix()

price_iterator <- function(pi, Vi, trans, delta){
  # first set up Vnext
  Vnext <- cbind(trans %*% Vi, 0)

  # calculate new V
  value <- as.matrix(pi + delta*Vnext)
  Vnew <- rowMaxs(value, value = TRUE)
  policy <- max.col(value) - 1
  return(list(V = Vnew, policy = policy))
}

tol <- 10^-8
diff <- 10000
Vt <- matrix(0, nrow = length(P), ncol = 1)
while(diff > tol){
  step <- price_iterator(profits, Vt, price_transition, delta)
  diff <- norm(as.matrix(Vt - step[[1]]))
  Vt <- step[[1]]
  drill <- step[[2]]
  print(diff)
}

pstar <- P[which(drill == 1)[1]] # woohoo got 41!!!


# Graph showing the value function
ggplot() +
  geom_line(aes(x = P, y = Vt), color = "purple4") +
  theme_minimal() +
  ylab("V(P)")
ggsave(file.path(gdir, "sunny_q3.png"), width = 8, height = 6)

# Is the intuition here that we can learn from observing what happens in the real
# world and adapt our behavior to increase our potential upside from investment/drilling
# Is this graph linear at the end because there's no more value from learning/flexibility past
# P = 41? Is this basically because at higher prices, there's less uncertainty because stdev / price
# is smaller, thus there's lower option value?


