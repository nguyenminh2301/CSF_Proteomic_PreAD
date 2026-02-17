# ==============================================================================
# 01_sensitivity_analysis.R
# 
# PURPOSE: Compute sensitivity analysis for the resilience model (n = 96)
#   - Two-stage design (matching R_manu3.R and manuscript):
#     Stage 1: Resilience model on n=96 (MEG+RBANS+PET participants)
#     Stage 2: PWAS on n=27 subset with CSF proteomics
#   - This script focuses on Stage 1 sensitivity:
#     1. Fit resilience model on n=96
#     2. Cook's distance analysis
#     3. Sensitivity analysis (single exclusion + leave-one-out)
#     4. Report % change in tau beta
#
# INPUT FILES:
#   - DATA/2_Neuropsychological_Data/RBANS.csv
#   - DATA/9_PET_tabular_data/PET_NAV_SUVR_ref-wholeCerebellum.csv
#   - DATA/9_PET_tabular_data/PET_FTP_SUVR_ref-infCerebellarGray.csv
#   - DATA/11_Neuroimaging_Analytic_data/MEG_relative_power_DK.csv
#
# NOTE: The resilience model is fit on n=96 (same as R_manu3.R). The n=27
#   subset is only used for PWAS. Manuscript tau β = -3.92 matches n=96 model.
#
# AUTHOR: Auto-generated for manuscript placeholder verification
# DATE: 2026-02-17
# ==============================================================================

# --- 0. Setup ---
library(data.table)
library(dplyr)

BASE_DIR <- "d:/Data_Nghien_cuu/PREVENT-AD"

cat("============================================================\n")
cat("  SENSITIVITY ANALYSIS: Resilience Model (n = 96)\n")
cat("============================================================\n\n")

# --- 1. Load RBANS data ---
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

# --- 2. Compute individual cognitive slopes ---
cat("\n--- STEP 2: Computing individual cognitive slopes ---\n")

rbans_valid <- rbans %>%
  filter(!is.na(total_scale_index_score)) %>%
  select(CONP_ID, age_years, total_scale_index_score)

slopes <- rbans_valid %>%
  group_by(CONP_ID) %>%
  filter(n() >= 2) %>%
  summarise(
    slope = coef(lm(total_scale_index_score ~ age_years))[2],
    n_visits = n(),
    .groups = "drop"
  )

cat("  Participants with computed slopes (all):", nrow(slopes), "\n")

# --- 2b. Filter to MEG participants ---
cat("\n--- STEP 2b: MEG participant filter ---\n")
meg <- fread(file.path(BASE_DIR, "DATA/11_Neuroimaging_Analytic_data/MEG_relative_power_DK.csv"))
meg_ids <- unique(meg$CONP_ID)
cat("  Participants with MEG data:", length(meg_ids), "\n")

slopes <- slopes %>% filter(CONP_ID %in% meg_ids)
cat("  Slopes after MEG filter:", nrow(slopes), "\n")

# --- 3. Load PET amyloid data ---
cat("\n--- STEP 3: Loading PET amyloid data ---\n")
pet_nav <- fread(file.path(BASE_DIR, "DATA/9_PET_tabular_data/PET_NAV_SUVR_ref-wholeCerebellum.csv"))

pet_amyloid <- pet_nav %>%
  group_by(CONP_ID) %>%
  summarise(amyloid_centiloid = mean(WhlCbl_centiloid, na.rm = TRUE), .groups = "drop")
cat("  Participants with amyloid data:", nrow(pet_amyloid), "\n")

# --- 4. Load PET tau data ---
cat("\n--- STEP 4: Loading PET tau data ---\n")
pet_ftp <- fread(file.path(BASE_DIR, "DATA/9_PET_tabular_data/PET_FTP_SUVR_ref-infCerebellarGray.csv"))

pet_tau <- pet_ftp %>%
  group_by(CONP_ID) %>%
  summarise(tau_suvr = mean(`meta-roi_SUVR`, na.rm = TRUE), .groups = "drop")
cat("  Participants with tau data:", nrow(pet_tau), "\n")

# --- 5. Merge datasets → n = 96 ---
cat("\n--- STEP 5: Merging datasets → target n = 96 ---\n")

data_n96 <- slopes %>%
  left_join(rbans_baseline, by = "CONP_ID") %>%
  rename(age_years = baseline_age) %>%
  left_join(pet_amyloid, by = "CONP_ID") %>%
  left_join(pet_tau, by = "CONP_ID") %>%
  filter(complete.cases(slope, amyloid_centiloid, tau_suvr, age_years))

cat("  Final n=96 sample size:", nrow(data_n96), "\n")

# --- 6. Fit the RESILIENCE MODEL on n = 96 ---
cat("\n============================================================\n")
cat("  STEP 6: RESILIENCE MODEL (n =", nrow(data_n96), ")\n")
cat("============================================================\n\n")

resilience_model <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, 
                        data = data_n96)

cat("--- Model Summary ---\n")
print(summary(resilience_model))

# Extract key coefficients
coefs <- coef(summary(resilience_model))
cat("\n--- Key Coefficients ---\n")
cat(sprintf("  tau_suvr:          β = %.6f, SE = %.6f, p = %.6e\n",
            coefs["tau_suvr", "Estimate"], 
            coefs["tau_suvr", "Std. Error"],
            coefs["tau_suvr", "Pr(>|t|)"]))
cat(sprintf("  amyloid_centiloid: β = %.6f, SE = %.6f, p = %.6e\n",
            coefs["amyloid_centiloid", "Estimate"], 
            coefs["amyloid_centiloid", "Std. Error"],
            coefs["amyloid_centiloid", "Pr(>|t|)"]))
cat(sprintf("  age_years:         β = %.6f, SE = %.6f, p = %.6e\n",
            coefs["age_years", "Estimate"], 
            coefs["age_years", "Std. Error"],
            coefs["age_years", "Pr(>|t|)"]))

r2 <- summary(resilience_model)$r.squared
adj_r2 <- summary(resilience_model)$adj.r.squared
cat(sprintf("\n  R² = %.4f, Adjusted R² = %.4f\n", r2, adj_r2))

# --- 7. Cook's Distance Analysis ---
cat("\n============================================================\n")
cat("  STEP 7: COOK'S DISTANCE ANALYSIS\n")
cat("============================================================\n\n")

n <- nrow(data_n96)
threshold_4n <- 4 / n

cooks_d <- cooks.distance(resilience_model)
max_cooks <- max(cooks_d)
max_cooks_idx <- which.max(cooks_d)
max_cooks_id <- data_n96$CONP_ID[max_cooks_idx]

cat(sprintf("  n = %d\n", n))
cat(sprintf("  4/n threshold = %.4f\n", threshold_4n))
cat(sprintf("  Max Cook's D = %.4f (observation %d, ID = %s)\n", 
            max_cooks, max_cooks_idx, max_cooks_id))
cat(sprintf("  Max Cook's D exceeds 4/n? %s\n", 
            ifelse(max_cooks > threshold_4n, "YES", "NO")))

# List all influential observations
influential_idx <- which(cooks_d > threshold_4n)
n_influential <- length(influential_idx)
cat(sprintf("\n  Number of observations with Cook's D > 4/n: %d\n", n_influential))

if (n_influential > 0) {
  cat("\n  Influential observations:\n")
  cat(sprintf("  %-4s %-14s %12s %10s %10s %10s %10s\n",
              "Obs", "CONP_ID", "Cook_D", "slope", "tau_suvr", "amyloid", "age"))
  cat(paste(rep("-", 75), collapse = ""), "\n")
  for (i in influential_idx) {
    cat(sprintf("  %-4d %-14s %12.4f %10.4f %10.4f %10.2f %10.1f\n",
                i, 
                data_n96$CONP_ID[i],
                cooks_d[i],
                data_n96$slope[i],
                data_n96$tau_suvr[i],
                data_n96$amyloid_centiloid[i],
                data_n96$age_years[i]))
  }
}

# Print ALL Cook's D values (top 20) for review
cat("\n  Cook's D values (top 20, sorted descending):\n")
cooks_sorted <- sort(cooks_d, decreasing = TRUE)
for (i in 1:min(20, length(cooks_sorted))) {
  obs_idx <- as.integer(names(cooks_sorted)[i])
  cat(sprintf("    %2d. Obs %2d (%s): Cook's D = %.4f %s\n",
              i, obs_idx, data_n96$CONP_ID[obs_idx], cooks_sorted[i],
              ifelse(cooks_sorted[i] > threshold_4n, " *** INFLUENTIAL", "")))
}

# --- 8. SENSITIVITY ANALYSIS ---
cat("\n============================================================\n")
cat("  STEP 8: SENSITIVITY ANALYSIS\n")
cat("  Refit model after excluding influential observations\n")
cat("============================================================\n\n")

tau_beta_original <- coefs["tau_suvr", "Estimate"]

# --- 8a. Exclude ALL observations with Cook's D > 4/n ---
if (n_influential > 0) {
  cat("--- 8a. Exclude ALL observations with Cook's D > 4/n ---\n")
  data_excl_all <- data_n96[-influential_idx, ]
  model_excl_all <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, 
                        data = data_excl_all)
  
  coefs_excl_all <- coef(summary(model_excl_all))
  tau_beta_excl_all <- coefs_excl_all["tau_suvr", "Estimate"]
  pct_change_all <- abs((tau_beta_excl_all - tau_beta_original) / tau_beta_original) * 100
  
  cat(sprintf("  Excluded: %d observations\n", n_influential))
  cat(sprintf("  Remaining n = %d\n", nrow(data_excl_all)))
  cat(sprintf("\n  Original tau β:  %.6f (p = %.6e)\n", 
              tau_beta_original, coefs["tau_suvr", "Pr(>|t|)"]))
  cat(sprintf("  Excluded tau β:  %.6f (p = %.6e)\n", 
              tau_beta_excl_all, coefs_excl_all["tau_suvr", "Pr(>|t|)"]))
  cat(sprintf("  %% change:        %.1f%%\n", pct_change_all))
  cat(sprintf("  Excluded adj R²: %.4f (original: %.4f)\n", 
              summary(model_excl_all)$adj.r.squared, adj_r2))
  
  cat("\n  Full model summary after exclusion:\n")
  print(summary(model_excl_all))
} else {
  cat("  No observations exceed Cook's D > 4/n threshold.\n")
  cat("  No exclusion needed.\n")
}

# --- 8b. Exclude ONLY the single most influential observation ---
cat("\n--- 8b. Exclude SINGLE most influential observation ---\n")
data_excl_max <- data_n96[-max_cooks_idx, ]
model_excl_max <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, 
                      data = data_excl_max)

coefs_excl_max <- coef(summary(model_excl_max))
tau_beta_excl_max <- coefs_excl_max["tau_suvr", "Estimate"]
pct_change_max <- abs((tau_beta_excl_max - tau_beta_original) / tau_beta_original) * 100

cat(sprintf("  Excluded: %s (Cook's D = %.4f)\n", max_cooks_id, max_cooks))
cat(sprintf("  Remaining n = %d\n", nrow(data_excl_max)))
cat(sprintf("\n  Original tau β:  %.6f (p = %.6e)\n", 
            tau_beta_original, coefs["tau_suvr", "Pr(>|t|)"]))
cat(sprintf("  Excluded tau β:  %.6f (p = %.6e)\n", 
            tau_beta_excl_max, coefs_excl_max["tau_suvr", "Pr(>|t|)"]))
cat(sprintf("  %% change:        %.1f%%\n", pct_change_max))

# --- 8c. Leave-one-out sensitivity: exclude each observation one at a time ---
cat("\n--- 8c. Leave-one-out sensitivity for tau β ---\n")
cat(sprintf("  Refitting model %d times (excluding one observation each time):\n\n", n))

loo_results <- data.frame(
  obs = integer(),
  CONP_ID = character(),
  cooks_d = numeric(),
  tau_beta = numeric(),
  tau_p = numeric(),
  pct_change = numeric(),
  stringsAsFactors = FALSE
)

for (i in 1:n) {
  data_loo <- data_n96[-i, ]
  model_loo <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, data = data_loo)
  coefs_loo <- coef(summary(model_loo))
  
  tau_beta_loo <- coefs_loo["tau_suvr", "Estimate"]
  tau_p_loo <- coefs_loo["tau_suvr", "Pr(>|t|)"]
  pct_change_loo <- abs((tau_beta_loo - tau_beta_original) / tau_beta_original) * 100
  
  loo_results <- rbind(loo_results, data.frame(
    obs = i,
    CONP_ID = data_n96$CONP_ID[i],
    cooks_d = cooks_d[i],
    tau_beta = tau_beta_loo,
    tau_p = tau_p_loo,
    pct_change = pct_change_loo,
    stringsAsFactors = FALSE
  ))
}

# Sort by % change descending, show top 20
loo_results <- loo_results[order(-loo_results$pct_change), ]

cat(sprintf("  %-4s %-14s %10s %12s %12s %10s\n",
            "Obs", "CONP_ID", "Cook_D", "tau_β", "tau_p", "% change"))
cat(paste(rep("-", 68), collapse = ""), "\n")
for (i in 1:min(20, nrow(loo_results))) {
  cat(sprintf("  %-4d %-14s %10.4f %12.6f %12.6e %9.1f%%\n",
              loo_results$obs[i],
              loo_results$CONP_ID[i],
              loo_results$cooks_d[i],
              loo_results$tau_beta[i],
              loo_results$tau_p[i],
              loo_results$pct_change[i]))
}

cat(sprintf("\n  Max %% change from any single exclusion: %.1f%% (excluding %s)\n",
            max(loo_results$pct_change),
            loo_results$CONP_ID[1]))
cat(sprintf("  Min %% change: %.1f%%\n", min(loo_results$pct_change)))
cat(sprintf("  Mean %% change: %.1f%%\n", mean(loo_results$pct_change)))

# --- 9. SUMMARY FOR MANUSCRIPT ---
cat("\n============================================================\n")
cat("  SUMMARY: VALUES FOR MANUSCRIPT SECTION 3.1\n")
cat("============================================================\n\n")
cat(sprintf("  Model fitted on: n = %d\n\n", n))
cat(sprintf("  [Tau β]              → %.4f (≈ −3.92)\n", coefs["tau_suvr", "Estimate"]))
cat(sprintf("  [Tau SE]             → %.4f\n", coefs["tau_suvr", "Std. Error"]))
cat(sprintf("  [Tau p]              → %.4e\n", coefs["tau_suvr", "Pr(>|t|)"]))
cat(sprintf("  [Amyloid β]          → %.6f (≈ −0.0098)\n", coefs["amyloid_centiloid", "Estimate"]))
cat(sprintf("  [Amyloid SE]         → %.6f\n", coefs["amyloid_centiloid", "Std. Error"]))
cat(sprintf("  [Amyloid p]          → %.4f\n", coefs["amyloid_centiloid", "Pr(>|t|)"]))
cat(sprintf("  [Age β]              → %.4f\n", coefs["age_years", "Estimate"]))
cat(sprintf("  [Age p]              → %.4f\n", coefs["age_years", "Pr(>|t|)"]))
cat(sprintf("  [Model variance %%]   → %.1f%%\n", r2 * 100))
cat(sprintf("  [Adjusted R²]        → %.4f\n", adj_r2))
cat(sprintf("  [Max Cook's D]       → %.4f\n", max_cooks))
cat(sprintf("  [Cook's D threshold] → %.4f (4/n = 4/%d)\n", threshold_4n, n))
cat(sprintf("  [Sensitivity %%]      → %.1f%% (excluding single most influential)\n", 
            pct_change_max))
if (n_influential > 0) {
  cat(sprintf("                       → %.1f%% (excluding all %d influential obs)\n", 
              pct_change_all, n_influential))
}

cat("\nDone.\n")
