# =============================================================================
# OLS regression
# =============================================================================
ols <- function(X, Y, intercept = TRUE, cluster= NULL){
  X <- as.matrix(X)
  Y <- as.matrix(Y)

  if(intercept) X <- cbind(1, X)

  beta <- as.vector(solve(t(X) %*% X) %*% (t(X) %*% Y))
  colnames <- c("Intercept", names(X))

  # find standard errors
  e <- Y - X %*% beta
  if(!is.null(cluster)){
    se <- cluster_se(X, e, cluster)
  } else{
    se <- sqrt(diag(as.numeric(t(e) %*% e)*solve(t(X) %*% X))/(nrow(X) - ncol(X)))
  }

  # r_squared
  adj_r2 <- r_squared(Y, e, ncol(X))

  return(list(coefs = tibble(term = colnames, estimate = beta, std.error = se),
              n = length(Y), adj_r2 = adj_r2))
}


r_squared <- function(y, e, k = NULL, adj = TRUE){
  y_mean <- 1/length(y) * sum(y)
  n <- length(y)
  tot <- sum((y - y_mean)^2)
  res <- sum(e^2)
  r2 <- 1 - res / tot

  if(adj) r2 <- 1 - (1 - r2) * (n - 1)/ (n - k - 1)
}


# =============================================================================
# Clustered Standard Errors
# =============================================================================
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



# =============================================================================
# Nearest Neighbor Matching
# =============================================================================
# https://www.stata.com/manuals13/teteffectsnnmatch.pdf
# https://scholar.harvard.edu/files/imbens/files/sjpdf-1.html_.pdf
# Isn't ATT = ATE in matching?
nnmatch <- function(f, d, data, outcome = "ate", k = 4){
  # set up all data matrcies
  X <- as.matrix(data[, all.vars(f)[-1]])
  Y <- as.matrix(data[, all.vars(f)[1]])
  D <- as.matrix(data[,d])

  X0 <- X[D == 0,]
  X1 <- X[D == 1,]
  Y0 <- Y[D == 0]
  Y1 <- Y[D == 1]
  X1_list <- split(X1, 1:nrow(X1))

  # find weighting matrix for mahalabonis distance method
  S <- covariance(X, X)

  # get matrix of distances between all X0 and X1 values
  dists <- matrix(nrow = 0, ncol = nrow(X1))
  for(i in 1:nrow(X0)){
    dists <- rbind(dists, map_dbl(X1_list, function(x) cov_dist(x, X0[i,], S)))
  }

  # for each Y0, calculate counterfactual Y(1)
  Y0_matches <-
    split(dists, 1:nrow(dists)) %>%
    map(function(w) find_matches(w, Y1, k))

  Y0_counterfactuals <-
    map_dbl(Y0_matches, function(x) 1/k* sum(pluck(x, 2))) %>%
    tibble(Y0 = Y0, Y1 = .)

  # for each Y1, calculate counterfactual Y(0)
  Y1_matches <-
    split(dists, rep(1:ncol(dists), each = nrow(dists))) %>%
    map(function(w) find_matches(w, Y0, k))

  Y1_counterfactuals <-
    map_dbl(Y1_matches, function(x) 1/k * sum(pluck(x, 2))) %>%
    tibble(Y0 = ., Y1 = Y1)

  # calculate coefficient
  if(outcome == "ate"){
    coef <-
      bind_rows(Y1_counterfactuals, Y0_counterfactuals) %>%
      mutate(diff = Y1 - Y0) %>%
      pull(diff) %>%
      sum(.) / nrow(X)
  } else if(outcome == "att"){
    coef <-
      Y1_counterfactuals %>%
      mutate(diff = Y1 - Y0) %>%
      pull(diff) %>%
      sum(.) / nrow(X)
  }

  # calculate robust standard errors ---------------------------------------
  # 1. Find number of times each X is used as match for all observations of the
  # opposite treatment group
  K0 <-
    map(Y1_matches, function(x) pluck(x, 1)) %>%
    reduce(c) %>%
    tibble(index = .) %>%
    group_by(index) %>%
    summarise(n = n()) %>%
    right_join(tibble(index = 1:length(Y0))) %>%
    mutate(n = replace_na(n, 0)) %>%
    pull(n) %>%
    split(1:length(Y0))

  K1 <-
    map(Y0_matches, function(x) pluck(x, 1)) %>%
    reduce(c) %>%
    tibble(index = .) %>%
    group_by(index) %>%
    summarise(n = n()) %>%
    right_join(tibble(index = 1:length(Y1))) %>%
    mutate(n = replace_na(n, 0)) %>%
    pull(n) %>%
    split(1:length(Y1))

  # GAH THIS DOESN"T WORK - TRY THE POPULATION VARIANCE INSTEAD!
  # 2. Find variance for each match group
  Y0_sigmas <- map2(Y0, map(Y0_matches, ~ pluck(.x, 2)), calc_sigma)
  Y1_sigmas <- map2(Y1, map(Y1_matches, ~ pluck(.x, 2)), calc_sigma)

  if(outcome == "ate"){
    var_hat0 <- map2_dbl(K0, Y0_sigmas, function(x, y) (1 + x)^2 * y)
    var_hat1 <- map2_dbl(K1, Y1_sigmas, function(x, y) (1 + x)^2 * y)

    var_hat <- 1/nrow(X)^2 * sum(var_hat0, var_hat1)
  }else if(outcome == "att"){
    var_hat0 <- map2_dbl(K0, Y0_sigmas, function(x, y) (1 + x)^2 * y)
    var_hat1 <- map2_dbl(K1, Y1_sigmas, function(x, y) (1 + x)^2 * y)

    var_hat <- 1/nrow(X)^2 * sum(var_hat0, var_hat1)
  }

  return(list(coefs = coef, se = sqrt(var_hat / nrow(X))))
}

# get variance-covariance matrix for matrices a and b
covariance <- function(a, b){
  n <- nrow(a)
  a_mean <- 1/n * colSums(a)
  b_mean <- 1/n * colSums(b)

  a_centered <- sweep(a, 2, a_mean)
  b_centered <- sweep(b, 2, b_mean)
  return(1 / (n - 1) * t(a_centered) %*% b_centered)
}

# find distance between x and y
cov_dist <- function(x, y, S){
  x <- matrix(x)
  y <- matrix(y)
  sqrt(t(x - y) %*% solve(S) %*% (x - y))
}

# give a vector of distances, find the k shortest distances and calculate
# the average y for these k values
find_matches <- function(dist, y, k){
  x <-
    tibble(index = 1:length(dist), distance = dist) %>%
    arrange(distance) %>%
    filter(row_number() <= k)
  return(list(i = x$index, y = y[x$index]))
}

calc_sigma <- function(yi, yi_matches){
  ys <- c(yi, yi_matches)
  y_mean <- 1/length(ys) * sum(ys)
  return(sum((ys - y_mean)^2) / length(yi_matches))
}

# =============================================================================
# formatting regression output to display estimate with se error in parentheses
# underneath
# =============================================================================
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

