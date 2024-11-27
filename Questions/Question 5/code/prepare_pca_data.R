#  Prepare PCA data
prepare_pca_data <- function(vol_data) {
    vol_data %>%
        pivot_wider(names_from = Name, values_from = Price) %>%
        mutate(across(starts_with("V"), ~ log(. / lag(.)))) %>%
        drop_na() %>%
        {
            pca_result <- prcomp(select(., starts_with("V")), scale. = TRUE)
            mutate(., PC1 = predict(pca_result)[, 1])
        }
}
