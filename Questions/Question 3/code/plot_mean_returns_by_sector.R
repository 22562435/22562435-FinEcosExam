library(dplyr)
library(ggplot2)
library(tidyr)

plot_mean_returns_by_sector <- function(ALSI, start_date, J203_column = "J203", J403_column = "J403") {
    # Compute portfolio returns dynamically based on column names for ALSI and SWIX portfolios
    weights_al <- ALSI %>%
        select(date, Tickers, weight = all_of(J203_column), Sector)

    weights_swix <- ALSI %>%
        select(date, Tickers, weight = all_of(J403_column), Sector)

    # Compute returns for each sector for ALSI
    returns_al_resources <- compute_returns(weights_al %>% filter(Sector == "Resources"), returns = ALSI)
    returns_al_financials <- compute_returns(weights_al %>% filter(Sector == "Financials"), returns = ALSI)
    returns_al_industrials <- compute_returns(weights_al %>% filter(Sector == "Industrials"), returns = ALSI)
    returns_al_property <- compute_returns(weights_al %>% filter(Sector == "Property"), returns = ALSI)

    # Compute returns for each sector for SWIX
    returns_swix_resources <- compute_returns(weights_swix %>% filter(Sector == "Resources"), returns = ALSI)
    returns_swix_financials <- compute_returns(weights_swix %>% filter(Sector == "Financials"), returns = ALSI)
    returns_swix_industrials <- compute_returns(weights_swix %>% filter(Sector == "Industrials"), returns = ALSI)
    returns_swix_property <- compute_returns(weights_swix %>% filter(Sector == "Property"), returns = ALSI)

    # Combine the returns data for ALSI and SWIX into one dataset
    mean_returns_data <- bind_rows(
        returns_al_resources %>% mutate(Index = "ALSI", Sector = "Resources"),
        returns_al_financials %>% mutate(Index = "ALSI", Sector = "Financials"),
        returns_al_industrials %>% mutate(Index = "ALSI", Sector = "Industrials"),
        returns_al_property %>% mutate(Index = "ALSI", Sector = "Property"),
        returns_swix_resources %>% mutate(Index = "SWIX", Sector = "Resources"),
        returns_swix_financials %>% mutate(Index = "SWIX", Sector = "Financials"),
        returns_swix_industrials %>% mutate(Index = "SWIX", Sector = "Industrials"),
        returns_swix_property %>% mutate(Index = "SWIX", Sector = "Property")
    )

    # Group by date, Index, and Sector to calculate mean returns
    mean_returns_by_sector <- mean_returns_data %>%
        group_by(date, Index, Sector) %>%
        summarise(Mean_Return = mean(portfolio_returns, na.rm = TRUE), .groups = 'drop')

    # Filter the data based on the start_date
    mean_returns_by_sector <- mean_returns_by_sector %>%
        filter(date >= as.Date(start_date))

    # Plotting the mean returns by sector
    ggplot(mean_returns_by_sector, aes(x = date, y = Mean_Return, color = Index)) +
        geom_line(linewidth = 0.7, alpha = 0.6) +
        facet_wrap(~ Sector, ncol = 1, scales = "free_y") +
        labs(
            title = "Mean Returns by Sector Over Time",
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