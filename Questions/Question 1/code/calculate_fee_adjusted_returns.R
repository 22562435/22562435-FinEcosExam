
calculate_fee_adjusted_returns <- function(data, returns_column = "Returns", fee_levels = c(50, 100, 200)) {
    # Convert annual fees to monthly compounded rates
    feeconverter <- function(x, Ann_Level) (1 + x)^(1 / Ann_Level) - 1

    # Rename the returns column dynamically
    data <- data %>%
        rename(returns = !!returns_column)  # Dynamically use the input column

    # Adjust returns for each fee level
    fee_adjusted <- data
    for (fee in fee_levels) {
        fee_rate <- feeconverter(fee * 1e-4, Ann_Level = 12)  # Convert fee to monthly rate
        fee_adjusted[[paste0("Return - ", fee, " bps")]] <- fee_adjusted$returns - fee_rate  # Adjust returns
    }

    # Reshape to long format (without cumulative returns)
    fee_adjusted_long <- fee_adjusted %>%
        pivot_longer(cols = starts_with("Return"), names_to = "Type", values_to = "Rets")

    return(fee_adjusted_long)
}

