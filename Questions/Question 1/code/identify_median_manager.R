identify_median_manager <- function(filtered_data) {
    # Step 1: Calculate each fund's overall medium return
    fund_medium <- filtered_data %>%
        group_by(Fund) %>%
        summarise(Overall_Median_Return = median(Returns, na.rm = TRUE), .groups = "drop")

    # Step 2: Calculate the global median return
    global_median <- median(filtered_data$Returns, na.rm = TRUE)

    # Step 3: Find the median manager
    median_manager <- fund_medium %>%
        mutate(Distance_to_Global_Median = abs(Overall_Median_Return - global_median)) %>%
        arrange(Distance_to_Global_Median) %>%
        slice(1)  # Select the manager with the smallest distance

    return(median_manager$Fund)  # Return the fund name
}
