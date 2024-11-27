plot_rolling_returns <- function(data) {
    ggplot(data %>% filter(!is.na(rolling_return)), aes(x = date, y = rolling_return, color = Type)) +
        geom_line(linewidth = 1, alpha = 0.5) +
        facet_wrap(~ Period, ncol = 1, scales = "free_y") +
        labs(
            title = "Rolling Returns Comparison",
            x = "Date",
            y = "Rolling Returns",
            color = "Type"
        ) +
        fmxdat::theme_fmx() +
        theme(
            plot.title = element_text(hjust = 0.5),
            legend.position = "bottom"
        )
}