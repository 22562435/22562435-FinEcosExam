plot_returns_by_volatility <- function(data) {
    ggplot(data %>% filter(!is.na(Volatility_Regime) & Period == "12M" & !is.na(rolling_return)),
           aes(x = rolling_return, fill = Type)) +
        geom_density(alpha = 0.5) +
        facet_wrap(~ Volatility_Regime + Period, scales = "free_y") +
        labs(
            title = "Rolling Returns by Volatility Regime",
            x = "Rolling Return",
            y = "Density",
            fill = "Type"
        ) +
        theme_bw() +
        theme(
            plot.title = element_text(hjust = 0.5),
            legend.position = "bottom"
        )
}