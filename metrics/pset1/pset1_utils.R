# OLS regression
ols <- function(f, data, intercept = TRUE, cluster= NULL){
  X <-
    data[, all.vars(f)[-1]] %>%
    as.matrix()

  if(intercept) X <- cbind(1, X)

  Y <-
    data[, all.vars(f)[1]] %>%
    as.matrix()

  beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)

  e <- Y - X %*% beta

  cl <- pull(data, cluster)
}

# Clustered Standard Errors
cluster_se <- function(X, e, cl){
  cluster_vals <- unique(cl)

  sandwich <- matrix(nrow = 0, ncol = ncol(X))
  for(i in 1:length(cluster_vals)){
    x_g <- matrix(X[which(cl == cluster_vals[i]),], ncol = ncol(X))
    e_g <- matrix(e[which(cl == cluster_vals[i])], ncol = 1)
    sandwich <- append(sandwich, list(t(x_g) %*% e_g %*% t(e_g) %*% x_g))
  }

  vcov <- solve(t(X) %*% X) %*% reduce(sandwich, `+`) %*% solve(t(X) %*% X)
  se <- sqrt(diag(vcov))
}
