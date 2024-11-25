install_and_load <- function(packages) {
    purrr::walk(packages, function(pkg) {
        if (!require(pkg, character.only = TRUE)) {
            install.packages(pkg, dependencies = TRUE)
            library(pkg, character.only = TRUE)
        }
    })
}