# Created by Yixin Sun on 11/20/2020
library(tidyverse)
library(ggplot2)
library(gurobi)

gdir <-  "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset3"
cov_dz <- 0.27125
ez <- 2.5
ed <- .4175
pscores <- c(.12, .29, .48, .78)

# ==========================================================================
# Calculate beta_s
# ==========================================================================
s_tsls <- function(z){
  pi <- t(matrix(c(1, 1, 1, 1, 0.12, 0.29, 0.48, 0.78), ncol = 2))
  A <- solve(pi %*% matrix(c(.25, .25, .25, .25, pscores/4), ncol = 2))
  weight <- A %*% (pi%*% diag(c(1, 1, 1, 1)))
  weight[2, z]
}

s_iv <- function(z){
  (z - ez)/cov_dz
}

m0_int <- function(p_low, p_high){
  integrate(function(u) .9 - 1.1*u + .3*u^2, p_low, p_high)$value
}

m1_int <- function(p_low, p_high){
  integrate(function(u) .35 - .3*u - .05*u^2, p_low, p_high)$value
}

beta_s <- function(s_fun){
    output <- m1_int(0, .12)*s_fun(1) + m1_int(0, .29)*s_fun(2) +
      m1_int(0, .48)*s_fun(3) + m1_int(0, .78)*s_fun(4) +
      m0_int(.12, 1)*s_fun(1) + m0_int(.29, 1)*s_fun(2)+
      m0_int(.48, 1)* s_fun(3) + m0_int(.78, 1)*s_fun(4)
    return(output/4)
}


beta_s <- function(s_fun){
  s <- map_dbl(1:4, s_fun)
  w1 <- rev(cumsum(rev(s)) / 4)
  w0 <- cumsum(s) / 4

  m1 <- map2_dbl(c(0, pscores[-4]), pscores, m1_int)*w1
  m0 <- map2_dbl(pscores, c(pscores[-1], 1), m0_int)*w0
  sum(m1, m0)
}

beta_iv <- beta_s(s_iv)
beta_tsls <- beta_s(s_tsls)

# ==========================================================================
# Helper functions
# ==========================================================================
# bernstein integral without simplification from mogstad et al supplement
bernstein_integral <- function(u_low, u_high, k, K){
  bfun <- function(u) choose(K, k)*u^k*(1-u)^(K - k)
  integrate(bfun, lower = u_low, upper = u_high)$value
}

# function for integral of bernstein polynomial for ith value
bernstein_i <- function(i, k, K, u_low, u_high){
  bfun <- function(u) (-1)^(i - k)*choose(K, i)*choose(i, k)*u^i
  integrate(bfun, lower = u_low, upp = u_high)$value
}

# evaluate sum of the tractable version of bernstein polynomial
bernstein_mono <- function(u_low, u_high, k, K){
  int_sum <- 0
  for(i in k:K){
    int_sum <- int_sum + bernstein_i(i, k, K, u_low, u_high)
  }
  return(int_sum)
}

# gamma_sdk <- function(k, K, d, s_fun){
#   if(d == 0){
#     output <- bernstein_integral(k, K, .12, 1)*s_fun(1)+
#       bernstein_integral(k, K, .29, 1)*s_fun(2) +
#       bernstein_integral(k, K, .48, 1)*s_fun(3) +
#       bernstein_integral(k, K, .78, 1)*s_fun(4)
#   }
#   if(d == 1){
#     output <- bernstein_integral(k, K, 0, .12)*s_fun(1)+
#       bernstein_integral(k, K, 0, .29)*s_fun(2) +
#       bernstein_integral(k, K, 0, .48)*s_fun(3) +
#       bernstein_integral(k, K, 0, .78)*s_fun(4)
#   }
#   return(output/4)
# }
#
#
# # function for calculating \gamma_dk for objective function
# gamma_obj_dk <- function(k, K, d){
#   if(d == 0){
#     output <- (bernstein_integral(k, K, .12, 1) +
#       bernstein_integral(k, K, .29, 1) +
#       bernstein_integral(k, K, .48, 1) +
#       bernstein_integral(k, K, .78, 1))/ed
#   }
#   if(d == 1){
#     output <- (bernstein_integral(k, K, 0, .12) +
#       bernstein_integral(k, K, 0, .29)+
#       bernstein_integral(k, K, 0, .48) +
#       bernstein_integral(k, K, 0, .78))/-ed
#   }
#   return(output/4)
# }

gamma_sdk <- function(k, K, d, s_fun){
  s <- map_dbl(1:4, s_fun)
  if(d == 0){
    w <- cumsum(s) / 4
    output <- map2_dbl(pscores, c(pscores[-1], 1), bernstein_integral, k, K)*w
  }
  if(d == 1){
    w <- rev(cumsum(rev(s)) / 4)
    output <- map2_dbl(c(0, pscores[-4]), pscores, bernstein_integral, k, K)*w
  }
  return(sum(output))
}

gamma_obj_dk <- function(k, K, d){
  if(d == 0){
    w <- -1/ed*c(1, .75, .5, .25)
  }
  if(d == 1){
    w <- 1/ed*c(1, .75, .5, .25)
  }
  output <- map2_dbl(c(0, pscores[-4]), pscores, bernstein_integral, k, K)*w
  return(sum(output))
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
  model$sense <- c("=", "=")
  #model$lb <- rep(0, length(gamma_obj))
  #model$ub <- rep(1, length(gamma_obj))
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
