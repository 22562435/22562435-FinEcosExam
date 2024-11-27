
# Function to calculate portfolio returns (hedged and unhedged)
calculate_portfolio_returns <- function(tidy_data, currency_returns, weights) {
    tidy_data %>%
        left_join(currency_returns, by = "date") %>%
        left_join(weights, by = "Tickers") %>%
        mutate(
            adjusted_return = case_when(
                Tickers %in% c("J433", "ALBI") ~ value - currency_return,  # Hedged returns
                TRUE ~ value  # USD assets remain unchanged
            )
        ) %>%
        filter(Tickers %in% weights$Tickers) %>%  # Only include portfolio tickers
        group_by(date) %>%
        summarize(
            unhedged_return = sum(value * weight, na.rm = TRUE),  # Use unadjusted ZAR returns
            hedged_return = sum(adjusted_return * weight, na.rm = TRUE)  # Use hedged ZAR returns
        ) %>%
        pivot_longer(cols = c(unhedged_return, hedged_return), names_to = "Tickers", values_to = "value") %>%
        ungroup()
}