# Function to convert currency returns into tidy format
convert_currency_returns_to_tidy <- function(currency_returns) {
    currency_returns %>%
        rename(value = currency_return) %>%
        mutate(Tickers = "currency_returns")  # Add new Tickers label
}
