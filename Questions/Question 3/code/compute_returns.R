compute_returns <- function(weights, returns) {
    weights_xts <- weights %>%
        tbl_xts(cols_to_xts = weight, spread_by = Tickers)
    returns_xts <- returns %>%
        filter(Tickers %in% unique(weights$Tickers)) %>%
        tbl_xts(cols_to_xts = Return, spread_by = Tickers)

    weights_xts[is.na(weights_xts)] <- 0
    returns_xts[is.na(returns_xts)] <- 0

    rmsfuns::Safe_Return.portfolio(R = returns_xts, weights = weights_xts, lag_weights = TRUE) %>%
        xts_tbl() %>%
        rename(portfolio_returns = portfolio.returns)
}