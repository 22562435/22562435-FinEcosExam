plot_volatility_comparison <- function(returns_df, cond_vol_df, filter_date = NULL) {
    if (!is.null(filter_date)) {
        returns_df <- returns_df %>% filter(as.Date(date) > as.Date(filter_date))
        cond_vol_df <- cond_vol_df %>% filter(as.Date(Date) > as.Date(filter_date))
    }

    ggplot() +
        geom_line(data = returns_df, aes(x = date, y = sqrt(Squared_Returns)), color = "blue3") +
        geom_line(data = cond_vol_df, aes(x = Date, y = Volatility), color = "red", size = 2, alpha = 0.75) +
        labs(
            title = "Comparison: Returns Sigma vs Sigma from GARCH",
            x = "Date",
            y = "Comparison of Estimated Volatility"
        ) +
        theme_minimal()
}
