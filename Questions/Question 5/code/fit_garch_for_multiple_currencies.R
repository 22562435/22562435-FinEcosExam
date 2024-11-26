fit_garch_for_multiple_currencies <- function(data, currencies) {
    volatility_data <- list()

    for (currency in currencies) {
        # Prepare data for the currency
        currency_ts <- prepare_data(data, currency_name = currency)

        # Ensure no missing values and sufficient data
        if (nrow(na.omit(currency_ts)) < 30) {
            message(paste("Skipping", currency, "due to insufficient data"))
            next
        }

        # Fit GARCH and extract conditional volatility
        tryCatch({
            volatility_data[[currency]] <- fit_garch(currency_ts) %>%
                mutate(Currency = currency)
        }, error = function(e) {
            message(paste("Error fitting GARCH for", currency, ":", e$message))
        })
    }

    bind_rows(volatility_data)
}
