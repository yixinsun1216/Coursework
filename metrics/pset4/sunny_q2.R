# Created by Yixin Sun on December 8th, 2020

library(tidyverse)
library(tictoc)
library(knitr)
library(kableExtra)
library(furrr)
gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset4"

# =============================================================================
# Set up functions for simulating and plotting the monte carlos
# =============================================================================
options(warn = -1)
M <- 100
t <- 5

ols <- function(x, y, err = "homo", cl = NULL){
  colnames <- c("Constant", colnames(x))

  x <- as.matrix(x)
  x <- cbind(1, x)
  y <- as.matrix(y)

  beta <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% y))

  # find standard errors
  if(err == "homo"){
    e <- y - x %*% beta
    se <- sqrt(diag(as.numeric(t(e) %*% e)*solve(t(x) %*% x))/(nrow(x) - ncol(x)))
  }
  if(err == "robust"){
    e <- diag(as.vector(y - x %*% beta)^2, ncol = length(y))
    meat <- t(x) %*% e %*% x
    var <- solve(t(x) %*% x) %*% meat %*% solve(t(x) %*% x)
    se <- sqrt(diag(var))
  }
  if(err == "cluster" | err == "wild"){
    e <- y - x %*% beta
    se <- cluster_se(x, e, cl)
  }

  return(tibble(term = colnames, estimate = beta, se = se))
}

cluster_se <- function(X, e, cl){
  cluster_vals <- unique(cl)

  sandwich <- map(cluster_vals, function(c){
    x_g <- matrix(X[which(cl == c),], ncol = ncol(X))
    e_g <- matrix(e[which(cl == c)], ncol = 1)
    return(t(x_g) %*% e_g %*% t(e_g) %*% x_g)
  })

  vcov <- solve(t(X) %*% X, tol = 1e-20) %*% reduce(sandwich, `+`) %*% solve(t(X) %*% X)
  se <- sqrt(diag(vcov))
  return(se)
}

wild_bootstrap <- function(x, y, cl){
  cluster_vals <- unique(cl)
  x_cons <- x[,colnames(x) != "Dr1"]
  y_cons <- y - sin(1) *x[,colnames(x) == "Dr1"]
  beta_cons <- as.vector(solve(t(x_cons) %*% x_cons, tol = 1e-20) %*% (t(x_cons) %*% y_cons))
  u_cons <- y_cons - x_cons %*% beta_cons

  # generate independent Rademacher draws for each cluster
  rad <- tibble(rad = sample(c(-1, 1), size = length(cluster_vals), replace = TRUE), cluster = cluster_vals)
  rad_all <- full_join(rad, tibble(cluster = cl), by = "cluster")$rad
  uwild <- u_cons*rad_all
  ywild <- x_cons%*%beta_cons + uwild

  beta_wild <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% ywild))
  e <- ywild - x%*%beta_wild

  se <- cluster_se(x, e, cl)[colnames(x) == "Dr1"]

  dr1 <- beta_wild[colnames(x) == "Dr1"]
  wald <- abs(dr1 - sin(1)) / (se/sqrt(length(y)))
  return(wald)
}


# setting up all necessary variables
event_simulation <- function(N, theta = -2, rho = .5, t = 5){
  V <- matrix(rnorm(N*t), ncol = t)
  epsilon <-  matrix(rnorm(N*t), ncol = t)

  make_U <- function(e){
    Ui <- rep(0, t)
    Ui[1] <- e[1]
    for(i in 2:t){
      Ui[i] <- rho*Ui[i-1] + e[i]
    }
    return(Ui)
  }
  U <-
    map(split(epsilon, 1:N), make_U) %>%
    reduce(rbind)

  E <- matrix(rep(sample(2:5, N, replace = TRUE), t), ncol = t)
  suppressMessages(t_all <- as.matrix(map_dfc(1:t, rep, N)))
  Y0 <- -.2 + .5*E + U
  Y1 <- -.2 + .5*E + sin(t_all - theta*E) + U + V

  # Reshape everything from N by T to N*T by 1
  Y0 <- c(Y0)
  Y1 <- c(Y1)
  E <- c(E)
  t_all <- c(t_all)

  # create individual identifiers to use for clustering later
  indiv <-  c(matrix(rep(1:N, t), ncol = t))

  # Construct D so that we can construct Y = D*Y1 + (1-D)*Y0
  D <- as.numeric(E <= t_all)
  Y <- D*Y1 + (1-D)*Y0

  # create cohort, time, and relative time dummies, with 1 cohort and 1 time
  # dummy dropped, and 2 relative time dummies dropped
  cohort_fe <-
    map_dfr(E, function(x) as.data.frame(t(as.numeric(x == 2:4)))) %>%
    setNames(paste0("Cohort", 2:4))

  time_fe <-
    map_dfr(t_all, function(x) as.data.frame(t(as.numeric(x == 1:(t-1))))) %>%
    setNames(paste0("Time", 1:(t-1)))

  reltime_dummies <-
    map_dfr(t_all - E, function(x) as.data.frame(t(as.numeric(x == -4:3)))) %>%
    setNames(paste0("Dr", -4:3)) %>%
    select(-c("Dr-4", "Dr-1"))

  xvars <- as.matrix(cbind(cohort_fe, time_fe, reltime_dummies))
  return(list(xvars, Y, E, t_all, indiv))
}

# using the output from event_simulation() to run OLS
event_betas <- function(N, theta = -2){
  simulation <- event_simulation(N, theta)
  betas <- ols(simulation[[1]], simulation[[2]])
  output <-
    data.frame(t(betas$estimate)) %>%
    setNames(betas$term)
  return(output)
}

# plotting figures for b and c
event_plot <- function(B1, B2, theta){
  # shaping the N = 1K and N=10K output
  output1 <-
    B1 %>%
    as_tibble() %>%
    summarise_all(funs(mean, quantile(., .025), quantile(., .975))) %>%
    t() %>%
    data.frame(term = rownames(.), value = .) %>%
    separate(term, into = c("time", "stat"), sep = "_") %>%
    filter(str_detect(time, "Dr")) %>%
    mutate(time = str_replace(time, "Dr", ""),
           stat = case_when(str_detect(stat, "2") ~ "2.5%",
                            str_detect(stat, "3") ~ "97.5%",
                            TRUE~  "mean"),
           N = 1000)

  output <-
    B2 %>%
    as_tibble() %>%
    summarise_all(funs(mean, quantile(., .025), quantile(., .975))) %>%
    t() %>%
    data.frame(term = rownames(.), value = .) %>%
    separate(term, into = c("time", "stat"), sep = "_") %>%
    filter(str_detect(time, "Dr")) %>%
    mutate(time = str_replace(time, "Dr", ""),
           stat = case_when(str_detect(stat, "2") ~ "2.5%",
                            str_detect(stat, "3") ~ "97.5%",
                            TRUE~  "mean"),
           N = 10000) %>%
    bind_rows(output1)

  # shaping output from long to wide
  output_mean <- filter(output, stat == "mean")
  output25 <-
    filter(output, stat == "2.5%") %>%
    rename(value_lower = value) %>%
    select(-stat)
  output975 <-
    filter(output, stat == "97.5%") %>%
    rename(value_higher = value) %>%
    select(-stat)
  output_wide <-
    select(output_mean, -stat) %>%
    full_join(output25) %>%
    full_join(output975) %>%
    mutate(time = as.numeric(time))

  # plotting mean with shaded ribbons for 2.5% and 97.5% values
  ggplot(data = output_wide, aes(x = time, y = value, group = N,
                                 color = as.factor(N))) +
    geom_line() +
    geom_point(aes(fill = as.factor(N)), size = 2) +
    geom_ribbon(aes(ymin=value_lower, ymax=value_higher, fill = as.factor(N)),
                alpha=0.3, color = NA) +
    theme_minimal() +
    scale_fill_manual(label = c("2.5% to 97.5% Perc., N = 1K", "2.5% to 97.5% Perc., N = 10K"),
                      values = c("#ef8a62", "#67a9cf"), name = "") +
    scale_colour_manual(name = "", label = c("N = 1K", "N = 10K"),
                        values = c("#ef8a62", "#67a9cf")) +
    theme(legend.position = "bottom") + xlab("Relative Time") + ylab("Coefficient")
  ggsave(file.path(gdir, paste0('sunny_q2_', theta, ".png")), width = 10, height = 6)
}




# # =============================================================================
# # (B) Plotting figures for theta = -2
# # =============================================================================
# # theta = -2
# tic()
# betas_1K <- future_map_dfr(1:M, function(x) event_simulation(1000))
# toc()
#
# tic()
# betas_10K <- future_map_dfr(1:M, function(x) event_simulation(10000))
# toc()
#
# event_plot(betas_1K, betas_10K, -2)
#
# # =============================================================================
# # (C) theta = {1, 0}
# # =============================================================================
# # theta = 0
# plan(multisession, workers = 3)
#
# tic()
# betas_1K <- future_map_dfr(1:M, function(x) event_simulation(1000, theta = 0))
# toc()
#
# tic()
# betas_10K <- future_map_dfr(1:M, function(x) event_simulation(10000, theta = 0))
# toc()
#
# event_plot(betas_1K, betas_10K, 0)
#
# # theta = 1
# plan(multisession, workers = 3)
#
# tic()
# betas_1K <- future_map_dfr(1:M, function(x) event_simulation(1000, theta = 1))
# toc()
#
# tic()
# betas_10K <- future_map_dfr(1:M, function(x) event_simulation(10000, theta = 1))
# toc()
#
# event_plot(betas_1K, betas_10K, 1)
#
# # =============================================================================
# # (D) Consistent estimator for ATE(2)
# # =============================================================================
# # calculating ATE_3(2) for part (d)
# event_ate <- function(theta, N = 10000, time = 3, event = 2){
#   simulation <- event_simulation(N, theta)
#   Yi <- simulation[[2]]
#   Ei <- simulation[[3]]
#   ti <- simulation[[4]]
#   term1 <- mean(Yi[Ei==event & ti == time])
#   term2 <- mean(Yi[Ei == event & ti == 1])
#   term3 <- mean(Yi[Ei == time + 1 & ti == time]) - mean(Yi[Ei == time + 1 & ti == 1])
#
#   return(term1 - term2 + term3)
# }
#
# # calculating the true value of ATE_3(2)
# true_ate <- function(theta, time = 3, event = 2){
#   sin(time - theta*event)
# }
#
# ate_all <- map_dbl(c(-2, 0, 1), event_ate)
# ate_true <- map_dbl(c(-2, 0, 1), true_ate)
#
# tibble("$\theta$" = c(-2, 0, 1), Estimate = ate_all, "True ATE" = ate_true) %>%
#   kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3) %>%
#   writeLines(file.path(gdir, "sunny_q2d.tex"))

# =============================================================================
# (E) t-tests
# =============================================================================
# return whether or not the t-stat is greater than 1.96
event_tstat <- function(N, rho, theta = 1){
  #plan(multisession, workers = 3)
  simulation <- event_simulation(N, theta, rho)
  err <- c("homo", "robust", "cluster")

  wald_all <-
    err %>%
    map(function(x) ols(simulation[[1]], simulation[[2]], x, simulation[[5]])) %>%
    map(function(x) filter(x, term == "Dr1")) %>%
    map_dbl(function(x) abs(x$estimate - sin(1) ) / (x$se/sqrt(N)) < 1.96)

  wild_ols <- ols(simulation[[1]], simulation[[2]], "wild", simulation[[5]])
  wald_boot <- map_dbl(1:100, function(b) wild_bootstrap(simulation[[1]], simulation[[2]], simulation[[5]]))
  wald_boot <- quantile(wald_boot, .95)
  dr1 <- filter(wild_ols, term == "Dr1")
  wald_all <- c(wald_all, abs(dr1$estimate - sin(1) ) / (dr1$se / sqrt(N)) < wald_boot)

  return(tibble(error = c(err, "wild"), reject = wald_all))
}

# run event_stat() over M simulations to find the proportion of time we reject
#plan(multisession, workers = 3)
run_tstat <- function(N, rho, M = 500, theta = 1){
  tic(paste("N =", N, "and rho =", rho))
  test <-
    map_dfr(1:M, function(x) tryCatch(event_tstat(N, rho, theta = theta),
                                      error=function(cond) return(tibble(error = NA, reject = NA)))) %>%
    filter(!is.na(error)) %>%
    group_by(error) %>%
    summarise(reject = mean(reject, na.rm = TRUE)) %>%
    mutate(N = N, rho = rho)
  toc()
  return(test)
}

rhos <- c(0, .5, 1)
Ns <- c(20, 50, 200)
combos <- map(cross2(rhos, Ns), unlist)
rhos_all <- map(combos, function(x) x[1])
Ns_all <- map(combos, function(x) x[2])

tic()
tests <- map2_df(Ns_all, rhos_all, run_tstat)
toc()

tests_output <-
  tests %>%
  mutate(error = factor(error, levels = c("homo", "robust", "cluster", "wild"))) %>%
  arrange(error) %>%
  spread(key = "rho", value = "reject")

tests_output %>%
  select(-error) %>%
  kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3) %>%
  kableExtra::group_rows("Homoscedastic", 1, 3)  %>%
  kableExtra::group_rows("Robust", 4, 6) %>%
  kableExtra::group_rows("Cluster-Robust", 7, 9) %>%
  kableExtra::group_rows("Wild Bootstrap", 10, 12) %>%
  add_header_above(c(" " = 1, "rho" = 3)) %>%
  writeLines(file.path(gdir, "sunny_q2e.tex"))
