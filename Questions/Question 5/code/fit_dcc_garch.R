# Fit DCC-GARCH
fit_dcc_garch <- function(merged_data) {
    univariate_spec <- ugarchspec(
        variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
        mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
        distribution.model = "std"
    )
    multi_spec <- multispec(replicate(ncol(merged_data) - 1, univariate_spec))
    dcc_spec <- dccspec(uspec = multi_spec, dccOrder = c(1, 1), distribution = "mvnorm")
    dcc_fit <- dccfit(dcc_spec, data = as.matrix(merged_data[, -1]))
    return(dcc_fit)
}