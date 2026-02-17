# Data Directory

This directory contains data used in the analysis. Due to data sharing restrictions, **raw PREVENT-AD data files are not included** in this repository.

## Directory Structure

```
data/
├── README.md              # This file
├── raw/                   # Raw data (NOT tracked in git)
│   └── README.md         # Instructions for obtaining raw data
└── processed/            # Processed outputs (tracked in git)
    ├── pwas_results_resilience.csv
    ├── resilience_scores_n96.csv
    ├── resilience_scores_proteomics_n27.csv
    ├── gsea_enrichment_results.csv
    └── sensitivity_enrichment_results.csv
```

## Raw Data

Raw data from the PREVENT-AD cohort must be obtained separately through the official data access process:

1. **Register** at [registeredpreventad.loris.ca](https://registeredpreventad.loris.ca)
2. **Complete** the data access application
3. **Obtain** ethics approval from your institution
4. **Download** approved data files
5. **Place** files in `data/raw/` directory

### Required Raw Data Files

The analysis requires the following PREVENT-AD data files (to be placed in `data/raw/`):

| File | Description | Visit(s) |
|------|-------------|----------|
| `RBANS.csv` | Repeatable Battery for Assessment of Neuropsychological Status | All available |
| `PET_NAV_SUVR_ref-wholeCerebellum.csv` | Amyloid PET (NAV4694) SUVR values | Baseline + follow-ups |
| `PET_FTP_SUVR_ref-infCerebellarGray.csv` | Tau PET (MK6240) SUVR values | Baseline + follow-ups |
| `CSF_SomaScan_7K_proteins.csv` | SomaScan 7K proteomics | BL00 only |
| `MEG_relative_power_DK.csv` | MEG resting-state power | Baseline |

> ⚠️ **Note**: These files contain participant identifiers and are subject to strict confidentiality agreements. Never share or redistribute these files.

## Processed Data

Processed data files (summary statistics, de-identified results) are included in this repository:

### `pwas_results_resilience.csv`
Results from proteome-wide association study (PWAS) of 7,321 proteins.

**Columns:**
- `protein`: Protein name (SomaScan aptamer ID)
- `beta`: Regression coefficient
- `se`: Standard error
- `t_stat`: t-statistic
- `p_value`: Nominal p-value
- `fdr`: FDR-adjusted p-value
- `n_obs`: Number of observations
- `rank_metric`: -log10(p) * sign(beta) for GSEA

### `resilience_scores_n96.csv`
Resilience scores and model variables for n=96 participants (MEG/PET sample).

**Columns:**
- `CONP_ID`: Participant ID (de-identified)
- `slope`: RBANS cognitive slope (points/year)
- `age_years`: Baseline age
- `amyloid_centiloid`: Mean amyloid PET centiloid
- `tau_suvr`: Mean tau PET SUVR (meta-ROI)
- `resilience_score`: Model residual

### `resilience_scores_proteomics_n27.csv`
Resilience scores for n=27 proteomics subsample.

### `gsea_enrichment_results.csv`
Pathway over-representation analysis results from Enrichr.

### `sensitivity_enrichment_results.csv`
Sensitivity analysis results across multiple p-value thresholds.

## Data Use Terms

When using PREVENT-AD data:

1. ✅ Use only for non-commercial neuroscience research
2. ✅ Cite PREVENT-AD in all publications
3. ✅ Maintain data security and confidentiality
4. ❌ Do not redistribute raw data
5. ❌ Do not attempt to re-identify participants
6. ❌ Do not use for commercial purposes

Full terms: [registeredpreventad.loris.ca/terms](https://registeredpreventad.loris.ca)

## Data Processing

Raw data are processed using the R scripts in `R/`:

```
Raw Data → 01_main_analysis.R → Processed Outputs
    ↓
Resilience Model (n=96)
    ↓
PWAS (n=27, 7,321 proteins)
    ↓
Pathway Enrichment
    ↓
Results CSV files
```

## Contact

For questions about data access: preventad@douglas.mcgill.ca  
For questions about this analysis: [corresponding email]
