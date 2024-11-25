filter_active_managers <- function(asisa_data, start_date, end_date) {
    asisa_data %>%
        filter(Index == "No" & FoF == "No") %>%
        group_by(Fund) %>%
        filter(min(date) <= as.Date(start_date) & max(date) >= as.Date(end_date)) %>%
        ungroup()
}
