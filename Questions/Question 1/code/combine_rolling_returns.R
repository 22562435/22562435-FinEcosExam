combine_rolling_returns <- function(ai_data, bm_data, fee_data, rolling_windows) {
    ai_rolling <- calculate_all_rolling_returns(ai_data$AI_Fund, ai_data$date, rolling_windows, "AI_Fund")
    bm_rolling <- calculate_all_rolling_returns(bm_data$Returns, bm_data$date, rolling_windows, "Benchmark")
    fee_rolling <- calculate_rolling_returns_by_type(fee_data, rolling_windows)

    bind_rows(ai_rolling, bm_rolling, fee_rolling)
}