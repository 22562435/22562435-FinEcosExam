# Main function to calculate either VaR or ES based on a boolean parameter
risk_metrics <- function(returns, alpha = 0.05, return_var = TRUE) {
    var <- calculate_var(returns, alpha)

    if (return_var) {
        return(var)
    } else {
        es <- calculate_es(returns, var)
        return(es)
    }
}