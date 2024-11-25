calculate_all_rolling_returns <- function(returns, dates, rolling_windows, type) {
    purrr::map_dfr(rolling_windows, function(window_size) {
        calculate_rolling_returns(returns, dates, window_size) %>%
            mutate(Period = paste0(window_size, "M"), Type = type)
    })
}
