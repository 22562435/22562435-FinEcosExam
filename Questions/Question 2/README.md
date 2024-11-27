# Purpose

Purpose of this work folder.

Ideally store a minimum working example data set in data folder.

Add binary files in bin, and closed R functions in code. Human Readable
settings files (e.g. csv) should be placed in settings/

``` r
# Process data and calculate returns in a streamlined manner
tidy_data <- Indexes %>%
    pivot_longer(cols = -date, names_to = "Tickers", values_to = "value") %>%
    bind_rows(Zar) %>%
    arrange(date, Tickers) %>%
    # Calculate monthly currency returns and convert to tidy format in-line
    bind_rows(
        convert_currency_returns_to_tidy(
            calculate_currency_returns(., "$ZAR.USD")
        )
    ) %>%
    # Define weights for portfolio
    bind_rows(
        calculate_portfolio_returns(
            .,
            calculate_currency_returns(., "$ZAR.USD"),
            tibble(
                Tickers = c("MSCI_ACWI", "Bbg_Agg", "J433", "ALBI"),
                weight = c(0.18, 0.12, 0.42, 0.28)  # 70% local, 30% global split
            )
        )
    ) %>%
    select(date, Tickers, value)  # Keep original tidy_data columns
```

``` r
plot_portfolio_relationships(tidy_data, "hedged_return", "currency_returns")
```

![](README_files/figure-gfm/plot-scatter-1.png)<!-- -->
