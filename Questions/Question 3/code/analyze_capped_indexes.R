analyze_capped_indexes <- function(ALSI, RebDays, column = "J403", caps = c(0.05, 0.10)) {
    library(dplyr)
    library(purrr)
    library(ggplot2)
    library(glue)

    rebalance_days <- RebDays %>% filter(Date_Type == "Effective Date")
    alsi_filtered <- ALSI %>% filter(date %in% rebalance_days$date)

    weights_list <- map(caps, ~ apply_capping(alsi_filtered %>% mutate(weight = !!sym(column)), .x))
    weights_list <- c(weights_list, list(alsi_filtered %>% mutate(weight = !!sym(column))))

    returns_list <- map(weights_list, ~ compute_returns(.x, ALSI))

    returns_all <- bind_rows(
        map2(returns_list, c(as.character(caps * 100), "Uncapped"),
             ~ .x %>% mutate(capping_level = paste0(.y, "%")))
    )

    plot_capped_returns(returns_all, column)
}
