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
  treated_pre <- matrix(treated[1:(treat_year - 1)], ncol = ncol(treated))
  untreated_pre <- matrix(untreated[1:(treat_year -1),], ncol = ncol(untreated))

  sc_weights <- synthetic_control(untreated_pre, treated_pre, treat_year)
  match_weights <- nnmatch(m, untreated_pre, treated_pre, treat_year)
  return(list(sc_weights, match_weights))
}

# =============================================================================
# MASC Cross validation
# =============================================================================
# for this set up, we have F = 7 folds
# t_floor = 1955, t_ceiling = 1962...1968
# m \in {1, 2, ... , 10}
# equally weight all folds
# so the parameters we need to choose are phi and m
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

# this function finds the optimal phi for a given m.
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

    return(tibble(cv_error = error, phi = phi, m = m))
  }

# =============================================================================
# Penalized Synthetic Control
# =============================================================================
penalized_sc_obj <- function(untreated, treated, pi){
  # first component
  sc <- (-2) * as.matrix((t(treated))) %*% as.matrix(untreated)

  # second component - essentially nearest neighbor with m = 1
  diff <- (untreated - as.vector(treated))^2
  nn <- colSums(data.frame(diff))
  return((1-pi)*sc + pi*nn)
}

penalized_sc <- function(untreated, treated, treat_year = 16, pi){
  # Computes the weights for the SC pen using beautiful gurobi
  treated_pre <- treated[1:(treat_year - 1)]
  untreated_pre <- untreated[1:(treat_year -1),]

  objective <- penalized_sc_obj(untreated_pre, treated_pre, pi)
  constant <- (1-pi)*t(treated_pre) %*% treated_pre
  quadratic <- (1-pi)*as.matrix((t(untreated_pre))) %*% as.matrix(untreated_pre)

  model <- list(
    A = matrix(1, 1, ncol(untreated_pre)),
    sense = "=",
    rhs = 1,
    lb = rep(0, ncol(untreated_pre)),
    ub = rep(1, ncol(untreated_pre)),
    obj = objective,
    objcon = constant,
    Q = quadratic
  )

  result <- gurobi(model)
  return(result$x)
}

cv_pi  <- function(pi, untreated, treated, folds = 8:14, m = 3) {

  find_psc <- function(treat, m, untreated, treated){
    psc_weights <- penalized_sc(untreated, treated, treat, pi)
    Y_psc <- untreated[treat,]%*% psc_weights
    Y_treated <- treated[treat]
    return(data.frame(Y_psc = Y_psc, Y_treated = Y_treated))
  }

  Y_all <- map_df(folds + 1, find_psc, m, untreated, treated)

  # analytic expression for phi
  Y_treated <- matrix(Y_all$Y_treated)
  Y_psc <- matrix(Y_all$Y_psc)
  error <- sum((Y_treated - Y_psc)^2)
  return(tibble(cv_error = error, pi = pi))
}


# =============================================================================
# Final function that graphs Figures 10 and 11
# =============================================================================
masc <- function(m_tune, untreated = df_untreated, treated = df_treated, treat_year = treatment){
  # find optimal phi and optimal m to compute gamma_match, gamma_sc, and gamma_masc
  output <- map_df(m_tune, cv_phi, untreated, treated, treat_year)
  output_opt <- output[which.min(output$cv_error),]

  weights_all <- solve_masc(untreated, treated, treat_year, output_opt$m)
  sc_weights <- weights_all[[1]]
  match_weights <- weights_all[[2]]

  masc_weights <- output_opt$phi * match_weights + (1-output_opt$phi) * sc_weights

  Y_match<- untreated %*% matrix(match_weights)
  Y_sc <- untreated %*% sc_weights
  Y_masc <- untreated %*% masc_weights

  # find optimal pi and compute gamma_{penalized sc} ----------------
  pi_outcomes <- map_df(seq(0, 1, .01), cv_pi, untreated, treated, m = output_opt$m)
  pi_opt <- pi_outcomes[which.min(pi_outcomes$cv_error),]

  psc_weights <- penalized_sc(untreated, treated, treat_year, 0.0101)
  Y_psc <- untreated %*% psc_weights

  # Figure 10 -------------------------------------------------------
  # Difference in outcomes each year
  Y_diff <- 1000*(treated - Y_masc)

  # Mean cost of terrorism implied by MASC
  mean_loss <- mean(Y_diff[-c(1:(treat_year - 1))])

  years <- as.numeric(rownames(untreated)) + 1954
  ggplot() +
    geom_line(aes(x = years, y = Y_diff)) +
    theme_minimal() +
    xlab("Year") +
    ylab("Per Capita GDP (USD 1986)") +
    geom_vline(xintercept = 1969.5, color = "blue") +
    geom_text(aes(x=1969, label="Treatment", y=-750), colour="blue", angle=90, size = 4) +
    geom_hline(yintercept = mean_loss, color = "red") +
    geom_text(aes(x = 1989, y = -945, label = "Avg Yearly Per Capita Loss"), color = "red", size= 4)
  ggsave(file.path(gdir, "sunny_figure10.png"), width = 8, height = 6)

  # Figure 11 ----------------------------
  Y_match_diff <- (treated - Y_match)*1000
  Y_sc_diff <- (treated- Y_sc)*1000
  Y_psc_diff <- ( treated - Y_psc )*1000

  tograph <-
    tibble(gdp = c(Y_match_diff - Y_diff, Y_sc_diff = Y_sc_diff - Y_diff, Y_psc_diff - Y_diff),
           year = rep(years, 3),
           type = c(rep("Matching", length(Y_match_diff)),
                    rep("Synthetic Control", length(Y_sc_diff)),
                    rep("Penalized Synthetic Control", length(Y_psc_diff))))
  ggplot(tograph, aes(x = year, y = gdp, group = type, color = type)) +
    geom_line() +
    theme_minimal()+
    xlim(c(1970, 1994)) +
    ylab("Difference in Effect (GDP Per Capita)") +
    xlab("Year") +
    scale_color_manual(name = "", values = c("#1b9e77", "#d95f02", "#7570b3")) +
    theme(legend.position = "bottom")
  ggsave(file.path(gdir, "sunny_figure11.png"), width = 8, height = 6)
}

masc(1:10)
