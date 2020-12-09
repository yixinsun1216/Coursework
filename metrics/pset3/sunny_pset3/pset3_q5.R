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
spec1 <- function(m1, m0, u, x, xu){
  # m1
  a1 <- m1[1]
  b1 <- 2*m1[2]
  g1 <- m1[3:(2+ncol(x))]
  mtr1 <- a1 + b1*u + as.matrix(x)%*%as.matrix(g1, ncol = 1)

  # m0
  a0 <- m0[1] - m0[2]
  b0 <- 2*m0[2]
  g0 <- m0[3:(2+ncol(x))]
  mtr0 <- a0 + b0*u + as.matrix(x)%*%as.matrix(g0, ncol = 1)


  return(mtr1 - mtr0)
}

spec2 <- function(m1, m0, u, x, xu){
  # m1
  a1 <- m1[1]
  b1 <- 2*m1[11] + 2*m1[12]
  g1 <- m1[2:10]
  mtr1 <- a1 + b1*u + as.matrix(x)%*%as.matrix(g1, ncol = 1)

  # m0
  a0 <- m0[1] - m0[11] + m0[12]
  b0 <- 2*m0[2]
  g0 <- m0[2:10]
  mtr0 <- a0 + b0*u + as.matrix(x)%*%as.matrix(g0, ncol = 1)

  return(mtr1 - mtr0)
}

spec3 <- function(m1, m0, u, x, xu){
  # m1
  a1 <- m1[1]
  b1 <- 2*m1[2]
  g1 <- m1[3:(2+ncol(x))]
  d1 <- 2*m1[(3+ncol(x)):(2+2*ncol(x))]
  mtr1 <- a1 + b1*u + as.matrix(x)%*%as.matrix(g1, ncol = 1) + as.matrix(xu)%*%as.matrix(d1, ncol = 1)

  # m0
  a0 <- m0[1] - m0[2]
  b0 <- 2*m0[2]
  g0 <- m0[3:(2+ncol(x))] - m0[(3+ncol(x)):(2+2*ncol(x))]
  d0 <- 2*m0[(3+ncol(x)):(2+2*ncol(x))]
  mtr0 <- a0 + b0*u + as.matrix(x)%*%as.matrix(g0, ncol = 1) + as.matrix(xu)%*%as.matrix(d0, ncol = 1)

  return(mtr1 - mtr0)
}

spec4 <- function(m1, m0, u, x){
  u2 = u^2

  # m1
  a1 <- m1[1]
  b11 <- 2*m1[2]
  b12 = 3*m1[3]
  g1 <- m1[4:(3+ncol(x))]
  mtr1 <- a1 + b11*u + b12*u2 + as.matrix(x)%*%as.matrix(g1, ncol = 1)

  # m0
  a0 <- m0[1] - m0[2]
  b01 <- 2*(m0[2] - m0[3])
  b02 = 3*m0[3]
  g0 <- m0[4:(3+ncol(x))]
  mtr0 <- a0 + b01*u + b02*u2 +as.matrix(x)%*%as.matrix(g0, ncol = 1)

  #return
  return(mtr1 - mtr0)
}

spec5 <- function(m1, m0, u, x){
  u2 = u^2
  u3 = u^3

  # m1
  a1 <- m1[1]
  b11 <- 2*m1[2]
  b12 <- 3*m1[3]
  b13 <- 4*m1[4]
  g1 <- m1[5:(4+ncol(x))]
  mtr1 <- a1 + b11*u + b12*u2 + b13*u3 + as.matrix(x)%*%as.matrix(g1, ncol = 1)

  # m0
  a0 <- m0[1] - m0[2]
  b01 <- 2*(m0[2] - m0[3])
  b02 <- 3*(m0[3] - m0[4])
  b03 <- 4*m0[4]
  g0 <- m0[5:(4+ncol(x))]
  mtr0 <- a0 + b01*u + b02*u2 + b03*u3 + as.matrix(x)%*%as.matrix(g0, ncol = 1)
  return(mtr1 - mtr0)
}


logit <- function(z, d){
  reg <- ols(z, d)
  fitted <- cbind(1, as.matrix(z)) %*% as.matrix(reg$estimate)
  return(1 / (1 + exp(-fitted)))
}

ols <- function(x, y){
  colnames <- c("Constant", names(x))

  x <- as.matrix(x)
  y <- as.matrix(y)
  x <- cbind(1, x)

  beta <- as.vector(solve(t(x) %*% x, tol = 1e-20) %*% (t(x) %*% y))

  return(tibble(term = colnames, estimate = beta))
}

tsls <- function(z, d, x, y){
  colnames <- c("Constant", names(d), names(x))
  z <- as.matrix(cbind(1, z, x))
  treat <- as.matrix(cbind(1, d, x))
  y <- as.matrix(y)
  pi <- as.matrix(solve(t(z) %*% z) %*% (t(z) %*% treat))
  beta <- solve(t(pi) %*% t(z) %*% treat) %*% (t(pi) %*% t(z) %*% y)
  return(beta[2])
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
  late <- sum(x$u*diff)/sum(x$u)

  return(list(ate = ate, att = att, atu = atu, late = late,
              m1 = m1, m0 = m0))
}

# =============================================================================
# Main function that estimates m(u) and target estimators for each specification
# =============================================================================
run_specifications <- function(z_ind){
  #pscore <- logit(bind_cols(xvars, z_ind), dvar)
  d_ind <- dvar$more2kids
  x_mean <- summarise_all(xvars, mean)
  u_grid <- runif(1000, 0, 1) # create grid of u's to construct MTE graph
  logit <- glm(d_ind ~ as.matrix(z_ind) + as.matrix(xvars), family = "binomial")
  pscore <- exp(as.matrix(cbind(1, z_ind, xvars))%*%logit$coefficients)/
    (1 + exp(as.matrix(cbind(1, z_ind,xvars))%*%logit$coefficients))

  # for each specification:
  # 1. construct matrix of variables to run OLS with
  # 2. Run OLS to get coefficients for MTRs
  # 3. Use the coefficients to construct MTE curve
  # part (i) ----------------------------------------------
  regvars_i <- cbind( data.frame(u = pscore), xvars)
  estimates_i <- estimates(regvars_i, yvar, d_ind, z_ind)
  mte_i <- map_dbl(u_grid, function(x) spec1(estimates_i$m1$estimate, estimates_i$m0$estimate, x, x_mean))

  # part (ii) ----------------------------------------------
  d1 <- d_ind == 1
  d0 <- d_ind == 0
  u1 <- data.frame(u1 = matrix(d1*pscore))
  regvars_ii <- cbind(xvars, data.frame(u = pscore), u1, d0 = d0)
  estimates_ii <- estimates(regvars_ii, yvar, d_ind, z_ind, single = TRUE)
  mte_ii <- map_dbl(u_grid, function(x) spec2(estimates_ii$m1$estimate, estimates_ii$m0$estimate, x, x_mean))

  # part (iii) ----------------------------------------------
  # first multiply x with u
  xu <-
    map_dfc(as.list(xvars), function(x) data.frame(matrix(x*pscore))) %>%
    setNames(paste0(colnames(xvars), "_u"))
  regvars_iii <- cbind( data.frame(u = pscore), xvars, xu)
  estimates_iii <- estimates(regvars_iii, yvar, d_ind, z_ind)
  mte_iii <- map_dbl(u_grid, function(x) spec3(estimates_iii$m1$estimate, estimates_iii$m0$estimate, x, x_mean, x*x_mean))

  # part (iv) ----------------------------------------------
  regvars_iv <- cbind( data.frame(u = pscore, u2 = pscore^2), xvars)
  estimates_iv <- estimates(regvars_iv, yvar, d_ind, z_ind)
  mte_iv <- map_dbl(u_grid, function(x) spec4(estimates_iv$m1$estimate, estimates_iv$m0$estimate, x, x_mean))

  # part (v) ----------------------------------------------
  regvars_v <- cbind( data.frame(u = pscore, u2 = pscore^2, u3 = pscore^3), xvars)
  estimates_v <- estimates(regvars_v, yvar, d_ind, z_ind)
  mte_v <- map_dbl(u_grid, function(x) spec5(estimates_v$m1$estimate, estimates_v$m0$estimate, x, x_mean))

  # Put ATE, ATT, ATU, and LATE into a table ----------------
  output <-
    list(estimates_i, estimates_ii, estimates_iii, estimates_iv, estimates_v) %>%
    map2(1:5, function(x, y){
      est <- as_tibble(x[1:4])
      tibble(estimator = colnames(est), !!paste0("value", y) := c(t(est)))}) %>%
    reduce(left_join)

  # Graph MTE against u for all specifications -------------
  mte <-
    list(mte_i, mte_ii, mte_iii, mte_iv, mte_v) %>%
    map2_dfr(1:5, function(x, y){
      tibble(est = y, mte = x)
    }) %>%
    mutate(u = rep(u_grid, 5),
           est = paste("Specification", est))

  ggplot(mte) +
    geom_line(aes(x = u, y = mte), color = "tomato4") +
    theme_minimal() +
    facet_wrap(~est, ncol = 2)
  ggsave(file = file.path(gdir, paste0("sunny_mte_", paste(colnames(z_ind), collapse = "_"), ".png")),
         height = 10, width = 8)

  return(output)
}

# =============================================================================
# Run main function for same sex instrument, twin instrument, and both instruments
# =============================================================================
samesex <- run_specifications(zvar_ss)
twins <- run_specifications(zvar_twins)
combined <- tibble(combined = as.numeric(factor(paste(zvar_ss$samesex, zvar_twins$twins, sep = "-"))))
both <- run_specifications(combined)

# output pretty table
bind_rows(samesex, twins, both) %>%
  kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3,
        col.names = c("Estimator", paste("Specification", 1:5))) %>%
  kableExtra::group_rows("Same Sex Instrument", 1, 4)  %>%
  kableExtra::group_rows("Twins Instrument", 5, 8) %>%
  kableExtra::group_rows("Both Instruments", 9, 12) %>%
  writeLines(file.path(gdir, "sunny_q5_estimators.tex"))

# create table of TSLS regressions
tibble(Instrument = c("Same Sex", "Twins", "Both"),
       Estimate = map_dbl(list(zvar_ss, zvar_twins, combined),
                          tsls, dvar, xvars, yvar)) %>%
  kable(format = "latex", booktabs = TRUE, linesep = "", digits = 3) %>%
  writeLines(file.path(gdir, "sunny_q5_tsls.tex"))
