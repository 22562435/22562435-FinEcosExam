plot_density <- function(data) {
    ggplot(data %>% filter(!is.na(rolling_return)), aes(x = rolling_return, fill = Type)) +
        geom_density(alpha = 0.6) +
        facet_wrap(~ Period, scales = "free") +
        labs(
            title = "Density of Rolling Returns by Period",
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
