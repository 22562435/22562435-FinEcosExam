gm_mean <- function(returns, na.rm = FALSE) {
    if (na.rm) {
        returns <- returns[!is.na(returns)] # Remove NA values
    }
    if (length(returns) == 0) {
        return(NA) # Return NA if the input is empty after removing NAs
    }
    compounded_return <- prod(1 + returns) # Add 1 to each return and multiply
    geometric_mean <- compounded_return^(1 / length(returns)) - 1
    return(geometric_mean)
}
