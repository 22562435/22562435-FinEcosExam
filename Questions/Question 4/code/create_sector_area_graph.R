
# Function to create a stacked area graph of sector composition
create_sector_area_graph <- function(portfolio_data, benchmark_data) {
    # Merge portfolio with benchmark to include Sector
    merged_data <- portfolio_data %>%
        left_join(benchmark_data %>% select(Tickers, Sector), by = "Tickers")

    # Handle missing sectors
    merged_data <- merged_data %>%
        mutate(Sector = ifelse(is.na(Sector), "Unknown", Sector))

    # Calculate total weights by sector and date
    sector_composition <- merged_data %>%
        group_by(date, Sector) %>%
        summarize(total_weight = sum(Weight, na.rm = TRUE), .groups = "drop")

    # Calculate percentage composition by sector
    sector_composition <- sector_composition %>%
        group_by(date) %>%
        mutate(percentage = total_weight / sum(total_weight)) %>%
        ungroup()

    # Get unique sectors and define colors
    sectors <- unique(sector_composition$Sector)
    sector_colors <- get_sector_colors(sectors)  # Match colors to sectors

    # Create the stacked area graph
    ggplot(sector_composition, aes(x = date, y = percentage, fill = Sector)) +
        geom_area(alpha = 0.8, color = "white") +
        scale_fill_manual(values = sector_colors) +
        scale_y_continuous(labels = scales::percent) +
        labs(
            title = "Sector Composition Over Time",
            x = "Date",
            y = "Percentage of Portfolio",
            fill = "Sector"
        ) +
        fmxdat::theme_fmx() +
        theme(
            legend.position = "right",
            text = element_text(size = 12),
            plot.title = element_text(hjust = 0.5)
        )
}