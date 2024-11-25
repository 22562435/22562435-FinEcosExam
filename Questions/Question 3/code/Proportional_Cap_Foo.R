Proportional_Cap_Foo <- function(df_Cons, W_Cap = 0.08, max_iter = 100) {
    if (!"weight" %in% names(df_Cons)) stop("Provide a 'weight' column.")
    if (!"date" %in% names(df_Cons)) stop("Provide a 'date' column.")
    if (!"Tickers" %in% names(df_Cons)) stop("Provide a 'Tickers' column.")

    # Start with the original data and initialize variables
    iter <- 0
    is_adjusted <- TRUE

    while (is_adjusted && iter < max_iter) {
        iter <- iter + 1
        # Identify breachers
        Breachers <- df_Cons %>% filter(weight > W_Cap) %>% pull(Tickers)

        if (length(Breachers) == 0) {
            is_adjusted <- FALSE
        } else {
            df_Cons <- bind_rows(
                df_Cons %>% filter(Tickers %in% Breachers) %>% mutate(weight = W_Cap),
                df_Cons %>% filter(!Tickers %in% Breachers) %>%
                    mutate(weight = (weight / sum(weight, na.rm = TRUE)) * (1 - length(Breachers) * W_Cap))
            )
        }
    }

    # Check for convergence
    total_weight <- sum(df_Cons$weight, na.rm = TRUE)
    max_weight <- max(df_Cons$weight, na.rm = TRUE)

    if (abs(total_weight - 1) > 0.001 || max_weight > W_Cap) {
        warning(glue::glue(
            "Weight adjustment did not converge for date: {unique(df_Cons$date)}. Final total weight: {total_weight}, max weight: {max_weight}."
        ))
    }

    return(df_Cons)
}