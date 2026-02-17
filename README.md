# CSF Proteomic Correlates of Cognitive Resilience in Preclinical Alzheimer's Disease

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-4.3.3-blue.svg)](https://www.r-project.org/)
[![Status](https://img.shields.io/badge/Status-Under%20Review-orange.svg)]()

This repository contains analysis code and supplementary materials for the research project:

> **CSF proteomic correlates of cognitive resilience in preclinical Alzheimer disease: opposing pathway enrichment for proteostasis and synaptic functions**

## 📋 Overview

Cognitive resilience—the maintenance of cognition despite Alzheimer disease pathology—has an unclear molecular basis. This research investigated CSF protein associations with cognitive resilience in 27 cognitively unimpaired PREVENT-AD participants with longitudinal cognitive trajectories (median 8-year follow-up), dual-tracer PET, and high-throughput proteomics.

> **Note**: The manuscript document is not included in this public repository. This repository contains analysis code, figures, tables, and processed data only.

### Key Findings

- **Tau dominance**: Tau SUVR (β = −3.92) was the strongest predictor of cognitive decline vs. amyloid (β = −0.0098)
- **Proteostatic pathways**: Ubiquitin-proteasome and autophagy terms enriched among proteins positively associated with resilience
- **Synaptic pathways**: Neuronal differentiation and synaptic assembly terms enriched among negatively associated proteins (including MEF2C)
- **No individual proteins survived FDR correction**, but pathway-level signals suggest resilience reflects aggregate protein contributions

## 📁 Repository Structure

```
.
├── README.md                 # This file
├── LICENSE                   # MIT License
├── .gitignore               # Git ignore rules
├── CITATION.cff             # Citation file
# Note: Manuscript files are not included in this public repository
├── R/                       # R analysis code
│   ├── 01_main_analysis.R   # Resilience model, PWAS, enrichment
│   ├── 02_figures.R         # Professional figure generation (Lancet style)
│   └── 03_tables.R          # Q1 journal standard table generation
├── data/                    # Data files (raw + processed)
│   ├── raw/                 # Raw data (not tracked in git)
│   └── processed/           # Processed analysis outputs
├── figures/                 # Generated figures
│   ├── main/                # Main manuscript figures
│   │   ├── Fig1.{png,pdf,tiff}    # Combined diagnostics + volcano
│   │   └── Fig2.{png,pdf,tiff}    # Pathway enrichment bubble plot
│   └── supplementary/       # Supplementary figures
│       ├── FigS1_diagnostics.*    # Model diagnostics
│       ├── FigS1B_volcano.*       # Separate volcano plot
│       ├── FigS2_cooks_distance.* # Cook's distance analysis
│       ├── FigS3_distribution.*   # Resilience score distribution
│       └── FigS4_sensitivity.*    # Sensitivity analysis
├── tables/                  # Generated tables
│   ├── Table1_baseline_characteristics.{csv,md}
│   ├── Table2_model_results.{csv,md}
│   ├── SupplementaryTableS1_top_proteins.{csv,md}
│   └── SupplementaryTableS2_pathway_enrichment.{csv,md}
└── archive/                 # Archived old versions
    ├── old_figures/         # Previous figure versions
    ├── old_manuscripts/     # Previous manuscript drafts
    └── old_docs/            # Old documentation
```

## 🔧 Requirements

### Software

- **R** (version 4.3.3 or higher)
- **RStudio** (recommended but not required)

### R Packages

```r
# Core packages
install.packages(c("data.table", "dplyr", "ggplot2", "gridExtra", "tidyr"))

# Analysis packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("fgsea")

# Optional but recommended
install.packages("gtsummary")  # For professional tables
```

### Data Access

This analysis uses data from the **PREVENT-AD** cohort. Data access is restricted and requires:

1. Registration at [registeredpreventad.loris.ca](https://registeredpreventad.loris.ca)
2. Approval from the PREVENT-AD data access committee
3. Appropriate ethics approvals

> ⚠️ **Note**: Raw PREVENT-AD data files are NOT included in this repository due to data sharing restrictions. Processed outputs (summary statistics, de-identified results) are provided in `data/processed/`.

## 🚀 Usage

### Reproducing the Analysis

1. **Clone the repository**:

```bash
git clone https://github.com/nguyenminh2301/CSF_Proteomic_PreAD.git
cd CSF_Proteomic_PreAD
```

2. **Obtain PREVENT-AD data access**:

   - Register at [registeredpreventad.loris.ca](https://registeredpreventad.loris.ca)
   - Download required data files
   - Place in `data/raw/` directory (see `data/raw/README.md` for file list)
3. **Run the analysis pipeline**:

```r
# In R, set working directory to repository root
setwd("path/to/CSF_Proteomic_PreAD")

# Run main analysis
source("R/01_main_analysis.R")

# Generate figures
source("R/02_figures.R")

# Generate tables
source("R/03_tables.R")
```

### Analysis Workflow

```
Raw Data → Resilience Model → PWAS → Pathway Enrichment → Figures/Tables
    ↓              ↓              ↓            ↓
  RBANS      Cognitive     Protein      Enrichr
  PET          Slope      Associations   ORA
  CSF
  Proteomics
```

## 📊 Key Outputs

### Main Figures

- **Figure 1**: Model diagnostics (A) + Volcano plot of 7,321 protein associations (B)
- **Figure 2**: Pathway over-representation analysis bubble plots

### Supplementary Figures

- **Figure S1**: Detailed model diagnostics (4-panel)
- **Figure S2**: Cook's distance influence analysis
- **Figure S3**: Resilience score distribution
- **Figure S4**: Sensitivity analysis across p-value thresholds

### Tables

- **Table 1**: Baseline characteristics (n=96 MEG/PET vs n=27 proteomics)
- **Table 2**: Resilience model results with VIF diagnostics
- **Supplementary Table S1**: Top 20 protein associations
- **Supplementary Table S2**: Complete pathway enrichment results

## 📖 Citation

If you use this code or data, please cite:

```
Nguyen MT, Mai TT. CSF proteomic correlates of cognitive resilience in 
preclinical Alzheimer's disease: opposing pathway enrichment for proteostasis 
and synaptic functions. [Manuscript in preparation]
```

And the PREVENT-AD cohort paper:

```
Poirier J, Tremblay-Mercier J, Breitner JCS, et al. The PREVENT-AD Study: 
a prospective cohort of cognitively healthy aging persons with parental or 
multiple-sibling history of Alzheimer's disease. Alzheimers Dement (N Y). 
2022;8(1):e12322. doi: 10.1002/trc2.12322
```

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

The PREVENT-AD data are subject to separate terms of use available at [registeredpreventad.loris.ca](https://registeredpreventad.loris.ca).

## 👥 Authors

- **Minh Thien Nguyen, MSc** - Data Curation, Formal Analysis, Visualization, Writing
- **Thuy Thi Thanh Mai, MSc** - Conceptualization, Supervision, Funding Acquisition

## 🙏 Acknowledgments

- **PREVENT-AD Research Group** for data collection and curation
- **StoP-AD Centre**, McGill University for research infrastructure
- **Douglas Mental Health University Institute** for ethics approval and facilities
- Participants and families in the PREVENT-AD cohort

## 📞 Contact

For questions about this analysis:

- Email: nguyenminh2301[at]gmail[dot]com
- Issues: Please use GitHub Issues for code-related questions

For PREVENT-AD data access:

- Website: [registeredpreventad.loris.ca](https://registeredpreventad.loris.ca)
- General inquiries: preventad@douglas.mcgill.ca

---

**Last Updated**: 2025-02-17
**Version**: 1.0.0
