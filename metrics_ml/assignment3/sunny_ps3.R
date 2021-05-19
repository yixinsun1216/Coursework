# Created by Yixin Sun on May 18, 2021

library(tidyverse)
library(tictoc)
library(knitr)
library(kableExtra)
library(furrr)
library(modelr)
library(MASS)
gdir <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics_ml/assignment3"

# ===================================================================
# Part A
# ===================================================================
data <- tibble(Y = c(0, 1, 1, 0, 1, 0, 1, 1, 0, 0),
             X = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))

sse_gain <- function(Ys, Xs, Is){
  sum((Ys[Xs <= Is] - mean(Ys[Xs <= Is]))^2) + sum((Ys[Xs > Is] - mean(Ys[Xs > Is]))^2)
}

tree.grow <- function(data){
  yi <- as.matrix(data[,1])
  xi <- as.matrix(data[,-1])
  N <- nrow(data)
  p <- ncol(xi)

  gains_all <- matrix(,nrow = N - 1, ncol = 0)
  for(i in 1:p){
    gain <- map_dbl(as.matrix(xi[-N,i]), function(x) sse_gain(yi, xi[,i], x))
    gains_all <- cbind(gains_all, gain)
  }

  # find index in the gains_all matrix telling me which x variable at what
  # threshold gives me the greatest gain in SSE
  xstar_ij <- which(gains_all == min(gains_all), arr.ind = TRUE)[1,]

  # return dataframe of best splitting criterion, decrease in SSE, and partition
  # of Ys denoted by (0,1) under the criterion
  output <- tibble(
    kstar = rep(xstar_ij[2], N),
    xstar = rep(xi[xstar_ij[1], xstar_ij[2]], N),
    sse_gain = rep(min(gains_all), N),
    partition = xi[,xstar_ij[2]] <= xi[xstar_ij[1], xstar_ij[2]]
  )

  return(output)
}

# ===================================================================
# Part B
# ===================================================================
tree.update <- function(data, split, assign, min.size, max.depth){
  # for leave with depth less than max.depth and size bigger than min.size,
  # use tree.grow to find best splitting
  data_assigned <-
    cbind(data, assign) %>%
    group_by(term_id) %>%
    mutate(end = !(depth < max.depth & n() > min.size))

  if(sum(data_assigned$end) == nrow(data)){
    # If there's no more leaves to grow, end here
    return("end")
  } else{

    # if there are still leaves to grow, throw each set of terminal xs into tree.grow
    # split data into list based on term_id
    data_list <-
      data_assigned %>%
      filter(!end) %>%
      split(f = .$term_id)

    data_grow <- map(data_list, function(x) tree.grow(x[, 1:ncol(data)]))

    # loop through each group to figure out the one that returns the greatest
    # gains to sse
    best_index <-
      map_dbl(data_grow, function(x) unique(x$sse_gain)) %>%
      which.min

    best_grow <- cbind(data_grow[[best_index]], data_list[[best_index]])

    # now update split and assign
    # for the split matrix, we want to add a new row
    split_updated <- rbind(split, c(best_grow$term_id[1], best_grow$depth[1],
                                    best_grow$kstar[1], best_grow$xstar[1]))

    # for assign, we want the xs that were in the terminal node that we split on
    # to get updated term_ids
    assign_updated <-
      assign %>%
      left_join(dplyr::select(best_grow, -term_id, -depth), by = "id") %>%
      mutate(term_id = case_when(
        partition ~ 2*term_id,
        !partition ~ 2*term_id + 1,
        is.na(partition) ~ term_id),
        depth = if_else(is.na(partition), depth, depth + 1)) %>%
      dplyr::select(id, term_id, depth)


    return(list(split = split_updated,
                assign = assign_updated))
  }
}


# ===================================================================
# Part C
# ===================================================================
tree <- function (data, min.size = 10, max.depth = 10){

  # use tree.grow on whole dataset to get the first split
  grow1 <- tree.grow(data)
  split1 <- tibble(leaf_id = 1, depth = 0, kstar = grow1$kstar[1], threshold = grow1$xstar[1])
  assign1 <-
    grow1 %>%
    mutate(term_id = if_else(partition, 2, 3),
           depth = 1,
           id = 1:nrow(data)) %>%
    dplyr::select(term_id, depth, id)

  updated_tree <- list(split = split1, assign = assign1)

  while(updated_tree != "end"){
    assign <- updated_tree$assign
    split <- updated_tree$split
    updated_tree <- tree.update(data, split, assign, min.size, max.depth)
  }

  # compute leaves, which are the id, depth, size, and mean of the terminal leaves
  leaves <-
    cbind(data, assign) %>%
    group_by(leaf_id = term_id, depth) %>%
    summarise(size = n(),
              Ymean = mean(Y))

  return(list(split = split, assign = assign, leaves = leaves))
}

# ===================================================================
# Part D
# ===================================================================
tree.predict <- function(data, tree_grown){
  y <- data[,1]
  x <- data[,-1]
  tree_split <- tree_grown$split
  tree_assign <- tree_grown$assign
  tree_leaves <- tree_grown$leaves

  # initial assignment of y from first row of split
  kinit <- tree_split$kstar[1]
  thresh_init <- tree_split$threshold[1]
  y_assign <- ifelse(x[,kinit] <= thresh_init, 2, 2 + 1)

  # Move through rows of split matrix and categorize the Y variable
  # according to threshold
  for(j in 2:nrow(tree_split)){
    kstar <- tree_split$kstar[j]
    thresh <- tree_split$threshold[j]
    leaf_id <- tree_split$leaf_id[j]

    y_assign  <- case_when(
      y_assign != leaf_id ~ y_assign,
      x[,kstar] <= thresh & y_assign == leaf_id ~ leaf_id*2,
      x[,kstar] > thresh & y_assign == leaf_id ~ leaf_id*2 + 1
    )
  }

  # join the assigned Y with the leaves dataset to get predicted Y
  ypred <- tibble(leaf_id = y_assign, id = 1:length(y_assign)) %>%
    left_join(tree_leaves, by = "leaf_id") %>%
    arrange(id) %>%
    pull(Ymean)

  return(ypred)
}


test <- tree.predict(data, tree(data, 3, 3))

# ===================================================================
# Part E
# ===================================================================
N <- 1000
vars <- mvrnorm(N, rep(0,3), diag(1, nrow = 3))
X1 <- vars[,1]
X2 <- vars[,2]
eps <- vars[,3]

Y <- 3 * min(X1, X2) + eps

# function that uses cross validation to estimate y using tree function
# and then computes the MSE
df <- cbind(Y, X1, X2)

estimate.cv <- function(data, min.size = 10, max.depth = 10, k = 10){
  # generate cross validation folds of my data
  data <-
    as.data.frame(data) %>%
    mutate(row_id = row_number(),
           fold = c(replicate(nrow(data) / 10, sample(1:k, k))))

  data_split <- split(data, data$fold)
  yhat_all <- tibble(row_id = NA, yhat_tree = NA, yhat_ols = NA)

  for(i in 1:k){
    # for each training fold, use the k - 1 folds to train the tree and OLS
    df_train <-
      filter(data, fold != i) %>%
      select(-row_id, -fold)

    tree_train <- tree(df_train, min.size, max.depth)
    ols_train <- ols(df_train)

    # then use the test fold to produce predicted Y
    df_test <-
      filter(data, fold == i) %>%
      select(-row_id, -fold)

    yhat_all <-
      tibble(row_id = filter(data, fold == i)$row_id,
             yhat_tree = tree.predict(df_test, tree_train),
             yhat_ols = ols.predict(df_test, ols_train)) %>%
      rbind(yhat_all)
  }

  # compute squared errors
  ypred <-
    data %>%
    left_join(yhat_all) %>%
    mutate(tree_mse = (Y - yhat_tree)^2,
           ols_mse = (Y - yhat_ols)^2)

  return(list(tree_mse = mean(ypred$tree_mse), ols_mse = mean(ypred$ols_mse)))
}

ols <- function(data){
  x <- cbind(1, as.matrix(data[,-1]))
  y <- as.matrix(data[,1])
  beta <- solve(t(x) %*% x) %*% (t(x) %*% y)
  return(beta)
}

ols.predict <- function(data, beta){
  x <- cbind(1, as.matrix(data[,-1]))
  y <- as.matrix(data[,1])
  beta <- solve(t(x) %*% x) %*% (t(x) %*% y)
  return(x %*% beta)
}

mse <- estimate.cv(df, 5, 10)
mse[[1]]
mse[[2]]

# ===================================================================
# Part F
# ===================================================================
Ytilde <- 3 * X1 - 3*X2 + eps
df_tilde <- cbind(Ytilde, X1, X2)

f_tree_mse <- tree.cv(df_tilde)
f_ols_mse <- ols_mse(df_tilde)
