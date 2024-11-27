
# Fit a univariate GARCH model
fit_univariate_garch <- function(returns_xts) {
    spec <- ugarchspec(
        variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
        mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
        distribution.model = "std"
    )
    fit <- ugarchfit(spec, data = returns_xts)
    return(sigma(fit))  # Return conditional volatility
}