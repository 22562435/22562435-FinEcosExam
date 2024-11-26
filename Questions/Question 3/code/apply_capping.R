apply_capping <- function(data, cap) {
    data %>%
        group_by(date) %>%
        group_split() %>%
        map_df(~ Proportional_Cap_Foo(.x, W_Cap = cap))
}