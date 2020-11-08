# Created by Yixin Sun on November 5th, 2020

library(tidyverse)
library(Matrix)
library(ggthemes)
library(tictoc)
library(ggplot2)

gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/eee1/computational"

# Set up
S <- 1000
delta <- 1 / 1.05
N <- 501
nA <- 501
Tend <- 80
tol <- 10^-8

stock <- seq(0, S, length.out = N)
action <- seq(0, S, length.out = nA)

# ============================================================================
# Helper Functions
# ============================================================================
utility1 <- function(y) 2*y^.5
utility2 <- function(y) 5*y - 0.05*y^2

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

# solve value function iteration
value_iterate <- function(util, trans, act){
  diff <- 10000
  Vi <- matrix(0, nrow = N, ncol = 1)
  while(diff > tol){
    step <- iterator(util, Vi, trans, delta)
    diff <- norm(as.matrix(Vi - step[[1]]))
    Vi <- step[[1]]
    print(diff)
  }
  return(list(V = Vi, policy = act[step[[2]]]))
}

# Given a stock level and policy function, the extraction function returns the
# optimal extraction rate and next period stock - works for both q1 and q2
extraction <- function(St, C){
  St_range <- close(St)
  high_weight <- 1 - abs(St_range[2] - St) / abs((St_range[2] - St_range[1]))
  low_weight <- 1 - high_weight

  yt <- high_weight*C[which(stock == St_range[2])] + low_weight * C[which(stock == St_range[1])]
  St1 <- interpolate_state(St, yt) %*% stock
  return(tibble(y = yt, S = as.numeric(St1)))
}

# find two closest stock values to any given stock level
close <- function(value){
  stock[order(abs(stock-value))][1:2]
}

# given a current state and amount to extract, return vector of probabilities for
# next period state
interpolate_state <- function(state, a){
  next_state <- state - a
  if(next_state <= 0){
    out <- matrix(c(1, rep(0, N - 1)), nrow = 1)
  } else{
    states <- close(next_state)
    high_weight <- 1 - abs(states[2] - next_state) / abs(states[2] - states[1])
    low_weight <- 1 - high_weight
    out <- matrix(0, ncol = N)
    out[which(stock == states[2])] <- high_weight
    out[which(stock == states[1])] <- low_weight
  }
  return(out)
}

# ============================================================================
# Question 1
# ============================================================================
# part d - flow utility matrix
flow1 <-
  map(action, function(x) ifelse(stock < x, -Inf, utility1(x))) %>%
  reduce(cbind)

flow2 <-
  map(action, function(x) ifelse(stock < x, -Inf, utility2(x))) %>%
  reduce(cbind)


# part e + f state transition matrix ------------------------------------------
tic("build transition matrix")
transition <-
  map(action, function(a){
    state <- ifelse(stock - a < 0, 0, stock - a)
    map(state, ~ as.numeric(stock == .x)) %>%
      reduce(rbind) %>%
      Matrix(sparse = TRUE)
  })
save(transition, file = file.path(gdir, "transition.Rda"))
toc()

load(file.path(gdir, "transition.Rda"))


# part g initialize and calculate Vnext ---------------------------------------
# run iterator function that calculates next Vi until Vi = Vi+1
model1 <- value_iterate(flow1, transition, action)
V1 <- model1[[1]]
policy1 <- model1[[2]]

# run iteratively until Vi = Vi+1 for second utility function
model2 <- value_iterate(flow2, transition, action)
V2 <- model2[[1]]
policy2 <- model2[[2]]

# part h solve for optimal transition matrix  ---------------------------------
trans_opt1 <-
  map(1:N, function(i){
    state <- ifelse(stock[i] - policy1[i] < 0, 0, stock[i] - policy1[i])
    Matrix(as.numeric(stock == state), nrow = 1, sparse = TRUE)
  }) %>%
  reduce(rbind)
#
# trans_opt2 <-
#   map(1:N, function(i){
#     state <- ifelse(stock[i] - policy2[i] < 0, 0, stock[i] - policy2[i])
#     Matrix(as.numeric(stock == state), nrow = 1, sparse = TRUE)
#   }) %>%
#   reduce(rbind)

# Simulate the model for utility function 1 ---------------------------------
# for each period, calculate the period's extraction and stock remaining
output1 <- tibble(y = NA, S = NA)
stock_t <- 1000
for(i in 1:Tend){
  out1 <- extraction(stock_t, policy1)
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
ggsave(file.path(gdir, "sunny_q1_u1.png"), width = 8, height = 6)

# Simulate model for utility function 2 ---------------------------------------
# for each period, calculate the period's extraction and stock remaining
output2 <- tibble(y = NA, S = NA)
stock_t <- 1000
for(i in 1:Tend){
  out2 <- extraction(stock_t, policy2)
  output2 <- bind_rows(output2, out2)
  stock_t <- out2$S
}

output2 <-
  output2 %>%
  filter(!is.na(y)) %>%
  mutate(price = 5 - 0.1*y,
         time = 1:Tend) %>%
  mutate(price = ifelse(price == Inf, NA, price))

# plot extraction path and price against time
output2 %>%
  select(-S) %>%
  gather(key = "type", value = "path", -time) %>%
  ggplot(aes(x= time, y = path)) +
  geom_line(color = "tomato3") +
  facet_wrap(~type, nrow = 2, scales = "free") +
  theme_clean()

ggsave(file.path(gdir, "sunny_q1_u2.png"), width = 8, height = 6)

# ============================================================================
# Question 2
# ============================================================================
action_int <- seq(0, S^.5, length.out = nA)^2

# part b Interpolate transition matrix -----------------------------------
tic("build transition matrix q2")
transition_int <-
  map(action_int, function(a){
    map(stock, ~ interpolate_state(.x, a)) %>%
      reduce(rbind) %>%
      Matrix(sparse = TRUE)
  })
save(transition_int, file = file.path(gdir, "transition_int.Rda"))
toc()

load(file.path(gdir, "transition_int.Rda"))

# part c Solve model via value function interation ------------------------
# run iterator function that calculates next Vi until Vi = Vi+1
model1_int <- value_iterate(flow1, transition_int, action_int)
policy1_int <- model1_int[[2]]

# run iteratively until Vi = Vi+1 for second utility function
model2_int <- value_iterate(flow2, transition_int, action_int)
policy2_int <- model2_int[[2]]

# Simulate the model for utility function 1 ---------------------------------
# for each period, calculate the period's extraction and stock remaining
output1_int <- tibble(y = NA, S = NA)
stock_t <- 1000
for(i in 1:Tend){
  out1_int <- extraction(stock_t, policy1_int)
  output1_int <- bind_rows(output1_int, out1_int)
  stock_t <- out1_int$S
}

output1_int <-
  output1_int %>%
  filter(!is.na(y)) %>%
  mutate(price = y^(-.5),
         time = 1:Tend) %>%
  mutate(price = ifelse(price == Inf, NA, price))

# plot extraction path and price against time
output1_int %>%
  select(-S) %>%
  gather(key = "type", value = "path", -time) %>%
  ggplot(aes(x= time, y = path)) +
  geom_line(color = "tomato3") +
  facet_wrap(~type, nrow = 2, scales = "free") +
  theme_clean()
ggsave(file.path(gdir, "sunny_q2_u1.png"), width = 8, height = 6)

# Simulate the model for utility function 2 ---------------------------------
# for each period, calculate the period's extraction and stock remaining
output2_int <- tibble(y = NA, S = NA)
stock_t <- 1000
for(i in 1:Tend){
  out2_int <- extraction(stock_t, policy2_int)
  output2_int <- bind_rows(output2_int, out2_int)
  stock_t <- out2_int$S
}

output2_int <-
  output2_int %>%
  filter(!is.na(y)) %>%
  mutate(price = 5 - 0.1*y,
         time = 1:Tend) %>%
  mutate(price = ifelse(price == Inf, NA, price))

# plot extraction path and price against time
output2_int %>%
  select(-S) %>%
  gather(key = "type", value = "path", -time) %>%
  ggplot(aes(x= time, y = path)) +
  geom_line(color = "tomato3") +
  facet_wrap(~type, nrow = 2, scales = "free") +
  theme_clean()
ggsave(file.path(gdir, "sunny_q2_u2.png"), width = 8, height = 6)
