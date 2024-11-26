library(dplyr)
library(ggplot2)
library(tidyr)

plot_mean_returns_by_cap_size <- function(ALSI, start_date, J203_column = "J203", J403_column = "J403") {
    # Compute portfolio returns dynamically based on column names for ALSI and SWIX portfolios
    weights_al <- ALSI %>%
        select(date, Tickers, weight = all_of(J203_column), Index_Name)

    weights_swix <- ALSI %>%
        select(date, Tickers, weight = all_of(J403_column), Index_Name)

    # Compute returns for each cap size for ALSI
    returns_al_small <- compute_returns(weights_al %>% filter(Index_Name == "Small_Caps"), returns = ALSI)
    returns_al_med <- compute_returns(weights_al %>% filter(Index_Name == "Mid_Caps"), returns = ALSI)
    returns_al_large <- compute_returns(weights_al %>% filter(Index_Name == "Large_Caps"), returns = ALSI)

    # Compute returns for each cap size for SWIX
    returns_swix_small <- compute_returns(weights_swix %>% filter(Index_Name == "Small_Caps"), returns = ALSI)
    returns_swix_med <- compute_returns(weights_swix %>% filter(Index_Name == "Mid_Caps"), returns = ALSI)
    returns_swix_large <- compute_returns(weights_swix %>% filter(Index_Name == "Large_Caps"), returns = ALSI)

    # Combine the returns data for ALSI and SWIX into one dataset
    mean_returns_data <- bind_rows(
        returns_al_small %>% mutate(Index = "ALSI", Cap_Size = "Small_Caps"),
        returns_al_med %>% mutate(Index = "ALSI", Cap_Size = "Mid_Caps"),
        returns_al_large %>% mutate(Index = "ALSI", Cap_Size = "Large_Caps"),
        returns_swix_small %>% mutate(Index = "SWIX", Cap_Size = "Small_Caps"),
        returns_swix_med %>% mutate(Index = "SWIX", Cap_Size = "Mid_Caps"),
        returns_swix_large %>% mutate(Index = "SWIX", Cap_Size = "Large_Caps")
    )

    # Group by date, Index, and Cap_Size to calculate mean returns
    mean_returns_by_cap_size <- mean_returns_data %>%
        group_by(date, Index, Cap_Size) %>%
        summarise(Mean_Return = mean(portfolio_returns, na.rm = TRUE), .groups = 'drop')

    # Filter the data based on the start_date
    mean_returns_by_cap_size <- mean_returns_by_cap_size %>%
        filter(date >= as.Date(start_date))

    # Plotting the mean returns by cap size
    ggplot(mean_returns_by_cap_size, aes(x = date, y = Mean_Return, color = Index)) +
        geom_line(linewidth = 0.7, alpha = 0.6) +
        facet_wrap(~ Cap_Size, ncol = 1, scales = "free_y") +
        labs(
            title = "Mean Returns by Cap Size Over Time",
            x = "",
            y = "Mean Return",
            color = "Index"
        ) +
        fmxdat::theme_fmx() +
        scale_color_manual(
            values = c("ALSI" = "yellow", "SWIX" = "red"),
            breaks = c("ALSI", "SWIX")
        ) +
        scale_alpha(guide = "none")
}