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
solve_bounds <- function(deg, sense, mono = FALSE){
  gamma_obj <- c(map_dbl(0:deg, gamma_obj_dk, deg, 1),  map_dbl(0:deg, gamma_obj_dk, deg, 0))
  gamma_iv <- c(map_dbl(0:deg, gamma_sdk, deg, 1, s_iv),  map_dbl(0:deg, gamma_sdk, deg, 0, s_iv))
  gamma_tsls <- c(map_dbl(0:deg, gamma_sdk, deg, 1, s_tsls),  map_dbl(0:deg, gamma_sdk, deg, 0, s_tsls))

  # add shape constraints if specified that we want monotone decreasing thetas
  if(mono){
    shape1 <- matrix(0, nrow = deg, ncol = 2*(deg + 1))
    shape0 <- matrix(0, nrow = deg, ncol = 2*(deg + 1))
    for(i in 1:deg){
      shape1[i, i] <- 1
      shape1[i, i+1] <- -1
      shape0[i, i+deg + 1] <- 1
      shape0[i, i+2+deg] <- -1
    }
    constraints <- rbind(matrix(gamma_iv, nrow = 1), matrix(gamma_tsls, nrow = 1), shape1, shape0)
    equalities <- c("=", "=", rep("<", deg*2))
    rhs_vals <- c(beta_iv, beta_tsls, rep(0, deg*2))
  } else{
    constraints <- rbind(matrix(gamma_iv, nrow = 1), matrix(gamma_tsls, nrow = 1))
    equalities <- c("=", "=")
    rhs_vals <- c(beta_iv, beta_tsls)
  }

  # create my model list for make a valid Gurobi object
  model <- list()
  model$A <- constraints
  model$obj <- gamma_obj
  model$modelsense <- sense
  model$rhs <- rhs_vals
  model$sense <- equalities
  model$lb <- 0
  model$ub <- 1
  result <- gurobi(model)

  return(result$objval)
}

# ==========================================================================
# Evaluate bounds and plot
# ==========================================================================
upper_bound <- map_dbl(1:19, solve_bounds, "max")
lower_bound <- map_dbl(1:19, solve_bounds, "min")

upper_bound_mono <- map_dbl(1:19, solve_bounds, "max", TRUE)
lower_bound_mono <- map_dbl(1:19, solve_bounds, "min", TRUE)

# calculating ATT
w0 <- -1/ed*c(1, .75, .5, .25)
w1 <- 1/ed*c(1, .75, .5, .25)
att <- sum(map2_dbl(c(0, pscores[-4]), pscores, m1_int)*w1 + map2_dbl(c(0, pscores[-4]), pscores, m0_int)*w0)

ggplot() +
  geom_point(aes(x = 1:19, y =lower_bound), color = "turquoise4") +
  geom_point(aes(x = 1:19,y = upper_bound), color = "turquoise4") +
  geom_line(aes(x = 1:19,y = lower_bound), color = "turquoise4") +
  geom_line(aes(x = 1:19,y = upper_bound), color = "turquoise4") +
  geom_point(aes(x = 1:19, y =lower_bound_mono), color = "darkorange3") +
  geom_point(aes(x = 1:19,y = upper_bound_mono), color = "darkorange3") +
  geom_line(aes(x = 1:19,y = lower_bound_mono), color = "darkorange3") +
  geom_line(aes(x = 1:19,y = upper_bound_mono), color = "darkorange3") +
  geom_hline(yintercept = att, linetype = "dashed", color = "maroon4") +
  geom_text(aes(17, att, label = "ATT", vjust = -.5), size = 3, color = "maroon4") +
  theme_minimal() +
  ylab("upper and lower bounds") +
  xlab("Polynomial Degree")


