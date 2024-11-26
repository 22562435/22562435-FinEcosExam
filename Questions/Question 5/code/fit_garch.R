fit_garch <- function(time_series) {
    garch_spec <- ugarchspec(
        variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
        mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
        distribution.model = "norm"
    )

    garch_fit <- ugarchfit(spec = garch_spec, data = time_series)
    cond_vol <- sigma(garch_fit)

    data.frame(Date = index(cond_vol), Volatility = cond_vol)
}
