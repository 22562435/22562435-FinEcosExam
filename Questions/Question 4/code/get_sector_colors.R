# Define a consistent color palette for sectors
get_sector_colors <- function(sectors) {
    palette <- RColorBrewer::brewer.pal(3, "Set3") # Adjust for number of sectors
    if (length(sectors) > length(palette)) {
        # Expand palette if needed
        palette <- colorRampPalette(palette)(length(sectors))
    }
    setNames(palette, sectors)
}
