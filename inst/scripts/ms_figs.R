library(dplyr)

d <- prep_table(where = "online")
d$env_process <- ifelse(d$env_collinearity == TRUE, TRUE, d$env_process)
d$study_region <- ifelse(d$backg_sample == TRUE, TRUE, d$study_region)
d$pred_inspect <- ifelse(d$pred_extrapolation == TRUE, TRUE, d$pred_inspect)
d$mod_combine <- d$mod_ensemble
d$mod_combine <- ifelse(d$mod_stack == TRUE, TRUE, d$mod_combine)
d <- select(d, -data_integration, -env_collinearity, -backg_sample,
            -pred_extrapolation, -mod_multispecies, -mod_mechanistic,
            -mod_stack, -mod_ensemble, -pred_general, -mod_fit) |>
  filter(name != "rgbif", name != "ibis.iSDM", name != "dismo")

pal <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a", "#66a61e", "#e6ab02",
         "#a6761d", "#666666")

pdf("fig3.pdf", height = 7, width = 16)
f2a <- plot_dendrogram(d, k = 8, cex = 0.7, diff_method = "binary",
                       k_colors = pal, horiz = TRUE, main = "")
f2b <- plot_dendrogram(d, k = 7, cex = 1, diff_method = "binary",
                       type = "phylogenic", repel = TRUE, k_colors = pal)
gridExtra::grid.arrange(f2a, f2b, nrow = 1, widths = c(10, 6))
dev.off() #nolint

clust <- plot_dendrogram(d, k = 8, cex = 0.7, diff_method = "binary",
                         k_colors = pal, horiz = TRUE, main = "",
                         return_clust = TRUE)
pkg_order <- rev(clust$labels[clust$order])

png("fig3.png", height = 480, width = 1100)
gridExtra::grid.arrange(f2a, f2b, nrow = 1, widths = c(10, 6))
dev.off() #nolint

pkg_cols <- pkg_order
names(pkg_cols) <- pkg_order
pkg_cols[1:4] <- pal[8]
pkg_cols[5] <- pal[7]
pkg_cols[6:7] <- pal[6]
pkg_cols[8:27] <- pal[5]
pkg_cols[28] <- pal[4]
pkg_cols[29:31] <- pal[3]
pkg_cols[32:34] <- pal[2]
pkg_cols[35] <- pal[1]

g <- plot_table(d,
                pkg_order = pkg_order,
                remove_empty_cats = TRUE)
ggplot2::ggsave("inst/img/pkgs.png", g, height = 10, width = 10)
