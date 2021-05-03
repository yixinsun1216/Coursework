library(tidyverse)
library(knitr)
library(ggplot2)
library(tictoc)
library(MASS)

setwd("C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics_ml/assignment2")

# ============================
# Exercise 1a
# ============================
lasso.objective <- function(b,data,lambda){
    .5*sum((data[,1] - data[,-1] %*% b)^2) + lambda * sum(abs(b))
}


# ============================
# Exercise 1b - coordinate descent
# ============================
lasso.update <- function(b, data, lambda){
  x <- data[,-1]
  y <- data[,1]
  p <- ncol(x)

  beta_tilde <- matrix(0, nrow = ncol(x), ncol = 1)
  for(k in 1:ncol(x)){
    if(k == 1){
      ytilde <- y - x[,(k+1):ncol(x)] %*% b[(k+1):ncol(x)]
    } else if(k == p){
      ytilde <- y - as.matrix(x[,1:(k-1)]) %*% beta_tilde[1:(k-1)]
    } else{
      ytilde <- y - as.matrix(x[,1:(k-1)]) %*% beta_tilde[1:(k-1)] - as.matrix(x[,(k+1):ncol(x)]) %*% b[(k+1):ncol(x)]
    }

    #ytilde <- y - x[,-k]%*%b[-k]
    bhat <- mean(x[,k] * ytilde)
    beta_tilde[k] <- sign(bhat)*max(c(abs(bhat) - lambda, 0))
  }
  return(beta_tilde)
}

# ============================
# Exercise 1c - coordinate descent
# ============================
lasso <- function(data, lambda = 20, b.initial = rep(0, p), eps = 10^(-6), max = 1000){
  #first standardize every regressor in the data
  x_unst <- data[,-1]
  data_st <- cbind(data[,1] - mean(data[,1]), scale(x_unst)) # center the y variable so we don't need intercept???

  b1 <- lasso.update(b.initial, data_st, lambda)
  obj <- lasso.objective(b1, data_st, lambda)
  i <- 1

  isstop <- 100

  # loop using the two stopping criteria
  while(isstop > eps & i < max){
    bnew <- lasso.update(b1, data_st, lambda)
    obj <- cbind(obj, lasso.objective(bnew, data_st, lambda))
    isstop <- max(abs(bnew - b1))
    b1 <- bnew
    i <- i + 1
  }

  # do i now unstandardize the coefficients??
 # bnew <- map2_dbl(bnew, as.list(as.data.frame(x_unst)), function(x, y) (x*sd(y)) + mean(y))

  output <- list(b_est = bnew,
                 obj = obj,
                 eps_stop = isstop < eps)
  return(output)
}

# ============================
# Exercise 1d - create dataset
# ============================
p <- 90
N <- 100
M <- 10000

X <- list()
Y <- list()
eps <- list()
for(i in 1:M){
  X <- append(X, list(replicate(p, rnorm(N, 0, 1))))
  eps <- append(eps, list(rnorm(N, 0, 1)))
  Y <- append(Y, list(X[[i]][,1] - X[[i]][,2] + eps[[i]]))
}

# compute lasso estimates for each dataset
tic()
beta_lasso <- map2(X, Y, function(x, y) lasso(cbind(y, x)))
toc()

beta_lasso_mean <-
  beta_lasso %>%
  map_dfc(~pluck(.x,1) )%>%
  rowMeans()

beta_lasso_var <-
  beta_lasso %>%
  map_dfc(~pluck(.x,1) )%>%
  apply(1, var)


# ============================
# Exercise 1e - ridge
# ============================
ridge <- function(data, lambda = 20){
  x_unst <- data[,-1]
  x <- apply(x_unst, 2, function(x1) x1 - mean(x1))
  y <- data[,1]

  beta_hat <- solve(t(x) %*% x + diag(lambda, nrow = ncol(x))) %*% (t(x)%*%y)
  return(beta_hat)
}

beta_ridge <- map2_dfc(X, Y, function(x, y) ridge(cbind(y, x)))
beta_ridge_mean <- rowMeans(beta_ridge)

out <- cbind(beta_lasso_mean[1:2], beta_ridge_mean[1:2], c(1.010, -0.990))
rownames(out) <- c("beta1", "beta2")
kable(out, digits = 3, col.names = c("Lasso", "Ridge", "OLS"),
      format = "latex", booktabs = TRUE) %>%
  writeLines("part1e.tex")



# ============================
# Exercise 1f - varying lambda
# ============================
# find lambda such that beta_hat = 0
find_lambda <- function(df, lambda_grid = seq(0.01, 3, .01)){
  beta_lambda <- rep(1, p)
  k <- 1

  while(abs(sum(beta_lambda)) > 10^(-6) & k < length(lambda_grid)){
    beta_lambda <- lasso(df, lambda_grid[k])[[1]]
    k <- k + 1
  }
  return(list(lambda = lambda_grid[k], optim = abs(sum(beta_lambda)) < 10^(-6)))
}

# choose random sample and find lambda_max
s <- runif(1, 1, M)
sample <- cbind(Y[[s]], X[[s]])
lambda_max <- find_lambda(sample)

# generate sequence of 0.01*lambda_max, 0.02*lambda_max etc etc
lambda_series <- seq(0.01, 1, .01)* lambda_max[[1]]
beta_lambdas <-
  map_dfc(lambda_series, ~lasso(sample, .x)[[1]][1:5]) %>%
  t() %>%
  as_tibble() %>%
  setNames(c("beta1", "beta2", "beta3", "beta4", "beta5")) %>%
  mutate(lambda = lambda_series) %>%
  pivot_longer(cols = beta1:beta5, names_to = "beta")


# plot beta1 through beta5 as function of lambda
ggplot(beta_lambdas) +
  geom_line(aes(x = lambda, y = value, group = beta, color = beta)) +
  theme_minimal() +
  theme(legend.position = "bottom", legend.title = element_blank())
ggsave("beta_lambdas.png", width = 8, height = 5)


# =============================================================================
# =============================================================================
# Exercise 2
# =============================================================================
# =============================================================================
# Exercise 2a - cross validation

# function for computing ols estimate
ols <- function(x, y){
  solve(t(x)%*%x)%*%(t(x)%*%y)
}

cross.validation <- function(data, lambda_seq, tau = c(100, 10), h = 1){
  tau1 <- tau[1]
  tau2 <- tau[2]

  Xlist <- data[[1]]
  Ylist <- data[[2]]


  k <- 1
  y_hat_all <- vector(mode = "list", length = length(lambda_seq))
  beta_hat_all <- vector(mode = "list", length = length(lambda_seq))

  # loop through estimation and test sets to generate sequence of predicted outcomes
  while((tau1 + k*tau2) <= T){
    x_est <- Xlist[1:(tau1 + (k-1)*tau2),]
    y_est <- Ylist[(h + (k-1)*tau2):(tau1 + (k-1)*tau2 + h - 1)]
    x_test <- Xlist[(tau1 + (k-1)*tau2):(tau1 + k*tau2 - 1),]

    df <- cbind(y_est, x_est)

    beta_hat <-
      map(lambda_seq, function(x) lasso(df, x, b.initial = rep(0, ncol(Xlist)))) %>%
      map(~pluck(.x, 1))
    beta_hat_all <- append(beta_hat_all, beta_hat)

    y_hat <- map(beta_hat, ~x_test %*% .x)
    y_hat_all <- map2(y_hat_all, y_hat,c)

    k <- k + 1
    print((tau1 + k*tau2))
  }

  # now evaluate the MSFE for each lambda
  y_actual <- Ylist[(tau1 + 1):length(Ylist)]
  msfe <- map_dbl(y_hat_all, function(x) mean((x - y_actual)^2))

  # return estimated betas using optimal lambda
  lambda_opt <- lambda_seq[[which.min(msfe)]]
  yopt <- data[[2]][h:length(Ylist)]
  xopt <- data[[1]][1:(length(Ylist) - h + 1),]

  beta_opt <- lasso(cbind(yopt, xopt), lambda_opt)[[1]]

  return(list(beta_opt = beta_opt, msfe = msfe))
}


# ============================
# Exercise 2b
# ============================
dgp <- function(beta = as.matrix(c(5, rep(0, 49))), rho = 0.9, sig = Sigma){
  p <- length(beta)

  X0 <- mvrnorm(n = 1, rep(0, p), 1/(1-rho^2)*sig)

  Xall <- matrix(X0, ncol = p)
  Yall <- matrix(0, nrow = T)
  for(i in 2:(T+1)){
    ept1 <- mvrnorm(n = 1, rep(0, p), sig)
    Xall <- rbind(Xall, rho*Xall[i-1,] + ept1)
    Yall[i-1] <- t(Xall[i,])%*%beta + rnorm(1, 0, 1)
  }
  return(list(X = Xall, Y = Yall))
}

T <- 200
rho <- 0.9
tau <- c(100, 10)
h <- 1
Sigma <- (1-rho^2)*diag(1, 50)

# create dataset where b1 = 5 and the rest are 0s
data <- dgp()
lambda_seq <- seq(0, 5, length.out = 40)

# run cross validation
results_b <- cross.validation(data, lambda_seq, tau, h)

# plot MSFE as function of lambda
ggplot()+
  geom_line(aes(x = lambda_seq, y = results_b[[2]])) +
  theme_minimal() +
  xlab("Lambda") +
  ylab("MSFE")
ggsave("lambda_2b.png",  width = 8, height = 5)

betas_b_out <- results_b[[1]]
rownames(betas_b_out) <- paste0("beta", 1:length(betas_b_out))

# plot true betas against estimated betas
ggplot() +
  geom_line(aes(x = 1:50, y = betas_b_out, color = "estimated")) +
  geom_line(aes(x = 1:50, y = c(5, rep(0, 49)), color = "actual")) +
  theme_minimal()


# ============================
# Exercise 2c
# ============================
beta_c <- rnorm(50, 0, 1)
data_c <- dgp(beta_c)
lambda_seq_c <- seq(0, 5, length.out = 40)
results_c <- cross.validation(data_c, lambda_seq_c, tau, h)

ggplot()+
  geom_line(aes(x = lambda_seq_c, y = results_c[[2]])) +
  theme_minimal() +
  xlab("Lambda") +
  ylab("MSFE")
ggsave("lambda_2c.png",  width = 8, height = 5)

betas_c_out <- results_c[[1]]
rownames(betas_c_out) <- paste0("beta", 1:length(betas_c_out))

# plot true betas against estimated betas
ggplot() +
  geom_line(aes(x = 1:50, y = betas_c_out, color = "estimated")) +
  geom_line(aes(x = 1:50, y = beta_c, color = "actual")) +
  geom_line(aes(x = 1:50, y = ols(data_c[[1]][-1,], data_c[[2]]), color = "ols")) +
  theme_minimal()

# ============================
# Exercise 2d
# ============================
Sigma_tilde <- diag(1-rho^2, 10)
Sigma_tilde[lower.tri(Sigma_tilde)] <- 0.8*(1-rho^2)
Sigma_tilde[upper.tri(Sigma_tilde)] <- 0.8*(1-rho^2)
Sigma_tilde <- diag(1, 5) %x% Sigma_tilde

data_d <- dgp(sig = Sigma_tilde)
lambda_seq_d <- seq(0, 20, length.out = 40)

results_d <- cross.validation(data_d, lambda_seq_d, tau, h)
ggplot()+
  geom_line(aes(x = lambda_seq_d, y = results_d[[2]])) +
  theme_minimal() +
  xlab("Lambda") +
  ylab("MSFE")
ggsave("lambda_2d.png",  width = 8, height = 5)

betas_d_out <- results_d[[1]]
rownames(betas_d_out) <- paste0("beta", 1:length(betas_d_out))

# plot true betas against estimated betas
ggplot() +
  geom_line(aes(x = 1:50, y = betas_d_out, color = "estimated")) +
  geom_line(aes(x = 1:50, y = c(5, rep(0, 49)), color = "actual")) +
  theme_minimal()
