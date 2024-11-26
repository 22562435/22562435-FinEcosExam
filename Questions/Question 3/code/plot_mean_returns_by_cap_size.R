library(dplyr)
library(ggplot2)
library(tidyr)

plot_mean_returns_by_cap_size <- function(ALSI) {
    # Calculate mean returns by cap size (Index_Name) over time
    mean_returns_data <- ALSI %>%
        group_by(date, Index_Name) %>%
        summarise(
            Mean_ALSI_Return = mean(J203, na.rm = TRUE),
            Mean_SWIX_Return = mean(J403, na.rm = TRUE)
        ) %>%
        pivot_longer(
            cols = c(Mean_ALSI_Return, Mean_SWIX_Return),
            names_to = "Index",
            values_to = "Mean_Return"
        )

    # Plotting
    ggplot(mean_returns_data, aes(x = date, y = Mean_Return, color = Index)) +
        geom_line() +
        facet_wrap(~ Index_Name, ncol = 1, scales = "free_y") +
        labs(
            title = "Mean Returns by Cap Size Over Time",
            x = "",
            y = "Mean Return",
            color = "Index"
        ) +
        fmxdat::theme_fmx() +
        scale_color_brewer(palette = "Set1")
}