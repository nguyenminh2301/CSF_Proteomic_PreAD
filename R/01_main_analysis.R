## =============================================================================
## R_manu3.R
## Cognitive Resilience Proteomics Analysis - PREVENT-AD Manuscript 3
## Minh_Nguyen
##
## TWO-STAGE DESIGN:
##   Stage 1: Fit resilience model on n=96 (MEG+RBANS+PET participants)
##            slope ~ amyloid_centiloid + tau_suvr + age_years
##   Stage 2: PWAS on n=27 subset who also have CSF SomaScan proteomics
##
## DATA PATHS: All absolute from DATA/ directory
## =============================================================================

# ==== [In 0] Load required libraries ====

library(data.table)
library(dplyr)
library(ggplot2)

# Base directory for all data
BASE_DIR <- "d:/Data_Nghien_cuu/PREVENT-AD"

cat("============================================================\n")
cat("  COGNITIVE RESILIENCE PROTEOMICS ANALYSIS\n")
cat("  PREVENT-AD Manuscript 3\n")
cat("============================================================\n\n")

# ==== [In 1] Load RBANS data and compute cognitive slopes ====

cat("--- STEP 1: Loading RBANS data ---\n")
rbans <- fread(file.path(BASE_DIR, "DATA/2_Neuropsychological_Data/RBANS.csv"))
cat("  RBANS file dimensions:", nrow(rbans), "x", ncol(rbans), "\n")

# Convert Candidate_Age from months to years
rbans$age_years <- rbans$Candidate_Age / 12

# Extract baseline ages (Visit_label == "BL00")
rbans_baseline <- rbans %>% 
  filter(Visit_label == "BL00") %>%
  select(CONP_ID, age_years) %>%
  rename(baseline_age = age_years)

cat("  Participants with baseline visit:", nrow(rbans_baseline), "\n")

# ==== [In 2] Compute individual cognitive slopes ====

cat("\n--- STEP 2: Computing individual cognitive slopes ---\n")

# Filter to valid scores only
rbans_valid <- rbans %>%
  filter(!is.na(total_scale_index_score)) %>%
  select(CONP_ID, age_years, total_scale_index_score)

# Compute slopes: for each participant, fit lm(score ~ age) and extract slope
cognitive_slopes <- rbans_valid %>%
  group_by(CONP_ID) %>%
  filter(n() >= 2) %>%
  summarise(
    slope = coef(lm(total_scale_index_score ~ age_years))[2],
    n_visits = n(),
    .groups = "drop"
  )

cat("  Participants with computed slopes (all):", nrow(cognitive_slopes), "\n")
cat("  Mean slope:", round(mean(cognitive_slopes$slope), 4), "\n")
cat("  SD slope:", round(sd(cognitive_slopes$slope), 4), "\n")

# ==== [In 3] Load MEG data and filter slopes ====

cat("\n--- STEP 3: Filtering to MEG participants ---\n")
meg <- fread(file.path(BASE_DIR, "DATA/11_Neuroimaging_Analytic_data/MEG_relative_power_DK.csv"))
meg_ids <- unique(meg$CONP_ID)
cat("  Participants with MEG data:", length(meg_ids), "\n")

# Filter slopes to MEG participants only (original sample = 96)
cognitive_slopes <- cognitive_slopes %>% filter(CONP_ID %in% meg_ids)
cat("  Slopes after MEG filter:", nrow(cognitive_slopes), "\n")

# ==== [In 4] Load PET amyloid data ====

cat("\n--- STEP 4: Loading PET amyloid data ---\n")
pet_nav <- fread(file.path(BASE_DIR, "DATA/9_PET_tabular_data/PET_NAV_SUVR_ref-wholeCerebellum.csv"))
cat("  PET NAV (amyloid) dimensions:", nrow(pet_nav), "x", ncol(pet_nav), "\n")

# Average centiloid per participant if multiple scans
pet_nav_avg <- pet_nav %>%
  group_by(CONP_ID) %>%
  summarize(
    amyloid_centiloid = mean(WhlCbl_centiloid, na.rm = TRUE),
    .groups = "drop"
  )
cat("  Participants with amyloid data:", nrow(pet_nav_avg), "\n")

# ==== [In 5] Load PET tau data ====

cat("\n--- STEP 5: Loading PET tau data ---\n")
pet_ftp <- fread(file.path(BASE_DIR, "DATA/9_PET_tabular_data/PET_FTP_SUVR_ref-infCerebellarGray.csv"))
cat("  PET FTP (tau) dimensions:", nrow(pet_ftp), "x", ncol(pet_ftp), "\n")

# Average tau per participant if multiple scans
pet_ftp_avg <- pet_ftp %>%
  group_by(CONP_ID) %>%
  summarize(
    tau_suvr = mean(`meta-roi_SUVR`, na.rm = TRUE),
    .groups = "drop"
  )
cat("  Participants with tau data:", nrow(pet_ftp_avg), "\n")

# ==== [In 6] Merge baseline age with cognitive slopes ====

cat("\n--- STEP 6: Merging datasets (n=96 target) ---\n")

# Merge slopes + baseline age + amyloid + tau
data_merged <- cognitive_slopes %>%
  left_join(rbans_baseline, by = "CONP_ID") %>%
  rename(age_years = baseline_age) %>%
  left_join(pet_nav_avg, by = "CONP_ID") %>%
  left_join(pet_ftp_avg, by = "CONP_ID")

cat("  After merge: n =", nrow(data_merged), "\n")
cat("  Missing amyloid values:", sum(is.na(data_merged$amyloid_centiloid)), "\n")
cat("  Missing tau values:", sum(is.na(data_merged$tau_suvr)), "\n")
cat("  Missing age values:", sum(is.na(data_merged$age_years)), "\n")

# Complete cases
data_merged <- data_merged %>%
  filter(complete.cases(slope, amyloid_centiloid, tau_suvr, age_years))

cat("  Final n=96 sample size:", nrow(data_merged), "\n")

# ==== [In 7] Build resilience model (n=96) ====

cat("\n============================================================\n")
cat("  RESILIENCE MODEL (n = 96)\n")
cat("============================================================\n\n")

# Model: cognitive_decline_rate ~ amyloid + tau + age
# Residuals = resilience score
resilience_model <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, data = data_merged)

cat("Resilience model summary:\n")
print(summary(resilience_model))

# Extract residuals as resilience score
data_merged$resilience_score <- residuals(resilience_model)

cat("\nResilience score distribution:\n")
cat("  Mean:", mean(data_merged$resilience_score), "\n")
cat("  SD:", sd(data_merged$resilience_score), "\n")
cat("  Min:", min(data_merged$resilience_score), "\n")
cat("  Max:", max(data_merged$resilience_score), "\n")

# Key coefficients for manuscript verification
coefs_96 <- coef(summary(resilience_model))
cat("\n--- Key Coefficients (n=96) ---\n")
cat(sprintf("  tau_suvr:          β = %.6f, SE = %.6f, p = %.6e\n",
            coefs_96["tau_suvr", "Estimate"], 
            coefs_96["tau_suvr", "Std. Error"],
            coefs_96["tau_suvr", "Pr(>|t|)"]))
cat(sprintf("  amyloid_centiloid: β = %.6f, SE = %.6f, p = %.6e\n",
            coefs_96["amyloid_centiloid", "Estimate"], 
            coefs_96["amyloid_centiloid", "Std. Error"],
            coefs_96["amyloid_centiloid", "Pr(>|t|)"]))
cat(sprintf("  age_years:         β = %.6f, SE = %.6f, p = %.6e\n",
            coefs_96["age_years", "Estimate"], 
            coefs_96["age_years", "Std. Error"],
            coefs_96["age_years", "Pr(>|t|)"]))
cat(sprintf("  R² = %.4f, Adjusted R² = %.4f\n", 
            summary(resilience_model)$r.squared,
            summary(resilience_model)$adj.r.squared))

# ==== [In 8] Cook's distance analysis (n=96 model) ====

cat("\n============================================================\n")
cat("  COOK'S DISTANCE ANALYSIS (n=96 model)\n")
cat("============================================================\n\n")

n_96 <- nrow(data_merged)
threshold_4n <- 4 / n_96
cooks_d <- cooks.distance(resilience_model)

cat(sprintf("  n = %d, 4/n threshold = %.4f\n", n_96, threshold_4n))
cat(sprintf("  Max Cook's D = %.4f (obs %d, ID = %s)\n",
            max(cooks_d), which.max(cooks_d), data_merged$CONP_ID[which.max(cooks_d)]))

influential <- cooks_d > threshold_4n
cat("  Number of influential points:", sum(influential), "\n")

if (sum(influential) > 0) {
  cat("\n  Influential observations:\n")
  influential_data <- data_merged[influential, c("CONP_ID", "slope", "amyloid_centiloid", 
                                                  "tau_suvr", "age_years", "resilience_score")]
  print(influential_data)
  cat("\n  Cook's distance values:\n")
  print(cooks_d[influential])
}

# Sensitivity analysis: exclude most influential observation
max_cooks_idx <- which.max(cooks_d)
data_excl <- data_merged[-max_cooks_idx, ]
model_excl <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, data = data_excl)
coefs_excl <- coef(summary(model_excl))

tau_orig <- coefs_96["tau_suvr", "Estimate"]
tau_excl <- coefs_excl["tau_suvr", "Estimate"]
pct_change <- abs((tau_excl - tau_orig) / tau_orig) * 100

cat(sprintf("\n  Sensitivity: excluding %s (max Cook's D = %.4f)\n",
            data_merged$CONP_ID[max_cooks_idx], max(cooks_d)))
cat(sprintf("    Original tau β: %.6f\n", tau_orig))
cat(sprintf("    Excluded tau β: %.6f\n", tau_excl))
cat(sprintf("    %% change: %.1f%%\n", pct_change))

# ==== [In 9] Load CSF SomaScan proteomics data ====

cat("\n============================================================\n")
cat("  STAGE 2: PWAS (n=27 CSF proteomics subset)\n")
cat("============================================================\n\n")

cat("--- STEP 9: Loading CSF SomaScan data ---\n")
csf_soma <- fread(file.path(BASE_DIR, "DATA/8_Biofluids/CSF_SomaScan_7K_proteins.csv"))
cat("  CSF SomaScan dimensions:", nrow(csf_soma), "x", ncol(csf_soma), "\n")

# ==== [In 10] Merge resilience scores with CSF proteomics ====

# Filter CSF to baseline visit (BL00)
csf_baseline <- csf_soma %>%
  filter(Visit_label == "BL00") %>%
  select(-CONP_CandID, -Visit_label)

cat("  CSF baseline (BL00) participants:", nrow(csf_baseline), "\n")

# Merge with resilience scores (inner join → n=27)
data_proteomics <- data_merged %>%
  inner_join(csf_baseline, by = "CONP_ID")

cat("  Participants with resilience scores AND CSF proteomics: n =", nrow(data_proteomics), "\n")

# Get list of protein columns (excluding metadata)
protein_cols <- setdiff(colnames(data_proteomics), c("CONP_ID", "slope", "n_visits",
                                                      "age_years", "amyloid_centiloid", "tau_suvr", 
                                                      "resilience_score"))
cat("  Number of proteins:", length(protein_cols), "\n")

# ==== [In 11] Perform PWAS ====

cat("\n--- STEP 11: Running PWAS ---\n")

# Initialize results
pwas_results <- data.frame(
  protein = character(),
  beta = numeric(),
  se = numeric(),
  t_stat = numeric(),
  p_value = numeric(),
  n_obs = integer(),
  stringsAsFactors = FALSE
)

cat("  Running PWAS for", length(protein_cols), "proteins...\n")

for (i in seq_along(protein_cols)) {
  if (i %% 1000 == 0) {
    cat("  Processed", i, "proteins\n")
  }
  
  protein <- protein_cols[i]
  protein_data <- data_proteomics[[protein]]
  n_valid <- sum(!is.na(protein_data))
  
  if (n_valid < 5) next
  
  tryCatch({
    fit <- lm(resilience_score ~ protein_data, data = data_proteomics)
    coef_summary <- summary(fit)$coefficients
    
    pwas_results <- rbind(pwas_results, data.frame(
      protein = protein,
      beta = coef_summary[2, "Estimate"],
      se = coef_summary[2, "Std. Error"],
      t_stat = coef_summary[2, "t value"],
      p_value = coef_summary[2, "Pr(>|t|)"],
      n_obs = n_valid,
      stringsAsFactors = FALSE
    ))
  }, error = function(e) {})
}

cat("\n  Completed PWAS analysis\n")
cat("  Total proteins tested:", nrow(pwas_results), "\n")

# ==== [In 12] Multiple testing correction ====

cat("\n--- STEP 12: Multiple testing correction ---\n")

pwas_results$fdr <- p.adjust(pwas_results$p_value, method = "fdr")
pwas_results <- pwas_results[order(pwas_results$p_value), ]

cat("  Proteins with FDR < 0.05:", sum(pwas_results$fdr < 0.05), "\n")
cat("  Proteins with FDR < 0.10:", sum(pwas_results$fdr < 0.10), "\n")
cat("  Proteins with FDR < 0.20:", sum(pwas_results$fdr < 0.20), "\n")
cat("  Proteins with nominal p < 0.05:", sum(pwas_results$p_value < 0.05), "\n")
cat("  Proteins with nominal p < 0.01:", sum(pwas_results$p_value < 0.01), "\n")

cat("\nTop 20 proteins by p-value:\n")
print(head(pwas_results, 20))

# ==== [In 13] Prepare ranked list for pathway analysis ====

cat("\n--- STEP 13: Preparing ranked protein list ---\n")

pwas_results$rank_metric <- -log10(pwas_results$p_value) * sign(pwas_results$beta)
pwas_results_ranked <- pwas_results[order(pwas_results$rank_metric, decreasing = TRUE), ]

cat("Top 10 positive associations:\n")
print(head(pwas_results_ranked, 10))
cat("\nTop 10 negative associations:\n")
print(tail(pwas_results_ranked, 10))

# Save PWAS results
pwas_out <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/pwas_results_resilience.csv")
write.csv(pwas_results_ranked, pwas_out, row.names = FALSE)
cat("\nPWAS results saved to:", pwas_out, "\n")

# ==== [In 14] Install and load packages for enrichment ====

cat("\n--- STEP 14: Loading enrichment packages ---\n")

if (!require("fgsea", quietly = TRUE)) {
  if (!require("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  BiocManager::install("fgsea")
}
library(fgsea)
cat("  fgsea loaded\n")

# ==== [In 15] Filter top proteins for enrichment ====

cat("\n--- STEP 15: Filtering top proteins for enrichment ---\n")

top_proteins <- pwas_results[pwas_results$p_value < 0.05, ]
cat("  Proteins with nominal p < 0.05:", nrow(top_proteins), "\n")

pos_proteins <- top_proteins[top_proteins$beta > 0, ]
neg_proteins <- top_proteins[top_proteins$beta < 0, ]

cat("  Positive associations:", nrow(pos_proteins), "\n")
cat("  Negative associations:", nrow(neg_proteins), "\n")

# ==== [In 16] Setup enrichR ====

cat("\n--- STEP 16: Setting up enrichR ---\n")

if (!require("enrichR", quietly = TRUE)) {
  tryCatch({
    install.packages("enrichR", repos = "http://cran.us.r-project.org")
  }, error = function(e) {
    cat("Could not install enrichR\n")
  })
}
library(enrichR)

# ==== [In 17] Select enrichR databases ====

dbs <- listEnrichrDbs()
cat("  Available enrichR databases:", nrow(dbs), "\n")

selected_dbs <- c(
  "GO_Biological_Process_2023",
  "GO_Cellular_Component_2023", 
  "GO_Molecular_Function_2023",
  "KEGG_2021_Human",
  "Reactome_2022",
  "WikiPathway_2023_Human"
)

cat("  Selected databases:", paste(selected_dbs, collapse = ", "), "\n")

# ==== [In 18] Run enrichment for positive associations ====

cat("\n--- STEP 18: Enrichment for positive associations ---\n")

# Use p < 0.01 for more stringent list (matches manuscript: 45 proteins)
top_proteins_stringent <- pwas_results[pwas_results$p_value < 0.01, ]
cat("  Proteins with p < 0.01:", nrow(top_proteins_stringent), "\n")

pos_proteins_stringent <- top_proteins_stringent[top_proteins_stringent$beta > 0, ]
pos_gene_list <- pos_proteins_stringent$protein
cat("  Positive associations (n =", length(pos_gene_list), "):\n")
print(pos_gene_list)

cat("\n=== Enrichment: Positive Associations (Better Resilience) ===\n")
enriched_pos <- enrichr(pos_gene_list, selected_dbs)

for (db in selected_dbs) {
  cat("\n---", db, "---\n")
  results <- enriched_pos[[db]]
  if (nrow(results) > 0) {
    results_sig <- results[results$Adjusted.P.value < 0.2, ]
    if (nrow(results_sig) > 0) {
      print(head(results_sig[, c("Term", "Overlap", "P.value", "Adjusted.P.value")], 10))
    } else {
      cat("No significant pathways (FDR < 0.2)\n")
      cat("Top 5 pathways by p-value:\n")
      print(head(results[, c("Term", "Overlap", "P.value", "Adjusted.P.value")], 5))
    }
  } else {
    cat("No results\n")
  }
}

# ==== [In 19] Run enrichment for negative associations ====

cat("\n--- STEP 19: Enrichment for negative associations ---\n")

neg_proteins_stringent <- top_proteins_stringent[top_proteins_stringent$beta < 0, ]
neg_gene_list <- neg_proteins_stringent$protein
cat("  Negative associations (n =", length(neg_gene_list), "):\n")
print(neg_gene_list)

cat("\n=== Enrichment: Negative Associations (Worse Resilience) ===\n")
enriched_neg <- enrichr(neg_gene_list, selected_dbs)

for (db in selected_dbs) {
  cat("\n---", db, "---\n")
  results <- enriched_neg[[db]]
  if (nrow(results) > 0) {
    results_sig <- results[results$Adjusted.P.value < 0.2, ]
    if (nrow(results_sig) > 0) {
      print(head(results_sig[, c("Term", "Overlap", "P.value", "Adjusted.P.value")], 10))
    } else {
      cat("No significant pathways (FDR < 0.2)\n")
      cat("Top 5 pathways by p-value:\n")
      print(head(results[, c("Term", "Overlap", "P.value", "Adjusted.P.value")], 5))
    }
  } else {
    cat("No results\n")
  }
}

# ==== [In 20] Save enrichment results ====

cat("\n--- STEP 20: Saving enrichment results ---\n")

pos_enrichment_all <- data.frame()
for (db in names(enriched_pos)) {
  if (nrow(enriched_pos[[db]]) > 0) {
    temp <- enriched_pos[[db]]
    temp$Database <- db
    temp$Direction <- "Positive"
    pos_enrichment_all <- rbind(pos_enrichment_all, temp)
  }
}

neg_enrichment_all <- data.frame()
for (db in names(enriched_neg)) {
  if (nrow(enriched_neg[[db]]) > 0) {
    temp <- enriched_neg[[db]]
    temp$Database <- db
    temp$Direction <- "Negative"
    neg_enrichment_all <- rbind(neg_enrichment_all, temp)
  }
}

all_enrichment <- rbind(pos_enrichment_all, neg_enrichment_all)

enrichment_out <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/gsea_enrichment_results.csv")
write.csv(all_enrichment, enrichment_out, row.names = FALSE)
cat("  Enrichment results saved to:", enrichment_out, "\n")

cat("  Total pathways tested:", nrow(all_enrichment), "\n")
cat("  Pathways with FDR < 0.2:", sum(all_enrichment$Adjusted.P.value < 0.2), "\n")
cat("  Pathways with nominal p < 0.05:", sum(all_enrichment$P.value < 0.05), "\n")

# ==== [In 21] Display top significant pathways ====

cat("\n=== TOP SIGNIFICANT PATHWAYS ===\n\n")

pos_sig <- pos_enrichment_all[pos_enrichment_all$Adjusted.P.value < 0.2, ]
pos_sig <- pos_sig[order(pos_sig$Adjusted.P.value), ]
cat("POSITIVE (Higher protein = Better resilience), FDR < 0.2:\n")
if (nrow(pos_sig) > 0) {
  for (i in 1:min(15, nrow(pos_sig))) {
    cat(i, ". ", pos_sig$Term[i], "\n", sep = "")
    cat("   Database: ", pos_sig$Database[i], "\n", sep = "")
    cat("   Overlap: ", pos_sig$Overlap[i], ", FDR = ", 
        round(pos_sig$Adjusted.P.value[i], 4), "\n\n", sep = "")
  }
} else {
  cat("No significant pathways at FDR < 0.2\n")
}

neg_sig <- neg_enrichment_all[neg_enrichment_all$Adjusted.P.value < 0.2, ]
neg_sig <- neg_sig[order(neg_sig$Adjusted.P.value), ]
cat("\nNEGATIVE (Higher protein = Worse resilience), FDR < 0.2:\n")
if (nrow(neg_sig) > 0) {
  for (i in 1:min(15, nrow(neg_sig))) {
    cat(i, ". ", neg_sig$Term[i], "\n", sep = "")
    cat("   Database: ", neg_sig$Database[i], "\n", sep = "")
    cat("   Overlap: ", neg_sig$Overlap[i], ", FDR = ", 
        round(neg_sig$Adjusted.P.value[i], 4), "\n\n", sep = "")
  }
} else {
  cat("No significant pathways at FDR < 0.2\n")
}

# ==== [In 22] Hypothesis-specific pathway analysis ====

cat("\n=== HYPOTHESIS-SPECIFIC PATHWAY ANALYSIS ===\n\n")

synaptic_keywords <- c("synap", "neurotransmitter", "axon", "dendrit", "neurite")
bioenergetics_keywords <- c("mitochond", "ATP", "energy", "metabol", "oxidative phosphorylation")
quality_control_keywords <- c("ubiquitin", "proteasome", "autophagy", "chaperone", "protein folding", 
                              "unfolded protein", "ER stress", "lysosom")

search_pathways <- function(enrichment_df, keywords, category_name) {
  cat("\n", category_name, ":\n", sep = "")
  cat("----------------------------------------\n")
  
  matching_rows <- c()
  for (keyword in keywords) {
    matches <- grep(keyword, enrichment_df$Term, ignore.case = TRUE)
    matching_rows <- unique(c(matching_rows, matches))
  }
  
  if (length(matching_rows) > 0) {
    results <- enrichment_df[matching_rows, ]
    results <- results[order(results$P.value), ]
    results_sig <- results[results$Adjusted.P.value < 0.2, ]
    
    if (nrow(results_sig) > 0) {
      cat("Significant pathways (FDR < 0.2):\n")
      for (i in 1:min(10, nrow(results_sig))) {
        cat(i, ". ", results_sig$Term[i], "\n", sep = "")
        cat("   Direction: ", results_sig$Direction[i], 
            ", Overlap: ", results_sig$Overlap[i], 
            ", p = ", format.pval(results_sig$P.value[i], digits = 3),
            ", FDR = ", round(results_sig$Adjusted.P.value[i], 3), "\n\n", sep = "")
      }
    } else {
      cat("No significant pathways (FDR < 0.2). Top results:\n")
      for (i in 1:min(5, nrow(results))) {
        cat(i, ". ", results$Term[i], "\n", sep = "")
        cat("   Direction: ", results$Direction[i], 
            ", p = ", format.pval(results$P.value[i], digits = 3),
            ", FDR = ", round(results$Adjusted.P.value[i], 3), "\n\n", sep = "")
      }
    }
  } else {
    cat("No pathways found.\n")
  }
}

search_pathways(all_enrichment, synaptic_keywords, "SYNAPTIC MAINTENANCE")
search_pathways(all_enrichment, bioenergetics_keywords, "BIOENERGETICS")
search_pathways(all_enrichment, quality_control_keywords, "CELLULAR QUALITY CONTROL")

# ==== [In 23] Volcano plot ====

cat("\n--- STEP 23: Creating volcano plot ---\n")

library(gridExtra)

pwas_results$significant <- ifelse(pwas_results$p_value < 0.01, "p < 0.01", "NS")
pwas_results$label <- ""
top_to_label <- pwas_results[pwas_results$p_value < 0.001, ]
pwas_results$label[match(top_to_label$protein, pwas_results$protein)] <- top_to_label$protein

p1 <- ggplot(pwas_results, aes(x = beta, y = -log10(p_value))) +
  geom_point(aes(color = significant), alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c("p < 0.01" = "red", "NS" = "gray70")) +
  geom_text(data = pwas_results[pwas_results$label != "", ], 
            aes(label = label), size = 2.5, vjust = -0.5, hjust = 0.5) +
  geom_hline(yintercept = -log10(0.01), linetype = "dashed", color = "blue", alpha = 0.5) +
  labs(
    title = "Proteome-Wide Association Study of Cognitive Resilience",
    subtitle = paste0("n = ", nrow(data_proteomics), " participants | ",
                      nrow(pwas_results), " proteins | ",
                      sum(pwas_results$p_value < 0.05), " at p < 0.05 | ",
                      "No FDR-significant hits"),
    x = "Effect size (β)",
    y = "-log10(p-value)",
    color = "Significance"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.subtitle = element_text(size = 9),
    legend.position = "bottom"
  )

# --- Save volcano plot at 600 DPI (PNG + TIFF) ---
volcano_png <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/Fig1B_volcano.png")
volcano_tiff <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/Fig1B_volcano.tiff")
ggsave(volcano_png, p1, width = 10, height = 8, dpi = 600)
ggsave(volcano_tiff, p1, width = 10, height = 8, dpi = 600, compression = "lzw")
cat("  Volcano plot saved (600 DPI):", volcano_png, "\n")
print(p1)

# ==== [In 24] Model diagnostic plots (Fig. 1A) ====

# --- Save diagnostics at 600 DPI (PNG + TIFF) ---
diag_png <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/Fig1A_diagnostics.png")
diag_tiff <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/Fig1A_diagnostics.tiff")

png(diag_png, width = 10, height = 8, units = "in", res = 600)
par(mfrow = c(2, 2))
plot(resilience_model, which = 1)
plot(resilience_model, which = 2)
plot(resilience_model, which = 3)
plot(resilience_model, which = 5)
dev.off()

tiff(diag_tiff, width = 10, height = 8, units = "in", res = 600, compression = "lzw")
par(mfrow = c(2, 2))
plot(resilience_model, which = 1)
plot(resilience_model, which = 2)
plot(resilience_model, which = 3)
plot(resilience_model, which = 5)
dev.off()

cat("  Diagnostic plots saved (600 DPI):", diag_png, "\n")

# ==== [In 24b] Fig. 2: Pathway enrichment bubble plot ====

cat("\n--- STEP 24b: Creating pathway enrichment bubble plot (Fig. 2) ---\n")

# Prepare top pathways for plotting
pos_top <- pos_enrichment_all[pos_enrichment_all$Adjusted.P.value < 0.2, ]
pos_top <- pos_top[order(pos_top$Adjusted.P.value), ]
pos_top <- head(pos_top, 15)
pos_top$Direction <- "Positive (better resilience)"

neg_top <- neg_enrichment_all[neg_enrichment_all$Adjusted.P.value < 0.2, ]
neg_top <- neg_top[order(neg_top$Adjusted.P.value), ]
neg_top <- head(neg_top, 15)
neg_top$Direction <- "Negative (worse resilience)"

bubble_data <- rbind(pos_top, neg_top)

# Extract overlap count from "2/18" format
bubble_data$Overlap_N <- as.numeric(sub("/.*", "", bubble_data$Overlap))

# Shorten long term names
bubble_data$Term_Short <- sub(" \\(GO:.*\\)", "", bubble_data$Term)
bubble_data$Term_Short <- sub(" \\(R-HSA-.*\\)", "", bubble_data$Term_Short)
bubble_data$Term_Short <- substr(bubble_data$Term_Short, 1, 50)

p2 <- ggplot(bubble_data, aes(x = -log10(Adjusted.P.value), 
                               y = reorder(Term_Short, -log10(Adjusted.P.value)))) +
  geom_point(aes(size = Overlap_N, color = Combined.Score), alpha = 0.8) +
  scale_color_gradient(low = "lightblue", high = "darkblue", name = "Enrichr\nCombined Score") +
  scale_size_continuous(name = "Overlap\nGenes", range = c(2, 8)) +
  geom_vline(xintercept = -log10(0.20), linetype = "dashed", color = "gray50", alpha = 0.5) +
  facet_wrap(~Direction, scales = "free_y", ncol = 2) +
  labs(
    title = "Pathway Over-Representation Analysis",
    subtitle = "Enrichr ORA of proteins at nominal p < 0.01",
    x = expression(-log[10](FDR)),
    y = ""
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(size = 12, face = "bold"),
    plot.subtitle = element_text(size = 9),
    axis.text.y = element_text(size = 7),
    strip.text = element_text(size = 10, face = "bold"),
    legend.position = "right"
  )

fig2_png <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/Fig2_pathway_enrichment.png")
fig2_tiff <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/Fig2_pathway_enrichment.tiff")
ggsave(fig2_png, p2, width = 16, height = 10, dpi = 600)
ggsave(fig2_tiff, p2, width = 16, height = 10, dpi = 600, compression = "lzw")
cat("  Pathway bubble plot saved (600 DPI):", fig2_png, "\n")
print(p2)

# ==== [In 25] Save analysis datasets ====

cat("\n--- STEP 25: Saving analysis datasets ---\n")

# Save n=96 resilience scores
data_resilience <- data_merged %>%
  select(CONP_ID, slope, age_years, amyloid_centiloid, tau_suvr, resilience_score)

res96_out <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/resilience_scores_n96.csv")
write.csv(data_resilience, res96_out, row.names = FALSE)
cat("  n=96 resilience scores saved to:", res96_out, "\n")

# Save n=27 proteomics subset
data_proteomics_subset <- data_proteomics %>%
  select(CONP_ID, slope, age_years, amyloid_centiloid, tau_suvr, resilience_score)

res27_out <- file.path(BASE_DIR, "MANUSCRIPT/Manu_3/data/processed/resilience_scores_proteomics_n27.csv")
write.csv(data_proteomics_subset, res27_out, row.names = FALSE)
cat("  n=27 proteomics subset saved to:", res27_out, "\n")

# ==== [In 26] Model assumptions testing ====

cat("\n============================================================\n")
cat("  MODEL ASSUMPTIONS TESTING\n")
cat("============================================================\n\n")

# 1. Normality (Shapiro-Wilk)
shapiro_test <- shapiro.test(residuals(resilience_model))
cat("Normality (Shapiro-Wilk):\n")
cat("  W =", round(shapiro_test$statistic, 4), "\n")
cat("  p =", format.pval(shapiro_test$p.value, digits = 3), "\n")
cat("  Conclusion:", ifelse(shapiro_test$p.value > 0.05, 
                             "Normal (p > 0.05) ✓", "Non-normal (p < 0.05) ✗"), "\n\n")

# 2. Homoscedasticity (Breusch-Pagan)
if (!require("lmtest", quietly = TRUE)) {
  install.packages("lmtest", repos = "http://cran.us.r-project.org")
}
library(lmtest)

bp_test <- bptest(resilience_model)
cat("Homoscedasticity (Breusch-Pagan):\n")
cat("  BP =", round(bp_test$statistic, 4), "\n")
cat("  p =", format.pval(bp_test$p.value, digits = 3), "\n")
cat("  Conclusion:", ifelse(bp_test$p.value > 0.05,
                             "Homoscedastic (p > 0.05) ✓", "Heteroscedastic (p < 0.05) ✗"), "\n\n")

# 3. Multicollinearity (VIF)
if (!require("car", quietly = TRUE)) {
  install.packages("car", repos = "http://cran.us.r-project.org")
}
library(car)

vif_values <- vif(resilience_model)
cat("Multicollinearity (VIF):\n")
print(vif_values)
cat("\n  All VIF < 5:", ifelse(all(vif_values < 5), "Yes ✓", "No ✗"), "\n")

# ==== [In 27] Variable distributions ====

cat("\n============================================================\n")
cat("  VARIABLE DISTRIBUTIONS\n")
cat("============================================================\n\n")

cat("Resilience Score (n = 96):\n")
cat("  Mean ± SD:", round(mean(data_merged$resilience_score), 3), "±", 
    round(sd(data_merged$resilience_score), 3), "\n")
cat("  Range: [", round(min(data_merged$resilience_score), 3), ",", 
    round(max(data_merged$resilience_score), 3), "]\n")
cat("  Median:", round(median(data_merged$resilience_score), 3), "\n\n")

cat("Cognitive Slope (n = 96):\n")
cat("  Mean ± SD:", round(mean(data_merged$slope), 3), "±", 
    round(sd(data_merged$slope), 3), "\n")
cat("  Range: [", round(min(data_merged$slope), 3), ",", 
    round(max(data_merged$slope), 3), "]\n\n")

cat("Amyloid Centiloid (n = 96):\n")
cat("  Mean ± SD:", round(mean(data_merged$amyloid_centiloid), 3), "±", 
    round(sd(data_merged$amyloid_centiloid), 3), "\n\n")

cat("Tau SUVR (n = 96):\n")
cat("  Mean ± SD:", round(mean(data_merged$tau_suvr), 3), "±", 
    round(sd(data_merged$tau_suvr), 3), "\n\n")

cat("Baseline Age (n = 96):\n")
cat("  Mean ± SD:", round(mean(data_merged$age_years), 3), "±", 
    round(sd(data_merged$age_years), 3), "\n\n")

cat("PROTEOMICS SUBSET (n =", nrow(data_proteomics_subset), "):\n")
cat("  Resilience:", round(mean(data_proteomics_subset$resilience_score), 3), 
    "±", round(sd(data_proteomics_subset$resilience_score), 3), "\n")
cat("  Slope:", round(mean(data_proteomics_subset$slope), 3), 
    "±", round(sd(data_proteomics_subset$slope), 3), "\n")
cat("  Amyloid:", round(mean(data_proteomics_subset$amyloid_centiloid), 3), 
    "±", round(sd(data_proteomics_subset$amyloid_centiloid), 3), "\n")
cat("  Tau:", round(mean(data_proteomics_subset$tau_suvr), 3), 
    "±", round(sd(data_proteomics_subset$tau_suvr), 3), "\n")

# ==== [In 28] Top protein associations ====

cat("\n=== TOP PROTEIN ASSOCIATIONS WITH RESILIENCE ===\n\n")

top5_pos <- head(pwas_results[pwas_results$beta > 0, ], 5)
top5_neg <- head(pwas_results[pwas_results$beta < 0, ], 5)

cat("POSITIVE (Higher protein = Better resilience):\n")
for (i in 1:5) {
  cat(sprintf("  %d. %-15s β = %7.4f, p = %s\n", i, 
              top5_pos$protein[i], top5_pos$beta[i], 
              format.pval(top5_pos$p_value[i], digits = 3, eps = 0.0001)))
}

cat("\nNEGATIVE (Higher protein = Worse resilience):\n")
for (i in 1:5) {
  cat(sprintf("  %d. %-15s β = %7.4f, p = %s\n", i, 
              top5_neg$protein[i], top5_neg$beta[i], 
              format.pval(top5_neg$p_value[i], digits = 3, eps = 0.0001)))
}

# Check MEF2C specifically (mentioned in manuscript)
mef2c_row <- pwas_results[pwas_results$protein == "MEF2C", ]
if (nrow(mef2c_row) > 0) {
  cat("\nMEF2C (manuscript highlight):\n")
  cat(sprintf("  β = %.4f, SE = %.4f, p = %s, FDR = %.4f\n",
              mef2c_row$beta, mef2c_row$se, 
              format.pval(mef2c_row$p_value, digits = 3),
              mef2c_row$fdr))
}

# ==== [In 29] FINAL COMPREHENSIVE REPORT ====

cat("\n\n")
cat("================================================================================\n")
cat("           COGNITIVE RESILIENCE PROTEOMICS ANALYSIS - FINAL REPORT\n")
cat("================================================================================\n\n")

cat("STAGE 1: RESILIENCE SCORE DERIVATION (N =", n_96, ")\n")
cat("--------------------------------------------------------------------------------\n")
cat("Model: cognitive_decline_rate ~ amyloid_centiloid + tau_suvr + age_years\n\n")
cat("Predictors:\n")
cat(sprintf("  - Amyloid (centiloid):  β = %.4f, SE = %.4f, p = %s\n",
            coefs_96["amyloid_centiloid", "Estimate"],
            coefs_96["amyloid_centiloid", "Std. Error"],
            format.pval(coefs_96["amyloid_centiloid", "Pr(>|t|)"], digits = 3)))
cat(sprintf("  - Tau (meta-ROI SUVR):  β = %.4f, SE = %.4f, p = %s\n",
            coefs_96["tau_suvr", "Estimate"],
            coefs_96["tau_suvr", "Std. Error"],
            format.pval(coefs_96["tau_suvr", "Pr(>|t|)"], digits = 3)))
cat(sprintf("  - Age (years):          β = %.4f, SE = %.4f, p = %s\n\n",
            coefs_96["age_years", "Estimate"],
            coefs_96["age_years", "Std. Error"],
            format.pval(coefs_96["age_years", "Pr(>|t|)"], digits = 3)))
cat(sprintf("Model fit: R² = %.3f, Adj R² = %.3f\n",
            summary(resilience_model)$r.squared,
            summary(resilience_model)$adj.r.squared))
cat(sprintf("Cook's D max = %.4f, sensitivity %% change = %.1f%%\n\n", max(cooks_d), pct_change))

cat(sprintf("STAGE 2: PWAS (N = %d with CSF proteomics)\n", nrow(data_proteomics)))
cat("--------------------------------------------------------------------------------\n")
cat(sprintf("Proteins tested: %d\n", nrow(pwas_results)))
cat(sprintf("Proteins p < 0.05: %d | p < 0.01: %d | FDR < 0.05: %d\n\n",
            sum(pwas_results$p_value < 0.05),
            sum(pwas_results$p_value < 0.01),
            sum(pwas_results$fdr < 0.05)))

cat("MANUSCRIPT PLACEHOLDER VALUES (Section 3.1):\n")
cat("--------------------------------------------------------------------------------\n")
cat(sprintf("  [Tau β]              → %.2f (= −3.92)\n", coefs_96["tau_suvr", "Estimate"]))
cat(sprintf("  [Tau SE]             → %.4f\n", coefs_96["tau_suvr", "Std. Error"]))
cat(sprintf("  [Tau p]              → %s\n", format.pval(coefs_96["tau_suvr", "Pr(>|t|)"], digits = 3)))
cat(sprintf("  [Amyloid β]          → %.4f (= −0.0098)\n", coefs_96["amyloid_centiloid", "Estimate"]))
cat(sprintf("  [Amyloid SE]         → %.4f\n", coefs_96["amyloid_centiloid", "Std. Error"]))
cat(sprintf("  [Amyloid p]          → %s\n", format.pval(coefs_96["amyloid_centiloid", "Pr(>|t|)"], digits = 3)))
cat(sprintf("  [Age β]              → %.4f\n", coefs_96["age_years", "Estimate"]))
cat(sprintf("  [Age p]              → %s\n", format.pval(coefs_96["age_years", "Pr(>|t|)"], digits = 3)))
cat(sprintf("  [Model variance %%]   → %.1f%%\n", summary(resilience_model)$r.squared * 100))
cat(sprintf("  [Adjusted R²]        → %.3f\n", summary(resilience_model)$adj.r.squared))
cat(sprintf("  [Max Cook's D]       → %.3f\n", max(cooks_d)))
cat(sprintf("  [Sensitivity %%]      → %.1f%%\n", pct_change))

# Proteins at p < 0.01
n_pos_001 <- sum(top_proteins_stringent$beta > 0)
n_neg_001 <- sum(top_proteins_stringent$beta < 0)
cat(sprintf("\nMANUSCRIPT PLACEHOLDER VALUES (Section 3.2):\n"))
cat(sprintf("  [n positive β at p<0.01] → %d\n", n_pos_001))
cat(sprintf("  [n negative β at p<0.01] → %d\n", n_neg_001))

# Top positive proteins
top3_pos <- head(pwas_results[pwas_results$beta > 0, ], 3)
cat("  [Top 3 positive proteins]:\n")
for (i in 1:3) {
  cat(sprintf("    %d. %s (β = %.4f, p = %s)\n", i, 
              top3_pos$protein[i], top3_pos$beta[i],
              format.pval(top3_pos$p_value[i], digits = 3)))
}

# MEF2C and second negative protein
if (nrow(mef2c_row) > 0) {
  cat(sprintf("  [MEF2C p]            → %s\n", format.pval(mef2c_row$p_value, digits = 3)))
}
top2_neg <- head(pwas_results[pwas_results$beta < 0, ], 2)
cat(sprintf("  [Second neg protein] → %s (β = %.4f, p = %s)\n",
            top2_neg$protein[2], top2_neg$beta[2], 
            format.pval(top2_neg$p_value[2], digits = 3)))

# Pathway FDRs
if (nrow(pos_sig) > 0) {
  cat(sprintf("\nMANUSCRIPT PLACEHOLDER VALUES (Section 3.3):\n"))
  cat(sprintf("  [Top positive pathway FDR] → %.4f\n", min(pos_sig$Adjusted.P.value)))
}
if (nrow(neg_sig) > 0) {
  cat(sprintf("  [Top negative pathway FDR] → %.4f\n", min(neg_sig$Adjusted.P.value)))
}

cat("\n================================================================================\n")
cat("  ANALYSIS COMPLETE\n")
cat("================================================================================\n")
