
# Function to merge currency returns back into tidy data
merge_currency_returns <- function(tidy_data, currency_returns_tidy) {
    bind_rows(tidy_data, currency_returns_tidy)  # Add currency returns as new rows
}