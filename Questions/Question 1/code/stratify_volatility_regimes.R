stratify_volatility_regimes <- function(volatility, low_quantile = 0.2, high_quantile = 0.8) {
    thresholds <- quantile(volatility, probs = c(low_quantile, high_quantile), na.rm = TRUE)
    case_when(
        volatility <= thresholds[1] ~ "Low Volatility",
        volatility >= thresholds[2] ~ "High Volatility",
        TRUE ~ "Normal"
    )
}
