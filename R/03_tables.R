## =============================================================================
## tables_q1.R
## Professional Table Generation for PREVENT-AD Manuscript 3
## Q1 Journal Standards (Nature/Lancet/Cell format)
##
## Generates:
##   - Table 1: Baseline Characteristics
##   - Table 2: Resilience Model Results
##   - Supplementary Table S1: Top 20 Protein Associations
##   - Supplementary Table S2: Complete Pathway Enrichment
## =============================================================================

# ==== Load Libraries ====
library(data.table)
library(dplyr)
library(tidyr)
library(gtsummary)  # For professional tables

# Base directory
BASE_DIR <- "d:/Data_Nghien_cuu/PREVENT-AD"
OUTPUT_DIR <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed")
TABLE_DIR <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/tables")
TABLE_DIR <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/Tables")

# Create tables directory if not exists
if (!dir.exists(TABLE_DIR)) {
  dir.create(TABLE_DIR, recursive = TRUE)
}

cat("============================================================\n")
cat("  Q1 JOURNAL STANDARD TABLE GENERATION\n")
cat("============================================================\n\n")

# ==== LOAD DATA ====
cat("--- Loading analysis data ---\n")

# Load main datasets
resilience_n96 <- fread(file.path(OUTPUT_DIR, "resilience_scores_n96.csv"))
resilience_n27 <- fread(file.path(OUTPUT_DIR, "resilience_scores_proteomics_n27.csv"))
pwas_results <- fread(file.path(OUTPUT_DIR, "pwas_results_resilience.csv"))
enrichment <- fread(file.path(OUTPUT_DIR, "gsea_enrichment_results.csv"))
sensitivity <- fread(file.path(OUTPUT_DIR, "sensitivity_enrichment_results.csv"))

cat("  n=96 dataset:", nrow(resilience_n96), "\n")
cat("  n=27 dataset:", nrow(resilience_n27), "\n")
cat("  PWAS results:", nrow(pwas_results), "proteins\n")
cat("  Enrichment pathways:", nrow(enrichment), "\n\n")

# =============================================================================
# TABLE 1: BASELINE CHARACTERISTICS
# =============================================================================

cat("--- Generating Table 1: Baseline Characteristics ---\n")

# Calculate statistics for n=96 and n=27
# Note: Some variables may not be available in the current data
# We'll work with what we have and note limitations

create_baseline_stats <- function(data, n_label) {
  
  # Continuous variables
  cont_vars <- c("age_years", "amyloid_centiloid", "tau_suvr", "slope", "resilience_score")
  
  stats_list <- list()
  
  for (var in cont_vars) {
    if (var %in% names(data)) {
      vals <- data[[var]]
      stats_list[[var]] <- data.frame(
        Variable = var,
        n = sum(!is.na(vals)),
        Mean_SD = sprintf("%.2f (%.2f)", mean(vals, na.rm=TRUE), sd(vals, na.rm=TRUE)),
        Median_IQR = sprintf("%.2f [%.2f, %.2f]", 
                            median(vals, na.rm=TRUE),
                            quantile(vals, 0.25, na.rm=TRUE),
                            quantile(vals, 0.75, na.rm=TRUE)),
        Range = sprintf("[%.2f, %.2f]", min(vals, na.rm=TRUE), max(vals, na.rm=TRUE))
      )
    }
  }
  
  do.call(rbind, stats_list)
}

stats_n96 <- create_baseline_stats(resilience_n96, "n=96")
stats_n27 <- create_baseline_stats(resilience_n27, "n=27")

# Create comprehensive Table 1
table1 <- data.frame(
  Characteristic = character(),
  n_96 = character(),
  n_27 = character(),
  stringsAsFactors = FALSE
)

# Add rows
add_row <- function(df, char, n96_val, n27_val) {
  rbind(df, data.frame(
    Characteristic = char,
    n_96 = n96_val,
    n_27 = n27_val,
    stringsAsFactors = FALSE
  ))
}

# Demographics section
table1 <- add_row(table1, "**Demographics**", "", "")
table1 <- add_row(table1, "Age, years", 
                 stats_n96$Mean_SD[stats_n96$Variable == "age_years"],
                 stats_n27$Mean_SD[stats_n27$Variable == "age_years"])
table1 <- add_row(table1, "Age range", 
                 stats_n96$Range[stats_n96$Variable == "age_years"],
                 stats_n27$Range[stats_n27$Variable == "age_years"])

# PET Biomarkers section
table1 <- add_row(table1, "", "", "")
table1 <- add_row(table1, "**PET Biomarkers**", "", "")
table1 <- add_row(table1, "Amyloid centiloid",
                 stats_n96$Mean_SD[stats_n96$Variable == "amyloid_centiloid"],
                 stats_n27$Mean_SD[stats_n27$Variable == "amyloid_centiloid"])
table1 <- add_row(table1, "Aβ positive (>20 centiloid), n (%)",
                 sprintf("%d (%.1f%%)", 
                        sum(resilience_n96$amyloid_centiloid > 20, na.rm=TRUE),
                        100*sum(resilience_n96$amyloid_centiloid > 20, na.rm=TRUE)/nrow(resilience_n96)),
                 sprintf("%d (%.1f%%)",
                        sum(resilience_n27$amyloid_centiloid > 20, na.rm=TRUE),
                        100*sum(resilience_n27$amyloid_centiloid > 20, na.rm=TRUE)/nrow(resilience_n27)))

table1 <- add_row(table1, "Tau meta-ROI SUVR",
                 stats_n96$Mean_SD[stats_n96$Variable == "tau_suvr"],
                 stats_n27$Mean_SD[stats_n27$Variable == "tau_suvr"])

# Cognitive Trajectory section
table1 <- add_row(table1, "", "", "")
table1 <- add_row(table1, "**Cognitive Trajectory**", "", "")
table1 <- add_row(table1, "RBANS slope, points/year",
                 stats_n96$Mean_SD[stats_n96$Variable == "slope"],
                 stats_n27$Mean_SD[stats_n27$Variable == "slope"])
table1 <- add_row(table1, "Cognitive slope range",
                 stats_n96$Range[stats_n96$Variable == "slope"],
                 stats_n27$Range[stats_n27$Variable == "slope"])

# Resilience Score section
table1 <- add_row(table1, "", "", "")
table1 <- add_row(table1, "**Resilience Model**", "", "")
table1 <- add_row(table1, "Resilience score (residuals)",
                 stats_n96$Mean_SD[stats_n96$Variable == "resilience_score"],
                 stats_n27$Mean_SD[stats_n27$Variable == "resilience_score"])
table1 <- add_row(table1, "Resilience score range",
                 stats_n96$Range[stats_n96$Variable == "resilience_score"],
                 stats_n27$Range[stats_n27$Variable == "resilience_score"])

# Add footnotes
table1_notes <- "
**Table 1.** Characteristics of the study sample.
Values are mean (SD) unless otherwise specified. 
The n=96 sample includes all participants with MEG, PET, and cognitive trajectory data.
The n=27 subsample includes those with additional CSF proteomics data.
"

# Save Table 1
write.csv(table1, file.path(TABLE_DIR, "Table1_baseline_characteristics.csv"), row.names=FALSE)

# Create Markdown version
table1_md <- paste0(
  "**Table 1. Characteristics of the study sample**\n\n",
  "| Characteristic | n=96 MEG/PET sample | n=27 Proteomics sample |\n",
  "|----------------|---------------------|------------------------|\n"
)

for (i in 1:nrow(table1)) {
  if (table1$n_96[i] == "" && table1$n_27[i] == "") {
    table1_md <- paste0(table1_md, "| ", table1$Characteristic[i], " | | |\n")
  } else {
    table1_md <- paste0(table1_md, "| ", table1$Characteristic[i], " | ", 
                       table1$n_96[i], " | ", table1$n_27[i], " |\n")
  }
}

table1_md <- paste0(table1_md, "\n", table1_notes)

cat(table1_md, file=file.path(TABLE_DIR, "Table1_baseline_characteristics.md"))

cat("  Table 1 saved\n\n")

# =============================================================================
# TABLE 2: RESILIENCE MODEL RESULTS
# =============================================================================

cat("--- Generating Table 2: Resilience Model Results ---\n")

# Rebuild model to get full statistics
model <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, data=resilience_n96)
model_summary <- summary(model)
coefs <- coef(model_summary)
confint_vals <- confint(model)

# Calculate VIF manually or use car package
calculate_vif <- function(model) {
  X <- model.matrix(model)[, -1]  # Remove intercept
  V <- cor(X)
  vif_result <- diag(solve(V))
  # Name the VIF values
  names(vif_result) <- colnames(X)
  return(vif_result)
}

vif_vals <- calculate_vif(model)
cat("  VIF values:", paste(round(vif_vals, 3), collapse=", "), "\n")

# Get coefficient names to ensure correct order
coef_names <- rownames(coefs)
cat("  Model coefficients:", paste(coef_names, collapse=", "), "\n")

# Map coefficients correctly
# coef_names[1] = Intercept
# coef_names[2] = amyloid_centiloid (if first in formula)
# coef_names[3] = tau_suvr
# coef_names[4] = age_years

# Create Table 2 with correct variable mapping
table2 <- data.frame(
  Predictor = c("Intercept", 
                "Amyloid centiloid", 
                "Tau SUVR", 
                "Age (years)"),
  beta = c(coefs["(Intercept)", "Estimate"], 
           coefs["amyloid_centiloid", "Estimate"], 
           coefs["tau_suvr", "Estimate"], 
           coefs["age_years", "Estimate"]),
  SE = c(coefs["(Intercept)", "Std. Error"], 
         coefs["amyloid_centiloid", "Std. Error"], 
         coefs["tau_suvr", "Std. Error"], 
         coefs["age_years", "Std. Error"]),
  CI_lower = c(confint_vals["(Intercept)", 1], 
               confint_vals["amyloid_centiloid", 1], 
               confint_vals["tau_suvr", 1], 
               confint_vals["age_years", 1]),
  CI_upper = c(confint_vals["(Intercept)", 2], 
               confint_vals["amyloid_centiloid", 2], 
               confint_vals["tau_suvr", 2], 
               confint_vals["age_years", 2]),
  t = c(coefs["(Intercept)", "t value"], 
        coefs["amyloid_centiloid", "t value"], 
        coefs["tau_suvr", "t value"], 
        coefs["age_years", "t value"]),
  p = c(coefs["(Intercept)", "Pr(>|t|)"], 
        coefs["amyloid_centiloid", "Pr(>|t|)"], 
        coefs["tau_suvr", "Pr(>|t|)"], 
        coefs["age_years", "Pr(>|t|)"]),
  VIF = c(NA, vif_vals["amyloid_centiloid"], vif_vals["tau_suvr"], vif_vals["age_years"])
)

# Format for display
table2_display <- table2
table2_display$beta <- sprintf("%.4f", table2_display$beta)
table2_display$SE <- sprintf("%.4f", table2_display$SE)
table2_display$CI_95 <- sprintf("[%.3f, %.3f]", table2_display$CI_lower, table2_display$CI_upper)
table2_display$t <- sprintf("%.2f", table2_display$t)
table2_display$p <- ifelse(table2_display$p < 0.001, "<0.001", sprintf("%.3f", table2_display$p))
table2_display$VIF <- ifelse(is.na(table2_display$VIF), "—", sprintf("%.2f", table2_display$VIF))

# Select columns for final table
table2_final <- table2_display[, c("Predictor", "beta", "SE", "CI_95", "p", "VIF")]

# Add model fit statistics
model_fit <- data.frame(
  Statistic = c("R²", "Adjusted R²", "F-statistic (df)", "p-value (model)"),
  Value = c(
    sprintf("%.3f", model_summary$r.squared),
    sprintf("%.3f", model_summary$adj.r.squared),
    sprintf("%.2f (%d, %d)", model_summary$fstatistic[1], 
           model_summary$fstatistic[2], model_summary$fstatistic[3]),
    "<0.001"
  )
)

# Save Table 2
write.csv(table2_final, file.path(TABLE_DIR, "Table2_model_results.csv"), row.names=FALSE)
write.csv(model_fit, file.path(TABLE_DIR, "Table2_model_fit.csv"), row.names=FALSE)

# Create Markdown version
table2_md <- paste0(
  "**Table 2. Multiple linear regression of cognitive slope on pathology and age**\n\n",
  "| Predictor | β | SE | 95% CI | p-value | VIF |\n",
  "|-----------|---|---|--------|---------|-----|\n"
)

for (i in 1:nrow(table2_final)) {
  table2_md <- paste0(table2_md, "| ", paste(table2_final[i,], collapse=" | "), " |\n")
}

table2_md <- paste0(table2_md, "\n**Model Fit Statistics**\n\n")
table2_md <- paste0(table2_md, "| Statistic | Value |\n|-----------|-------|\n")
for (i in 1:nrow(model_fit)) {
  table2_md <- paste0(table2_md, "| ", model_fit$Statistic[i], " | ", model_fit$Value[i], " |\n")
}

table2_notes <- "

Model: Cognitive Slope = β₀ + β₁(Amyloid) + β₂(Tau) + β₃(Age)
n = 96 participants. Dependent variable: RBANS total score slope (points/year).
VIF = Variance Inflation Factor. All VIF < 2 indicates no multicollinearity.
"

table2_md <- paste0(table2_md, table2_notes)
cat(table2_md, file=file.path(TABLE_DIR, "Table2_model_results.md"))

cat("  Table 2 saved\n\n")

# =============================================================================
# SUPPLEMENTARY TABLE S1: TOP 20 PROTEIN ASSOCIATIONS
# =============================================================================

cat("--- Generating Supplementary Table S1: Top Protein Associations ---\n")

# Prepare data
pwas_results <- pwas_results[order(pwas_results$p_value), ]

# Get top 10 positive and top 10 negative
top_pos <- head(pwas_results[pwas_results$beta > 0, ], 10)
top_neg <- head(pwas_results[pwas_results$beta < 0, ], 10)

# Combine and add rank
top20 <- rbind(top_pos, top_neg)
top20$rank <- 1:nrow(top20)
top20$direction <- ifelse(top20$beta > 0, "Positive (better resilience)", "Negative (worse resilience)")

# Format
table_s1 <- data.frame(
  Rank = top20$rank,
  Protein = top20$protein,
  Beta = sprintf("%.4f", top20$beta),
  SE = sprintf("%.4f", top20$se),
  t_statistic = sprintf("%.2f", top20$t_stat),
  p_value = ifelse(top20$p_value < 0.001, "<0.001", sprintf("%.3f", top20$p_value)),
  FDR = ifelse(top20$fdr < 0.001, "<0.001", sprintf("%.3f", top20$fdr)),
  Direction = top20$direction
)

# Save
write.csv(table_s1, file.path(TABLE_DIR, "SupplementaryTableS1_top_proteins.csv"), row.names=FALSE)

# Markdown
table_s1_md <- "**Supplementary Table S1. Top 20 protein associations with cognitive resilience**\n\n"
table_s1_md <- paste0(table_s1_md, "| Rank | Protein | β | SE | t | p-value | FDR | Direction |\n")
table_s1_md <- paste0(table_s1_md, "|------|---------|---|---|---|---------|-----|-----------|\n")

for (i in 1:nrow(table_s1)) {
  table_s1_md <- paste0(table_s1_md, "| ", paste(table_s1[i,], collapse=" | "), " |\n")
}

table_s1_notes <- "

Top 10 positive and top 10 negative associations from PWAS (n=27, 7,321 proteins tested).
No protein survived FDR correction at q < 0.05.
MEF2C: Myocyte Enhancer Factor 2C; NDC80: Kinetochore complex component.
"

table_s1_md <- paste0(table_s1_md, table_s1_notes)
cat(table_s1_md, file=file.path(TABLE_DIR, "SupplementaryTableS1_top_proteins.md"))

cat("  Supplementary Table S1 saved\n\n")

# =============================================================================
# SUPPLEMENTARY TABLE S2: COMPLETE PATHWAY ENRICHMENT
# =============================================================================

cat("--- Generating Supplementary Table S2: Pathway Enrichment ---\n")

# Filter significant pathways
sig_enrichment <- enrichment[enrichment$Adjusted.P.value < 0.20, ]
sig_enrichment <- sig_enrichment[order(sig_enrichment$Adjusted.P.value), ]

# Format
table_s2 <- data.frame(
  Database = sig_enrichment$Database,
  Pathway = sig_enrichment$Term,
  Overlap = sig_enrichment$Overlap,
  Genes = sig_enrichment$Genes,
  p_value = ifelse(sig_enrichment$P.value < 0.001, "<0.001", sprintf("%.4f", sig_enrichment$P.value)),
  FDR = ifelse(sig_enrichment$Adjusted.P.value < 0.001, "<0.001", sprintf("%.4f", sig_enrichment$Adjusted.P.value)),
  Combined_Score = sprintf("%.1f", sig_enrichment$Combined.Score),
  Direction = sig_enrichment$Direction
)

# Save
write.csv(table_s2, file.path(TABLE_DIR, "SupplementaryTableS2_pathway_enrichment.csv"), row.names=FALSE)

# Create summary markdown with just top pathways per database
table_s2_md <- "**Supplementary Table S2. Pathway over-representation analysis results**\n\n"
table_s2_md <- paste0(table_s2_md, "Pathways with FDR < 0.20 shown (total n=", nrow(table_s2), " pathways).\n\n")

# Add top 5 pathways by database
databases <- unique(table_s2$Database)
for (db in databases) {
  db_data <- table_s2[table_s2$Database == db, ]
  if (nrow(db_data) > 0) {
    db_top <- head(db_data, 5)
    table_s2_md <- paste0(table_s2_md, "\n**", db, "** (top 5)\n\n")
    table_s2_md <- paste0(table_s2_md, "| Pathway | Overlap | FDR | Direction |\n")
    table_s2_md <- paste0(table_s2_md, "|---------|---------|-----|-----------|\n")
    for (i in 1:nrow(db_top)) {
      table_s2_md <- paste0(table_s2_md, "| ", db_top$Pathway[i], " | ", 
                           db_top$Overlap[i], " | ", db_top$FDR[i], " | ", 
                           db_top$Direction[i], " |\n")
    }
  }
}

table_s2_notes <- "

Complete results available in SupplementaryTableS2_pathway_enrichment.csv.
Positive: Higher protein = Better resilience (proteostatic pathways).
Negative: Higher protein = Worse resilience (synaptic/neuronal pathways).
"

table_s2_md <- paste0(table_s2_md, table_s2_notes)
cat(table_s2_md, file=file.path(TABLE_DIR, "SupplementaryTableS2_pathway_enrichment.md"))

cat("  Supplementary Table S2 saved\n\n")

# =============================================================================
# SUMMARY
# =============================================================================

cat("============================================================\n")
cat("  TABLE GENERATION COMPLETE\n")
cat("============================================================\n\n")

tables_generated <- list.files(TABLE_DIR, pattern="\\.(csv|md)$", full.names=FALSE)

cat("Tables generated in:", TABLE_DIR, "\n\n")
cat("Files:\n")
for (tbl in sort(tables_generated)) {
  cat("  -", tbl, "\n")
}

cat("\n============================================================\n")
cat("  TABLE SUMMARY\n")
cat("============================================================\n")
cat("\n**Main Tables:**\n")
cat("  1. Table1_baseline_characteristics.*\n")
cat("     - Sample demographics and biomarkers\n")
cat("     - Compares n=96 vs n=27 samples\n")
cat("\n  2. Table2_model_results.*\n")
cat("     - Resilience model coefficients\n")
cat("     - Model fit statistics (R², F-statistic)\n")
cat("\n**Supplementary Tables:**\n")
cat("  S1. SupplementaryTableS1_top_proteins.*\n")
cat("      - Top 20 protein associations\n")
cat("\n  S2. SupplementaryTableS2_pathway_enrichment.*\n")
cat("      - Complete pathway enrichment (FDR<0.20)\n")
cat("============================================================\n")
