process_data <- function(tidy_data, currency_ticker = "$ZAR.USD", weights = NULL) {

    # Step 1: Calculate monthly currency returns
    currency_returns <- calculate_currency_returns(tidy_data, currency_ticker)

    # Step 2: Convert currency returns into tidy format
    currency_returns_tidy <- convert_currency_returns_to_tidy(currency_returns)

    # Step 3: Merge currency returns back into tidy_data
    tidy_data <- bind_rows(tidy_data, currency_returns_tidy)  # Directly using bind_rows

    # Step 4: Assign weights for portfolio if not provided
    if (is.null(weights)) {
        weights <- assign_weights()
    }

    # Step 5: Calculate portfolio returns (hedged and unhedged)
    portfolio_returns <- calculate_portfolio_returns(tidy_data, currency_returns, weights)

    # Step 6: Add portfolio returns back into tidy_data
    tidy_data <- tidy_data %>%
        select(date, Tickers, value) %>%  # Keep original tidy_data columns
        bind_rows(portfolio_returns)       # Add portfolio returns in tidy format

    return(tidy_data)
}