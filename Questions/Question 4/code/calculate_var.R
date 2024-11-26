# Function to calculate Value-at-Risk (VaR)
calculate_var <- function(returns, alpha) {
    quantile(returns, probs = alpha, na.rm = TRUE)
}

