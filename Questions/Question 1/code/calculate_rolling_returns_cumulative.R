calculate_rolling_returns_cumulative <- function(cumulative_returns, dates, window_size) {
    # Calculate rolling percentage changes in cumulative returns
    rolling_returns <- zoo::rollapply(cumulative_returns, width = window_size, FUN = function(x) {
        if (length(x) < window_size) return(NA)  # Skip short periods
        last(x) / first(x) - 1  # Percentage change over the rolling window
    }, align = "right", fill = NA)

    data.frame(date = dates, rolling_return = rolling_returns)
}
