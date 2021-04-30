library(tidyverse)
library(knitr)
library(ggplot2)

setwd("C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics_ml/assignment2")

# ============================
# Exercise 1a
# ============================
ols <- function(x, y){
  solve(t(x)%*%x)%*%(t(x)%*%y)
}

data = cbind(Y[[2]], X[[2]])
b =  ols(data[,-1], data[,1])
lambda = 20

lasso.objective <- function(b,data,lambda){
    .5*sum((data[,1] - data[,-1] %*% b)^2) + lambda * sum(abs(b))
}


# ============================
# Exercise 1b - coordinate descent 
# ============================
lasso.update <- function(b, data, lambda){
  x <- data[,-1]
  y <- data[,1]
  
  beta_tilde <- matrix(0, nrow = ncol(x), ncol = 1)
  for(k in 1:p){
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


lambda_series <- seq(0.01, 1, .01)* lambda_max[[1]]
beta_lambdas <- 
  map_dfc(lambda_series, ~lasso(sample, .x)[[1]][1:5]) %>%
  t() %>%
  as_tibble() %>%
  setNames(c("beta1", "beta2", "beta3", "beta4", "beta5")) %>%
  mutate(lambda = lambda_series) %>%
  pivot_longer(cols = beta1:beta5, names_to = "beta")


ggplot(beta_lambdas) + 
  geom_line(aes(x = lambda, y = value, group = beta, color = beta)) + 
  theme_minimal() + 
  theme(legend.position = "bottom", legend.title = element_blank())
ggsave("beta_lambdas.png", width = 8, height = 5)
