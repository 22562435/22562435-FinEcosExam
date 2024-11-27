# Function to assign weights for the portfolio
assign_weights <- function() {
    tibble(
        Tickers = c("MSCI_ACWI", "Bbg_Agg", "J433", "ALBI"),
        weight = c(0.18, 0.12, 0.42, 0.28)  # 70% local, 30% global split
    )
}