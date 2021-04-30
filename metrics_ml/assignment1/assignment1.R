library(tidyverse)
library(knitr)
library(MASS)

setwd("C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/field_courses/Bonhomme - Econometrics/Homework/assignment1")

# ============================
# Part A - create dataset
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

# function for computing ols estimate
ols <- function(x, y){
  solve(t(x)%*%x)%*%(t(x)%*%y)
}

# ============================
# Part B
# ============================
betas <- map2_dbl(X, Y, function(x,y){
  x1 <- as.matrix(x[,1])
  y1 <- as.matrix(y)
  ols(x1, y1)
})

print(mean(betas))
print(var(betas))

# ============================
# Part C
# ============================
beta_p <- list()
p_tilde <- c(1, 5, 10, 50, 85, 90)
for(i in 1:length(p_tilde)){
  beta_pi <- map2_dbl(X, Y, function(x, y){
    xp <- x[,1:p_tilde[i]]
    y1 <- as.matrix(y)
    ols(xp, y1)[1]
  })
  beta_p <- append(beta_p, list(beta_pi))
}

# create table of average and variance 
cbind(p = p_tilde, beta_mean = map_dbl(beta_p, mean), 
      beta_var = map_dbl(beta_p, var)) %>%
  kable(digits = 3, format = "latex", 
        col.names = c("p", "mean", "variance"), booktabs = TRUE) %>%
  writeLines("part_c.tex")


# ============================
# Part D
# ============================
p_tilde <- c(5, 10, 50, 85, 90)

# calculate x1_hat and square it 
x1_hat <- list()
for(i in 1:length(p_tilde)){
  x1_out <- map(X, function(x){
    xp <- x[,2:p_tilde[i]]
    x1 <- as.matrix(x[,1])
    gamma <- ols(xp, x1)
    xp%*%gamma
  })
  x1_avg <-  map_dbl(x1_out, function(x) mean(x*x))
  x1_hat <- append(x1_hat, list(mean(x1_avg)))
}

# lowest eigenvalue
x_eigen <- list()
for(i in 1:length(p_tilde)){
  eig_out <- map_dbl(X, function(x) {
    x2 <- x[,2:p_tilde[i]]
    ev <- min(eigen(t(x2) %*% x2)$values)
  })
  x_eigen <- append(x_eigen, list(mean(eig_out)))
}

tibble(p = p_tilde, x1_2 = unlist(x1_hat), x_eigen = unlist(x_eigen)) %>%
  kable(digits = 3, format = "latex", booktabs = TRUE) %>%
  writeLines("part_d.tex")



# ============================
# Part E
# ============================
M <- 1000
rho_all <- c(0, 0.5, 0.9)
N_all <- c(100, 200, 500, 1000)

# function to create samples based on rho and N
simulate <- function(rho, N, pval){
  Sigma <- matrix(rho, ncol = pval, nrow = pval)
  diag(Sigma) <- 1
  Xvals <- mvrnorm(N, mu = rep(0, pval), Sigma)
  u <- rnorm(N, 0, 1)
  Yvals <- Xvals[,1] - Xvals[,2] + u
  return(list(Xvals, Yvals))
}

# function to calculate one beta_1 and one eigenvalue based on the given data
value_step <- function(x1, y){
  b1 <- ols(x1, y)[1]
  eig <- min(eigen(t(x1)%*%x1)$values)
  return(list(b1 = b1, eig = eig))
}

# function to essentially loop through all samples of a given rho and N
value_all <- function(rho, N, pval = 90){
  df <- map(1:M, ~ simulate(rho, N, pval))
  vals <- map(df, function(x) value_step(x[[1]], x[[2]]))
  out <- reduce(vals, bind_rows) 
  averages <- tibble(b1_mean = mean(out$b1), b1_var = var(out$b1), eig_mean = mean(out$eig), N = N, rho = rho)
  return(averages)
}


tic()
rhoN <- cross2(rho_all, N_all)
part_e <- map_df(rhoN, function(x) value_all(x[[1]], x[[2]]))
toc()

kable(part_e, digits = 3, format = "latex", booktabs = T, 
      col.names = c("mean $\\beta_1$", "var $\\beta_1$", "eig", "N", "$\\rho$"), 
      escape = FALSE) %>%
  writeLines("part_e.tex")


# ============================
# Part F
# ============================
value_eig <- function(rho){
  df <- map(1:M, ~ simulate(rho, 1000, 90))
  eig <- 
    map(df, function(x) sort(eigen(t(x[[1]])%*%x[[1]])$values, decreasing = T)) %>%
    reduce(rbind) %>% 
    colMeans
  return(eig)
}

part_f <- 
  map(rho_all, value_eig) %>%
  reduce(c) %>%
  tibble(Order = rep(1:90, 3), "Average Eigenvalue" = ., 
         rho = c(rep("rho=0", 90), rep("rho=0.5", 90), rep("rho=0.9", 90))) 
 
ggplot(part_f) + 
  geom_line(aes(Order, y = `Average Eigenvalue`)) + 
  theme_minimal() +
  facet_wrap(~rho, nrow = 3, scales = "free")
ggsave("part_f.png", height = 10, width = 7)

# ============================
# Part G
# ============================
# pN = 0.9N
part_g1 <- map_df(rhoN, function(x) value_all(x[[1]], x[[2]], 0.9*x[[2]]))

# pN = 20*log(X)
part_g2 <- map_df(rhoN, function(x) value_all(x[[1]], x[[2]], floor(20*log(x[[2]]))))


kable(part_g1, digits = 3, format = "latex", booktabs = T, 
      col.names = c("mean $\\beta_1$", "var $\\beta_1$", "eig", "N", "$\\rho$"), 
      escape = FALSE) %>%
  writeLines("part_g1.tex")

kable(part_g2, digits = 3, format = "latex", booktabs = T, 
      col.names = c("mean $\\beta_1$", "var $\\beta_1$", "eig", "N", "$\\rho$"), 
      escape = FALSE) %>%
  writeLines("part_g2.tex")

