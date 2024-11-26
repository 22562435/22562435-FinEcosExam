# Function to calculate Expected Shortfall (ES)
calculate_es <- function(returns, var) {
    mean(returns[returns <= var], na.rm = TRUE)
}

