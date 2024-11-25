library(ggplot2)
library(ggExtra)
library(RColorBrewer)
library(dplyr)
library(tidyr)
library(rlang)

# Function to create scatter plots with marginal density plots
create_scatter_plot_with_marginals <- function(data, x_var, y_var, title) {
    # Create the scatter plot
    scatter_plot <- ggplot(data, aes(x = !!sym(x_var), y = !!sym(y_var))) +
        geom_point(alpha = 0.7, size = 2, color = brewer.pal(3, "Set2")[1]) +  # Use a color palette
        geom_smooth(formula = y ~ x, method = "lm", color = "red", linetype = "dashed", se = TRUE) +  # Trend line
        labs(
            title = title,
            x = gsub("_", " ", x_var),  # Replace underscores with spaces for better readability
            y = gsub("_", " ", y_var)   # Replace underscores with spaces for better readability
        ) +
        fmxdat::theme_fmx() +  # Change theme
        theme(
            plot.title = element_text(size = 12, face = "bold"),
            axis.title = element_text(size = 12),
            legend.position = "none"
        )

    # Add marginal density plots
    ggMarginal(scatter_plot, type = "density", margins = "both", size = 5, fill = brewer.pal(3, "Set2")[2])
}

# Main function to filter data and create plots
plot_portfolio_relationships <- function(tidy_data, hedged_var, currency_var) {
    # Filter for unhedged returns
    scatter_data_unhedged <- tidy_data %>%
        filter(Tickers %in% c("unhedged_return", currency_var)) %>%
        pivot_wider(names_from = Tickers, values_from = value) %>%
        filter(!is.na(unhedged_return), !is.na(!!sym(currency_var)))  # Use !!sym for dynamic variable names

    # Create the scatter plot for unhedged returns
    create_scatter_plot_with_marginals(scatter_data_unhedged, currency_var, "unhedged_return",
                                       "Relationship Between Unhedged Portfolio Returns and ZAR/USD Returns")

    # Filter for hedged returns
    scatter_data_hedged <- tidy_data %>%
        filter(Tickers %in% c(hedged_var, currency_var)) %>%
        pivot_wider(names_from = Tickers, values_from = value) %>%
        filter(!is.na(!!sym(hedged_var)), !is.na(!!sym(currency_var)))  # Use !!sym for dynamic variable names

    # Create the scatter plot for hedged returns
    create_scatter_plot_with_marginals(scatter_data_hedged, currency_var, hedged_var,
                                       "Relationship Between Hedged Portfolio Returns and ZAR/USD Returns")
}

