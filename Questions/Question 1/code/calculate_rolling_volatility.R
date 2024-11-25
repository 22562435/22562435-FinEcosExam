calculate_rolling_volatility <- function(returns, dates, window_size = 20) {
    data.frame(
        date = dates,
        Rolling_Volatility = rollapply(returns, width = window_size, FUN = sd, align = "right", fill = NA)
    )
}
