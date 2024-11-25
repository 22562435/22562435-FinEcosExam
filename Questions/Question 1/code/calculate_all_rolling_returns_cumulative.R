calculate_all_rolling_returns_cumulative <- function(cumulative_returns, dates, rolling_windows, type) {
    purrr::map_dfr(rolling_windows, function(window_size) {
        calculate_rolling_returns_cumulative(cumulative_returns, dates, window_size) %>%
            mutate(Period = paste0(window_size, "M"), Type = type)
    })
}
