# Created by Yixin Sun on October 29, 2020
library(tidyverse)
library(MASS)
gdir <- root <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset2"

# =============================================================================
# Helper functions and estimator functions
# =============================================================================
mu <- function(x){
  sum(x, na.rm = TRUE)/length(x)
}

stdev <- function(x){
  sqrt(sum((x-mu(x))^2/(length(x)-1)))
}

summary_output <- function(out, name){
  med <- median(out$estimate)
  bias <- mu(out$bias)
  st_dev <- stdev(out$estimate)
  coverage <- sum(out$in95)/nrow(out)
  return(tibble(name = name, med = med, bias = bias, st_dev = st_dev,
                coverage = coverage))
}

ols <- function(x, y){
  x <- as.matrix(x)
  y <- as.matrix(y)

  x <- cbind(1, x)

  beta <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% y))

  e <- y - x %*% beta
  se <- sqrt(diag(as.numeric(t(e) %*% e)*solve(t(x) %*% x))/(nrow(x) - ncol(x)))
  ci <- c(beta[2] - 1.96*se[2], beta[2] + 1.96*se[2])

  return(tibble(estimate = beta[2], bias = beta[2] - 1,
                in95 = 1 >= ci[1] & 1 <= ci[2]))
}

tsls <- function(z, x, y){
  z <- cbind(1, z)
  x <- cbind(1, x)
  pi <- as.matrix(solve(t(z) %*% z) %*% (t(z) %*% x))
  beta <- solve(t(pi) %*% t(z) %*% x) %*% (t(pi) %*% t(z) %*% y)

  # calculate 95% coverage
  e <- y - x %*% beta
  P <- z %*%solve(t(z) %*% z)%*% t(z)
  var <- as.numeric(t(e) %*% e)*solve(t(x) %*% P %*% x, tol = 1e-20)
  se <- sqrt(diag(var/(nrow(x) - ncol(x))))
  ci <- c(beta[2] - 1.96*se[2], beta[2] + 1.96*se[2])
  return(tibble(estimate = beta[2], bias = beta[2] - 1,
         in95 = 1 >= ci[1] & 1 <= ci[2]))
}

# Jackknife
jackknife <- function(z, x, y){
  z <- as.matrix(z)
  zz <- solve(t(z) %*% z)
  z_i <- split(z, 1:nrow(z))
  h <- map(z_i, function(zi) as.matrix(t(zi) %*% zz %*% zi))

  # compute jackknife predicted values X_i
  x_i <- split(x, 1:length(x))
  pi_hat <- as.matrix(solve(t(z) %*% z) %*% (t(z) %*% x))
  x_dot <-
    list(h, x_i, z_i) %>%
    pmap_dbl(function(h1, x1, z1)  (z1%*%pi_hat - h1 %*% x1) / (1 - h1))

  x_dot <- cbind(1, x_dot)
  x <- cbind(1, x)
  beta <- solve(t(x_dot) %*% x) %*% (t(x_dot)%*%y)

  # calculate 95% coverage
  e <- y - x %*% beta
  P <- z %*%solve(t(z) %*% z)%*% t(z)
  var <- as.numeric(t(e) %*% e)*solve(t(x) %*% P %*% x, tol = 1e-20)
  se <- sqrt(diag(var/(nrow(x) - ncol(x))))
  ci <- c(beta[2] - 1.96*se[2], beta[2] + 1.96*se[2])
  return(tibble(estimate = beta[2], bias = beta[2] - 1,
                in95 = 1 >= ci[1] & 1 <= ci[2]))
}



# =============================================================================
# Main function - outputs the various methods for different sample sizes
# =============================================================================
estimators <- function(N, M = 100){
  # Generate bivariate normal errors
  UV <- map(1:M, ~ mvrnorm(N, c(0, 0), matrix(c(.25, .2, .2, .25), ncol = 2)))
  U <- map(UV, ~ .x[,1])
  V <- map(UV, ~ .x[,2])

  # generate Z1-Z20
  Z <- map(1:M, function(x) matrix(, nrow = N, ncol = 0))
  for(i in 1:20){
    z_i <- map(1:M, ~rnorm(N, 0, 1))
    Z <- map2(Z, z_i, cbind)
  }
  Z1 <- map(Z, ~.x[,1])

  # generate X and Y
  X <- map2(Z1, V, function(z, v) .3*z + v)
  Y <- map2(X, U, function(x, u) x + u)

  # run ols
  ols_outcomes <-
    map2_df(X, Y, function(x, y) ols(x, y)) %>%
    summary_output("OLS")

  # tsls - one instrument
  tsls_outcomes <-
    pmap_df(list(Z1, X, Y), function(z, x, y) tsls(z, x, y)) %>%
    summary_output("TSLS - 1 Instrument")

  # tsls - many instruments
  tsls_many_outcomes <-
    pmap_df(list(Z, X, Y), function(z, x, y) tsls(z, x, y)) %>%
    summary_output("TSLS - Many Instruments")

  # jackknife - 1 instrument
  jackknife_one <-
    pmap_df(list(Z1, X, Y), function(z, x, y) jackknife(z, x, y)) %>%
    summary_output("Jackknife - 1 Instrument")

  # jackknife - multiple instruments
  jackknife_many <-
    pmap_df(list(Z, X, Y), function(z, x, y) jackknife(z, x, y)) %>%
    summary_output("Jackknife - Many Instruments")

  return(bind_rows(ols_outcomes, tsls_outcomes, tsls_many_outcomes,
                   jackknife_one, jackknife_many))
}

# run main function over N = 100, 200, 400, 800
output <- map(c(100, 200, 400, 800), estimators)

# =============================================================================
# Output Results to Table
# =============================================================================
format_output <- function(out){
  dplyr::select(out, -name) %>%
    t() %>%
    as_tibble() %>%
    setNames(c("N = 100", "N = 200", "N = 400", "N = 800"))
}

ols_output <-
  output %>%
  map_df(~.x[1,]) %>%
  format_output()

tsls_output <-
  output %>%
  map_df(~.x[2,]) %>%
  format_output()

tsls_many_output <-
  output %>%
  map_df(~.x[3,]) %>%
  format_output()

jackknife_one <-
  output %>%
  map_df(~.x[4,]) %>%
  format_output()

jackknife_many <-
  output %>%
  map_df(~.x[5,]) %>%
  format_output()

outtable <-
  bind_rows(ols_output, tsls_output, tsls_many_output,
            jackknife_one, jackknife_many) %>%
  bind_cols(Value = rep(c("Median", "Bias", "SD"), 5), .)


kable(outtable, format = "latex", booktabs = TRUE, linesep = "", digits = 3) %>%
  kableExtra::group_rows("OLS", 1, 3)  %>%
  kableExtra::group_rows("TSLS - 1 Instrument", 4, 6) %>%
  kableExtra::group_rows("TSLS - Many Instruments", 7, 9) %>%
  kableExtra::group_rows("Jackknife - 1 Instrument", 10, 12) %>%
  kableExtra::group_rows("Jackknife - Many Instruments", 13, 15) %>%
  write(file.path(gdir, "sunny_q6.tex"))
