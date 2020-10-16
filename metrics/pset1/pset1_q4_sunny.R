# Created by Yixin Sun on October 7, 2020

# =============================================================================
# Set up environment
# =============================================================================
library(tidyverse)
library(ggplot2)
library(ggthemes)
library(gridExtra)
library(Hmisc)

root <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset1"

# load helper functions
source(file.path(root, "pset1_utils.R"))

# simulate data
N <- 250
M <- 50

X <- map(1:M ,~ seq(-2, 2, length.out = N))
U <- map(1:M, ~ rnorm(N, 0, .3))
Y <- map2(X, U, function(x, u) sin(2*x) + 2*exp(-16*x^2) + u)

df <-
  tibble(X = reduce(X, c), Y = reduce(Y, c)) %>%
  group_by(X) %>%
  summarise(Y_mean = mu(Y))

# =============================================================================
# Helper functions
# =============================================================================
# for each method, run the method for each X-Y simulation, and output the
# mean and standard deviation of the M simulations
aggregate_M <- function(x, y, func, d){
  map2_df(x, y, func, d) %>%
    group_by(X) %>%
    summarise(Y_mean = mu(Y_hat),
              Y_min = mu(Y_hat) - stdev(Y_hat),
              Y_max = mu(Y_hat) + stdev(Y_hat))
}

# Plot the mean and sd for the method
MC_plot <- function(d, title, legend = FALSE){
  gg <-
    ggplot(d) +
    geom_line(data = df, aes(X, Y_mean, color = "Y")) +
    geom_line(aes(X, Y_mean, color = "E[Y|X]")) +
    geom_ribbon(aes(x = X, ymin = Y_min, ymax = Y_max), fill = "#5ab4ac",
                alpha = .3) +
    theme_minimal() +
    ggtitle(title) +
    ylab("Y") +
    scale_color_manual(values = c("#01665e", "#8c510a"), name = "")

  if(!legend) gg <- gg + theme(legend.position = "none")

  return(gg)
}

# =============================================================================
# Uniform Kernel
# =============================================================================
local_constant <- function(x, y, h = .1){
  # sort the x's
  x_df <-
    tibble(X = x, Y = y) %>%
    arrange(X)

  x_split <- split(x_df$X, 1:length(x))

  # for each x, pick out the ones that fall into the given bandwidth
  x_closest <- map(x_split, function(x1){
    x_min <- x1 - h
    x_max <- x1 + h
    y_closest <- filter(x_df, X >= x_min & X <= x_max)
    return(list(y = y_closest$Y, n = nrow(y_closest)))
  })

  # calculate fitted y by averaging over the y values of the observations that
  # were within the bandwidth
  y_hat <- map_dbl(x_closest, function(x1) sum(pluck(x1, 1)) / pluck(x1, 2))

  return(tibble(X = x, Y_hat = y_hat, H = h))
}

# bandwidth .05 and .3
unif_h1 <- aggregate_M(X, Y, local_constant, .05)
unif_h2 <- aggregate_M(X, Y, local_constant, .3)

unif_h1_plot <- MC_plot(unif_h1, "Local Constant Regression: h = .05")
unif_h2_plot <- MC_plot(unif_h2, "Local Constant Regression: h = .3")


# =============================================================================
# Local Linear Regression
# =============================================================================
local_linear <- function(x, y, h = .1){
  # sort the x's
  x_df <-
    tibble(X = x, Y = y) %>%
    arrange(X)

  x_split <- split(x_df$X, 1:length(x))

  # for each x, pick out the ones that fall into the given bandwidth
  x_closest <- map(x_split, function(x1){
    x_min <- x1 - h
    x_max <- x1 + h
    y_closest <- filter(x_df, X >= x_min & X <= x_max)
    return(list(y = as.matrix(y_closest$Y),
                x = as.matrix(y_closest$X),
                n = nrow(y_closest)))
  })

  # calculate fitted y by running regressions on values that fall within the
  # bandwidth
  y_hat <- map_dbl(x_closest, function(df){
    reg <- ols(pluck(df, 2), pluck(df, 1))
    y_fit <- cbind(1, pluck(df, 2)) %*% as.matrix(reg[[1]]$estimate)
    y_mean <- sum(y_fit) / pluck(df, 3)
  })

  return(tibble(X = x, Y_hat = y_hat, H = h))
}


# bandwidth .05 and .3
ll_h1 <- aggregate_M(X, Y, local_linear, .05)
ll_h2 <- aggregate_M(X, Y, local_linear, .3)

ll_h1_plot <- MC_plot(ll_h1, "Local Linear Regression: h = .05")
ll_h2_plot <- MC_plot(ll_h2, "Local Linear Regression: h = .3")


# =============================================================================
# Sieve - Polynomial
# =============================================================================
sieve_poly <- function(x, y, deg = 3){
  # expand out polynomials
  x_poly <- poly(x, degree = deg)

  # run ols over these expanded out polynomials
  reg <- ols(x_poly, y)
  y_hat <- cbind(1, x_poly) %*% as.matrix(reg[[1]]$estimate)

  return(tibble(X = x, Y_hat = y_hat, degree = deg))
}

# degree 3 and degree 10 polynomial
sieve_deg3 <- aggregate_M(X, Y, sieve_poly, 5)
sieve_deg25 <- aggregate_M(X, Y, sieve_poly, 25)

sieve_deg3_plot <- MC_plot(sieve_deg3, "Sieve Polynomial: degree 3")
sieve_deg25_plot <- MC_plot(sieve_deg25, "Sieve Polynomial: degree 25")


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

knn_3_plot <- MC_plot(knn_3, "KNN: k = 3")
knn_30_plot <- MC_plot(knn_30, "KNN: k = 30")


# =============================================================================
# Sieve - Berinstein polynomial
# =============================================================================
sieve_bernstein <- function(x, y, deg = 3){
  # normalize to z
  z <- (x + 2) / 4

  # plug z's into bernstein polynomial equation
  b_k <- map_dfc(0:deg, function(k) choose(deg, k)*z^k*(1-z)^(deg - k))

  # run OLS on outputted polynomial values
  reg <- ols(b_k, y, intercept = FALSE)
  y_hat <- as.matrix(b_k) %*% as.matrix(reg[[1]]$estimate)

  return(tibble(X = x, Y_hat = y_hat, degree = deg))
}

# degree 3 and degree 25 bernstein polynomials
bernstein_deg3 <- aggregate_M(X, Y, sieve_bernstein, 3)
bernstein_deg25 <- aggregate_M(X, Y, sieve_bernstein, 25)

bernstein_deg3_plot <- MC_plot(bernstein_deg3, "Sieve Bernstein: degree = 3")
bernstein_deg25_plot <- MC_plot(bernstein_deg25, "Sieve Bernstein: degree = 25")



# =============================================================================
# Sieve - splines
# =============================================================================
sieve_spline <- function(x, y, k = 5){
  r_k <- cut2(x, g = k + 1, onlycuts= TRUE)
  r_k <- r_k[-1]
  r_k <- r_k[-length(r_k)]

  data <-
    tibble(x = x, y = y, index = 1:length(x)) %>%
    arrange(x)

  # create columns for x - r_k values ------------------------
  for(i in 1:k){
    bool_name <- rlang::sym(paste0("is_rk", i))
    var_name <- rlang::sym(paste0("rk", i))

    data <-
      data %>%
      mutate(!!bool_name := x >= r_k[i]) %>%
      mutate(!!var_name := !!bool_name * (x - r_k[i])) %>%
      select(-!!bool_name)
  }

  basis <-
    select(data, x, paste0("rk", 1:k)) %>%
    as.matrix

  y <- as.matrix(data$y)

  reg <- ols(basis, y)
  y_fit <- cbind(1, basis) %*% as.matrix(reg[[1]]$estimate)

  return(tibble(X = x, Y_hat = y_fit, k = k))
}

# k = 3 and degree 10 spline
spline_k30 <- aggregate_M(X, Y, sieve_spline, 30)
spline_k3 <- aggregate_M(X, Y, sieve_spline, 3)

spline_k30_plot <- MC_plot(spline_k30, "Sieve Spline: k = 30")
spline_k3_plot <- MC_plot(spline_k3, "Sieve Spline: k = 3")

# =============================================================================
# Output graphs
# =============================================================================
# with 6 * 2 = 12 total graphs, plot 2 panels of graphs, each with 3 methods
output1 <- grid.arrange(unif_h1_plot, unif_h2_plot, ll_h1_plot, ll_h2_plot,
                        sieve_deg25_plot, sieve_deg3_plot, ncol = 2)
ggsave(output1, width = 9, height = 11, file = file.path(root, "sunny_monte_carlos1.png"))

output2 <- grid.arrange(knn_3_plot, knn_30_plot, bernstein_deg25_plot,
                        bernstein_deg3_plot, spline_k30_plot, spline_k3_plot,
                        ncol = 2)
ggsave(output2, width = 9, height = 11, file = file.path(root, "sunny_monte_carlos2.png"))


