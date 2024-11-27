get_median_manager_data <- function(data, start_date, end_date) {
    median_manager <- filter_active_managers(data, start_date, end_date) %>%
        identify_median_manager()

    data %>%
        filter(Fund == median_manager)
}
