calculate_all_rolling_returns_for_fees <- function(data, rolling_windows) {
    # Group by 'Type' (e.g., fee levels) and calculate rolling returns
    data %>%
        group_by(Type) %>%
        group_map(~ {
            fee_type_data <- .x  # Fee-specific data
            purrr::map_dfr(rolling_windows, function(window_size) {
                rolling_returns <- calculate_rolling_returns(fee_type_data$Rets, fee_type_data$date, window_size)
                rolling_returns %>%
                    mutate(Period = paste0(window_size, "M"), Type = .y$Type)
            })
        }) %>%
        bind_rows()
}
