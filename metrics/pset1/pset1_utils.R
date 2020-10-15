mu <- function(x){
  sum(x, na.rm = TRUE)/length(x)
}

stdev <- function(x){
  sqrt(sum((x-mu(x))^2/(length(x)-1)))
}

# =============================================================================
# OLS regression
# =============================================================================
ols <- function(X, Y, intercept = TRUE, cluster= NULL, se_calc = TRUE){
  colnames <- names(X)

  X <- as.matrix(X)
  Y <- as.matrix(Y)

  if(intercept){
    X <- cbind(1, X)
    colnames <- c("Intercept", colnames)
  }

  beta <- as.vector(solve(t(X) %*% X, tol = 1e-20) %*% (t(X) %*% Y))

  # find standard errors
  e <- Y - X %*% beta
  if(!is.null(cluster) & se_calc){
    se <- cluster_se(X, e, as.matrix(cluster))
  } else if(is.null(cluster) & se_calc){
    se <- sqrt(diag(as.numeric(t(e) %*% e)*solve(t(X) %*% X))/(nrow(X) - ncol(X)))
  } else{
    se <- NA
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
    # filter to a cluster
    x_g <- matrix(X[which(cl == cluster_vals[i]),], ncol = ncol(X))
    e_g <- matrix(e[which(cl == cluster_vals[i])], ncol = 1)
    sandwich <- append(sandwich, list(t(x_g) %*% e_g %*% t(e_g) %*% x_g))
  }

  vcov <- solve(t(X) %*% X, tol = 1e-20) %*% reduce(sandwich, `+`) %*% solve(t(X) %*% X)
  se <- sqrt(diag(vcov))
}



# =============================================================================
# Nearest Neighbor Matching
# =============================================================================
nnmatch <- function(X, Y, D, outcome = "ate", k = 4){
  # set up all data matrcies
  Y <- as.matrix(Y)
  D <- as.matrix(D)

  X <- tibble(X)
  X0 <- as.matrix(X[D == 0,])
  X1 <- as.matrix(X[D == 1,])
  X <- as.matrix(X)
  Y0 <- Y[D == 0]
  Y1 <- Y[D == 1]

  N1 <- length(Y1)
  N0 <- length(Y0)
  N <- length(Y)
  X1_list <- split(X1, 1:N1)

  # find weighting matrix for mahalabonis distance method
  S <- covariance(X, X)

  # get matrix of distances between all X0 and X1 values
  dists <- matrix(nrow = 0, ncol = N1)
  for(i in 1:N0){
    dists <- rbind(dists, map_dbl(X1_list, function(x) cov_dist(x, X0[i,], S)))
  }

  # for each Y0, calculate counterfactual Y(1)
  Y0_matches <-
    split(dists, 1:nrow(dists)) %>%
    map(function(w) find_matches(w, Y1, k))

  Y0_counterfactuals <-
    map_dbl(Y0_matches, function(x) 1/k* sum(pluck(x, 2))) %>%
    tibble(Y0 = Y0, Y1 = .) %>%
    mutate(diff = Y1 - Y0)

  # for each Y1, calculate counterfactual Y(0)
  Y1_matches <-
    split(dists, rep(1:ncol(dists), each = nrow(dists))) %>%
    map(function(w) find_matches(w, Y0, k))

  Y1_counterfactuals <-
    map_dbl(Y1_matches, function(x) 1/k * sum(pluck(x, 2))) %>%
    tibble(Y0 = ., Y1 = Y1) %>%
    mutate(diff = Y1 - Y0)

  # calculate coefficient
  if(outcome == "ate"){
    coef <-
      bind_rows(Y1_counterfactuals, Y0_counterfactuals) %>%
      pull(diff) %>%
      sum(.) / N
  } else if(outcome == "att"){
    coef <-
      Y1_counterfactuals %>%
      pull(diff) %>%
      sum(.) / N1
  }

  # calculate robust standard errors ---------------------------------------
  # 1. Find number of times each X is used as match for all observations of the
  # opposite treatment group. Also find K' and K^2 for the variance function
  K0_count <-
    map(Y1_matches, function(x) pluck(x, 1)) %>%
    reduce(c) %>%
    tibble(index = .) %>%
    group_by(index) %>%
    summarise(n = n()) %>%
    right_join(tibble(index = 1:N0)) %>%
    mutate(n = replace_na(n, 0))
  K0 <-
    mutate(K0_count, n = n / k) %>%
    pull(n) %>%
    split(1:N0)
  K0_prime <-
    mutate(K0_count, n = n / k^2) %>%
    pull(n) %>%
    split(1:N0)
  K02 <- map(K0, ~ .x^2)

  K1_count <-
    map(Y0_matches, function(x) pluck(x, 1)) %>%
    reduce(c) %>%
    tibble(index = .) %>%
    group_by(index) %>%
    summarise(n = n()) %>%
    right_join(tibble(index = 1:N1)) %>%
    mutate(n = replace_na(n, 0))
  K1 <-
    mutate(K1_count, n = n / k) %>%
    pull(n) %>%
    split(1:N1)
  K1_prime <-
    mutate(K1_count, n = n / k^2) %>%
    pull(n) %>%
    split(1:N1)
  K12 <- map(K1, ~ .x^2)

  # 2. Find sigma_w^2 for each match group
  Y0_sigmas <- map2(Y0, map(Y0_matches, ~ pluck(.x, 2)), calc_sigma)
  Y1_sigmas <- map2(Y1, map(Y1_matches, ~ pluck(.x, 2)), calc_sigma)

  # 3. Find variance using equations on page 12 from
  # https://scholar.harvard.edu/files/imbens/files/sjpdf-1.html_.pdf
  if(outcome == "ate"){
    difference <-
      bind_rows(Y1_counterfactuals, Y0_counterfactuals) %>%
      pull(diff) %>%
      split(seq(length(.)))
    K <- append(K1, K0)
    K2 <- append(K12, K02)
    K_prime <- append(K1_prime, K0_prime)
    sigmas <- append(Y1_sigmas, Y0_sigmas)

    var_hat <-
      list(difference, K, K_prime, K2, sigmas) %>%
      pmap_dbl(function(d, k, kp, k2, s) (d- coef)^2 + (k2 + 2*k - kp)*s)

    var_hat <- 1/N^2 * sum(var_hat)
    se <- sqrt(var_hat)

  } else if(outcome == "att"){
    var_hat1 <- 1/N1^2*sum((Y1_counterfactuals$diff - coef)^2)

    var_hat0 <-
      list(K0_prime, K02, Y0_sigmas) %>%
      pmap_dbl(function(kp, k2, s) (k2 - kp)*s)

    var_hat <- 1/N1^2 * sum(var_hat1, var_hat0)
    se <- sqrt(var_hat)
  }

  return(tibble(estimate = coef, std.error = se))
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

# given a vector of distances, find the k shortest distances and calculate
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
  return(sum((ys - y_mean)^2) / length(ys))
}


# =============================================================================
# Calculating estimates through propensity score
# =============================================================================
# logit function for calculating propensity score
logit <- function(X, D){
  reg <- ols(X, D)
  fitted <- cbind(1, as.matrix(X)) %*% as.matrix(reg[[1]]$estimate)
  return(1 / (1 + exp(-fitted)))
}

propensity <- function(X, Y, D, B = 100, outcome = "ate"){
  X <- as.matrix(X)
  Y <- as.matrix(Y)
  D <- as.matrix(D)

  # find propensity score using logic
  pscore <- logit(X, D)

  # get nearest neighbor estimates by matching on the propensity score
  estimates <- nnmatch(pscore, Y, D, outcome = outcome)

  # bootstrap standard errors -------------------------
  # 1.  generate B samples of indices
  boot_samples <- map(1:B, function(x) sample(1:length(Y), length(Y),
                                              replace = TRUE))

  # 2. run nnmatch over these samples
  estimates_boot <-
    boot_samples %>%
    map_df(function(x) nnmatch(pscore[x], Y[x], D[x], outcome = outcome))
  se <- stdev(estimates_boot$coefs)

  return(tibble(estimate = estimates$estate, std.error = se))
}


# =============================================================================
# formatting regression output to display estimate with se error in parentheses
# underneath
# =============================================================================
reg_output <- function(estimates, decimals = 3,
                       extra_rows = NULL, format = "latex"){
  output <-
    tibble(estimates) %>%
    mutate(std.error = trimws(format(round(std.error, decimals),
                                     nsmall = decimals)),
           estimate = trimws(format(round(estimate, decimals),
                                    nsmall = decimals))) %>%
    mutate(index = row_number()) %>%
    gather(type, value, -term, -index) %>%
    group_by(index) %>%
    arrange(index, type) %>%
    mutate(term = if_else(row_number() == 2, "", term)) %>%
    ungroup %>%
    select(-index) %>%
    mutate(value = if_else(type == "std.error", paste0("(", value, ")"),
                           as.character(value)),
           value = format(value, justify = "centre")) %>%
    select(-type)
  if(!is.null(extra_rows)){
    extra_rows <-
      extra_rows %>%
      mutate(value = trimws(format(round(value, decimals)))) %>%
      mutate_all(as.character)
    output <- bind_rows(output, extra_rows)
  }
  return(kable(output, format = format, booktabs = TRUE))
}

