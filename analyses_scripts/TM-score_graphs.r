# #!/usr/bin/env Rscript
# R-script for correlation point graph of TM scores
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

# CB Colors
cols_cb_5 <- c("#A3A500", "#F8766D", "#E76BF3", "#00BF7D", "#00B0F6")
breaks_cb_5 <- c("HA", "EBOV", "MARV", "LASV1", "LASV2")

cols_cb_6 <- c("#A3A500", "#F8766D", "#E76BF3", "#00BF7D", "#00B0F6", "#FFA500")
breaks_cb_6 <- c("HA", "EBOV", "MARV", "LASV1", "LASV2", "RSV")

# RW Colors
cols_rw <- c("#FF0066", "#FFFF00", "#66FF66", "#9933FF")
breaks_rw <- c("JUNV", "LUJV", "CHAV", "MACV")

process_files <- function(file_pattern, set_type = "CB") {
  files <- list.files(pattern = file_pattern, full.names = TRUE)

  for (file in files) {
    df <- read.csv(file, sep = "", header = TRUE)
    base_name <- tools::file_path_sans_ext(basename(file))
    base_name <- gsub("plddt_", "", base_name)

    pt_pre_x <- NA
    pt_pre_y <- NA
    pt_post_x <- NA
    pt_post_y <- NA
    curr_colors <- NULL
    curr_breaks <- NULL

    if (grepl("def", base_name)) {
      # Default Results
      pt_pre_y <- 0.3522
      pt_post_x <- 0.0901
      pt_post_y <- 0.9922
      if (set_type == "RW") {
        pt_pre_x <- 0.9955
      } else {
        pt_pre_x <- 0.9885
      }
    } else {
      if (grepl("post", base_name)) {
        # wTemplate post-template
        pt_pre_x <- 0.7018
        pt_pre_y <- 0.3642
        pt_post_x <- 0.0974
        pt_post_y <- 0.9931
      } else {
        # wTemplate all & pre-templates
        pt_pre_x <- 0.9885
        pt_pre_y <- 0.2952
        pt_post_x <- 0.0895
        pt_post_y <- 0.9931
      }
    }

    if (set_type == "RW") {
      curr_colors <- cols_rw
      curr_breaks <- breaks_rw
    } else {
      # Logic for CB: If it's "cropped", use 5 colors, otherwise 6 (include RSV)
      if (grepl("cropped", base_name)) {
        curr_colors <- cols_cb_5
        curr_breaks <- breaks_cb_5
      } else {
        curr_colors <- cols_cb_6
        curr_breaks <- breaks_cb_6
      }
    }

    pl <- ggplot() +
      geom_point(data = df, aes(x = pre_TM, y = post_TM, fill = virus), size = 4.0, stroke = 0.375, pch = 21, color = "dark blue", alpha = 0.7) +
      scale_x_continuous(limits = c(0, 1)) +
      scale_y_continuous(limits = c(0, 1)) +
      labs(x = "TM-score (prefusion)", y = "TM-score (postfusion)") +
      ggtitle(base_name) +
      my_theme +
      geom_point(aes(alpha = "control-prefusion", x = pt_pre_x, y = pt_pre_y), shape = 9, size = 4, stroke = 1, color = "black") +
      geom_point(aes(alpha = "control-postfusion", x = pt_post_x, y = pt_post_y), shape = 7, stroke = 1, size = 4, color = "black") +
      scale_fill_manual(breaks = curr_breaks, values = curr_colors) +
      guides(fill = guide_legend(override.aes = list(size = 8))) +
      geom_hline(aes(yintercept = 0.45), linetype = "dotted", color = "black", linewidth = 0.5) +
      geom_vline(aes(xintercept = 0.45), linetype = "dotted", color = "black", linewidth = 0.5) +
      scale_alpha_manual(name = NULL, values = c(1, 1), breaks = c("control-prefusion", "control-postfusion"), guide = guide_legend(override.aes = list(shape = c(9, 7))))

    ggsave(pl, filename = paste0(base_name, ".png"), type = "cairo", dpi = 300, width = 11.5, height = 6.92, units = "in")
  
    message(paste("Saved plot for:", base_name))
  }
}

setwd("pLDDT_TM_scores") # Edit the path based on your working directory which contains the data files

process_files(file_pattern = "CB.*\\.dat$", set_type = "CB")
process_files(file_pattern = "RW.*\\.dat$", set_type = "RW")

