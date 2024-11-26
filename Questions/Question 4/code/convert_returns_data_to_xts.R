# Function to convert the prepared returns data to xts format
convert_returns_data_to_xts <- function(returns_data, date_col = "date") {
    xts(
        x = returns_data %>% select(-!!rlang::sym(date_col)) %>% as.matrix(),
        order.by = as.Date(returns_data[[date_col]])
    )
}