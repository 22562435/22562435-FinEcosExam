# Function to calculate rolling tracking error
calculate_rolling_tracking_error <- function(active_returns, width = 12) {
    rollapply(
        active_returns,
        width = width,
        FUN = sd,
        align = "right",
        fill = NA  # Fill with NA for the initial periods
    )
}