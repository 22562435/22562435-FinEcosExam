
# Function to plot dynamic correlations with annotation
plot_dynamic_correlations <- function(correlation_df, title = "Dynamic Correlations over Time") {
    ggplot(correlation_df, aes(x = date, y = Correlation, color = Correlation_Pair)) +
        geom_line(size = 1) +  # Thicker lines for better visibility
        scale_color_manual(
            values = c("ZAR_Dollar" = "#D55E00", "ZAR_PC1" = "#0072B2")
        ) +  # Custom color palette
        scale_x_date(
            labels = date_format("%Y"),
            breaks = date_breaks("1 year")
        ) +  # Cleaner date format
        labs(
            title = title,
            x = "Date",
            y = "Correlation",
            color = "Correlation Pair",
            caption="Correlations computed using a DCC-GARCH model\nwith GJR-GARCH univariate specifications.\nPC1 represents the primary factor capturing shared volatility across VIX, V2X, and VXEEM indices."
        ) +
        fmxdat::theme_fmx() +  # Larger font for readability
        theme(
            legend.position = "bottom",  # Move legend to the bottom
            legend.title = element_text(size = 12, face = "bold"),
            legend.text = element_text(size = 10),
            plot.title = element_text(hjust = 0.5, face = "bold"),  # Center the title
            axis.text.x = element_text(angle = 45, hjust = 1)  # Tilt x-axis labels
        )
}