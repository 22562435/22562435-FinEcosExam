Proportional_Cap_Foo <- function(df_Cons, W_Cap = 0.08){
    if (!"weight" %in% names(df_Cons)) stop("Provide a column 'weight'")
    if (!"Tickers" %in% names(df_Cons)) stop("Provide a column 'Tickers'")

    Breachers <- df_Cons %>% filter(weight > W_Cap) %>% pull(Tickers)

    while (df_Cons %>% filter(weight > W_Cap) %>% nrow() > 0) {
        df_Cons <- bind_rows(
            df_Cons %>% filter(Tickers %in% Breachers) %>% mutate(weight = W_Cap),
            df_Cons %>% filter(!Tickers %in% Breachers) %>%
                mutate(weight = (weight / sum(weight, na.rm = TRUE)) * (1 - length(Breachers) * W_Cap))
        )
        Breachers <- c(Breachers, df_Cons %>% filter(weight > W_Cap) %>% pull(Tickers))
    }

    if (abs(sum(df_Cons$weight, na.rm = TRUE) - 1) > 0.001) {
        stop("Weight adjustment failed to sum to 1.")
    }

    return(df_Cons)
}