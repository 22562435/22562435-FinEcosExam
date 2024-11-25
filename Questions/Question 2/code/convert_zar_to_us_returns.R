convert_zar_to_us_returns <- function(index_dates, index_returns, zar_data) {
    library(dplyr)

    # Ensure dates are in Date format
    index_dates <- as.Date(index_dates)
    zar_data <- zar_data %>% mutate(date = as.Date(date))

    # Calculate ZAR exchange rate returns
    zar_data <- zar_data %>%
        arrange(date) %>%
        mutate(FX_return = value / lag(value) - 1)

    # Interpolate ZAR FX returns to match index dates
    interpolated_fx_returns <- approx(
        x = zar_data$date,
        y = zar_data$FX_return,
        xout = index_dates,
        method = "linear",
        rule = 2
    )$y

    # Calculate USD returns
    usd_returns <- (1 + index_returns) / (1 + interpolated_fx_returns) - 1

    return(usd_returns)
}
