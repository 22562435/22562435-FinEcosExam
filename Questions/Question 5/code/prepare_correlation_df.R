#  Prepare correlation data frame
prepare_correlation_df <- function(dcc_fit, dates) {
    correlations <- rcor(dcc_fit)
    data.frame(
        date = dates,
        ZAR_Dollar = correlations[1, 2, ],
        ZAR_PC1 = correlations[1, 3, ]
    ) %>%
        pivot_longer(-date, names_to = "Correlation_Pair", values_to = "Correlation")
}
