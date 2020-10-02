# OLS regression
ols <- function(f, data, intercept = TRUE, cluster= NULL){
  X <-
    data[, all.vars(f)[-1]] %>%
    as.matrix()

  if(intercept) X <- cbind(1, X)

  Y <-
    data[, all.vars(f)[1]] %>%
    as.matrix()

  beta <- as.vector(solve(t(X) %*% X) %*% (t(X) %*% Y))
  colnames <- c("Intercept", all.vars(f)[-1])

  # find standard errors
  e <- Y - X %*% beta
  if(!is.null(cluster)){
    cl <- pull(data, cluster)
    se <- cluster_se(X, e, cl)
  }

  # r_squared
  adj_r2 <- r_squared(Y, e, ncol(X))

  return(list(coefs = tibble(term = colnames, estimate = beta, std.error = se),
              n = length(Y), adj_r2 = adj_r2))
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

# formatting regression output to display estimate with se error in parentheses
# underneath
reg_output <- function(term, estimate, std.error, decimals, extra_rows = NULL){
  tibble(term = term, estimate = estimate, std.error = std.error) %>%
    mutate(std.error = trimws(format(round(std.error, decimals),
                                     nsmall = decimals)),
           estimate = trimws(format(round(estimate, decimals),
                                    nsmall = decimals))) %>%
    mutate(index = row_number()) %>%
    gather(type, value, -term, -index) %>%
    group_by(index) %>%
    arrange(index, type) %>%
    ungroup %>%
    select(-index) %>%
    mutate(value = if_else(type == "std.error", paste0("(", value, ")"),
                           as.character(value)),
           value = format(value, justify = "centre")) %>%
    select(-type)
}

r_squared <- function(y, e, k = NULL, adj = TRUE){
  y_mean <- 1/length(y) * sum(y)
  n <- length(y)
  tot <- sum((y - y_mean)^2)
  res <- sum(e^2)
  r2 <- 1 - res / tot

  if(adj) r2 <- 1 - (1 - r2) * (n - 1)/ (n - k - 1)
}
