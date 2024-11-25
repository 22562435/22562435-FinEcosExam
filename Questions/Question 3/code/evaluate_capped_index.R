evaluate_capped_index <- function(ALSI, RebDays, capping_levels = c(0.05, 0.10, Inf), top_n = 30, SWIX = FALSE) {
    # Determine which column to use for calculations based on SWIX
    index_col <- if (SWIX) "J403" else "J203"
    title_subtitle <- if (SWIX) "SWIX (J403)" else "ALSI (J203)"

    ALSI <- ALSI %>%
        filter(date %in% RebDays$date) %>%
        mutate(RebalanceTime = format(date, "%Y%B")) %>%
        group_by(RebalanceTime) %>%
        arrange(desc(.data[[index_col]])) %>% # Dynamically reference the chosen index column
        top_n(top_n, .data[[index_col]]) %>%
        mutate(weight = .data[[index_col]] / sum(.data[[index_col]])) %>% # Normalize weights
        ungroup() %>%
        arrange(date)

    results <- list()

    for (cap in capping_levels) {
        capped_weights <- ALSI %>%
            group_split(RebalanceTime) %>%
            map_df(~Proportional_Cap_Foo(., W_Cap = cap)) %>%
            select(-RebalanceTime)

        # Convert weights and returns to xts for portfolio evaluation
        wts <- capped_weights %>%
            tbl_xts(cols_to_xts = weight, spread_by = Tickers)

        rts <- ALSI %>%
            filter(Tickers %in% unique(capped_weights$Tickers)) %>%
            tbl_xts(cols_to_xts = Return, spread_by = Tickers)

        wts[is.na(wts)] <- 0
        rts[is.na(rts)] <- 0

        idx <- rmsfuns::Safe_Return.portfolio(R = rts, weights = wts, lag_weights = TRUE) %>%
            xts_tbl() %>%
            rename(portfolio_returns = portfolio.returns)

        results[[as.character(cap)]] <- idx %>%
            mutate(Index = cumprod(1 + portfolio_returns)) %>%
            mutate(Cap_Level = ifelse(cap == Inf, "Uncapped", paste0(cap * 100, "% Capped")))
    }

    # Combine all results for visualization
    bind_rows(results) %>%
        ggplot() +
        geom_line(aes(x = date, y = Index, color = Cap_Level)) +
        labs(
            title = "Capped Index Performance",
            subtitle = paste("Comparison of Capping Levels for", title_subtitle),
            x = "",
            y = "Index Value"
        ) +
        fmxdat::theme_fmx()
}