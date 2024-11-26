# Function to calculate rolling downside deviation
calculate_rolling_downside_deviation <- function(returns_xts, width = 12, fund_col = "Fund", mar = 0) {
    rollapply(
        returns_xts[, fund_col],
        width = width,
        FUN = function(x) DownsideDeviation(x, MAR = mar),
        align = "right",
        fill = NA  # Fill with NA for the initial periods
    )
}