#  Calculate log returns
calculate_log_returns <- function(data, name_col = "Name", price_col = "Price") {
    data %>%
        arrange(date) %>%
        mutate(log_return = log(.data[[price_col]] / lag(.data[[price_col]]))) %>%
        drop_na()
}
