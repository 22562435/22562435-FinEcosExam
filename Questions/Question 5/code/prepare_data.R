prepare_data <- function(data, currency_name = NULL, date_col = "date", price_col = "Price") {
    # Filter for specific currency if provided
    if (!is.null(currency_name)) {
        data <- data %>% filter(Name == currency_name)
    }

    # Calculate log returns
    data <- data %>%
        arrange(!!sym(date_col)) %>%
        mutate(log_return = log(!!sym(price_col) / lag(!!sym(price_col)))) %>%
        drop_na()

    # Convert to time-series format
    tbl_xts(data, cols_to_xts = "log_return", spread_by = "Name")
}
