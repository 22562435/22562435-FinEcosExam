# Define the function
plot_portfolio_returns_by_volatility <- function(ALSI, Zar, compute_returns, volatility_levels = c("Low Volatility", "Normal Volatility", "High Volatility"), J203_column = "J203", J403_column = "J403") {

    # Step 1: Filter Zar data based on ALSI date and categorize currency
    Zar <- Zar %>% filter(as.Date(date) >= first(ALSI$date)) %>% categorize_currency(value)

    # ALSI Portfolio (J203) weights
    weights_al <- ALSI %>%
        select(date, Tickers, weight = all_of(J203_column))

    # SWIX Portfolio (J403) weights
    weights_swix <- ALSI %>%
        select(date, Tickers, weight = all_of(J403_column))

    # Portfolio returns for ALSI (J203) and SWIX (J403)
    returns_al <- compute_returns(weights_al, returns = ALSI)
    returns_swix <- compute_returns(weights_swix, returns = ALSI)

    # Step 2: Merge portfolio returns with volatility levels from Zar
    merged_data <- bind_rows(
        returns_al %>%
            mutate(Portfolio_Type = "ALSI Returns"),
        returns_swix %>%
            mutate(Portfolio_Type = "SWIX Returns")
    ) %>%
        inner_join(Zar %>% select(date, volatility), by = "date") %>%
        mutate(
            volatility = factor(volatility, levels = volatility_levels)
        )

    # Step 3: Create ridgeline plot for the portfolio returns by volatility level
    ggplot(merged_data, aes(x = portfolio_returns, y = volatility, fill = Portfolio_Type)) +
        geom_density_ridges(alpha = 0.7, scale = 1) +
        scale_fill_manual(values = c("ALSI Returns" = "blue", "SWIX Returns" = "green")) +
        labs(
            title = "Distribution of ALSI and SWIX Portfolio Returns by ZAR Volatility Level",
            x = "Portfolio Return",
            y = "ZAR Volatility Level",
            fill = "Return Type"
        ) +
        theme_minimal() +
        theme(legend.position = "bottom",
    plot.title = element_text(size = 10))
}


