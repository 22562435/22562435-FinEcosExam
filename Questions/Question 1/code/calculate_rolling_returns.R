calculate_rolling_returns <- function(returns, dates, window_size) {
    # Calculate rolling returns
    rolling_returns <- zoo::rollapply(returns, width = window_size, FUN = function(x) prod(1 + x) - 1, align = "right", fill = NA)
    data.frame(date = dates, rolling_return = rolling_returns)
}
