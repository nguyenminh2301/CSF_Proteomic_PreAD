## =============================================================================
## figures_lancet.R
## Professional Figure Generation for PREVENT-AD Manuscript 3
## Lancet-style publication quality figures
## 
## PREREQUISITE: Run R_manu3.R first to generate analysis data
## =============================================================================

# ==== [In 0] Load required libraries ====
library(data.table)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)
# Font settings - use sans-serif fonts available on all systems
# For publication, fonts can be changed to Arial/Helvetica if installed
LANCET_FONT <- "sans"

# Base directory
BASE_DIR <- "d:/Data_Nghien_cuu/PREVENT-AD"
OUTPUT_DIR <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed")

# Create output directory if not exists
if (!dir.exists(OUTPUT_DIR)) {
  dir.create(OUTPUT_DIR, recursive = TRUE)
}

cat("============================================================\n")
cat("  LANCET-STYLE FIGURE GENERATION\n")
cat("  Font:", LANCET_FONT, "\n")
cat("============================================================\n\n")

# ==== LANCET COLOR PALETTE ====
# Official Lancet colors for medical publications
LANCET_COLORS <- c(
  primary_blue   = "#00468B",   # Deep blue
  primary_red    = "#ED0000",   # Red
  primary_green  = "#42B540",   # Green
  secondary_cyan = "#0099B4",   # Cyan
  secondary_purple = "#925E9F", # Purple
  secondary_orange = "#FDAF91", # Light orange
  secondary_crimson = "#AD002A", # Dark red
  neutral_gray   = "#7F7F7F",   # Gray
  light_gray     = "#E8E8E8"    # Light gray
)

# ==== LANCET THEME ====
theme_lancet <- function(base_size = 12) {
  theme_bw(base_size = base_size, base_family = LANCET_FONT) +
    theme(
      # Plot title
      plot.title = element_text(
        size = base_size + 4, 
        face = "bold", 
        hjust = 0,
        margin = margin(b = 10)
      ),
      # Subtitle
      plot.subtitle = element_text(
        size = base_size + 1, 
        hjust = 0,
        margin = margin(b = 15),
        color = "gray30"
      ),
      # Axis titles
      axis.title = element_text(
        size = base_size + 2, 
        face = "bold"
      ),
      # Axis text
      axis.text = element_text(
        size = base_size,
        color = "black"
      ),
      # Axis ticks
      axis.ticks = element_line(linewidth = 0.5, color = "black"),
      axis.ticks.length = unit(3, "pt"),
      # Panel
      panel.grid.major = element_line(linewidth = 0.3, color = "gray90"),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(linewidth = 0.8, color = "black", fill = NA),
      # Legend
      legend.title = element_text(
        size = base_size + 1, 
        face = "bold"
      ),
      legend.text = element_text(size = base_size),
      legend.position = "bottom",
      legend.box = "horizontal",
      legend.margin = margin(t = 10),
      legend.key.size = unit(0.8, "lines"),
      # Facet strips
      strip.background = element_rect(fill = "gray95", color = "black"),
      strip.text = element_text(
        size = base_size + 1, 
        face = "bold"
      ),
      # Plot margins
      plot.margin = margin(15, 15, 15, 15)
    )
}

# ==== LOAD DATA ====
cat("--- Loading analysis data ---\n")

# Load resilience model data
pwas_results <- fread(file.path(OUTPUT_DIR, "pwas_results_resilience.csv"))
resilience_scores <- fread(file.path(OUTPUT_DIR, "resilience_scores_n96.csv"))
proteomics_scores <- fread(file.path(OUTPUT_DIR, "resilience_scores_proteomics_n27.csv"))

# Load enrichment results if available
enrichment_file <- file.path(OUTPUT_DIR, "gsea_enrichment_results.csv")
if (file.exists(enrichment_file)) {
  all_enrichment <- fread(enrichment_file)
  cat("  Enrichment data loaded\n")
} else {
  cat("  Warning: Enrichment data not found\n")
  all_enrichment <- NULL
}

cat("  PWAS results:", nrow(pwas_results), "proteins\n")
cat("  Resilience scores (n=96):", nrow(resilience_scores), "\n\n")

# =============================================================================
# FIGURE 1A: MODEL DIAGNOSTICS (Professional Grid Layout)
# =============================================================================

cat("--- Generating Figure 1A: Model Diagnostics ---\n")

# Rebuild the resilience model from saved data
resilience_model <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, 
                       data = resilience_scores)

# Create professional diagnostic plots
create_diagnostics <- function(model, data) {
  # Extract model components
  fitted_vals <- fitted(model)
  residuals_vals <- residuals(model)
  std_residuals <- rstandard(model)
  sqrt_abs_stdres <- sqrt(abs(std_residuals))
  
  # Leverage and Cook's distance
  hat_vals <- hatvalues(model)
  cooks_d <- cooks.distance(model)
  
  # Calculate threshold
  threshold_4n <- 4 / length(fitted_vals)
  
  # Create data frame for ggplot
  diag_data <- data.frame(
    fitted = fitted_vals,
    residuals = residuals_vals,
    std_residuals = std_residuals,
    sqrt_abs_stdres = sqrt_abs_stdres,
    leverage = hat_vals,
    cooks_distance = cooks_d,
    obs_id = 1:length(fitted_vals),
    influential = factor(cooks_d > threshold_4n, levels = c(FALSE, TRUE), labels = c("FALSE", "TRUE"))
  )
  
  # Panel A: Residuals vs Fitted
  p1 <- ggplot(diag_data, aes(x = fitted, y = residuals)) +
    geom_point(alpha = 0.7, size = 2, color = LANCET_COLORS["primary_blue"]) +
    geom_hline(yintercept = 0, linetype = "dashed", 
               color = LANCET_COLORS["primary_red"], linewidth = 0.8) +
    geom_smooth(method = "loess", se = FALSE, 
                color = LANCET_COLORS["primary_red"], linewidth = 0.8) +
    labs(
      title = "A",
      x = "Fitted values",
      y = "Residuals"
    ) +
    theme_lancet(base_size = 11) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0),
      panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
    )
  
  # Panel B: Normal Q-Q Plot
  p2 <- ggplot(diag_data, aes(sample = std_residuals)) +
    stat_qq(alpha = 0.7, size = 2, color = LANCET_COLORS["primary_blue"]) +
    stat_qq_line(color = LANCET_COLORS["primary_red"], linewidth = 0.8) +
    labs(
      title = "B",
      x = "Theoretical quantiles",
      y = "Standardized residuals"
    ) +
    theme_lancet(base_size = 11) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0),
      panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
    )
  
  # Panel C: Scale-Location (Spread-Location)
  p3 <- ggplot(diag_data, aes(x = fitted, y = sqrt_abs_stdres)) +
    geom_point(alpha = 0.7, size = 2, color = LANCET_COLORS["primary_blue"]) +
    geom_smooth(method = "loess", se = FALSE, 
                color = LANCET_COLORS["primary_red"], linewidth = 0.8) +
    labs(
      title = "C",
      x = "Fitted values",
      y = expression(sqrt("|Standardized residuals|"))
    ) +
    theme_lancet(base_size = 11) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0),
      panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
    )
  
  # Panel D: Cook's Distance (influential already defined above)
  
  p4 <- ggplot(diag_data, aes(x = obs_id, y = cooks_distance)) +
    geom_col(aes(fill = influential), width = 0.7, show.legend = FALSE) +
    geom_hline(yintercept = threshold_4n, linetype = "dashed", 
               color = LANCET_COLORS["primary_red"], linewidth = 0.8) +
    scale_fill_manual(values = c("TRUE" = LANCET_COLORS["primary_red"], 
                                  "FALSE" = LANCET_COLORS["primary_blue"])) +
    labs(
      title = "D",
      x = "Observation",
      y = "Cook's distance",
      caption = paste0("Threshold = 4/n = ", round(threshold_4n, 3))
    ) +
    theme_lancet(base_size = 11) +
    theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0),
      plot.caption = element_text(size = 9, color = "gray40"),
      panel.grid.major.x = element_blank()
    )
  
  list(p1 = p1, p2 = p2, p3 = p3, p4 = p4)
}

diag_plots <- create_diagnostics(resilience_model, resilience_scores)

# Combine plots with gridExtra
fig1a_combined <- grid.arrange(
  diag_plots$p1, diag_plots$p2, 
  diag_plots$p3, diag_plots$p4,
  ncol = 2,
  top = textGrob(
    "Resilience Model Diagnostic Plots (n = 96)",
    gp = gpar(fontsize = 16, fontface = "bold", fontfamily = LANCET_FONT)
  ),
  bottom = textGrob(
    "Model: Cognitive Decline Rate ~ Amyloid + Tau + Age",
    gp = gpar(fontsize = 11, color = "gray40", fontfamily = LANCET_FONT)
  )
)

# Save Figure 1A
ggsave(file.path(OUTPUT_DIR, "Fig1A_diagnostics_lancet.png"), 
       fig1a_combined, width = 12, height = 11, dpi = 600)
ggsave(file.path(OUTPUT_DIR, "Fig1A_diagnostics_lancet.tiff"), 
       fig1a_combined, width = 12, height = 11, dpi = 600, compression = "lzw")
ggsave(file.path(OUTPUT_DIR, "Fig1A_diagnostics_lancet.pdf"), 
       fig1a_combined, width = 12, height = 11)

cat("  Figure 1A saved\n\n")

# =============================================================================
# FIGURE 1B: VOLCANO PLOT (Lancet Style)
# =============================================================================

cat("--- Generating Figure 1B: Volcano Plot ---\n")

# Prepare data for volcano plot
pwas_results$neg_log10_p <- -log10(pwas_results$p_value)
pwas_results$significance <- factor(
  ifelse(pwas_results$p_value < 0.01, "p < 0.01",
         ifelse(pwas_results$p_value < 0.05, "p < 0.05", "NS")),
  levels = c("NS", "p < 0.05", "p < 0.01")
)

# Select top proteins to label (most significant from each direction)
label_proteins <- pwas_results %>%
  filter(p_value < 0.001) %>%
  arrange(p_value) %>%
  head(12) %>%
  pull(protein)

pwas_results$label <- ifelse(pwas_results$protein %in% label_proteins, 
                             pwas_results$protein, "")

# Color palette for significance
sig_colors <- c(
  "NS"       = LANCET_COLORS["neutral_gray"],
  "p < 0.05" = LANCET_COLORS["secondary_orange"],
  "p < 0.01" = LANCET_COLORS["primary_red"]
)

fig1b <- ggplot(pwas_results, aes(x = beta, y = neg_log10_p)) +
  # Points
  geom_point(aes(color = significance, size = significance), alpha = 0.8) +
  scale_color_manual(values = sig_colors, name = "Significance") +
  scale_size_manual(values = c("p < 0.01" = 2.5, "p < 0.05" = 2, "NS" = 1.5),
                    name = "Significance") +
  
  # Threshold lines
  geom_hline(yintercept = -log10(0.05), linetype = "dotted", 
             color = LANCET_COLORS["neutral_gray"], linewidth = 0.6) +
  geom_hline(yintercept = -log10(0.01), linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 0.8) +
  
  # Labels for significant proteins
  geom_text(aes(label = label), size = 3.5, vjust = -0.8, hjust = 0.5,
            fontface = "bold", family = LANCET_FONT) +
  
  # Annotations
  annotate("text", x = max(pwas_results$beta) * 0.7, 
           y = -log10(0.01) + 0.3,
           label = "p = 0.01", size = 4, color = LANCET_COLORS["primary_red"],
           fontface = "bold") +
  annotate("text", x = max(pwas_results$beta) * 0.7, 
           y = -log10(0.05) + 0.2,
           label = "p = 0.05", size = 3.5, color = LANCET_COLORS["neutral_gray"]) +
  
  # Labels
  labs(
    title = "Proteome-Wide Association Study of Cognitive Resilience",
    subtitle = paste0(
      "n = 27 participants | ",
      nrow(pwas_results), " proteins tested | ",
      sum(pwas_results$p_value < 0.05), " at p < 0.05 | ",
      sum(pwas_results$p_value < 0.01), " at p < 0.01"
    ),
    x = expression("Effect size (" * beta * ")"),
    y = expression("-log"[10] * "(p-value)")
  ) +
  theme_lancet(base_size = 12) +
  theme(
    legend.position = c(0.85, 0.85),
    legend.background = element_rect(fill = "white", color = "gray80"),
    legend.box.margin = margin(5, 5, 5, 5)
  )

# Save Figure 1B
ggsave(file.path(OUTPUT_DIR, "Fig1B_volcano_lancet.png"), 
       fig1b, width = 12, height = 10, dpi = 600)
ggsave(file.path(OUTPUT_DIR, "Fig1B_volcano_lancet.tiff"), 
       fig1b, width = 12, height = 10, dpi = 600, compression = "lzw")
ggsave(file.path(OUTPUT_DIR, "Fig1B_volcano_lancet.pdf"), 
       fig1b, width = 12, height = 10)

cat("  Figure 1B saved\n\n")

# =============================================================================
# FIGURE 2: PATHWAY ENRICHMENT BUBBLE PLOT (Lancet Style)
# =============================================================================

cat("--- Generating Figure 2: Pathway Enrichment ---\n")

if (!is.null(all_enrichment) && nrow(all_enrichment) > 0) {
  
  # Prepare data
  pos_data <- all_enrichment %>%
    filter(Direction == "Positive", Adjusted.P.value < 0.2) %>%
    arrange(Adjusted.P.value) %>%
    head(15) %>%
    mutate(Direction = "Higher protein = Better resilience")
  
  neg_data <- all_enrichment %>%
    filter(Direction == "Negative", Adjusted.P.value < 0.2) %>%
    arrange(Adjusted.P.value) %>%
    head(15) %>%
    mutate(Direction = "Higher protein = Worse resilience")
  
  bubble_data <- bind_rows(pos_data, neg_data)
  
  # Extract overlap count
  bubble_data$Overlap_N <- as.numeric(sub("/.*", "", bubble_data$Overlap))
  
  # Clean and shorten pathway names
  bubble_data$Term_Clean <- bubble_data$Term %>%
    sub(" \\([^)]*\\)$", "", .) %>%  # Remove GO/Reactome IDs
    substr(1, 45)
  
  # Ensure unique labels
  bubble_data$Term_Clean <- make.unique(bubble_data$Term_Clean, sep = " ")
  
  # Create color palette for combined score
  fig2 <- ggplot(bubble_data, 
                 aes(x = -log10(Adjusted.P.value), 
                     y = reorder(Term_Clean, -log10(Adjusted.P.value)))) +
    geom_point(aes(size = Overlap_N, fill = Combined.Score), 
               alpha = 0.9, shape = 21, color = "white", stroke = 0.3) +
    
    # Color gradient
    scale_fill_gradientn(
      colors = c("#E8F4F8", LANCET_COLORS["secondary_cyan"], 
                 LANCET_COLORS["primary_blue"]),
      name = "Enrichment\nScore",
      trans = "log10"
    ) +
    
    # Size scale
    scale_size_continuous(
      name = "Gene\nOverlap",
      range = c(3, 10),
      breaks = c(2, 5, 10, 15)
    ) +
    
    # FDR threshold line
    geom_vline(xintercept = -log10(0.20), linetype = "dashed", 
               color = LANCET_COLORS["primary_red"], linewidth = 0.8, alpha = 0.7) +
    annotate("text", x = -log10(0.20) + 0.15, y = Inf,
             label = "FDR = 0.20", size = 3.5, color = LANCET_COLORS["primary_red"],
             angle = 90, hjust = 1.5, vjust = 0.5, fontface = "bold") +
    
    # Facets
    facet_wrap(~Direction, scales = "free_y", ncol = 2) +
    
    # Labels
    labs(
      title = "Pathway Over-Representation Analysis",
      subtitle = "Enrichr ORA of proteins at nominal p < 0.01",
      x = expression("-log"[10] * "(FDR)"),
      y = NULL
    ) +
    theme_lancet(base_size = 11) +
    theme(
      strip.background = element_rect(fill = "gray95", color = "black"),
      strip.text = element_text(size = 12, face = "bold"),
      axis.text.y = element_text(size = 9, face = "bold"),
      panel.spacing = unit(1, "lines"),
      legend.position = "right",
      legend.box = "vertical"
    )
  
  # Save Figure 2
  ggsave(file.path(OUTPUT_DIR, "Fig2_pathway_enrichment_lancet.png"), 
         fig2, width = 16, height = 12, dpi = 600)
  ggsave(file.path(OUTPUT_DIR, "Fig2_pathway_enrichment_lancet.tiff"), 
         fig2, width = 16, height = 12, dpi = 600, compression = "lzw")
  ggsave(file.path(OUTPUT_DIR, "Fig2_pathway_enrichment_lancet.pdf"), 
         fig2, width = 16, height = 12)
  
  cat("  Figure 2 saved\n\n")
} else {
  cat("  Skipping Figure 2 (no enrichment data)\n\n")
}

# =============================================================================
# FIGURE 3: RESILIENCE SCORE DISTRIBUTION (Additional)
# =============================================================================

cat("--- Generating Figure 3: Resilience Score Distribution ---\n")

# Distribution of resilience scores with demographic breakdown
fig3_data <- resilience_scores %>%
  mutate(
    Amyloid_Status = ifelse(amyloid_centiloid > 20, "Elevated", "Normal"),
    Age_Group = cut(age_years, breaks = c(60, 70, 75, 85), 
                    labels = c("60-70", "70-75", "75+"))
  )

fig3 <- ggplot(fig3_data, aes(x = resilience_score)) +
  geom_histogram(aes(fill = after_stat(count)), bins = 20, 
                 color = "white", linewidth = 0.3) +
  scale_fill_gradientn(colors = c(LANCET_COLORS["secondary_cyan"], 
                                  LANCET_COLORS["primary_blue"]),
                       guide = "none") +
  geom_vline(xintercept = 0, linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 1) +
  annotate("text", x = 0, y = Inf, vjust = 1.5, hjust = -0.1,
           label = "Expected\n(value)", size = 4, 
           color = LANCET_COLORS["primary_red"], fontface = "bold") +
  labs(
    title = "Distribution of Cognitive Resilience Scores",
    subtitle = paste0("n = ", nrow(fig3_data), 
                      " | Mean = ", round(mean(fig3_data$resilience_score), 2),
                      " | SD = ", round(sd(fig3_data$resilience_score), 2)),
    x = "Resilience Score (residuals)",
    y = "Frequency"
  ) +
  theme_lancet(base_size = 12)

# Save Figure 3
ggsave(file.path(OUTPUT_DIR, "Fig3_resilience_distribution_lancet.png"), 
       fig3, width = 10, height = 8, dpi = 600)
ggsave(file.path(OUTPUT_DIR, "Fig3_resilience_distribution_lancet.tiff"), 
       fig3, width = 10, height = 8, dpi = 600, compression = "lzw")
ggsave(file.path(OUTPUT_DIR, "Fig3_resilience_distribution_lancet.pdf"), 
       fig3, width = 10, height = 8)

cat("  Figure 3 saved\n\n")

# =============================================================================
# SUMMARY TABLE OF FIGURES
# =============================================================================

cat("============================================================\n")
cat("  FIGURE GENERATION COMPLETE\n")
cat("============================================================\n\n")

figures_generated <- list.files(OUTPUT_DIR, pattern = "_lancet\\.(png|tiff|pdf)$", 
                                full.names = FALSE)

cat("Figures generated:\n")
for (fig in sort(figures_generated)) {
  cat("  -", fig, "\n")
}

cat("\nOutput directory:\n")
cat("  ", OUTPUT_DIR, "\n")

cat("\n============================================================\n")
cat("  All figures follow Lancet style guidelines:\n")
cat("  - Font: ", LANCET_FONT, "\n")
cat("  - Resolution: 600 DPI (PNG/TIFF) + PDF for vector\n")
cat("  - Colors: Professional medical publication palette\n")
cat("============================================================\n")


# =============================================================================
# SUPPLEMENTARY FIGURE S1: DETAILED COOK'S DISTANCE ANALYSIS
# =============================================================================

cat("--- Generating Supplementary Figure S1: Cook's Distance Analysis ---\n")

# Cook's distance with threshold analysis
n_obs <- nrow(resilience_scores)
threshold_4n <- 4 / n_obs
cooks_values <- cooks.distance(resilience_model)

# Create data frame
cooks_data <- data.frame(
  observation = 1:n_obs,
  cooks_distance = cooks_values,
  participant_id = resilience_scores$CONP_ID,
  influential = cooks_values > threshold_4n
)

# Sort by Cook's distance
cooks_data <- cooks_data[order(-cooks_data$cooks_distance), ]
cooks_data$rank <- 1:nrow(cooks_data)

# Top 15 for bar plot
top_cooks <- head(cooks_data, 15)
top_cooks$participant_id <- factor(top_cooks$participant_id, 
                                   levels = rev(top_cooks$participant_id))

# Panel A: Bar plot of top Cook's distances
s1a <- ggplot(top_cooks, aes(x = cooks_distance, y = participant_id)) +
  geom_col(aes(fill = influential), width = 0.7, show.legend = FALSE) +
  geom_vline(xintercept = threshold_4n, linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 1) +
  scale_fill_manual(values = c("TRUE" = LANCET_COLORS["primary_red"], 
                                "FALSE" = LANCET_COLORS["primary_blue"])) +
  annotate("text", x = threshold_4n + 0.02, y = 2,
           label = paste0("Threshold = 4/n = ", round(threshold_4n, 3)),
           size = 4, color = LANCET_COLORS["primary_red"], 
           hjust = 0, fontface = "bold") +
  labs(
    title = "A",
    x = "Cook's Distance",
    y = "Participant ID"
  ) +
  theme_lancet(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0),
    axis.text.y = element_text(size = 9),
    panel.grid.major.y = element_blank()
  )

# Panel B: Histogram of all Cook's distances
s1b <- ggplot(cooks_data, aes(x = cooks_distance)) +
  geom_histogram(bins = 20, fill = LANCET_COLORS["primary_blue"], 
                 color = "white", alpha = 0.8) +
  geom_vline(xintercept = threshold_4n, linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 1) +
  annotate("text", x = threshold_4n + 0.01, y = Inf, vjust = 1.5, hjust = 0,
           label = paste0("Threshold\n", round(threshold_4n, 3)),
           size = 4, color = LANCET_COLORS["primary_red"], fontface = "bold") +
  labs(
    title = "B",
    x = "Cook's Distance",
    y = "Frequency"
  ) +
  theme_lancet(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0)
  )

# Panel C: Cook's distance vs Leverage
leverage_vals <- hatvalues(resilience_model)
stud_resid <- rstudent(resilience_model)

cooks_data$leverage <- leverage_vals[match(cooks_data$observation, 1:n_obs)]
cooks_data$stud_residual <- stud_resid[match(cooks_data$observation, 1:n_obs)]

s1c <- ggplot(cooks_data, aes(x = leverage, y = stud_residual)) +
  geom_point(aes(size = cooks_distance, color = influential), alpha = 0.7) +
  scale_color_manual(values = c("TRUE" = LANCET_COLORS["primary_red"], 
                                 "FALSE" = LANCET_COLORS["primary_blue"]),
                     guide = "none") +
  scale_size_continuous(range = c(2, 8), name = "Cook's D") +
  geom_hline(yintercept = 0, linetype = "solid", color = "gray50") +
  geom_hline(yintercept = c(-2, 2), linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], alpha = 0.5) +
  labs(
    title = "C",
    x = "Leverage (hat values)",
    y = "Studentized Residuals"
  ) +
  theme_lancet(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0)
  )

# Panel D: Summary statistics table as text annotation
influential_count <- sum(cooks_data$influential)
max_cooks <- max(cooks_data$cooks_distance)
max_idx <- which.max(cooks_values)
sensitivity_change <- abs((coef(lm(slope ~ amyloid_centiloid + tau_suvr + age_years, 
                                    data = resilience_scores[-max_idx, ]))["tau_suvr"] - 
                            coef(resilience_model)["tau_suvr"]) / 
                           coef(resilience_model)["tau_suvr"] * 100)

summary_text <- paste0(
  "Cook's Distance Summary\n",
  "═══════════════════════\n\n",
  "n = ", n_obs, "\n",
  "Threshold (4/n) = ", round(threshold_4n, 4), "\n",
  "Influential points = ", influential_count, " (", round(influential_count/n_obs*100, 1), "%)\n\n",
  "Maximum Cook's D:\n",
  "  Value = ", round(max_cooks, 4), "\n",
  "  Participant = ", resilience_scores$CONP_ID[max_idx], "\n\n",
  "Sensitivity Analysis:\n",
  "  Tau β change = ", round(sensitivity_change, 1), "%"
)

s1d <- ggplot() + 
  annotate("text", x = 0.5, y = 0.5, label = summary_text,
           size = 4.5, hjust = 0.5, vjust = 0.5, family = "mono",
           fontface = "plain") +
  xlim(0, 1) + ylim(0, 1) +
  labs(title = "D") +
  theme_void() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0, 
                               margin = margin(b = 10))
  )

# Combine S1 panels
fig_s1 <- grid.arrange(
  s1a, s1b, 
  s1c, s1d,
  ncol = 2,
  top = textGrob(
    "Supplementary Figure S1. Detailed Cook's Distance Analysis",
    gp = gpar(fontsize = 16, fontface = "bold", fontfamily = LANCET_FONT)
  ),
  bottom = textGrob(
    "Assessment of influential observations in the resilience model (n = 96)",
    gp = gpar(fontsize = 11, color = "gray40", fontfamily = LANCET_FONT)
  )
)

# Save Figure S1
ggsave(file.path(OUTPUT_DIR, "FigS1_cooks_distance_lancet.png"), 
       fig_s1, width = 14, height = 12, dpi = 600)
ggsave(file.path(OUTPUT_DIR, "FigS1_cooks_distance_lancet.tiff"), 
       fig_s1, width = 14, height = 12, dpi = 600, compression = "lzw")
ggsave(file.path(OUTPUT_DIR, "FigS1_cooks_distance_lancet.pdf"), 
       fig_s1, width = 14, height = 12)

cat("  Supplementary Figure S1 saved\n\n")

# =============================================================================
# COMBINED FIGURE 1: PANEL A (DIAGNOSTICS) + PANEL B (VOLCANO)
# =============================================================================

cat("--- Generating Combined Figure 1 (Panel A + Panel B) ---\n")

# We need to recreate the diagnostic and volcano plots with matching dimensions
# and proper panel labels

# Recreate simplified diagnostics (2x2 grid)
diag_data <- data.frame(
  fitted = fitted(resilience_model),
  residuals = residuals(resilience_model),
  std_residuals = rstandard(resilience_model)
)
diag_data$sqrt_abs_stdres <- sqrt(abs(diag_data$std_residuals))
diag_data$leverage <- hatvalues(resilience_model)
diag_data$cooks_distance <- cooks.distance(resilience_model)
diag_data$obs_id <- 1:nrow(diag_data)
diag_data$influential <- diag_data$cooks_distance > threshold_4n

# Simplified diagnostic plots for combined figure
d1 <- ggplot(diag_data, aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.7, size = 1.5, color = LANCET_COLORS["primary_blue"]) +
  geom_hline(yintercept = 0, linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 0.6) +
  geom_smooth(method = "loess", se = FALSE, 
              color = LANCET_COLORS["primary_red"], linewidth = 0.6) +
  labs(x = "Fitted values", y = "Residuals") +
  theme_lancet(base_size = 9) +
  theme(
    plot.title = element_blank(),
    panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
  )

d2 <- ggplot(diag_data, aes(sample = std_residuals)) +
  stat_qq(alpha = 0.7, size = 1.5, color = LANCET_COLORS["primary_blue"]) +
  stat_qq_line(color = LANCET_COLORS["primary_red"], linewidth = 0.6) +
  labs(x = "Theoretical quantiles", y = "Std. residuals") +
  theme_lancet(base_size = 9) +
  theme(
    plot.title = element_blank(),
    panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
  )

d3 <- ggplot(diag_data, aes(x = fitted, y = sqrt_abs_stdres)) +
  geom_point(alpha = 0.7, size = 1.5, color = LANCET_COLORS["primary_blue"]) +
  geom_smooth(method = "loess", se = FALSE, 
              color = LANCET_COLORS["primary_red"], linewidth = 0.6) +
  labs(x = "Fitted values", y = expression(sqrt("|Std. residuals|"))) +
  theme_lancet(base_size = 9) +
  theme(
    plot.title = element_blank(),
    panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
  )

d4 <- ggplot(diag_data, aes(x = obs_id, y = cooks_distance)) +
  geom_col(aes(fill = influential), width = 0.7, show.legend = FALSE) +
  geom_hline(yintercept = threshold_4n, linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 0.6) +
  scale_fill_manual(values = c("TRUE" = LANCET_COLORS["primary_red"], 
                                "FALSE" = LANCET_COLORS["primary_blue"])) +
  labs(x = "Observation", y = "Cook's D") +
  theme_lancet(base_size = 9) +
  theme(
    plot.title = element_blank(),
    panel.grid.major.x = element_blank()
  )

# Arrange diagnostics in 2x2 grid
diag_grid <- grid.arrange(d1, d2, d3, d4, ncol = 2,
                          top = textGrob("Model Diagnostics", 
                                         gp = gpar(fontsize = 12, fontface = "bold", 
                                                   fontfamily = LANCET_FONT)))

# Create volcano plot for combined figure (slightly smaller)
volcano_data <- pwas_results
volcano_data$significance <- factor(
  ifelse(volcano_data$p_value < 0.01, "p < 0.01",
         ifelse(volcano_data$p_value < 0.05, "p < 0.05", "NS")),
  levels = c("NS", "p < 0.05", "p < 0.01")
)

# Label key proteins including MEF2C
key_proteins <- c("MEF2C", label_proteins[1:min(5, length(label_proteins))])
volcano_data$label <- ifelse(volcano_data$protein %in% key_proteins, 
                             volcano_data$protein, "")

sig_colors_small <- c(
  "NS"       = LANCET_COLORS["neutral_gray"],
  "p < 0.05" = LANCET_COLORS["secondary_orange"],
  "p < 0.01" = LANCET_COLORS["primary_red"]
)

volcano_small <- ggplot(volcano_data, aes(x = beta, y = neg_log10_p)) +
  geom_point(aes(color = significance), alpha = 0.8, size = 1.5) +
  scale_color_manual(values = sig_colors_small, guide = "none") +
  geom_hline(yintercept = -log10(0.05), linetype = "dotted", 
             color = LANCET_COLORS["neutral_gray"], linewidth = 0.5) +
  geom_hline(yintercept = -log10(0.01), linetype = "dashed", 
             color = LANCET_COLORS["primary_red"], linewidth = 0.7) +
  geom_text(aes(label = label), size = 3, vjust = -0.6, hjust = 0.5,
            fontface = "bold", family = LANCET_FONT) +
  annotate("text", x = max(volcano_data$beta) * 0.6, 
           y = -log10(0.01) + 0.25,
           label = "p = 0.01", size = 3, color = LANCET_COLORS["primary_red"],
           fontface = "bold") +
  labs(
    title = "PWAS Volcano Plot",
    x = expression(beta),
    y = expression("-log"[10] * "(p)")
  ) +
  theme_lancet(base_size = 10) +
  theme(
    plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
    panel.grid.major = element_line(linewidth = 0.2, color = "gray90")
  )

# Create the combined figure using cowplot-style arrangement
# Use grid.arrange with layout

# Create panel labels
panel_a <- textGrob("A", gp = gpar(fontsize = 20, fontface = "bold", 
                                    fontfamily = LANCET_FONT))
panel_b <- textGrob("B", gp = gpar(fontsize = 20, fontface = "bold", 
                                    fontfamily = LANCET_FONT))

# Main title
title_grob <- textGrob(
  "Proteome-Wide Association Study of Cognitive Resilience",
  gp = gpar(fontsize = 16, fontface = "bold", fontfamily = LANCET_FONT)
)

# Subtitle
subtitle_grob <- textGrob(
  paste0("n = ", nrow(proteomics_scores), " participants | ",
         nrow(pwas_results), " proteins | ",
         sum(pwas_results$p_value < 0.05), " at p < 0.05 | ",
         sum(pwas_results$p_value < 0.01), " at p < 0.01"),
  gp = gpar(fontsize = 11, color = "gray40", fontfamily = LANCET_FONT)
)

# Arrange: Title on top, then Panel A (left) and Panel B (right)
# Use a 2x2 layout with proper spacing

# Create the combined layout
fig1_combined <- grid.arrange(
  arrangeGrob(d1, d2, d3, d4, ncol = 2, 
              top = textGrob("A", x = 0.02, y = 0.98, 
                            gp = gpar(fontsize = 18, fontface = "bold"))),
  arrangeGrob(ggplotGrob(volcano_small),
              top = textGrob("B", x = 0.02, y = 0.98,
                            gp = gpar(fontsize = 18, fontface = "bold"))),
  ncol = 2,
  widths = c(1, 0.9),
  top = title_grob,
  bottom = subtitle_grob
)

# Save Combined Figure 1
ggsave(file.path(OUTPUT_DIR, "Fig1_combined_lancet.png"), 
       fig1_combined, width = 16, height = 10, dpi = 600)
ggsave(file.path(OUTPUT_DIR, "Fig1_combined_lancet.tiff"), 
       fig1_combined, width = 16, height = 10, dpi = 600, compression = "lzw")
ggsave(file.path(OUTPUT_DIR, "Fig1_combined_lancet.pdf"), 
       fig1_combined, width = 16, height = 10)

cat("  Combined Figure 1 (Panel A + B) saved\n\n")

# =============================================================================
# SUPPLEMENTARY FIGURE S2: SENSITIVITY ANALYSIS FOR PATHWAY ENRICHMENT
# =============================================================================

cat("--- Generating Supplementary Figure S2: Sensitivity Analysis ---\n")

# Ensure enrichR is loaded
if (!require("enrichR", quietly = TRUE)) {
  install.packages("enrichR", repos = "http://cran.us.r-project.org")
}
library(enrichR)

# Define selected databases (same as in main analysis)
selected_dbs <- c(
  "GO_Biological_Process_2023",
  "GO_Cellular_Component_2023", 
  "GO_Molecular_Function_2023",
  "KEGG_2021_Human",
  "Reactome_2022",
  "WikiPathway_2023_Human"
)

# Function to run enrichment for a given p-value threshold
run_enrichment_for_threshold <- function(pwas_results, p_threshold, databases) {
  
  # Filter proteins at this threshold
  sig_proteins <- pwas_results[pwas_results$p_value < p_threshold, ]
  
  if (nrow(sig_proteins) == 0) {
    return(NULL)
  }
  
  # Separate by direction
  pos_proteins <- sig_proteins$protein[sig_proteins$beta > 0]
  neg_proteins <- sig_proteins$protein[sig_proteins$beta < 0]
  
  # Run enrichR if proteins available
  results_list <- list()
  
  if (length(pos_proteins) >= 2) {
    enriched_pos <- enrichr(pos_proteins, databases)
    # Combine all DB results
    pos_all <- data.frame()
    for (db in names(enriched_pos)) {
      if (nrow(enriched_pos[[db]]) > 0) {
        temp <- enriched_pos[[db]]
        temp$Database <- db
        temp$Direction <- "Positive"
        pos_all <- rbind(pos_all, temp)
      }
    }
    if (nrow(pos_all) > 0) {
      pos_all$Threshold <- paste0("p < ", p_threshold)
      results_list[[length(results_list) + 1]] <- pos_all
    }
  }
  
  if (length(neg_proteins) >= 2) {
    enriched_neg <- enrichr(neg_proteins, databases)
    neg_all <- data.frame()
    for (db in names(enriched_neg)) {
      if (nrow(enriched_neg[[db]]) > 0) {
        temp <- enriched_neg[[db]]
        temp$Database <- db
        temp$Direction <- "Negative"
        neg_all <- rbind(neg_all, temp)
      }
    }
    if (nrow(neg_all) > 0) {
      neg_all$Threshold <- paste0("p < ", p_threshold)
      results_list[[length(results_list) + 1]] <- neg_all
    }
  }
  
  if (length(results_list) > 0) {
    return(do.call(rbind, results_list))
  } else {
    return(NULL)
  }
}

# Define thresholds for sensitivity analysis
thresholds <- c(0.001, 0.005, 0.01, 0.05)
threshold_labels <- c("p < 0.001", "p < 0.005", "p < 0.01", "p < 0.05")

# Run enrichment for each threshold
sensitivity_results <- list()
for (i in seq_along(thresholds)) {
  cat("  Running enrichment for", threshold_labels[i], "...\n")
  result <- run_enrichment_for_threshold(pwas_results, thresholds[i], selected_dbs)
  if (!is.null(result)) {
    sensitivity_results[[threshold_labels[i]]] <- result
  }
}

# Combine all results
all_sensitivity <- do.call(rbind, sensitivity_results)

# Save sensitivity analysis results
sensitivity_out <- file.path(OUTPUT_DIR, "sensitivity_enrichment_results.csv")
write.csv(all_sensitivity, sensitivity_out, row.names = FALSE)
cat("  Sensitivity results saved to:", sensitivity_out, "\n")

# Create bubble plots for each threshold comparison
# We will show: p < 0.001 (A), p < 0.005 (B), p < 0.05 (C)
# Compare with primary p < 0.01

create_sensitivity_plot <- function(enrichment_df, threshold_label, panel_title) {
  
  # Filter for this threshold
  df <- enrichment_df[enrichment_df$Threshold == threshold_label, ]
  
  if (is.null(df) || nrow(df) == 0) {
    return(ggplot() + 
             annotate("text", x = 0.5, y = 0.5, 
                     label = paste0("No pathways at ", threshold_label),
                     size = 5, hjust = 0.5, vjust = 0.5) +
             theme_void() +
             labs(title = panel_title))
  }
  
  # Get top pathways per direction
  pos_df <- df[df$Direction == "Positive" & df$Adjusted.P.value < 0.2, ]
  if (nrow(pos_df) > 10) {
    pos_df <- pos_df[order(pos_df$Adjusted.P.value), ][1:10, ]
  }
  
  neg_df <- df[df$Direction == "Negative" & df$Adjusted.P.value < 0.2, ]
  if (nrow(neg_df) > 10) {
    neg_df <- neg_df[order(neg_df$Adjusted.P.value), ][1:10, ]
  }
  
  plot_df <- rbind(pos_df, neg_df)
  
  if (nrow(plot_df) == 0) {
    return(ggplot() + 
             annotate("text", x = 0.5, y = 0.5, 
                     label = paste0("No significant pathways\nat FDR < 0.2 for ", threshold_label),
                     size = 5, hjust = 0.5, vjust = 0.5) +
             theme_void() +
             labs(title = panel_title))
  }
  
  # Clean pathway names
  plot_df$Term_Clean <- substr(sub(" \\([^)]*\\)$", "", plot_df$Term), 1, 40)
  plot_df$Overlap_N <- as.numeric(sub("/.*", "", plot_df$Overlap))
  
  # Create direction label
  plot_df$Direction_Label <- ifelse(plot_df$Direction == "Positive", 
                                    "Higher = Better resilience",
                                    "Higher = Worse resilience")
  
  ggplot(plot_df, aes(x = -log10(Adjusted.P.value), 
                      y = reorder(Term_Clean, -log10(Adjusted.P.value)))) +
    geom_point(aes(size = Overlap_N, fill = Combined.Score), 
               alpha = 0.85, shape = 21, color = "white", stroke = 0.3) +
    scale_fill_gradientn(
      colors = c("#E8F4F8", LANCET_COLORS["secondary_cyan"], LANCET_COLORS["primary_blue"]),
      name = "Score",
      trans = "log10"
    ) +
    scale_size_continuous(range = c(3, 8), name = "N genes") +
    geom_vline(xintercept = -log10(0.20), linetype = "dashed", 
               color = LANCET_COLORS["primary_red"], linewidth = 0.7, alpha = 0.7) +
    facet_wrap(~Direction_Label, scales = "free_y", ncol = 1) +
    labs(
      title = panel_title,
      x = expression("-log"[10] * "(FDR)"),
      y = NULL
    ) +
    theme_lancet(base_size = 9) +
    theme(
      plot.title = element_text(size = 11, face = "bold", hjust = 0.5),
      strip.background = element_rect(fill = "gray95", color = "black"),
      strip.text = element_text(size = 9, face = "bold"),
      axis.text.y = element_text(size = 7.5),
      panel.spacing = unit(0.5, "lines"),
      legend.position = "none"
    )
}

# Create plots for each threshold
s2_a <- create_sensitivity_plot(all_sensitivity, "p < 0.001", "A: p < 0.001")
s2_b <- create_sensitivity_plot(all_sensitivity, "p < 0.005", "B: p < 0.005")
s2_c <- create_sensitivity_plot(all_sensitivity, "p < 0.05", "C: p < 0.05")
s2_primary <- create_sensitivity_plot(all_sensitivity, "p < 0.01", "Primary: p < 0.01")

# Arrange in 2x2 grid
fig_s2 <- grid.arrange(
  arrangeGrob(s2_a, s2_b, ncol = 2),
  arrangeGrob(s2_primary, s2_c, ncol = 2),
  nrow = 2,
  top = textGrob(
    "Supplementary Figure S2. Sensitivity Analysis: Pathway Enrichment Across P-value Thresholds",
    gp = gpar(fontsize = 14, fontface = "bold", fontfamily = LANCET_FONT)
  ),
  bottom = textGrob(
    "Bubble plots show pathway over-representation at different protein selection thresholds. Row 1: Stringent thresholds (p < 0.001, p < 0.005); Row 2: Primary threshold (p < 0.01) and lenient threshold (p < 0.05).",
    gp = gpar(fontsize = 9, color = "gray40", fontfamily = LANCET_FONT)
  )
)

# Save Figure S2
ggsave(file.path(OUTPUT_DIR, "FigS2_sensitivity_analysis_lancet.png"), 
       fig_s2, width = 16, height = 14, dpi = 600)
ggsave(file.path(OUTPUT_DIR, "FigS2_sensitivity_analysis_lancet.tiff"), 
       fig_s2, width = 16, height = 14, dpi = 600, compression = "lzw")
ggsave(file.path(OUTPUT_DIR, "FigS2_sensitivity_analysis_lancet.pdf"), 
       fig_s2, width = 16, height = 14)

cat("  Supplementary Figure S2 saved\n\n")

# =============================================================================
# FINAL SUMMARY
# =============================================================================

cat("============================================================\n")
cat("  FIGURE GENERATION COMPLETE\n")
cat("============================================================\n\n")

figures_generated <- list.files(OUTPUT_DIR, pattern = "_lancet\\.(png|tiff|pdf)$", 
                                full.names = FALSE)

cat("Figures generated:\n")
for (fig in sort(figures_generated)) {
  cat("  -", fig, "\n")
}

cat("\nOutput directory:\n")
cat("  ", OUTPUT_DIR, "\n")

cat("\n============================================================\n")
cat("  All figures follow Lancet style guidelines:\n")
cat("  - Font: ", LANCET_FONT, "\n")
cat("  - Resolution: 600 DPI (PNG/TIFF) + PDF for vector\n")
cat("  - Colors: Professional medical publication palette\n")
cat("\n")
cat("  Main Figures:\n")
cat("    - Fig1_combined_lancet.* : Panel A (diagnostics) + Panel B (volcano)\n")
cat("    - Fig2_pathway_enrichment_lancet.* : Pathway bubble plot\n")
cat("    - Fig3_resilience_distribution_lancet.* : Resilience score distribution\n")
cat("\n")
cat("  Supplementary Figures:\n")
cat("    - FigS1_cooks_distance_lancet.* : Detailed Cook's distance analysis\n")
cat("    - FigS2_sensitivity_analysis_lancet.* : Sensitivity analysis across p-value thresholds\n")
cat("============================================================\n")
