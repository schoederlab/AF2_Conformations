#!/usr/bin/env Rscript
# R-script for correlation point graph of TM and plddt score
# Author: Sevilay Gulesen

library(tidyr)
library(ggplot2)
library(dplyr)
library(tools)

my_theme <- theme_light() +
    theme(
        legend.title = element_text(face = "bold", size = 26),
        legend.text = element_text(size = 22, margin = margin(b = 8)),
        legend.spacing.y = unit(5, "mm"),
        panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
        axis.title.y = element_text(size = 28, face = "bold", margin = margin(r = 10)),
        axis.title.x = element_text(size = 28, face = "bold", margin = margin(t = 10)),
        axis.text.y = element_text(size = 24, colour = "black"),
        axis.text.x = element_text(size = 24, colour = "black"),
        aspect.ratio = 1,
        plot.title = element_text(color = "black", size = 22, face = "bold.italic", hjust = 0)
    )

# RW Colors
cols_rw <- c("#FF0066", "#FFFF00", "#66FF66", "#9933FF")
breaks_rw <- c("JUNV", "LUJV", "CHAV", "MACV")

create_plot <- function(data, y_col, y_label, plot_title, colors, breaks) {
    ggplot(data, aes(x = N_plddt, y = .data[[y_col]], fill = virus)) +
        geom_point(size = 4.0, stroke = 0.375, pch = 21, color = "dark blue", alpha = 0.7) +
        scale_x_continuous(limits = c(0, 1)) +
        scale_y_continuous(limits = c(0, 1)) +
        labs(x = "Normalized pLDDT score", y = y_label) +
        ggtitle(plot_title) +
        my_theme +
        scale_fill_manual(breaks = breaks, values = colors) +
        guides(fill = guide_legend(override.aes = list(size = 8)))
}

process_files <- function(file_pattern) {
    files <- list.files(pattern = file_pattern, full.names = TRUE)

    for (file in files) {
        df <- read.csv(file, sep = "", header = TRUE)
        base_name <- tools::file_path_sans_ext(basename(file))
        df$N_plddt <- (df$plddt) / 100

        pl_pre <- create_plot(df, "pre_TM", "TM-score (prefusion)", base_name, cols_rw, breaks_rw)
        pl_post <- create_plot(df, "post_TM", "TM-score (postfusion)", base_name, cols_rw, breaks_rw)

        ggsave(pl_pre,filename = paste0(base_name, "_pre.png"),type = "cairo", dpi = 300, width = 11.5, height = 6.92, units = "in" )
        ggsave(pl_post,filename = paste0(base_name, "_post.png"),type = "cairo", dpi = 300, width = 11.5, height = 6.92, units = "in")

        message(paste("Saved plots for:", base_name))
    }
}

setwd("RW_Prefusion-Specific_analyses") # Edit the path based on your working directory which contains the data files

process_files(file_pattern = "RW.*\\.dat$")

