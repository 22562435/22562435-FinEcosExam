# Function to create a tidy data frame for plotting metrics
create_tidy_data_for_plotting <- function(rolling_te, rolling_dd, te_label = "Tracking Error", dd_label = "Downside Risk") {
    rolling_te_df <- tibble(
        date = index(rolling_te),
        tickers = te_label,
        value = coredata(rolling_te)
    )

    rolling_dd_df <- tibble(
        date = index(rolling_dd),
        tickers = dd_label,
        value = coredata(rolling_dd)
    )

    bind_rows(rolling_te_df, rolling_dd_df)
}