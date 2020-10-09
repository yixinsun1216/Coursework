# Created by Yixin Sun on October 7, 2020

# =============================================================================
# Set up environment
# =============================================================================
library(tidyverse)
library(ggplot2)
library(ggthemes)

root <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset1"

# load helper functions
source(file.path(root, "pset1_utils.R"))

# simulate data
N <- 100
M <- 50

X <- map(1:M ,~ seq(-2, 2, length.out = N))
U <- map(1:M, ~ rnorm(N, 0, .3))
Y <- map2(X, U, function(x, u) sin(2*x) + 2*exp(-16*x^2) + u)

df <-
  tibble(X = reduce(X, c), Y = reduce(Y, c)) %>%
  group_by(X) %>%
  summarise(Y_mean = mu(Y))

aggregate_M <- function(x, y, func, d){
  map2_df(x, y, func, d) %>%
    group_by(X) %>%
    summarise(Y_mean = mu(Y_hat),
              Y_min = mu(Y_hat) - stdev(Y_hat),
              Y_max = mu(Y_hat) + stdev(Y_hat))
}

MC_plot <- function(d, title){
  ggplot(d) +
    geom_line(data = df, aes(X, Y_mean, color = "Y")) +
    geom_line(aes(X, Y_mean, color = "E[Y|X]")) +
    geom_ribbon(aes(x = X, ymin = Y_min, ymax = Y_max), fill = "#5ab4ac",
                alpha = .3) +
    theme_minimal() +
    ggtitle(title) +
    ylab("Y") +
    scale_color_manual(values = c("#01665e", "#8c510a"), name = "")
}

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
sieve_deg3 <- aggregate_M(X, Y, sieve_poly, 5)
sieve_deg25 <- aggregate_M(X, Y, sieve_poly, 25)

MC_plot(sieve_deg3, "Sieve Polynomial: degree 3")
MC_plot(sieve_deg25, "Sieve Polynomial: degree 25")


# =============================================================================
# K nearest neighbors
# =============================================================================
knn <- function(x, y, k = 3){
  # calculate distances between all x's
  x_split <- split(x, 1:length(x))
  dists <- map(x_split,
               function(x1) tibble(index = 1:length(x), dist = abs(x - x1)))

  # for each x, find the index of the k closest
  x_closest <- map(dists,
                   function(d) arrange(d, dist) %>%
                     filter(row_number() <= k) %>%
                     pull(index))

  # calculate fitted y by averaging over the y values of the k observations that
  # were closest to each x
  y_hat <- map_dbl(x_closest, function(i) sum(y[i]) / k)

  return(tibble(X = x, Y_hat = y_hat, K = k))
}


# k = 3 and k = 10
knn_3 <- aggregate_M(X, Y, knn, 5)
knn_30 <- aggregate_M(X, Y, knn, 30)

MC_plot(knn_3, "KNN: k = 3")
MC_plot(knn_20, "KNN: k = 30")




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

# degree 3 and degree 25 bernstein polynomials
ggplot(df) +
  geom_point(aes(X, Y)) +
  geom_point(data = bernstein_deg3, aes(X, Y_hat), color = 'red') +
  geom_point(data = bernstein_deg10, aes(X, Y_hat), color = "blue") +
  theme_minimal()


# k = 3 and k = 10
bernstein_deg3 <- aggregate_M(X, Y, sieve_bernstein, 5)
bernstein_deg25 <- aggregate_M(X, Y, sieve_bernstein, 25)

MC_plot(bernstein_deg3, "Sieve Bernstein: degree = 3")
MC_plot(bernstein_deg25, "Sieve Bernstein: degree = 25")






