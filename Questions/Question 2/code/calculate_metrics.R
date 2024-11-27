calculate_metrics <- function(data, start_date, row_variables, reference_variable) {
    library(dplyr)
    library(stringr)

    # Filter the dataset for the required period
    filtered_data <- data %>%
        filter(date >= as.Date(start_date))

    # Extract reference variable data for correlation calculation
    reference_data <- filtered_data %>%
        filter(Tickers == reference_variable) %>%
        select(date, value) %>%
        rename(reference_value = value)



    # Calculate metrics for the specified row variables
    results <- filtered_data %>%
        filter(Tickers %in% row_variables) %>%
        left_join(reference_data, by = "date") %>%
        group_by(Tickers) %>%
        summarise(
            !!paste0("Correlation with ", reference_variable) := cor(value, reference_value, use = "complete.obs"),
            `Annual Return` = calc_annual_return(value),
            `Standard Deviation` = sd(value, na.rm = TRUE) * sqrt(12)  # Annualized SD
        )

    # Clean up variable names: replace underscores with spaces and capitalize
    results <- results %>%
        mutate(
            Tickers = str_replace_all(Tickers, "_", " ") %>% str_to_title()
        ) %>%
        arrange(Tickers)

    results_table <- kable(results, format = "markdown", caption = "Portfolio Metrics Comparison")
    return(results_table)


    return(results)
}