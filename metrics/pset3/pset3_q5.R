# Created by Yixin Sun on November 20th, 2020
library(tidyverse)
library(tictoc)
library(knitr)
library(kableExtra)
gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset3"
ddir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/field_courses/Applied Microeconometrics/Problem Sets/ps3"

# =============================================================================
# read in data and set up variables
# =============================================================================
data <- read_csv(file.path(ddir, "angrist_evans_clean.csv"))

xvars <-
  data %>%
  select(age, ageat1st, agekid1, agekid2, agekid1, agekid2, boy1st, boy2nd, black,
         hispanic, otherrace)
yvar <- select(data, worked)
dvar <- select(data, more2kids)
zvar_ss <- select(data, samesex)
zvar_twins <- select(data, twins)


# =============================================================================
# Set Up Helper Functions
# =============================================================================
probit <- function(z, d){
  reg <- ols(z, d)
  fitted <- cbind(1, as.matrix(z)) %*% as.matrix(reg$estimate)
  return(pnorm(fitted))
}

ols <- function(x, y){
  colnames <- c("Constant", names(x))

  x <- as.matrix(x)
  y <- as.matrix(y)

  x <- cbind(1, x)

  beta <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% y))

  # # calculate robust standard error
  # e <- diag(as.vector(y - x %*% beta)^2, ncol = length(y))
  # meat <- t(x) %*% e %*% x
  # var <- solve(t(x) %*% x) %*% meat %*% solve(t(x) %*% x)
  # se <- sqrt(diag(var))

  return(tibble(term = colnames, estimate = beta))
}


estimates <- function(x, y, d, z, single = FALSE){
  if(single){
    m1 <- filter(ols(x, y), term != "d0")
    m0 <- filter(ols(x, y), term != "u1")
    x0 <- cbind(1, x[-which(colnames(x) %in% c("u1"))])
    x1 <- cbind(1, x[-which(colnames(x) %in% c("d0"))])

    outcomes <-
      data.frame(y= y, d = d, y1_imp = as.matrix(x1) %*% as.matrix(m1$estimate),
                 y0_imp = as.matrix(x0) %*% as.matrix(m0$estimate)) %>%
      as_tibble() %>%
      mutate(y1 = if_else(d == 1, worked, y1_imp),
             y0 = if_else(d == 0, worked, y0_imp))

    } else{
    m1 <- ols(x[d == 1,], y[d == 1,])
    m0 <- ols(x[d == 0,], y[d == 0,])

    outcomes <-
      data.frame(y= y, d = d, y1_imp = as.matrix(cbind(1, x)) %*% as.matrix(m1$estimate),
                 y0_imp = as.matrix(cbind(1, x)) %*% as.matrix(m0$estimate)) %>%
      as_tibble() %>%
      mutate(y1 = if_else(d == 1, worked, y1_imp),
             y0 = if_else(d == 0, worked, y0_imp))
  }

  ate <- mean(outcomes$y1) - mean(outcomes$y0)
  att <- mean(outcomes$y1[d == 1]) - mean(outcomes$y0[d == 1])
  atu <- mean(outcomes$y1[d == 0]) - mean(outcomes$y0[d == 0])
  diff <- outcomes$y1_imp - outcomes$y0_imp

  if(ncol(z) == 1){
    #late <- (mean(outcomes$y1[z == 1]) - mean(outcomes$y0[z == 0])) / (mean(d[z==1]) - mean(d[z==0]))
    late <- sum(x$u*diff)/sum(x$u)
  } else{
    #late1 <- (mean(outcomes$y1[z[,1] == 1]) - mean(outcomes$y0[z[,1] == 0])) / (mean(d[z[,1]==1]) - mean(d[z[,1]==0]))
    #late2 <- (mean(outcomes$y1[z[,2] == 1]) - mean(outcomes$y0[z[,2] == 0])) / (mean(d[z[,2]==1]) - mean(d[z[,2]==0]))
    late1 <- sum(x$u[z[,1] == 1]*diff[z[,1] == 1]) / sum(x$u[z[,1] == 1])
    late2 <-sum(x$u[z[,2] == 1]*diff[z[,2] == 1]) / sum(x$u[z[,2] == 1])
    late <- mean(z[,1])/(mean(z[,1]) + mean(z[,2]))*late1 + mean(z[,2])/(mean(z[,1]) + mean(z[,2]))*late2
  }

  return(list(ate = ate, att = att, atu = atu, late = late,
              m1 = m1, m0 = m0))
}

# =============================================================================
# Main function that estimates m(u) and target estimators for each specification
# =============================================================================
run_specifications <- function(z_ind){
  pscore <- probit(bind_cols(xvars, z_ind), dvar)
  d_ind <- pull(dvar, 1)
  x_mean <- summarise_all(xvars, mean)
  u_grid <- runif(1000, 0, 1)

  # part (i) ----------------------------------------------
  regvars_i <- cbind( data.frame(u = pscore), xvars)
  estimates_i <- estimates(regvars_i, yvar, d_ind, z_ind)
  mte_i <- map_dbl(u_grid, function(x){
    vars <- as.matrix(cbind(1, x, x_mean))
    vars %*% as.matrix(estimates_i$m1$estimate) - vars %*% as.matrix(estimates_i$m0$estimate)})

  # part (ii) ----------------------------------------------
  d1 <- d_ind == 1
  d0 <- d_ind == 0
  u1 <- data.frame(u1 = matrix(d1*pscore))
  regvars_ii <- cbind(xvars, data.frame(u = pscore), u1, d0 = d0)
  estimates_ii <- estimates(regvars_ii, yvar, d_ind, z_ind, single = TRUE)
  mte_ii <- map_dbl(u_grid, function(x){
    vars1 <- as.matrix(cbind(1, x_mean, x, x))
    vars0 <- as.matrix(cbind(1, x_mean, x, 1))
    vars1 %*% as.matrix(estimates_ii$m1$estimate) - vars0 %*% as.matrix(estimates_ii$m0$estimate)})

  # part (iii) ----------------------------------------------
  # first multiply x with u
  xu <-
    map_dfc(as.list(xvars), function(x) data.frame(matrix(x*pscore))) %>%
    setNames(paste0(colnames(xvars), "_u"))

  regvars_iii <- cbind( data.frame(u = pscore), xvars, xu)
  estimates_iii <- estimates(regvars_iii, yvar, d_ind, z_ind)
  mte_iii <- map_dbl(u_grid, function(x){
    vars <- as.matrix(cbind(1, x, x_mean, x*x_mean))
    vars %*% as.matrix(estimates_iii$m1$estimate) - vars %*% as.matrix(estimates_iii$m0$estimate)})

  # part (iv) ----------------------------------------------
  regvars_iv <- cbind( data.frame(u = pscore, u2 = pscore^2), xvars)
  estimates_iv <- estimates(regvars_iv, yvar, d_ind, z_ind)
  mte_iv <- map_dbl(u_grid, function(x){
    vars <- as.matrix(cbind(1, x, x^2, x_mean))
    vars %*% as.matrix(estimates_iv$m1$estimate) - vars %*% as.matrix(estimates_iv$m0$estimate)})

  # part (v) ----------------------------------------------
  regvars_v <- cbind( data.frame(u = pscore, u2 = pscore^2, u3 = pscore^3), xvars)
  estimates_v <- estimates(regvars_v, yvar, d_ind, z_ind)
  mte_v <- map_dbl(u_grid, function(x){
    vars <- as.matrix(cbind(1, x, x^2, x^3, x_mean))
    vars %*% as.matrix(estimates_v$m1$estimate) - vars %*% as.matrix(estimates_v$m0$estimate)})

  # Put everything into a table ---------------------------
  output <-
    list(estimates_i, estimates_ii, estimates_iii, estimates_iv, estimates_v) %>%
    map2(1:5, function(x, y){
      est <- as_tibble(x[1:4])
      tibble(estimator = colnames(est), !!paste0("value", y) := c(t(est)))}) %>%
    reduce(left_join)

  mte <-
    list(mte_i, mte_ii, mte_iii, mte_iv, mte_v) %>%
    map2_dfr(1:5, function(x, y){
      tibble(est = y, mte = x)
    }) %>%
    mutate(u = rep(u_grid, 5),
           est = paste("Specification", est))

  # Graph MTE against u for all specifications -------------
  ggplot(mte) +
    geom_smooth(aes(x = u, y = mte)) +
    theme_minimal() +
    facet_wrap(~est, ncol = 2, scales = "free")
  ggsave(file = file.path(gdir, paste0("sunny_mte_", paste(colnames(z_ind), collapse = "_"), ".png")),
         height = 10, width = 8)

  return(output)
}

# =============================================================================
# Run main function for same sex instrument, twin instrument, and both instruments
# =============================================================================
samesex <- run_specifications(zvar_ss)
twins <- run_specifications(zvar_twins)
both <- run_specifications(cbind(zvar_ss, zvar_twins))

# output pretty table
bind_rows(samesex, twins, both) %>%
  kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3,
        col.names = c("Estimator", paste("Specification", 1:5))) %>%
  kableExtra::group_rows("Same Sex Instrument", 1, 4)  %>%
  kableExtra::group_rows("Twins Instrument", 5, 8) %>%
  kableExtra::group_rows("Both Instruments", 9, 12) %>%
  writeLines(file.path(gdir, "sunny_q6_estimators.tex"))

# how do I for LATE???
# https://eml.berkeley.edu//~crwalters/papers/multiple_Z.pdf
