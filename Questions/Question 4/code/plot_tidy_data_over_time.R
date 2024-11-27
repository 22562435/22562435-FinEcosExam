

library(ggplot2)

# Function to plot any tidy data variable over time
plot_tidy_data_over_time <- function(tidy_data, x_var = "date", y_var = "value",
                                     ticker_var = "tickers",
                                     title = "Time Series Plot",
                                     x_label = "",
                                     y_label = "Value",
                                     color_values = NULL) {

    # Check if the specified columns exist in the tidy data
    if (!all(c(x_var, y_var, ticker_var) %in% names(tidy_data))) {
        stop("One or more specified columns do not exist in the tidy data.")
    }

    # Create the plot
    ggplot(tidy_data, aes_string(x = x_var, y = y_var, color = ticker_var, linetype = ticker_var)) +
        geom_line(size = 1) +  # Use lines to connect the points
        theme_minimal() +
        labs(
            title = title,
            x = x_label,
            y = y_label,
            color = "Metrics",
            linetype = "Metrics"
        ) +
        # If color values are provided, use them; otherwise, use default ggplot colours
        if (!is.null(color_values)) {
            scale_color_manual(values = color_values)
        } else {
            NULL
        } +
        theme(
            legend.position = "top",
            axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels for better readability
        )
}