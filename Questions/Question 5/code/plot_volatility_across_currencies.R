plot_volatility_across_currencies <- function(volatility_df, highlight_currency = "SouthAfrica_Cncy", filter_date = NULL) {
    if (!is.null(filter_date)) {
        volatility_df <- volatility_df %>% filter(as.Date(Date) > as.Date(filter_date))
    }

    # Create a palette for the other currencies
    gray_palette <- colorRampPalette(c("gray80", "gray20"))(length(unique(volatility_df$Currency)) - 1)

    # Create a named vector for colors, ensuring the highlight currency is included
    currency_colors <- setNames(c(gray_palette, "red4"), c(setdiff(unique(volatility_df$Currency), highlight_currency), highlight_currency))

    ggplot(volatility_df, aes(x = Date, y = Volatility, color = Currency)) +
        geom_line(size = 0.7, alpha = 0.75) +
        scale_color_manual(values = currency_colors) +
        labs(
            title = "Time-Varying Conditional Volatility Across Selected Currencies",
            subtitle = paste(highlight_currency, "Highlighted in Red"),
            x = "",
            y = "Volatility",
            color = ""
        ) +
        theme_minimal() +
        theme(
            legend.position = "bottom",
            plot.title = element_text(size = 14, face = "bold"),
            plot.subtitle = element_text(size = 10),
            axis.text = element_text(size = 8),
            axis.title = element_text(size = 12)
        )
}