# Question 2

``` r
plot_portfolio_relationships(tidy_data, "hedged_return", "currency_returns")
```

![](README_files/figure-gfm/plot-scatter-1.png)<!-- -->

``` r
calculate_metrics(
  data = tidy_data,
  start_date = "2004-12-01",
  row_variables = c("hedged_return", "unhedged_return"),
  reference_variable = "$ZAR.USD"
)
```

    ## # A tibble: 2 × 4
    ##   Tickers         Correlation with $ZAR.U…¹ `Annual Return` `Standard Deviation`
    ##   <chr>                               <dbl>           <dbl>                <dbl>
    ## 1 Hedged Return                      -0.100          0.0516               0.188 
    ## 2 Unhedged Return                    -0.116          0.0988               0.0991
    ## # ℹ abbreviated name: ¹​`Correlation with $ZAR.USD`
