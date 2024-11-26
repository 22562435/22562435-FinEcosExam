library(ggplot2)

plot_capped_returns <- function(data, column_name) {
    data %>%
        group_by(capping_level) %>%
        mutate(cumulative_return = cumprod(1 + portfolio_returns)) %>%
        ggplot(aes(date, cumulative_return, color = capping_level)) +
        geom_line() +
        labs(
            title = glue::glue("Impact of Capping on Index Returns ({column_name})"),
            x = "Date",
            y = "Cumulative Return"
        ) +
        fmxdat::theme_fmx()
}
