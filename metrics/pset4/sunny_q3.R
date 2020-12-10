# Created by Yixin Sun on december 10, 2020

# =============================================================================
# Set up environment
# =============================================================================
library(tidyverse)
library(ggplot2)
library(gurobi)

gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset4"
ddir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/field_courses/Applied Microeconometrics/Problem Sets/ps4"

df <-
  read_csv(file.path(ddir, "basque.csv")) %>%
  select(regionname, year, gdpcap)

untreated <-
  filter(df, !str_detect(regionname, "Basque")) %>%
  spread(year, gdpcap) %>%
  select(-regionname) %>%
  t()

treated <-
  filter(df, str_detect(regionname, "Basque")) %>%
  spread(year, gdpcap) %>%
  select(-regionname) %>%
  t()

treat_year <- 1970 - min(df$year)

# =============================================================================
# Estimator Functions
# =============================================================================
# matching
nnmatch <- function(m = 4, untreated = untreated, treated = treated, treat_year = treat_year){
  treated_pre <- treated[1:(treat_year - 1)]

  untreated_pre <-
    untreated[1:(treat_year -1),] %>%
    t() %>%
    split(1:nrow(.))

  dist <- map_dbl(untreated_pre, function(x) sum((x - treated_pre)^2))

  weights <- as.numeric(dist <= sort(dist)[m]) / m
  return(weights)
}

# synthetic control -------------------------------
synthetic_control <- function(untreated = untreated, treated = treated, treat_year = treat_year) {
  treated_pre <- as.matrix(treated[1:(treat_year - 1)])
  untreated_pre <- as.matrix(untreated[1:(treat_year -1),])

  objective <- -2 * t(treated_pre) %*% untreated_pre
  constant <- t(treated_pre) %*% treated_pre
  quadratic <- t(untreated_pre) %*% untreated_pre

  model <- list(
    A = matrix(rep(1, ncol(untreated_pre)), nrow = 1),
    sense = "=",
    rhs = 1,
    lb = rep(0, ncol(untreated_pre)),
    ub = rep(1, ncol(untreated_pre)),
    obj = objective,
    objcon = constant,
    modelsense = "min",
    Q = quadratic
  )

  result <- gurobi(model)

  return(as.vector(result$x))
}

# MASC ----------------------------------------- OK REALLY DON"T SEEM TO NEED THIS?
solve_masc <- function(untreated = untreated, treated = treated, treat_year = treat_year, tune) {
    treated_pre <- as.matrix(treated[1:(treat_year - 1)])
    untreated_pre <- as.matrix(untreated[1:(treat_year -1),])

    sc_weights <- synthetic_control(untreated_pre, treated_pre, treat_year)
    match_weights <- nnmatch(tune$m, untreated_pre, treated_pre, treat_year)
    return(list(sc_weights, match_weights))
}
