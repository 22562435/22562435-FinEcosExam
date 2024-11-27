

library(tidyverse)
library(quadprog)

# Portfolio Optimization Function with External Constraints
optimize_portfolio <- function(data, asset_class_mapping, 
                               single_stock_max, equities_max, bond_credit_max) {
  # Prepare the data
  returns_data <- data %>%
    pivot_wider(names_from = Ticker, values_from = Price) %>%
    select(-date) %>%
    na.omit() %>%
    as.matrix()
  
  # Exclude assets with less than 3 years of data
  min_data_length <- 3 * 252  # Approx. 252 trading days in a year
  valid_assets <- colnames(returns_data)[colSums(!is.na(returns_data)) >= min_data_length]
  returns_data <- returns_data[, valid_assets]
  
  # Covariance matrix and mean returns
  cov_matrix <- cov(returns_data)
  mean_returns <- colMeans(returns_data)
  
  # Number of assets
  num_assets <- ncol(returns_data)
  
  # Define constraints
  lower_bounds <- rep(0, num_assets)  # Long-only strategy
  upper_bounds <- rep(single_stock_max, num_assets)  # Max single stock weight
  
  # Aggregate constraints by asset class
  asset_classes <- asset_class_mapping %>%
    filter(Ticker %in% valid_assets)
  
  equity_indices <- which(asset_classes$AssetClass == "Equity")
  bond_indices <- which(asset_classes$AssetClass %in% c("Credit", "Rates"))
  
  equity_upper <- rep(0, num_assets)
  equity_upper[equity_indices] <- 1
  
  bond_upper <- rep(0, num_assets)
  bond_upper[bond_indices] <- 1
  
  # Constraint matrix (A) and bounds (b)
  A_matrix <- rbind(
    rep(1, num_assets),  # Sum of weights = 1
    diag(1, num_assets),  # Individual upper bounds
    -diag(1, num_assets),  # Individual lower bounds
    equity_upper,  # Equity constraint
    bond_upper  # Bond constraint
  )
  
  b_vector <- c(
    1,  # Total weights sum to 1
    lower_bounds,  # Lower bounds
    -upper_bounds,  # Upper bounds
    equities_max,  # Max total weight in equities
    bond_credit_max  # Max total weight in bonds/credit
  )
  
  # Solve the quadratic programming problem
  solution <- solve.QP(
    Dmat = cov_matrix,
    dvec = mean_returns,
    Amat = t(A_matrix),
    bvec = b_vector,
    meq = 1  # Only the first constraint is equality
  )
  
  # Format results
  results <- tibble(
    Ticker = colnames(returns_data),
    Weight = round(solution$solution, 4)
  )
  
  return(results)
}