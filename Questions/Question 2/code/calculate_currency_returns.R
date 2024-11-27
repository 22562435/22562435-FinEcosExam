# Function to calculate monthly currency returns
calculate_currency_returns <- function(data, currency_ticker) {
    data %>%
        filter(Tickers == currency_ticker) %>%
        arrange(date) %>%
        mutate(currency_return = log(value / lag(value))) %>%
        select(date, currency_return)
}