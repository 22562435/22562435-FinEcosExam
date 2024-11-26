library(dplyr)
library(ggplot2)
library(tidyr)
library(fmxdat)

plot_sector_exposure_over_time <- function(ALSI) {
    # Calculate sector weightings over time
    sector_time_data <- ALSI %>%
        group_by(date, Sector) %>%
        summarise(
            ALSI_Return = sum(J203, na.rm = TRUE), #weightings not returns
            SWIX_Return = sum(J403, na.rm = TRUE)
        ) %>%
        pivot_longer(cols = c(ALSI_Return, SWIX_Return), names_to = "Index", values_to = "Return")

    # Plotting
    ggplot(sector_time_data, aes(x = date, y = Return, fill = Sector)) +
        geom_area(position = "fill") +
        facet_wrap(~ Index, ncol = 1) +
        labs(title = "Sector Exposure Over Time",
             y = "Proportion of Portfolio",
             fill = "Sector") +
        fmxdat::theme_fmx() +
        scale_fill_brewer(palette = "Set2")
}

