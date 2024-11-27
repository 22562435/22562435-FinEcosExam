get_fee_adjusted_returns <- function(data, returns_column, fee_levels) {
    calculate_fee_adjusted_returns(data, returns_column, fee_levels) %>%
        select(date, Type, Rets) %>%
        mutate(Type = paste0("Median Manager ", Type))
}
