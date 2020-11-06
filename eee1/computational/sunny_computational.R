# Created by Yixin Sun on November 5th, 2020

library(tidyverse)
library(Matrix)
library(Rfast)
library(tictoc)
gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/eee1/computational"

# ============================================================================
# Question 1
# ============================================================================
# Set up
S <- 1000
utility1 <- function(y) 2*y^.5
utility2 <- function(y) 5*y - 0.05*6^2
delta <- 1 / 1.05
N <- 501
nA <- 501

stock <- seq(0, 1000, length.out = N)
action <- seq(0, 1000, length.out = nA)


# flow utility matrix --------------------------
flow1 <-
  map(action, function(x) ifelse(stock < x, -Inf, utility1(x))) %>%
  reduce(cbind)

flow2 <-
  map(action, function(x) ifelse(stock < x, -Inf, utility2(x))) %>%
  reduce(cbind)

# index of state next period -------------------
index <-
  action %>%
  map(~ map_dbl(stock - .x, function(i) ifelse(length(which(stock == i)) == 0, 1,
                                               which(stock == i)))) %>%
  reduce(cbind)

# state transition matrix ----------------------
# FIX THIS - TRANSITION MATRIX SHOULD BE N by (N*nA)
tic()
transition <-
  map(action, function(a){
    state <- ifelse(stock - a < 0, 0, stock - a)
    map(stock, ~ as.numeric(stock == .x)) %>%
      reduce(rbind) %>%
      Matrix(sparse = TRUE)
  })
toc()

# initialize and calculate Vnext ----------------
iterator <- function(U, Vi, trans, delta){
  # first set up Vnext
  Vnext <-
    map(trans, ~.x %*% Vi) %>%
    reduce(cbind)

  # calculate new V
  value <- as.matrix(U + delta*Vnext)
  Vnew <- rowMaxs(value, value = TRUE)
  policy <- max.col(value)
  return(list(V = Vnew, policy = policy))
}

tol <- 10^-8
diff <- 10000
V0_1 <- matrix(0, nrow = N, ncol = 1)
while(diff > tol){
  step <- iterator(flow2, V0_1, transition, delta)
  diff <- norm(as.matrix(V0_1 - step[[1]]))
  V0_1 <- step[[1]]
  policy1 <- action[step[[2]]]
  print(diff)
}


tol <- 10^-8
diff <- 10000
V0_2 <- matrix(0, nrow = N, ncol = 1)
while(diff > tol){
  step <- iterator(flow2, V0_2, transition, delta)
  diff <- norm(as.matrix(V0_2 - step[[1]]))
  V0_2 <- step[[1]]
  policy2 <- action[step[[2]]]
  print(diff)
}
