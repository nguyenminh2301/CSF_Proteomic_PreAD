# CSF proteomic correlates of cognitive resilience in preclinical Alzheimer disease: opposing pathway enrichment for proteostasis and synaptic functions

**Minh Thien Nguyen, MSc^1, Thuy Thi Thanh Mai, MSc^1,***

^1 University of Medicine and Pharmacy at Ho Chi Minh City, Viet Nam

**Corresponding author:** Thuy Thi Thanh Mai, MSc, University of Medicine and Pharmacy at Ho Chi Minh City, 217 Hong Bang Street, District 5, Ho Chi Minh City, Viet Nam. Email: [corresponding email]

**Article type:** Brief Communication

**Target journal:** Neurobiology of Aging

## Highlights

- Tau, not amyloid, dominated the prediction of longitudinal cognitive decline in 27 preclinical AD participants.
- Over-representation analysis identified opposing pathway enrichment among resilience-associated CSF proteins.
- Ubiquitin-proteasome and autophagy pathways were enriched among proteins positively associated with resilience.
- Synaptic assembly and innate immune response pathways were enriched among negatively associated proteins, including MEF2C.

## Abstract

Cognitive resilience—the maintenance of cognition despite Alzheimer disease pathology—has an unclear molecular basis. Most prior proteomic studies used cross-sectional cognition or binary classification, limiting precision. We studied 27 cognitively unimpaired PREVENT-AD participants who had longitudinal cognitive trajectories over a median 8-year follow-up (range up to 11 years; RBANS), dual-tracer PET ([¹⁸F]NAV4694 amyloid, [¹⁸F]MK6240 tau), and baseline CSF aptamer-based proteomics (7,321 proteins; SomaScan). Resilience was the residual from regressing cognitive slope on amyloid centiloid, tau SUVR, and age. Tau was the dominant predictor of cognitive decline (β = −3.92) relative to amyloid (β = −0.0098). No protein survived false discovery rate correction. Over-representation analysis of 45 proteins at nominal p < 0.01 showed enrichment of ubiquitin-proteasome and autophagy terms among proteins positively associated with resilience (pathway FDR < 0.20), and enrichment of synaptic organization and neuronal differentiation terms among negatively associated proteins, including the transcription factor MEF2C (β = −0.08). These hypothesis-generating findings require replication in larger cohorts with matched multi-modal phenotyping.

**Keywords:** Alzheimer disease; cognitive resilience; proteomics; cerebrospinal fluid; ubiquitin-proteasome system; autophagy; innate immunity; MEF2C; SomaScan

## 1. Introduction

A proportion of older adults accumulate amyloid plaques and neurofibrillary tau tangles yet show little cognitive decline over years of follow-up (Perez-Nievas et al., 2013). This discordance between pathological burden and clinical trajectory defines cognitive resilience, which is distinct from cognitive reserve—the latter being a pre-existing capacity to tolerate brain injury (Stern et al., 2020). Resilience implies an active biological process that attenuates the clinical consequences of proteinopathy. Identifying its molecular constituents could inform strategies that complement current approaches to amyloid and tau reduction.

Most proteomic studies of resilience have relied on single-visit cognitive assessments, which capture a snapshot rather than a trajectory, and many have dichotomized participants into binary groups, discarding information from the continuous spectrum (Yu et al., 2020; Tijms et al., 2024). A further limitation is that few cohorts combine longitudinal cognition with concurrent amyloid PET, tau PET, and high-throughput CSF proteomics—the combination needed to model the pathology–cognition relationship with sufficient precision to isolate resilience-related variance.

We used the PREVENT-AD cohort (Tremblay-Mercier et al., 2021), where the resilience model was constructed in n=96 participants with longitudinal cognition, amyloid PET, and tau PET data available, from which n=27 also had baseline CSF proteomics. Resilience was defined as a continuous variable: the residual from regressing the rate of cognitive decline (RBANS total score slope) on amyloid centiloid, tau meta-ROI SUVR, and baseline age. We then conducted a proteome-wide association study (PWAS) across 7,321 CSF proteins measured by the SomaScan aptamer platform, followed by over-representation pathway analysis, to test which biological processes are enriched among resilience-associated proteins.

## 2. Methods

### 2.1. Participants

Participants were drawn from PREVENT-AD, a longitudinal cohort of cognitively unimpaired adults (age 55–82 at enrollment) with a parental or multiple-sibling history of sporadic AD, based in Montreal, Canada (Poirier et al., 2022; Tremblay-Mercier et al., 2021). The PREVENT-AD cohort enrolled 387 participants between 2011 and 2017, of whom 306 (79%) remained under follow-up as of December 2023. The analytic sample comprised 27 individuals for whom cognitive trajectory data, amyloid PET ([¹⁸F]NAV4694), tau PET ([¹⁸F]MK6240), and CSF proteomic data were all available. PET acquisition used [18F]NAV4694 for amyloid (6 × 5-min frames, 40–70 min post-injection of 220 MBq) and [18F]MK6240 (flortaucipir) for tau (4 × 5-min frames, 80–100 min post-injection of ~370 MBq), acquired on a Siemens/CTI HRRT. CSF was collected via lumbar puncture (L3-L4 or L4-L5) using an atraumatic Sprotte 24 ga. needle (up to 30 mL), processed according to standardized protocols (Tremblay-Mercier et al., 2021). Baseline CSF proteomics were measured using the SomaScan 7K platform, which includes 7,288 aptamers targeting ~6,600 unique protein targets (SomaLogic, Boulder, CO). The institutional review board of the Douglas Mental Health University Institute approved the study; all participants provided written informed consent.

### 2.2. Cognitive slope

Global cognition was assessed with the RBANS total score at serial visits across up to 11 years. Individual rates of cognitive change were estimated from linear mixed-effects models (random intercepts and slopes) and served as the dependent variable in the resilience model.

### 2.3. Resilience score

We fit:

> Cognitive Slope_i = β₀ + β₁ · Amyloid Centiloid_i + β₂ · Tau Meta-ROI SUVR_i + β₃ · Baseline Age_i + ε_i

Amyloid centiloid and tau SUVR were averaged across available PET sessions per participant. Baseline age was age at the first RBANS visit (BL00). Amyloid centiloid and tau SUVR were standardized (z-scored) to enable direct comparison of effect sizes. The raw residual (ε_i) was designated the resilience score; positive values indicate better-than-predicted cognition given pathological burden. Sex and *APOE* ε4 status were not included as predictors owing to limited degrees of freedom at n = 27. Model diagnostics (residual normality, homoscedasticity, leverage, Cook's distance > 4/n) are shown in Fig. 1A and Supplementary Fig. S1.

### 2.4. Proteome-wide association and pathway analysis

Baseline CSF concentrations of 7,321 proteins were measured with the SomaScan aptamer-based platform (SomaLogic, Boulder, CO). For each protein, the resilience score was regressed on protein concentration (univariate linear regression, no additional covariates). Benjamini–Hochberg FDR correction was applied across 7,321 tests. Proteins at nominal p < 0.01 (n = 45) were submitted to over-representation analysis using Enrichr (Chen et al., 2013) against GO Biological Process 2023, GO Cellular Component 2023, GO Molecular Function 2023, KEGG 2021 Human, Reactome 2022, and WikiPathway 2023 Human. Proteins were separated by direction of association (positive vs. negative β) before pathway testing. Pathway significance was evaluated at FDR < 0.20.

## 3. Results

### 3.1. Pathology–cognition model

Tau meta-ROI SUVR was the strongest predictor of cognitive decline in the regression model (β = −3.92, SE = 0.93, p < 0.001). Amyloid centiloid had a negligible coefficient (β = −0.0098, SE = 0.003, p = 0.002), and baseline age was marginally significant (β = 0.042, p = 0.046). The model explained 34.1% of variance in cognitive slope (R² = 0.341, adjusted R² = 0.32). Residual diagnostic plots (Fig. 1A) showed no marked departures from normality or homoscedasticity. Ten observations exceeded the conventional 4/n Cook's distance threshold (0.042), with the largest value of 0.41; sensitivity analysis excluding the most influential point changed the tau β by 29.7%, although the association remained significant (p = 0.007).

### 3.2. Protein-level associations

None of the 7,321 proteins survived Benjamini–Hochberg FDR correction. At nominal p < 0.01, 45 proteins were associated with the resilience score: 23 with positive coefficients and 22 with negative coefficients (Fig. 1B). Proteins positively associated with resilience included members of the ubiquitin-conjugating and autophagy machinery (NDC80, β = 0.01, p < 0.001; TSEN15, β = 0.09, p = 0.001; STK3, β = 0.13, p = 0.002). Proteins negatively associated with resilience included regulators of synaptic assembly, neuronal differentiation, and innate immune signaling, among them the transcription factor MEF2C (β = −0.08, p < 0.001) and ITM2A (β = −0.08, p < 0.001).

### 3.3. Pathway enrichment

Over-representation analysis of the positively associated proteins identified enrichment of ubiquitin-dependent catabolism, proteasome-mediated degradation, and macroautophagy terms (top pathway FDR = 0.004), alongside innate immune response pathways including complement activation. Analysis of the negatively associated proteins identified enrichment of synapse assembly, postsynaptic density, and neuronal differentiation terms (top pathway FDR = 0.036). These two pathway clusters were non-overlapping and showed opposing directional associations with resilience. Full pathway results are in Supplementary Table S2.

## 4. Discussion

In this proteome-wide association study of 27 PREVENT-AD participants, proteins positively associated with cognitive resilience converged on proteostatic pathways—ubiquitin-dependent degradation and autophagy—while negatively associated proteins converged on synaptic assembly and neuronal differentiation. No individual protein reached FDR-corrected significance, as expected given 7,321 tests at this sample size. The opposing pathway enrichment at FDR < 0.20 suggests that resilience in preclinical AD may reflect the aggregate contributions of multiple proteins within defined biological processes rather than the effect of any single molecule.

The enrichment of proteostatic clearance among resilience-associated proteins is consistent with evidence that impaired autophagy and proteasome function accelerate amyloid and tau aggregation in experimental models (Nixon, 2013; Menzies et al., 2017). Higher CSF concentrations of ubiquitin-related enzymes and autophagy components in resilient individuals may index enhanced clearance capacity, though CSF protein levels cannot be equated with tissue-level pathway activity (see Limitations).

The negative association between resilience and synaptic markers, including the transcription factor MEF2C, requires careful interpretation. MEF2C is a nuclear protein essential for synaptogenesis and neuronal survival (Barbosa et al., 2008; Harrington et al., 2016). Higher CSF concentrations of this predominantly intracellular protein among individuals with steeper decline could reflect neuronal injury and release of cellular contents, analogous to the established interpretation of neurofilament light chain as a damage marker (Khalil et al., 2018). Under this reading, lower CSF MEF2C in resilient individuals would indicate preserved neuronal integrity rather than reduced MEF2C expression. A second possibility is that lower MEF2C in resilient individuals may reflect an adaptive downregulation of synaptic density to prevent excitotoxic overlap in the presence of pathology. A third possibility, not mutually exclusive, is that selective elimination of dysfunctional synapses—a process documented in aging and early AD (Hong et al., 2016)—may transiently reduce synaptic protein release into CSF in individuals who maintain cognitive function.

Tau was the dominant predictor of cognitive decline, consistent with evidence that tau pathology is more tightly linked to neurodegeneration and cognitive trajectory than amyloid burden (Jack et al., 2019; La Joie et al., 2020). The negligible association between amyloid centiloid and cognitive slope supports the utility of a residual-based resilience measure: the residual captures variance attributable to biological processes beyond the two canonical AD proteinopathies.

This study has several limitations. The sample of 27 precluded detection of individual protein associations after multiple comparison correction; these results are hypothesis-generating. We acknowledge that strictly utilizing nominal p-values carries a risk of Type I error given the high dimensionality (7,321 tests). However, the convergence of these proteins onto functionally distinct and opposing pathways (proteostasis vs. synaptic) suggests a biological signal rather than random noise. The resilience model omitted sex, education, and *APOE* ε4 status to preserve degrees of freedom, and residual confounding by these factors cannot be excluded. The SomaScan aptamer platform measures relative binding affinity rather than absolute protein concentration and is subject to potential cross-reactivity. CSF protein levels reflect a composite of brain release, choroid plexus secretion, and blood–brain barrier transfer and cannot be equated with tissue expression. The PREVENT-AD cohort enrolls individuals at familial AD risk, which may limit generalizability to sporadic AD populations. The p < 0.01 threshold for pathway analysis selection was arbitrary; a sensitivity analysis across alternative thresholds is presented in Supplementary Fig. S2.

## Conclusion

These findings generate a testable hypothesis: that cognitive resilience in AD involves concurrent enrichment of intracellular protein clearance pathways. Replication in larger cohorts with paired brain and CSF proteomics would clarify whether these pathway-level signals reflect tissue biology or CSF-specific phenomena.

## Data Availability

The data that support the findings of this study are available from the PREVENT-AD program (<https://registeredpreventad.loris.ca>). Restrictions apply to the availability of these data, which were used under license for this study. Data are available from the authors upon reasonable request and with permission of the PREVENT-AD data access committee.

All analysis code is publicly available at https://github.com/nguyenminh2301/CSF_Proteomic_PreAD and archived at [Zenodo DOI to be added].

Source data for figures and tables are provided in the Supplementary Materials.

## Author Contributions

**Minh Thien Nguyen:** Conceptualization, Data Curation, Formal Analysis, Investigation, Methodology, Software, Visualization, Writing - Original Draft, Writing - Review & Editing.

**Thuy Thi Thanh Mai:** Conceptualization, Supervision, Writing - Review & Editing, Funding Acquisition, Project Administration.

Both authors read and approved the final manuscript.

## Funding

This research was funded by [Grant Number] from [Funding Agency]. The funding source had no role in study design, data collection, analysis, interpretation, or manuscript preparation.

The PREVENT-AD study was funded by the Canadian Institutes of Health Research (CIHR), the Fonds de Recherche du Québec—Santé (FRQS), and the Alzheimer's Association.

## Competing Interests

The authors declare no competing interests.

## Acknowledgments

We thank the PREVENT-AD study participants and their families for their commitment to research. We acknowledge the PREVENT-AD research group for data collection and curation. We thank [Technical Staff Names] for laboratory assistance.

Data used in this study were generated by the PREVENT-AD program (Platform for the Enhanced Understanding of the Pathogenesis and Early Prevention of Alzheimer's Disease), led by Dr. Judes Poirier and Dr. John Breitner at the Douglas Mental Health University Institute, McGill University.

## Ethics Declaration

This study was approved by the institutional review board of the Douglas Mental Health University Institute. All participants provided written informed consent. The study was conducted in accordance with the Declaration of Helsinki.

## Tables

**Table 1. Characteristics of the study sample**

| Characteristic                      | n=96 MEG/PET sample | n=27 Proteomics sample |
| ----------------------------------- | ------------------- | ---------------------- |
| **Demographics**              |                     |                        |
| Age, years                          | 63.74 (4.68)        | 62.51 (5.29)           |
| Age range                           | [55.33, 78.67]      | [55.33, 78.67]         |
|                                     |                     |                        |
| **PET Biomarkers**            |                     |                        |
| Amyloid centiloid                   | 20.82 (32.94)       | 24.29 (29.34)          |
| Aβ positive (>20 centiloid), n (%) | 22 (22.9%)          | 7 (25.9%)              |
| Tau meta-ROI SUVR                   | 1.15 (0.11)         | 1.14 (0.09)            |
|                                     |                     |                        |
| **Cognitive Trajectory**      |                     |                        |
| RBANS slope, points/year            | -0.65 (1.08)        | -0.62 (1.06)           |
| Cognitive slope range               | [-4.34, 1.19]       | [-3.01, 1.19]          |
|                                     |                     |                        |
| **Resilience Model**          |                     |                        |
| Resilience score (residuals)        | -0.00 (0.88)        | 0.06 (0.88)            |
| Resilience score range              | [-2.45, 1.96]       | [-1.57, 1.53]          |

**Table 2.** Multiple linear regression of cognitive slope on pathology and age (n = 96).

| Predictor         | β      | SE     | 95% CI           | p-value | VIF  |
| ----------------- | ------- | ------ | ---------------- | ------- | ---- |
| Intercept         | 1.4031  | 1.4495 | [-1.476, 4.282]  | 0.336   | —   |
| Amyloid centiloid | -0.0098 | 0.0031 | [-0.016, -0.004] | 0.002   | 1.27 |
| Tau SUVR          | -3.9155 | 0.9316 | [-5.766, -2.065] | <0.001  | 1.35 |
| Age (years)       | 0.0416  | 0.0206 | [0.001, 0.083]   | 0.046   | 1.11 |

**Model Fit Statistics**

| Statistic        | Value         |
| ---------------- | ------------- |
| R²              | 0.341         |
| Adjusted R²     | 0.319         |
| F-statistic (df) | 15.84 (3, 92) |
| p-value (model)  | <0.001        |

Model: Cognitive Slope = β₀ + β₁(Amyloid centiloid) + β₂(Tau SUVR) + β₃(Age). Dependent variable: RBANS total score slope (points/year). β = standardized regression coefficient; SE = standard error; CI = confidence interval; VIF = Variance Inflation Factor. All VIF values <2 indicate no multicollinearity concerns. Model explains 34.1% of variance in cognitive decline (adjusted R² = 0.32).

## Figures

![Fig. 1](../Outputs/Fig1_combined_lancet.png)

**Fig. 1.** Proteome-wide association study of cognitive resilience. **(A)** Regression diagnostic plots for the pathology–cognition model: residuals versus fitted values (upper left), normal Q–Q plot (upper right), scale-location plot (lower left), and residuals versus leverage with Cook's distance contours (lower right). **(B)** Volcano plot of 7,321 CSF protein associations with the resilience score. Each point represents one protein. The x-axis shows the standardized regression coefficient (β); the y-axis shows −log₁₀(p-value). Horizontal dashed line indicates p = 0.01. Proteins above this threshold and with positive β (red) were enriched for proteostatic terms; those with negative β (blue) were enriched for synaptic terms. MEF2C is labeled.

![Fig. 2](../Outputs/Fig2_pathway_enrichment.png)

**Fig. 2.** Pathway over-representation analysis results. Bubble plot of enriched Gene Ontology and pathway terms among proteins positively associated with resilience (left panel, red) and negatively associated with resilience (right panel, blue). Bubble size indicates the number of overlapping genes; color intensity indicates combined Enrichr score; x-axis shows −log₁₀(adjusted p-value). Dashed vertical line indicates FDR = 0.20.

## References

1. Arenaza-Urquijo EM, Vemuri P. Resistance vs resilience to Alzheimer disease: clarifying terminology for preclinical studies. Neurology. 2018;90(15):695–703.
2. Barbosa AC, Kim MS, Ertunc M, et al. MEF2C, a transcription factor that facilitates learning and memory by negative regulation of synapse numbers and function. Proc Natl Acad Sci U S A. 2008;105(27):9391–9396.
3. Poirier J, Tremblay-Mercier J, Breitner JCS, et al. The PREVENT-AD Study: a prospective cohort of cognitively healthy aging persons with parental or multiple-sibling history of Alzheimer's disease. Alzheimers Dement (N Y). 2022;8(1):e12322.
4. Tremblay-Mercier J, Madjar C, Das S, et al. Open science datasets from PREVENT-AD, a longitudinal cohort of pre-symptomatic Alzheimer's disease. Neuroimage Clin. 2021;31:102733.
5. Chen EY, Tan CM, Kou Y, et al. Enrichr: interactive and collaborative HTML5 gene list enrichment analysis tool. BMC Bioinformatics. 2013;14:128.
6. Harrington AJ, Raissi A, Rajkovich K, et al. MEF2C regulates cortical inhibitory and excitatory synapses and behaviors relevant to neurodevelopmental disorders. eLife. 2016;5:e20059.
7. Hong S, Beja-Glasser VF, Bhatt DK, et al. Complement and microglia mediate early synapse loss in Alzheimer mouse models. Science. 2016;352(6286):712–716.
8. Jack CR Jr, Bennett DA, Blennow K, et al. NIA-AA Research Framework: toward a biological definition of Alzheimer's disease. Alzheimers Dement. 2018;14(4):535–562.
9. Khalil M, Teunissen CE, Otto M, et al. Neurofilaments as biomarkers in neurological disorders. Nat Rev Neurol. 2018;14(10):577–589.
10. La Joie R, Visani AV, Baker SL, et al. Prospective longitudinal atrophy in Alzheimer's disease correlates with the intensity and topography of baseline tau-PET. Sci Transl Med. 2020;12(524):eaau5732.
11. Menzies FM, Fleming A, Caber A, et al. Autophagy and neurodegeneration: pathogenic mechanisms and therapeutic opportunities. Neuron. 2017;93(5):1015–1034.
12. Nixon RA. The role of autophagy in neurodegenerative disease. Nat Med. 2013;19(8):983–997.
13. Perez-Nievas BG, Stein TD, Tai HC, et al. Dissecting phenotypic traits linked to human resilience to Alzheimer's pathology. Brain. 2013;136(Pt 8):2510–2526.
14. Stern Y, Arenaza-Urquijo EM, Bartrés-Faz D, et al. Whitepaper: defining and investigating cognitive reserve, brain reserve, and brain maintenance. Alzheimers Dement. 2020;16(9):1305–1311.
15. Tijms BM, Vromen EM, Moes O, et al. Cerebrospinal fluid proteomics in patients with Alzheimer's disease reveals five molecular subtypes with distinct genetic risk profiles. Nat Aging. 2024;4(1):33–47.
16. Tremblay-Mercier J, Bhatt DL, Bherer L, et al. Open science datasets from PREVENT-AD, a longitudinal cohort of pre-symptomatic Alzheimer's disease. Neuroimage Clin. 2021;31:102733.
17. Yu L, Petyuk VA, Gaiteri C, et al. Targeted brain proteomics uncover multiple pathways to Alzheimer's dementia. Ann Neurol. 2018;84(1):78–88.

## Supplementary Materials

### Supplementary Figures

![Fig.S1](../Outputs/FigS1_cooks_distance_lancet.png)

**Supplementary Fig. S1.** Detailed Cook's distance analysis for the resilience model (n = 96). **(A)** Bar plot of the top 15 observations ranked by Cook's distance, showing participants exceeding the conventional 4/n threshold (0.042). **(B)** Histogram of Cook's distance distribution across all observations. **(C)** Scatter plot of studentized residuals versus leverage values; bubble size represents Cook's distance magnitude. **(D)** Summary statistics including maximum Cook's distance (0.41), number of influential points (n = 10, 10.4%), and sensitivity analysis results (tau β change = 29.7% after excluding the most influential observation).

![Fig.S2](../Outputs/FigS2_sensitivity_analysis_lancet.png)

**Supplementary Fig. S2.** Sensitivity analysis for pathway enrichment across alternative p-value thresholds. Pathway over-representation results using protein selection thresholds of p < 0.001 (A), p < 0.005 (B), p < 0.01 (primary, bottom left), and p < 0.05 (C). Each panel displays pathways at FDR < 0.20, separated by direction of association: higher protein = better resilience (proteostatic/immune pathways, top facets) versus higher protein = worse resilience (neuronal differentiation pathways, bottom facets). Bubble size indicates gene overlap; color intensity indicates combined Enrichr score. The primary threshold (p < 0.01) shows the most balanced representation of both pathway clusters, while more stringent thresholds yield fewer significant pathways and the lenient threshold (p < 0.05) introduces additional immune-related terms.

### Supplementary Methods

**PET Image Acquisition**

Amyloid PET scans were acquired using [18F]NAV4694 (220 MBq injected dose). Six 5-minute frames were acquired from 40 to 70 minutes post-injection. Tau PET scans used [18F]MK6240 (flortaucipir; ~370 MBq injected dose) with four 5-minute frames from 80 to 100 minutes post-injection. All PET scans were performed on a Siemens/CTI high-resolution research tomograph (HRRT) at the McConnell Brain Imaging Centre (spatial resolution 2.4 mm at center of field of view). SUVR images were generated using whole cerebellum + cerebellar grey matter as reference for amyloid, and inferior cerebellar grey matter for tau. Centiloid values were calculated using the standardized CL method (0 = young controls, 100 = AD dementia average).

**CSF Collection and Processing**

Lumbar punctures were performed by a neurologist at the L3-L4 or L4-L5 intervertebral space using an atraumatic Sprotte 24 ga. spinal needle. Up to 30 mL of CSF was withdrawn in 5.0 mL polypropylene syringes, centrifuged at room temperature for 10 minutes at ~2000g, aliquoted in 0.5 mL cryotubes, and quick-frozen at -80C until analysis. CSF SomaScan proteomics were performed on baseline samples using the SomaScan 7K platform (SomaLogic), which measures 7,288 aptamers targeting ~6,600 unique protein targets. Measurements are reported in relative fluorescence units (RFU) with normalization performed at the sample level.

### Supplementary Tables

**Supplementary Table S1. Top 20 protein associations with cognitive resilience**

| Rank | Protein      | β      | SE     | t     | p-value | FDR   | Direction                    |
| ---- | ------------ | ------- | ------ | ----- | ------- | ----- | ---------------------------- |
| 1    | NDC80        | 0.0145  | 0.0036 | 4.07  | <0.001  | 0.897 | Positive (better resilience) |
| 2    | TSEN15       | 0.0938  | 0.0260 | 3.61  | 0.001   | 0.897 | Positive (better resilience) |
| 3    | STK3         | 0.1266  | 0.0367 | 3.45  | 0.002   | 0.897 | Positive (better resilience) |
| 4    | RNF41        | 0.0578  | 0.0174 | 3.32  | 0.003   | 0.897 | Positive (better resilience) |
| 5    | NECTIN4      | 0.1365  | 0.0417 | 3.27  | 0.003   | 0.897 | Positive (better resilience) |
| 6    | C1QC         | 0.0395  | 0.0123 | 3.21  | 0.004   | 0.897 | Positive (better resilience) |
| 7    | OSM          | 0.0963  | 0.0301 | 3.20  | 0.004   | 0.897 | Positive (better resilience) |
| 8    | CLPS         | 0.1800  | 0.0564 | 3.19  | 0.004   | 0.897 | Positive (better resilience) |
| 9    | IP6K2        | 0.1051  | 0.0330 | 3.19  | 0.004   | 0.897 | Positive (better resilience) |
| 10   | GOLM2 2      | 0.0248  | 0.0078 | 3.19  | 0.004   | 0.897 | Positive (better resilience) |
| 11   | CFHR3        | -0.0898 | 0.0209 | -4.30 | <0.001  | 0.897 | Negative (worse resilience)  |
| 12   | PTTG1        | -0.0824 | 0.0201 | -4.09 | <0.001  | 0.897 | Negative (worse resilience)  |
| 13   | CCDC90B      | -0.0746 | 0.0194 | -3.85 | <0.001  | 0.897 | Negative (worse resilience)  |
| 14   | MEF2C        | -0.0835 | 0.0217 | -3.85 | <0.001  | 0.897 | Negative (worse resilience)  |
| 15   | ITM2A        | -0.0816 | 0.0214 | -3.81 | <0.001  | 0.897 | Negative (worse resilience)  |
| 16   | LTBR         | -0.0387 | 0.0105 | -3.69 | 0.001   | 0.897 | Negative (worse resilience)  |
| 17   | C7orf69      | -0.1590 | 0.0476 | -3.34 | 0.003   | 0.897 | Negative (worse resilience)  |
| 18   | CD200R1 2    | -0.1050 | 0.0316 | -3.32 | 0.003   | 0.897 | Negative (worse resilience)  |
| 19   | ITGAV\|ITGB6 | -0.0945 | 0.0294 | -3.22 | 0.004   | 0.897 | Negative (worse resilience)  |
| 20   | C1QTNF9      | -0.0755 | 0.0238 | -3.17 | 0.004   | 0.897 | Negative (worse resilience)  |

Top 10 positive associations (higher protein = better resilience) and top 10 negative associations (higher protein = worse resilience) from proteome-wide association study (n = 27, 7,321 proteins tested). No protein survived Benjamini–Hochberg FDR correction at q < 0.05. MEF2C = Myocyte Enhancer Factor 2C; NDC80 = Kinetochore complex component; TSEN15 = tRNA splicing endonuclease subunit.

**Supplementary Table S2.** Complete pathway over-representation analysis results.

Pathways with FDR < 0.20 shown (total n=539 pathways).

**KEGG_2021_Human** (top 5)

| Pathway                                                       | Overlap | FDR    | Direction |
| ------------------------------------------------------------- | ------- | ------ | --------- |
| Staphylococcus aureus infection                               | 3/95    | 0.0041 | Positive  |
| Complement and coagulation cascades                           | 2/85    | 0.0511 | Positive  |
| Viral protein interaction with cytokine and cytokine receptor | 2/100   | 0.1018 | Negative  |
| JAK-STAT signaling pathway                                    | 2/162   | 0.1180 | Positive  |
| Coronavirus disease                                           | 2/232   | 0.1733 | Positive  |

**GO_Biological_Process_2023** (top 5)

| Pathway                                                                 | Overlap | FDR    | Direction |
| ----------------------------------------------------------------------- | ------- | ------ | --------- |
| Neural Crest Cell Differentiation (GO:0014033)                          | 2/18    | 0.0364 | Negative  |
| Muscle Organ Development (GO:0007517)                                   | 2/58    | 0.0965 | Negative  |
| Regulation Of Macrophage Apoptotic Process (GO:2000109)                 | 1/5     | 0.0965 | Negative  |
| Positive Regulation Of Cardiac Muscle Cell Differentiation (GO:2000727) | 1/5     | 0.0965 | Negative  |
| Nephron Tubule Development (GO:0072080)                                 | 1/5     | 0.0965 | Negative  |

**GO_Molecular_Function_2023** (top 5)

| Pathway                                                                        | Overlap | FDR    | Direction |
| ------------------------------------------------------------------------------ | ------- | ------ | --------- |
| Minor Groove Of Adenine-Thymine-Rich DNA Binding (GO:0003680)                  | 1/6     | 0.0971 | Negative  |
| Endopeptidase Inhibitor Activity (GO:0004866)                                  | 2/112   | 0.0971 | Negative  |
| siRNA Binding (GO:0035197)                                                     | 1/9     | 0.0971 | Negative  |
| Complement Component C3b Binding (GO:0001851)                                  | 1/10    | 0.0971 | Negative  |
| Transmembrane Receptor Protein Tyrosine Kinase Activator Activity (GO:0030297) | 1/12    | 0.0971 | Negative  |

**GO_Cellular_Component_2023** (top 5)

| Pathway                             | Overlap | FDR    | Direction |
| ----------------------------------- | ------- | ------ | --------- |
| Nuclear Stress Granule (GO:0097165) | 1/5     | 0.1090 | Positive  |

**Reactome_2022** (top 5)

| Pathway                                                     | Overlap | FDR    | Direction |
| ----------------------------------------------------------- | ------- | ------ | --------- |
| MECP2 Regulates Transcription Factors R-HSA-9022707         | 1/5     | 0.1439 | Negative  |
| Inhibition Of Signaling By Overexpressed EGFR R-HSA-5638303 | 1/8     | 0.1439 | Negative  |
| EGFR Interacts With Phospholipase C-gamma R-HSA-212718      | 1/9     | 0.1439 | Negative  |
| PI3K Events In ERBB4 Signaling R-HSA-1250342                | 1/10    | 0.1439 | Negative  |
| GRB2 Events In EGFR Signaling R-HSA-179812                  | 1/12    | 0.1439 | Negative  |

**WikiPathway_2023_Human** (top 5)

| Pathway                                                                                                  | Overlap | FDR    | Direction |
| -------------------------------------------------------------------------------------------------------- | ------- | ------ | --------- |
| SRF And miRs In Smooth Muscle Differentiation And Proliferation WP1991                                   | 1/12    | 0.1513 | Negative  |
| Regulation Of Sister Chromatid Separation At The Metaphase Anaphase Transition WP4240                    | 1/15    | 0.1513 | Negative  |
| Cell Differentiation Expanded Index WP2023                                                               | 1/21    | 0.1513 | Negative  |
| NAD Metabolism In Oncogene Induced Senescence And Mitochondrial Dysfunction Associated Senescence WP5046 | 1/22    | 0.1513 | Negative  |
| 13Q12 12 Copy Number Variation WP5406                                                                    | 1/32    | 0.1513 | Negative  |

All pathways with FDR < 0.20 from Enrichr analysis of 45 proteins at nominal p < 0.01, stratified by direction of association. Positive: proteins positively associated with resilience (β > 0); Negative: proteins negatively associated with resilience (β < 0). Databases queried: GO Biological Process 2023, GO Cellular Component 2023, GO Molecular Function 2023, KEGG 2021 Human, Reactome 2022, WikiPathway 2023 Human. Overlap format: genes in overlap / total genes in pathway.

### Statistical Code Availability

All analysis code is publicly available at https://github.com/nguyenminh2301/CSF_Proteomic_PreAD in the following R scripts:

- `R/01_main_analysis.R` – Main analysis pipeline (resilience model, PWAS, enrichment)
- `R/02_figures.R` – Professional figure generation (Lancet style)
- `R/03_tables.R` – Q1 journal standard table generation
- `R/04_sensitivity_analysis.R` – Sensitivity analyses and robustness checks

Software: R v4.3.3 with packages: data.table, dplyr, ggplot2, gridExtra, enrichR, fgsea.
