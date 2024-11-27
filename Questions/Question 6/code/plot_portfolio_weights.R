library(ggplot2)
library(dplyr)
library(scales)
library(fmxdat)

# Function to create a bar chart for portfolio weights
plot_portfolio_weights <- function(portfolio_weights, asset_class_mapping) {
  # Join portfolio_weights with asset_class_mapping
  portfolio_with_classes <- portfolio_weights %>%
    left_join(asset_class_mapping, by = "Ticker")  # Assuming Ticker is the common column
  
  # Create the bar chart
  ggplot(portfolio_with_classes, aes(x = reorder(Ticker, -Weight), y = Weight, fill = AssetClass)) +
    geom_bar(stat = "identity", width = 0.7) +
    scale_fill_brewer(palette = "Set2") +  # Use a color palette for asset classes
    labs(
      title = "Portfolio Weights by Asset",
      x = "Assets",
      y = "Weights",
      fill = "Asset Class"
    ) +
    geom_text(aes(label = scales::percent(Weight, accuracy = 0.1)), 
              vjust = -0.5, size = 3.5) +  # Add percentages above bars
    fmxdat::theme_fmx() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
      axis.title = element_text(size = 12),
      legend.position = "top"
    )
}


