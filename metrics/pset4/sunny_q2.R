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
M <- 50
t <- 5

ols <- function(x, y){
  colnames <- c("Constant", colnames(x))

  x <- as.matrix(x)
  x <- cbind(1, x)
  y <- as.matrix(y)

  beta <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% y))

  return(tibble(term = colnames, estimate = beta))
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
  t_all <- as.matrix(map_dfc(1:t, rep, N))
  Y0 <- -.2 + .5*E + U
  Y1 <- -.2 + .5*E + sin(t_all - theta*E) + U + V

  # Reshape everything from N by T to N*T by 1
  Y0 <- c(Y0)
  Y1 <- c(Y1)
  E <- c(E)
  t_all <- c(t_all)

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
  return(list(xvars, Y, E, t_all))
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

# calculating ATE_3(2) for part (d)
event_ate <- function(theta, N = 10000, time = 3, event = 2){
  simulation <- event_simulation(N, theta)
  Yi <- simulation[[2]]
  Ei <- simulation[[3]]
  ti <- simulation[[4]]
  term1 <- mean(Yi[Ei==event & ti == time])
  term2 <- mean(Yi[Ei == event & ti == 1])
  term3 <- mean(Yi[Ei == time + 1 & ti == time]) - mean(Yi[Ei == time + 1 & ti == 1])

  return(term1 - term2 + term3)
}

# calculating the true value of ATE_3(2)
true_ate <- function(theta, time = 3, event = 2){
  sin(time - theta*event)
}


# =============================================================================
# (B) Plotting figures for theta = -22
# =============================================================================
# theta = -2
plan(multisession, workers = 3)

tic()
betas_1K <- future_map_dfr(1:M, function(x) event_simulation(1000))
toc()

tic()
betas_10K <- future_map_dfr(1:M, function(x) event_simulation(10000))
toc()

event_plot(betas_1K, betas_10K, -2)

# =============================================================================
# (C) theta = {1, 0}
# =============================================================================
# theta = 0
plan(multisession, workers = 3)

tic()
betas_1K <- future_map_dfr(1:M, function(x) event_simulation(1000, theta = 0))
toc()

tic()
betas_10K <- future_map_dfr(1:M, function(x) event_simulation(10000, theta = 0))
toc()

event_plot(betas_1K, betas_10K, 0)

# theta = 1
plan(multisession, workers = 3)

tic()
betas_1K <- future_map_dfr(1:M, function(x) event_simulation(1000, theta = 1))
toc()

tic()
betas_10K <- future_map_dfr(1:M, function(x) event_simulation(10000, theta = 1))
toc()

event_plot(betas_1K, betas_10K, 1)

# =============================================================================
# (D) Consistent estimator for ATE(2)
# =============================================================================
ate_all <- map_dbl(c(-2, 0, 1), event_ate)
ate_true <- map_dbl(c(-2, 0, 1), true_ate)

tibble("$\theta$" = c(-2, 0, 1), Estimate = ate_all, "True ATE" = ate_true) %>%
  kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3) %>%
  writeLines(file.path(gdir, "sunny_q2d.tex"))

# =============================================================================
# (E) t-tests
# =============================================================================
M <- 1000
