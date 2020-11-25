# Created by Yixin Sun on 11/20/2020
library(tidyverse)
library(ggplot2)
library(gurobi)

gdir <-  "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset3"
beta_iv <- -1.101817887
cov_dz <- 0.27125
ez <- 2.5
ed <- .4175

# ==========================================================================
# Calculate beta_s
# ==========================================================================
s_tsls <- function(z){
  A <- 1/(.48*.12 + 1.16*.29 + 1.92*.48 + 3.12*.78)
  B <- matrix(c(.48, 1.16, 1.92, 3.12), nrow = 1)
  A %*% (B%*% matrix(c(z == 1, z == 2, z == 3, z == 4), ncol = 1))
}

s_iv <- function(z){
  (z - ez)/cov_dz
}

m1_int <- function(u_low, u_high){
  .9*u_high - 1.1/2*u_high^2 + .1*u_high^3 - (.9*u_low - 1.1/2*u_low^2 - .1*u_low^3)
}

m0_int <- function(u_low, u_high){
  .35*u_high - .15*u_high^2 - .05/3*u_high^3 - (.35*u_low - .15*u_low^2 - .05/3*u_low^3)
}

beta_s <- function(s_fun){
    output <- m0_int(0, .12)*s_fun(1) + m0_int(0, .29)*s_fun(2) +
      m0_int(0, .48)*s_fun(3) + m0_int(0, .78)*s_fun(4) +
      m1_int(.12, 1)*s_fun(1) + m1_int(.29, 1)*s_fun(2)+
      m1_int(.48, 1)* s_fun(3) + m1_int(.78, 1)*s_fun(4)
    return(output/4)
}

beta_iv <- beta_s(s_iv)
beta_tsls <- beta_s(s_tsls)

# ==========================================================================
# Helper functions
# ==========================================================================
# function for integral of bernstein polynomial for ith value
bernstein_integral <- function(i, k, K, u){
  1/(i + 1)*(-1)^(i - k)*choose(K, i)*choose(i, k)*u^(i + 1)
}

# evaluate sum of the tractable version of bernstein polynomial
bernstein_i <- function(k, K, u_low, u_high){
  int_sum <- 0
  for(i in k:K){
    int_sum <- int_sum + bernstein_integral(i, k, K, u_high) - bernstein_integral(i, k, K, u_low)
  }
  return(int_sum)
}

# function for calculating \gamma_sdk IV-like estimand slope
gamma_sdk <- function(k, K, d, s_fun){
  if(d == 1){
    output <- bernstein_i(k, K, .12, 1)*s_fun(1)+
      bernstein_i(k, K, .29, 1)*s_fun(2) +
      bernstein_i(k, K, .48, 1)*s_fun(3) +
      bernstein_i(k, K, .78, 1)*s_fun(4)
  }
  if(d == 0){
    output <- bernstein_i(k, K, 0, .12)*s_fun(1)+
      bernstein_i(k, K, 0, .29)*s_fun(2) +
      bernstein_i(k, K, 0, .48)*s_fun(3) +
      bernstein_i(k, K, 0, .78)*s_fun(4)
  }
  return(output/4)
}


# function for calculating \gamma_dk for objective function
gamma_obj_dk <- function(k, K, d){
  if(d == 1){
    output <- bernstein_i(k, K, .12, 1)/ed +
      bernstein_i(k, K, .29, 1)/ed +
      bernstein_i(k, K, .48, 1)/ed +
      bernstein_i(k, K, .78, 1)/ed
  }
  if(d == 0){
    output <- bernstein_i(k, K, 0, .12)/-ed +
      bernstein_i(k, K, 0, .29)/-ed+
      bernstein_i(k, K, 0, .48)/-ed +
      bernstein_i(k, K, 0, .78)/-ed
  }
  return(output/4)
}


# ==========================================================================
# Main function that runs gurobi over different polynomial degrees
# ==========================================================================
solve_bounds <- function(deg, sense){
  gamma_obj <- c(map_dbl(1:deg, gamma_obj_dk, deg, 1),  map_dbl(1:deg, gamma_obj_dk, deg, 0))
  gamma_iv <- c(map_dbl(1:deg, gamma_sdk, deg, 1, s_iv),  map_dbl(1:deg, gamma_sdk, deg, 0, s_iv))
  gamma_tsls <- c(map_dbl(1:deg, gamma_sdk, deg, 1, s_tsls),  map_dbl(1:deg, gamma_sdk, deg, 0, s_tsls))

  model <- list()
  model$A <- rbind(matrix(gamma_iv, nrow = 1), matrix(gamma_tsls, nrow = 1))
  model$obj <- gamma_obj
  model$modelsense <- sense
  model$rhs <- c(beta_iv, beta_tsls)
  model$sense <- c("=")
  result <- gurobi(model)

  return(result$objval)
}

# ==========================================================================
# Evaluate bounds and plot
# ==========================================================================
upper_bound <- map_dbl(1:19, solve_bounds, "max")
lower_bound <- map_dbl(1:19, solve_bounds, "min")

ggplot() +
  geom_point(aes(x = 1:19, y =lower_bound), color = "turquoise4") +
  geom_point(aes(x = 1:19,y = upper_bound), color = "turquoise4") +
  geom_line(aes(x = 1:19,y = lower_bound), color = "turquoise4") +
  geom_line(aes(x = 1:19,y = upper_bound), color = "turquoise4") +
  theme_minimal() +
  ylab("upper and lower bounds")



# COMPARE TO FIGURE 4 TO FIGURE OUT WHAT'S WRONG
