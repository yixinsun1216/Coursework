# Created by Yixin Sun on November 1st, 2020
library(tidyverse)
library(tictoc)
library(kable)
library(kableExtra)
gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset2"
ddir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/field_courses/Applied Microeconometrics/Problem Sets/ps2"

# read in data and set up variables
data <- read_csv(file.path(ddir, "abadie.csv"))
controls <-
  select(data, inc, marr, age, fsize) %>%
  mutate(age = age - 25,
         age2 = age^2)

treat <- select(data, p401k)
instrument <- select(data, e401k)
outcome <- select(data, nettfa)

# =============================================================================
# Table 2 Column 1
# =============================================================================
ols <- function(x, y){
  colnames <- c("Constant", names(x))

  x <- as.matrix(x)
  y <- as.matrix(y)

  x <- cbind(1, x)

  beta <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% y))

  # calculate robust standard error
  e <- diag(as.vector(y - x %*% beta)^2, ncol = length(y))
  meat <- t(x) %*% e %*% x
  var <- solve(t(x) %*% x) %*% meat %*% solve(t(x) %*% x)
  se <- sqrt(diag(var))

  return(tibble(term = colnames, estimate = beta, std.error = se))
}

ols_outcomes <-
  ols(cbind(treat, controls), outcome) %>%
  mutate(estimate = estimate*1000,
         std.error = std.error*1000)

# =============================================================================
# Table 2 Columns 2 and 3
# =============================================================================
tsls <- function(z, d, y, x){
  colnames <- c("Constant", names(d), names(x))
  z <- as.matrix(cbind(1, z, x))
  d <- as.matrix(cbind(1, d, x))
  y <- as.matrix(y)
  pi <- as.matrix(solve(t(z) %*% z) %*% (t(z) %*% d))
  beta <- solve(t(pi) %*% t(z) %*% d) %*% (t(pi) %*% t(z) %*% y)

  # calculate robust standard error
  e <- diag(as.vector(y - as.matrix(d) %*% beta)^2, ncol = length(y))
  meat <- t(z) %*% e %*% z
  var <- solve(t(z) %*% d) %*% meat %*% solve(t(z) %*% d)
  se <- sqrt(diag(var))
  return(tibble(term = colnames, estimate = as.vector(beta), std.error = se))
}

first_stage <- ols(cbind(instrument, controls), treat)
second_stage <-
  tsls(instrument, treat, outcome, controls) %>%
  mutate(estimate = estimate*1000,
         std.error = std.error*1000)

# =============================================================================
# Table 2 Column 4
# =============================================================================
logit <- function(x, z){
  reg <- ols(x, z)
  fitted <- cbind(1, as.matrix(x)) %*% as.matrix(reg$estimate)
  return(1 / (1 + exp(-fitted)))
}

# probit <- function(x, z){
#   reg <- ols(x, z)
#   fitted <- cbind(1, as.matrix(x)) %*% as.matrix(reg$estimate)
#   return(pnorm(fitted))
# }

mu <- function(x){
  sum(x, na.rm = TRUE)/length(x)
}

stdev <- function(x){
  sqrt(sum((x-mu(x))^2/(length(x)-1)))
}

# given kappa, d, y, x, make one larf calculation
larf_step <- function(kappa, d, y, x){
  N <- nrow(x)
  colnames <- c("Constant", names(d), names(x))
  vars <- as.matrix(cbind(1, d, x))
  y <- as.matrix(y)

  # split everything into N length lists so we can calculate at the i level
  d_list <- split(vars, 1:N)
  y_list <- split(y, 1:N)
  kappa_list <- split(kappa, 1:N)

  # calculate (D'D)^{-1}(D'Y), weighted by kappa
  dd <-
    map2(d_list, kappa_list, function(di, ki) as.matrix(di) %*% ki %*% t(as.matrix(di))) %>%
    reduce(`+`) / N
  dd_inv <- solve(dd)
  dy <-
    list(d_list, kappa_list, y_list) %>%
    pmap(function(di, ki, yi) as.matrix(di) * ki * yi) %>%
    reduce(`+`) / N
  beta <- dd_inv %*% dy

  return(tibble(term = colnames, estimate = as.vector(beta)))
}

# run larf calculations, with bootstrapped errors
larf <- function(z, d, y, x, B = 200){
  # calculate P(Z = 1|X) using logit
  tau <- logit(x, z)

  # use estimated tau to calculate kappa
  kappa <-
    tibble(treatment = pull(d), instrument = pull(z)) %>%
    mutate(tau = as.vector(tau),
           kappa = 1 - treatment*(1-instrument) / (1- tau) - (1-treatment)*instrument / tau) %>%
    pull(kappa)

  # use equation 7 from abadie 2003 to find beta
  beta <- larf_step(kappa, d, y, x)

  # bootstrap standard errors
  boot_samples <- map(1:B, function(x) sample(1:N, N, replace = TRUE))
  estimates_boot <-
    boot_samples %>%
    map_df(function(s) larf_step(kappa[s], d[s,], y[s,], x[s,]))

  se <-
    estimates_boot %>%
    group_by(term) %>%
    summarise_all(stdev) %>%
    left_join(tibble(term = beta$term), .)

  return(tibble(term = colnames, estimate = beta$estimate, std.error = se$estimate))
}

tic()
larf_outcome <-
  larf(instrument, treat, outcome, controls, 200) %>%
  mutate(estimate = estimate*1000,
         std.error = std.error*1000)
toc()


# =============================================================================
# formatting regression output to display estimate with se error in parentheses
# underneath
# =============================================================================
reg_output <- function(estimates, name, decimals = 3){
  output <-
    tibble(estimates) %>%
    mutate(std.error = trimws(format(round(std.error, decimals),
                                     nsmall = decimals, big.mark=",")),
           estimate = trimws(format(round(estimate, decimals),
                                    nsmall = decimals, big.mark=","))) %>%
    mutate(index = row_number()) %>%
    gather(type, value, -term, -index) %>%
    group_by(index) %>%
    arrange(index, type) %>%
    ungroup %>%
    select(-index) %>%
    mutate(value = if_else(type == "std.error", paste0("(", value, ")"),
                           as.character(value)),
           value = format(value, justify = "centre"))  %>%
    rename(!!name := value)
  return(output)
}

# order variables to match table 2
table_order <- tibble(term = c("p401k", "Constant", "inc", "age", "age2",
                               "marr", "fsize", "e401k"),
                      Var = c("Participation in 401(k)", "Constant",
                                   "Family Income (thousand $)", "Age (minus 25)",
                                   "Age (minus 25) sq.", "Married", "Family Size",
                                   "Eligibility for 401(k)"))

# format all outcome columns, and join together
outcomes_all <-
  reg_output(ols_outcomes, "OLS") %>%
  full_join(reg_output(first_stage, "First Stage")) %>%
  full_join(reg_output(second_stage, "Second Stage")) %>%
  full_join(reg_output(larf_outcome, "Least squares treated")) %>%
  left_join(table_order, .) %>%
  mutate(Var = if_else(type == "std.error", "", Var)) %>%
  select(-type, -term) %>%
  mutate_all(list(~if_else(is.na(.), "", .)))

kable(outcomes_all, booktabs = TRUE, format = "latex", linesep = "",
      align = "c") %>%
  add_header_above(c(" "= 2, "Endogenous Treatment" = 3)) %>%
  add_header_above(c(" " = 2, "Two stage least squares"= 2)) %>%
  write(file.path(gdir, "sunny_q7.1.tex"))

