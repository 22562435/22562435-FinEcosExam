# calculate annual returns
calc_annual_return <- function(returns) {
    ((1 + mean(returns, na.rm = TRUE))^12 - 1)
}