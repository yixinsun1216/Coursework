# Created by Yixin Sun on december 10, 2020

# I am thankful to Jeanne Sorin for helpful tips with coding
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
  dplyr::filter(regionno != 1)

df_untreated <-
  df[df$regionno!=17 & df$year,c(1,3,4)] %>%
  as.data.frame() %>%
  reshape(idvar = "year", timevar="regionno", direction="wide") %>%
  dplyr::select(-year) %>%
  as.matrix()

df_treated <-
  df[df$regionno==17 & df$year, c(1,3,4)] %>%
  as.data.frame() %>%
  reshape(idvar = "year", timevar="regionno", direction="wide") %>%
  dplyr::select(-year) %>%
  as.matrix()

treatment <- 16

# =============================================================================
# Estimator Functions
# =============================================================================
# matching
nnmatch <- function(m = 4, untreated, treated, treat_year){
  #browser()
  treated_pre <- treated[1:(treat_year - 1)]
  untreated_pre <- untreated[1:(treat_year -1),]

  diff <- (untreated_pre - as.vector(treated_pre))^2
  dist <- colSums(matrix(diff, nrow = treat_year - 1))

  weights <- as.numeric(dist <= sort(dist)[m]) / m
  return(weights)
}


# synthetic control -------------------------------
# synthetic_control <- function(untreated, treated, treat_year) {
#   treated_pre <- matrix(treated[1:(treat_year - 1)])
#   untreated_pre <- matrix(untreated[1:(treat_year -1),], nrow = treat_year - 1)
#
#   objective <- -2 * t(treated_pre) %*% untreated_pre
#   constant <- t(treated_pre) %*% treated_pre
#   quadratic <- t(untreated_pre) %*% untreated_pre
#
#   model <- list(
#     A = matrix(rep(1, ncol(untreated_pre)), nrow = 1),
#     sense = "=",
#     rhs = 1,
#     lb = rep(0, ncol(untreated_pre)),
#     ub = rep(1, ncol(untreated_pre)),
#     obj = objective,
#     objcon = constant,
#     modelsense = "min",
#     Q = quadratic
#   )
#
#   result <- gurobi(model)
#
#   return(as.vector(result$x))
# }


synthetic_control <- function(untreated, treated, treat_year) {
  objective <- -2 * as.matrix((t(treated))) %*% as.matrix(untreated)
  constant <- t(treated) %*% treated
  quadratic <- as.matrix((t(untreated))) %*% as.matrix(untreated)

  model <- list(
    A = matrix(1, 1, ncol(untreated)),
    sense = "=",
    rhs = 1,
    lb = rep(0, ncol(untreated)),
    ub = rep(1, ncol(untreated)),
    obj = objective,
    objcon = constant,
    Q = quadratic
  )

  result <- gurobi(model)
  return(result$x)
}

solve_masc <- function(untreated, treated, treat_year, m = 3) {
  #browser()
  treated_pre <- matrix(treated[1:(treat_year - 1)], ncol = ncol(treated))
  untreated_pre <- matrix(untreated[1:(treat_year -1),], ncol = ncol(untreated))

  sc_weights <- synthetic_control(untreated_pre, treated_pre, treat_year)
  match_weights <- nnmatch(m, untreated_pre, treated_pre, treat_year)
  return(list(sc_weights, match_weights))
}

# Cross validation------------------------------
# for this set up, we have F = 7 folds
# t_floor = 1955, t_ceiling = 1962...1968
# m \in {1, 2, ... , 10}
# equally weight all folds
# so the parameters we need to choose are phi and m
# this function finds the optimal phi for a given m. Later, we loop through all m's, and us cv to find optimal m
find_Y <- function(treat, m, untreated, treated){
  #browser()
  weights_all <- solve_masc(untreated, treated, treat, m)
  sc_weights <- weights_all[[1]]
  match_weights <- weights_all[[2]]
  Y_sc<-  untreated[treat,] %*% sc_weights
  Y_match<- untreated[treat,] %*% match_weights

  Y_treated <- treated[treat]
  return(data.frame(Y_sc = Y_sc, Y_match = Y_match, Y_treated = Y_treated))
}


cv_phi <- function(m = 3, untreated, treated, treat_year, folds = 8:14) {

    Y_all <- map_df(folds + 1, find_Y, m, untreated, treated)

    # analytic expression for phi
    Y_treated <- matrix(Y_all$Y_treated)
    Y_sc <- matrix(Y_all$Y_sc)
    Y_match <- matrix(Y_all$Y_match)
    phi<-t(Y_treated-Y_sc)%*%(Y_match-Y_sc)/((t(Y_match-Y_sc))%*%(Y_match-Y_sc))
    phi<-max(0,phi)
    phi<-as.numeric(min(1,phi))

    error <- sum((Y_treated-phi*Y_match-(1-phi)*Y_sc)^2)
    sum(objweight*(Ytreated - (phi*Ynn + (1-phi)*Ysc))^2)

    return(tibble(cv_error = error, phi = phi, m = m))
  }

masc <- function(m_tune, untreated = df_untreated, treated = df_treated, treat_year = treatment){
  output <- map_df(m_tune, cv_phi, untreated, treated, treat_year)
  output_opt <- output[which.min(output$cv_error),]

  weights_all <- solve_masc(untreated, treated, treat_year, m)
  sc_weights <- weights_all[[1]]
  match_weights <- weights_all[[2]]

  masc_weights <- output_opt$phi * match_weights + (1-output_opt$phi) * sc_weights

  Y_match<- untreated %*% matrix(match_weights)
  Y_sc <- untreated %*% sc_weights
  Y_masc <- untreated %*% masc_weights

  # actual outcome
  #Y_treated <- treated[treat_year]
  Y_diff <- 1000*(df_treated - Y_masc)

  years <- as.numeric(rownames(untreated))
  out <-
    ggplot() +
    geom_line(aes(x = years, y = Y_diff)) +
    theme_minimal() +
    xlab("Year") +
    ylab("Per Capita GDP (USD 1986)")
  out
  ggsave(file.path(gdir, "sunny_figure10.png"), out)
}
# penalized synthetic control has penalty parameter, pi
