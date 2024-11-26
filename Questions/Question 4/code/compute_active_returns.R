# Function to calculate active returns from the xts object
compute_active_returns <- function(returns_xts, fund_col = "Fund", bm_col = "BM") {
    returns_xts[, fund_col] - returns_xts[, bm_col]
}
