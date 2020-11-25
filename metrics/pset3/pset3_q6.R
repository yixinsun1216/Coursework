# Created by Yixin Sun on 11/20/2020
library(tidyverse)
library(ggplot2)

gdir <-  "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset3"
beta_iv <- -1.101817887
cov_dz <- 0.27125
ez <- 2.5
ed <- .4175


bernstein_integral <- function(i, k, K, u){
  1/(i + 1)*(-1)^(i - k)*choose(K, i)*choose(i, k)*u^(i + 1)
}

bernstein_i <- function(k, K, u_low, u_high){
  int_sum <- 0
  for(i in k:K){
    int_sum <- int_sum + bernstein_integral(i, k, K, u_high) - bernstein_integral(i, k, K, u_low)
  }
  return(int_sum)
}

# function for calculating \gamma_sdk IV slope
gamma_iv_dk <- function(k, K, d){
  if(d == 1){
    output <- bernstein_i(k, K, .12, 1)*(1 - ez)/cov_dz +
      bernstein_i(k, K, .29, 1)*(2 - ez)/cov_dz +
      bernstein_i(k, K, .48, 1)*(3 - ez)/cov_dz +
      bernstein_i(k, K, .78, 1)*(4 - ez)/cov_dz
  }
  if(d == 0){
    output <- bernstein_i(k, K, 0, .12)*(1 - ez)/cov_dz +
      bernstein_i(k, K, 0, .29)*(2 - ez)/cov_dz +
      bernstein_i(k, K, 0, .48)*(3 - ez)/cov_dz +
      bernstein_i(k, K, 0, .78)*(4 - ez)/cov_dz
  }
  return(output)
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
  return(output)
}

deg <- 2
gamma_obj <- c(map_dbl(1:deg, gamma_obj_dk, deg, 1),  map_dbl(1:deg, gamma_obj_dk, deg, 0))
gamma_iv <- c(map_dbl(1:deg, gamma_iv_dk, deg, 1),  map_dbl(1:deg, gamma_iv_dk, deg, 0))

model <- list()
model$A <- matrix(gamma_iv, nrow = 1)
model$obj <- gamma_obj
model$modelsense <- "min"
model$rhs <- -.12
model$sense <- c("=")


result <- gurobi(model)

# function for calculating \gamma_sdk TSLS slope

# COMPARE TO FIGURE 4 TO FIGURE OUT WHAT'S WRONG
