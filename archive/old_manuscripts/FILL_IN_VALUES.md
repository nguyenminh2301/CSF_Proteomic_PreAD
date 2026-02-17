# Manuscript Placeholder Fill-In Values

> Source: `R_scrip.md` (R output from Jupyter notebook)
> Target: `FINAL-MANUSCRIPT_Ver1.md`
> Date: 2026-02-17

---

## Section 3.1 — Pathology–cognition model (Line 70)

### ✅ Values found in R output

| Placeholder | Location in manuscript | Value from R output | Source line in R_scrip.md |
|---|---|---|---|
| Tau SE | `SE = [__]` | **0.9316** | L1160: `tau_suvr -3.915451 0.931552` |
| Tau p-value | `p = [__]` | **6.09 × 10⁻⁵** | L1160: `6.09e-05 ***` |
| Amyloid SE | `SE = [__]` | **0.0031** | L1159: `amyloid_centiloid -0.009797 0.003140` |
| Amyloid p-value | `p = [__]` | **0.0024** | L1159: `0.00241 **` |
| Age β | `β = [__]` | **0.042** | L1161: `age_years 0.041637` |
| Age p-value | `p = [__]` | **0.046** | L1161: `0.04606 *` |
| Model % variance | `[__]%` | **34.1%** | L1166: `Multiple R-squared: 0.3406` |
| Adjusted R² | `adjusted R² = [__]` | **0.319** | L1166: `Adjusted R-squared: 0.3191` |

### ⚠️ Partially available — needs additional computation

| Placeholder | Issue | Available data |
|---|---|---|
| Cook's distance value | R output shows 10 observations exceed 4/n threshold. The **largest** Cook's D is **0.413** (observation 74 = CONP0000206). Note: the manuscript says "approaching but not exceeding the 4/n threshold" — this is **incorrect**, since 4/96 = 0.0417 and the max Cook's D is 0.413, which **far exceeds** 4/n. | L3384–3387 |
| Sensitivity analysis: `% change in tau β` | **NOT COMPUTED** in R_scrip.md. The script checks Cook's distance and influential points but does **not** refit the model after excluding influential observations. | — |

> [!CAUTION]
> **Cook's distance statement needs revision.** The R output shows 10 observations with Cook's D > 4/n (max = 0.413). The manuscript currently states one observation "approaching but not exceeding the 4/n threshold" — this contradicts the R results.

---

## Section 3.2 — Protein-level associations (Line 74)

### ✅ Values found in R output

| Placeholder | Value from R output | Source |
|---|---|---|
| `[__] with positive coefficients` | **23** | L1916: `Positive associations (n = 23)` |
| `[__] with negative coefficients` | **22** | L2078: `Negative associations (n = 22)` |
| MEF2C p-value | **0.00073** | L1392: `MEF2C -0.08353835 0.021717003 -3.846679 0.0007337525` |

### Top 3 positively associated proteins (for `[TOP 3 PROTEIN NAMES WITH β AND p: __]`)

From R output (sorted by p-value, positive β only):

| Rank | Protein | β | SE | p-value |
|---|---|---|---|---|
| 1 | NDC80 | 0.0145 | 0.0036 | 0.00042 |
| 2 | TSEN15 | 0.0938 | 0.0260 | 0.00135 |
| 3 | STK3 | 0.1266 | 0.0367 | 0.00200 |

> [!WARNING]
> **Mismatch with manuscript narrative.** The manuscript describes the top positive proteins as "members of the ubiquitin-conjugating and autophagy machinery." However, the actual top-ranked positive proteins (NDC80, TSEN15, STK3) are **not** ubiquitin/autophagy proteins:
>
> - **NDC80** = kinetochore component (cell division)
> - **TSEN15** = tRNA splicing endonuclease
> - **STK3** = serine/threonine kinase (Hippo signaling)
>
> The only ubiquitin-related protein in the top positive list is **RNF41** (rank 4, β = 0.0578, p = 0.00277), which is an E3 ubiquitin ligase. The narrative may need to be revised to accurately reflect the top protein identities, or the "ubiquitin/autophagy" claim should be limited to pathway-level enrichment rather than individual protein rankings.

### Second negative protein (for `[SECOND PROTEIN: __ (β = __, p = __)]`)

From R output (sorted by p-value, negative β only):

| Rank | Protein | β | SE | p-value |
|---|---|---|---|---|
| 1 | CFHR3 | −0.0898 | 0.0209 | 0.00023 |
| 2 | PTTG1 | −0.0824 | 0.0201 | 0.00039 |
| 3 | CCDC90B | −0.0746 | 0.0194 | 0.00073 |
| 4 | MEF2C | −0.0835 | 0.0217 | 0.00073 |
| 5 | ITM2A | −0.0816 | 0.0214 | 0.00080 |

> Suggested second protein: **ITM2A** (β = −0.0816, p = 0.00080) — already mentioned in the Discussion as amyloid-related.

> [!CAUTION]
> **MEF2C β discrepancy.** The manuscript Abstract states `β = −0.45` for MEF2C. The R output shows **β = −0.0835** (unstandardized). These do not match. Possible explanations:
>
> 1. The abstract value may be a **standardized β**, but this was not computed in the R script.
> 2. The value −0.45 may have been fabricated in a prior draft.
>
> **Action required:** Either compute the standardized β for MEF2C, or correct the abstract to use the unstandardized value (−0.084). The manuscript line 74 also references `β = −0.45` — this should be reconciled.

---

## Section 3.3 — Pathway enrichment (Line 78)

### ✅ Values found in R output

| Placeholder | Value from R output | Details |
|---|---|---|
| Top pathway FDR for positive-β protein ORA | **0.004** | KEGG: Staphylococcus aureus infection (FDR = 0.0041) |
| Top pathway FDR for negative-β protein ORA | **0.036** | GO:BP: Neural Crest Cell Differentiation (FDR = 0.0364) |

> [!IMPORTANT]
> **Pathway interpretation note.** The manuscript describes the positively associated pathway enrichment as "ubiquitin-dependent catabolism, proteasome-mediated degradation, and macroautophagy." However, the actual **top pathway by FDR** is:
>
> - Staphylococcus aureus infection (KEGG, FDR = 0.004)
> - Complement and coagulation cascades (KEGG, FDR = 0.051)
>
> The ubiquitin/autophagy pathways appear in the **hypothesis-specific analysis** (Section In [25]):
>
> - Metal-Dependent Deubiquitinase Activity (GO, FDR = 0.107)
> - Selective Autophagy (GO, FDR = 0.131)
> - Protein Autoubiquitination (GO, FDR = 0.136)
> - Macroautophagy (GO, FDR = 0.165)
>
> The manuscript narrative should clarify that ubiquitin/autophagy enrichment is noted at FDR < 0.20, not as the top pathway result.

---

## Summary: What can be filled now vs. what needs computation

### ✅ Can be inserted directly (12 values)

```
Line 70 (Section 3.1):
  Tau β SE       → 0.93
  Tau p          → 6.09 × 10⁻⁵
  Amyloid β SE   → 0.0031
  Amyloid p      → 0.0024
  Age β          → 0.042
  Age p          → 0.046
  Variance %     → 34.1
  Adjusted R²    → 0.319

Line 74 (Section 3.2):
  Positive-β count  → 23
  Negative-β count  → 22
  MEF2C p-value     → 0.00073

Line 78 (Section 3.3):
  Top pathway FDR (positive) → 0.004
  Top pathway FDR (negative) → 0.036
```

### ❌ Cannot be filled — needs additional R code

| Item | What is needed | Suggested R code |
|---|---|---|
| Sensitivity analysis (% change in tau β) | Refit model excluding influential observations, compare tau β | See below |
| Standardized β for MEF2C | Scale predictors and outcome, or use `lm.beta` package | See below |
| Cook's D statement correction | Rewrite the sentence in Section 3.1 | Narrative revision |
| Protein narrative (Section 3.2) | Revise "ubiquitin-conjugating and autophagy machinery" or choose different proteins | Narrative revision |

### R code for missing computations

```r
# ---- 1. Sensitivity analysis: exclude influential observations ----
influential_ids <- which(cooks.distance(resilience_model) > 4/nrow(data_merged))
data_excl <- data_merged[-influential_ids, ]
model_excl <- lm(slope ~ amyloid_centiloid + tau_suvr + age_years, data = data_excl)
tau_beta_original <- coef(resilience_model)["tau_suvr"]
tau_beta_excl <- coef(model_excl)["tau_suvr"]
pct_change <- abs((tau_beta_excl - tau_beta_original) / tau_beta_original) * 100
cat("Tau β original:", tau_beta_original, "\n")
cat("Tau β after exclusion:", tau_beta_excl, "\n")
cat("% change:", round(pct_change, 1), "%\n")

# ---- 2. Standardized β for MEF2C ----
mef2c_data <- data_proteomics[, c("resilience_score", "MEF2C")]
mef2c_data_scaled <- as.data.frame(scale(mef2c_data))
fit_std <- lm(resilience_score ~ MEF2C, data = mef2c_data_scaled)
cat("MEF2C standardized β:", coef(fit_std)["MEF2C"], "\n")
```
