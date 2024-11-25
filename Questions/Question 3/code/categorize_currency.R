library(dplyr)
library(zoo)

# Define the function
categorize_currency <- function(data, value_col, window_size = 12, sd_threshold = 1) {
    # Ensure the column name is interpreted correctly
    value_col <- enquo(value_col)

    # Calculate rolling statistics
    data <- data %>%
        mutate(
            rolling_mean = rollapply(!!value_col, width = window_size, FUN = mean, fill = NA, align = "right"),
            rolling_sd = rollapply(!!value_col, width = window_size, FUN = sd, fill = NA, align = "right")
        )

    # Add volatility category based on rolling standard deviation
    data <- data %>%
        mutate(
            volatility = case_when(
                rolling_sd < quantile(rolling_sd, 0.33, na.rm = TRUE) ~ "Low Volatility",
                rolling_sd > quantile(rolling_sd, 0.67, na.rm = TRUE) ~ "High Volatility",
                TRUE ~ "Normal Volatility"
            )
        )

    # Add performance category based on deviations from the rolling mean
    data <- data %>%
        mutate(
            performance = case_when(
                (!!value_col) < (rolling_mean - sd_threshold * rolling_sd) ~ "Good Performance",
                (!!value_col) > (rolling_mean + sd_threshold * rolling_sd) ~ "Poor Performance",
                TRUE ~ "Average Performance"
            )
        ) %>% select(-rolling_mean,-rolling_sd )

    return(data)
}
