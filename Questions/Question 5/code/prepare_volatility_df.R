#  Prepare volatility data frame
prepare_volatility_df <- function(dcc_fit, dates) {
    volatilities <- sigma(dcc_fit)
    data.frame(
        date = dates,
        ZAR_volatility = volatilities[, 1],
        Dollar_volatility = volatilities[, 2],
        PC1_volatility = volatilities[, 3]
    ) %>%
        pivot_longer(-date, names_to = "Series", values_to = "Volatility")
}