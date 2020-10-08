# Created by Yixin Sun on October 7, 2020

# =============================================================================
# Set up environment
# =============================================================================
library(tidyverse)
library(ggplot2)

root <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset1"

# load helper functions
source(file.path(root, "pset1_utils.R"))

# simulate data
N <- 100
M <- 50

X <- map(1:M, ~ runif(N, -2, 2))
U <- map(1:M, ~ rnorm(N, 0, .3))
Y <- map2(X, U, function(x, u) sin(2*x) + 2*exp(-16*x^2) + u)

df <- tibble(X = reduce(X, c), Y = reduce(Y, c))

# =============================================================================
# Uniform Kernel
# =============================================================================



# =============================================================================
# Sieve - Polynomial
# =============================================================================
sieve_poly <- function(x, y, deg = 3){
  x_poly <- poly(x, degree = deg)
  reg <- ols(x_poly, y)
  y_hat <- cbind(1, x_poly) %*% as.matrix(reg[[1]]$estimate)

  return(tibble(X = x, Y_hat = y_hat, degree = deg))
}

# degree 3 and degree 10 polynomial
sieve_deg3 <- map2_df(X, Y, sieve_poly)
sieve_deg10 <- map2_df(X, Y, sieve_poly, 10)


ggplot(df) +
  geom_point(aes(X, Y)) +
  geom_point(data = sieve_deg3, aes(X, Y_hat), color = 'red') +
  geom_point(data = sieve_deg10, aes(X, Y_hat), color = "blue") +
  theme_minimal()

# what am i suppose to be plotting????


# =============================================================================
# K nearest neighbors
# =============================================================================
knn <- function(x, y, k = 3){
  # calculate distances between all x's
  x_split <- split(x, 1:length(x))
  dists <- map(x_split,
               function(x1) tibble(index = 1:length(x), dist = abs(x - x1)))

  # for each x, find the index of the k closest
  x_closests <- map(dists,
                    function(d) arrange(d, dist) %>%
                      filter(row_number() <= k) %>%
                      pull(index))

  # calculate fitted y by averaging over the y values of the k observations that
  # were closest to each x
  y_hat <- map_dbl(x_closest, function(i) sum(y[i]) / deg)

  return(tibble(X = x, Y_hat = y_hat, K = k))
}


# k = 3 and k = 10
knn_3 <- map2_df(X, Y, knn)
knn_10 <- map2_df(X, Y, knn, 10)


ggplot(df) +
  geom_point(aes(X, Y)) +
  geom_point(data = knn_3, aes(X, Y_hat), color = 'red') +
  geom_point(data = knn_10, aes(X, Y_hat), color = "blue") +
  theme_minimal()

# =============================================================================
# Sieve - Berinstein polynomial
# =============================================================================
sieve_bernstein <- function(x, y, deg = 3){
  z <- (x + 2) / 4

  b_k <- map_dfc(0:deg, function(k) choose(deg, k)*z^k*(1-z)^(deg - k))
  reg <- ols(b_k, y, intercept = FALSE)
  y_hat <- as.matrix(b_k) %*% as.matrix(reg[[1]]$estimate)

  return(tibble(X = x, Y_hat = y_hat, degree = deg))
}

# degree 3 and degree 10 bernstein polynomials
bernstein_deg3 <- map2_df(X, Y, sieve_bernstein)
bernstein_deg10 <- map2_df(X, Y, sieve_bernstein, 10)


ggplot(df) +
  geom_point(aes(X, Y)) +
  geom_point(data = bernstein_deg3, aes(X, Y_hat), color = 'red') +
  geom_point(data = bernstein_deg10, aes(X, Y_hat), color = "blue") +
  theme_minimal()


# transform x into z



