# Created by Yixin Sun on November 5th, 2020
library(tidyverse)
library(Matrix)
library(ggthemes)
library(tictoc)
library(ggplot2)
library(Rfast)
tic("Run whole program")

gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/eee1/computational"

# Set up
S <- 1000
delta <- 1 / 1.05
N <- 501
nA <- 501
Tend <- 80

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
  policy <- rowMaxs(value, value = FALSE)
  return(list(V = Vnew, policy = policy))
}

# solve value function iteration
value_iterate <- function(util, trans){
  diff <- 10000
  Vi <- matrix(0, nrow = N, ncol = 1)
  while(diff > 10^-8){
    step <- iterator(util, Vi, trans, delta)
    diff <- norm(as.matrix(Vi - step[[1]]))
    Vi <- step[[1]]
    print(paste("V distance:", diff))
  }


  return(list(V = Vi, policy = step[[2]]))
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

# find next state, given current state and action
next_ind <- function(current, action, all_stocks){
  next_state <- max(current - action, 0)
  return(which.max(all))
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
    high_weight <- 1 - abs(states[2] - next_state) / abs((states[2] - states[1]))
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

# part e index of state next period -------------------------
index <-
  action %>%
  map(~ map_dbl(stock - .x, function(i) ifelse(length(which(stock == i)) == 0, 1,
                                               which(stock == i)))) %>%
  reduce(cbind) %>%
  split(., rep(1:ncol(.), each = nrow(.)))

# part f state transition matrix ------------------------------------------
transition <-
  map(index, function(i){
    out <- Matrix(0, nrow = N, ncol = N, sparse = TRUE)
    out_ind <- cbind(1:N, i)
    out[out_ind] <- 1
    return(out)
  })


# part g initialize and calculate Vnext ---------------------------------------
# run iterator function that calculates next Vi until Vi = Vi+1
# model1 <- value_iterate(flow1, transition)
# V1 <- model1[[1]]
# policy1 <- action[model1[[2]]]
#
# # run iteratively until Vi = Vi+1 for second utility function
# model2 <- value_iterate(flow2, transition)
# V2 <- model2[[1]]
# policy2 <- action[model2[[2]]]

# part h solve for optimal transition matrix  ---------------------------------
# trans_opt1 <-
#   map(1:N, function(i){
#     state <- max(0, stock[i] - policy1[i])
#     Matrix(as.numeric(stock == state), nrow = 1, sparse = TRUE)
#   }) %>%
#   reduce(rbind)
#
# trans_opt2 <-
#   map(1:N, function(i){
#     state <- max(0, stock[i] - policy2[i])
#     Matrix(as.numeric(stock == state), nrow = 1, sparse = TRUE)
#   }) %>%
#   reduce(rbind)

# Simulate the model for utility function 1 ---------------------------------
# for each period, calculate the period's extraction and stock remaining
# output1 <- tibble(y = NA, S = NA)
# stock_t <- 1000
# for(i in 1:Tend){
#   out1 <- extraction(stock_t, policy1)
#   output1 <- bind_rows(output1, out1)
#   stock_t <- out1$S
# }
#
# output1 <-
#   output1 %>%
#   filter(!is.na(y)) %>%
#   mutate(price = y^(-.5),
#          time = 1:Tend) %>%
#   mutate(price = ifelse(price == Inf, NA, price))
#
# # plot extraction path and price against time
# output1 %>%
#   select(-S) %>%
#   gather(key = "type", value = "path", -time) %>%
#   ggplot(aes(x= time, y = path)) +
#   geom_line(color = "tomato3") +
#   facet_wrap(~type, nrow = 2, scales = "free") +
#   theme_clean()
# ggsave(file.path(gdir, "sunny_q1_u1.png"), width = 8, height = 6)
#
# # Simulate model for utility function 2 ---------------------------------------
# # for each period, calculate the period's extraction and stock remaining
# output2 <- tibble(y = NA, S = NA)
# stock_t <- 1000
# for(i in 1:Tend){
#   out2 <- extraction(stock_t, policy2)
#   output2 <- bind_rows(output2, out2)
#   stock_t <- out2$S
# }
#
# output2 <-
#   output2 %>%
#   filter(!is.na(y)) %>%
#   mutate(price = 5 - 0.1*y,
#          time = 1:Tend) %>%
#   mutate(price = ifelse(price == Inf, NA, price))
#
# # plot extraction path and price against time
# output2 %>%
#   select(-S) %>%
#   gather(key = "type", value = "path", -time) %>%
#   ggplot(aes(x= time, y = path)) +
#   geom_line(color = "tomato3") +
#   facet_wrap(~type, nrow = 2, scales = "free") +
#   theme_clean()
#
# ggsave(file.path(gdir, "sunny_q1_u2.png"), width = 8, height = 6)

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

# load("C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/transition_int.Rda")

# part d - flow utility matrix -----------------------------------
flow1_int <-
  map(action_int, function(x) ifelse(stock < x, -Inf, utility1(x))) %>%
  reduce(cbind)

flow2_int <-
  map(action_int, function(x) ifelse(stock < x, -Inf, utility2(x))) %>%
  reduce(cbind)


# part c Solve model via value function interation ------------------------
# run iterator function that calculates next Vi until Vi = Vi+1
model1_int <- value_iterate(flow1_int, transition_int)
policy1_int <- action_int[model1_int[[2]]]

# run iteratively until Vi = Vi+1 for second utility function
model2_int <- value_iterate(flow2_int, transition_int)
policy2_int <- action_int[model2_int[[2]]]

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

toc()
