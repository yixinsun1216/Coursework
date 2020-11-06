# Created by Yixin Sun on November 5th, 2020

library(tidyverse)
library(Matrix)
library(ggthemes)
library(tictoc)
library(ggplot2)

gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/eee1/computational"

# Set up
S <- 1000
utility1 <- function(y) 2*y^.5
utility2 <- function(y) 5*y - 0.05*6^2
delta <- 1 / 1.05
N <- 501
nA <- 501

stock <- seq(0, 1000, length.out = N)
action <- seq(0, 1000, length.out = nA)

# ============================================================================
# Question 1
# ============================================================================
# flow utility matrix
flow1 <-
  map(action, function(x) ifelse(stock < x, -Inf, utility1(x))) %>%
  reduce(cbind)

flow2 <-
  map(action, function(x) ifelse(stock < x, -Inf, utility2(x))) %>%
  reduce(cbind)

# index of state next period -------------------------
index <-
  action %>%
  map(~ map_dbl(stock - .x, function(i) ifelse(length(which(stock == i)) == 0, 1,
                                               which(stock == i)))) %>%
  reduce(cbind)

# state transition matrix -----------------------------
tic("build transition matrix")
transition <-
  map(action, function(a){
    state <- ifelse(stock - a < 0, 0, stock - a)
    map(state, ~ as.numeric(stock == .x)) %>%
      reduce(rbind) %>%
      Matrix(sparse = TRUE)
  })
toc()

# initialize and calculate Vnext ----------------------
# function that calculates Vnext, U + delta*Vnext, and returns the maximum
# V as well as the policy that induced the optimal

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

# run above function iteratively until Vi = Vi+1 for first utility function
tol <- 10^-8
diff <- 10000
V0_1 <- matrix(0, nrow = N, ncol = 1)
while(diff > tol){
  step <- iterator(flow1, V0_1, transition, delta)
  diff <- norm(as.matrix(V0_1 - step[[1]]))
  V0_1 <- step[[1]]
  policy1 <- action[step[[2]]]
  print(diff)
}

# run above function iteratively until Vi = Vi+1 for second utility function
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

# solve for optimal transition matrix  ----------------
trans_opt1 <-
  map(1:N, function(i){
    state <- ifelse(stock[i] - policy1[i] < 0, 0, stock[i] - policy1[i])
    Matrix(as.numeric(stock == state), nrow = 1, sparse = TRUE)
  }) %>%
  reduce(rbind)

trans_opt2 <-
  map(1:N, function(i){
    state <- ifelse(stock[i] - policy2[i] < 0, 0, stock[i] - policy2[i])
    Matrix(as.numeric(stock == state), nrow = 1, sparse = TRUE)
  }) %>%
  reduce(rbind)

# ============================================================================
# Simulate the model for t = 80 periods
# ============================================================================
Tend <- 80

# for each period, calculate the period's extraction and stock remaining
extraction <- function(St, C, Topt){
  s_index <- which(stock == St)
  yt <- C[s_index]
  St1 <- Topt[s_index,] %*% stock
  return(tibble(y = yt, S = as.numeric(St1)))
}

output1 <- tibble(y = NA, S = NA)
stock_t <- 1000
for(i in 1:Tend){
  out1 <- extraction(stock_t, policy1, trans_opt1)
  output1 <- bind_rows(output1, out1)
  stock_t <- out1$S
}

output1 <-
  output1 %>%
  filter(!is.na(y)) %>%
  mutate(price = y^(-.5),
         time = 1:Tend) %>%
  mutate(price = ifelse(price == Inf, NA, price))

# plot extraction path and price against time
output1 %>%
  select(-S) %>%
  gather(key = "type", value = "path", -time) %>%
  ggplot(aes(x= time, y = path)) +
  geom_line(color = "tomato3") +
  facet_wrap(~type, nrow = 2, scales = "free") +
  theme_clean()
