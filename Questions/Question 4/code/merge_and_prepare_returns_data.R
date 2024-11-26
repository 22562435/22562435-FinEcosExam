# Function to prepare the returns data by merging and renaming columns

merge_and_prepare_returns_data <- function(port_rets, bm_rets, fund_col = "Returns", date_col = "date") {
    port_rets %>%
        rename(Fund = !!rlang::sym(fund_col)) %>%
        left_join(bm_rets, by = date_col) %>%
        select(!!rlang::sym(date_col), Fund, BM)
}