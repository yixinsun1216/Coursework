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
N <- 1000
X <- runif(N, -2, 2)
U <- rnorm(N, 0, .3)
Y <- sin(2*X) + 2*exp(-16*X^2) + U

# =============================================================================
# Uniform Kernel
# =============================================================================
library(np)

local_linear_reg <- npregress(X, Y)

ggplot() +
  geom_point(aes(X, Y)) +
  geom_point(aes(X, local_linear_reg$y), color = 'red') +
  theme_minimal()

# =============================================================================
# Sieve - Polynomial
# =============================================================================
sieve_reg1 <- ols(Y ~ X, degree = 3, )
