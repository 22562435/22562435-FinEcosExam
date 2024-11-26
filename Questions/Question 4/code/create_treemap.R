library(dplyr)
library(treemap)
library(ggplot2)

# Function to create a treemap
create_treemap <- function(portfolio_data, benchmark_data, date = NULL, N = 5) {
    # Default date to the last available date in the portfolio
    if (is.null(date)) {
        date <- max(portfolio_data$date)
    }

    # Merge portfolio with benchmark to get sector and name information
    treemap_data <- portfolio_data %>%
        filter(date == !!date) %>%
        left_join(benchmark_data %>% select(Tickers, Sector, name), by = "Tickers")

    # Handle missing sectors or names
    treemap_data <- treemap_data %>%
        mutate(
            Sector = ifelse(is.na(Sector), "Unknown", Sector),
            name = ifelse(is.na(name), Tickers, name) # Use ticker if name is missing
        )

    # Identify the top N stocks by weight for labeling
    top_stocks <- treemap_data %>%
        arrange(desc(Weight)) %>%
        slice_head(n = N)

    # Add a label column to highlight the top N full names, use tickers for others
    treemap_data <- treemap_data %>%
        mutate(
            label = ifelse(Tickers %in% top_stocks$Tickers, name, Tickers)
        )

    # Get unique sectors and define consistent colors
    sectors <- unique(treemap_data$Sector)
    sector_colors <- get_sector_colors(sectors)

    # Create the treemap with consistent colors
    treemap(
        treemap_data,
        index = c("Sector", "label"),  # Group by Sector, label stocks
        vSize = "Weight",             # Box size proportional to weight
        vColor = "Sector",            # Color by Sector
        palette = sector_colors,      # Use consistent sector colors
        title = paste("Portfolio Composition Treemap -", as.character(date)),
        fontsize.labels = c(12, 8),   # Font size for sector and stock labels
        align.labels = list(c("center", "center"), c("left", "top"))
    )
}