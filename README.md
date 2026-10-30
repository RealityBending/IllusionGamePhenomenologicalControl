# Illusion Sensitivity & Phenomenological Control

*A Stage 2 Registered Report (PCI Registered Reports), registered on OSF ([osf.io/kvjnm](https://osf.io/kvjnm)) following Stage 1 in-principle acceptance on 5 December 2025.*

**Abstract**. Visual illusions highlight how easily our conscious experience can be altered with respect to perceptual reality. Despite sharing in-principle mechanisms with phenomenological control, i.e., the ability to alter our perceptual experience to match task demands or expectations, research tying the two remains scarce. This study aimed to replicate and extend Lush et al., (2022) by testing for a relationship between phenomenological control and illusion sensitivity across multiple illusion types, assessing the role of higher-level (top-down) processes. It also examines associations between visual illusion sensitivity and psychoticism to assess the potential contribution of lower-level effects (e.g., weak priors). Five hundred participants were recruited in an online study using an illusion-based perceptual decision paradigm (Illusion Game; Makowski et al., 2023) measuring sensitivity to three visual illusions (Ebbinghaus, Müller-Lyer, Vertical-Horizontal), alongside the Phenomenological Control Scale and personality measures. Bayesian correlation analyses provided evidence against a relationship between phenomenological control and sensitivity to the Müller-Lyer and Ebbinghaus illusions, whereas the evidence was inconclusive for the Vertical-Horizontal illusion. The data also favoured the absence of the hypothesised association between illusion sensitivity and psychoticism. These findings are consistent with the hypothesis that these illusions are to some degree cognitively impenetrable under the present task conditions, and suggest that susceptibility to them operates independently of trait-level control over subjective experience. However, low consistency across illusion measures highlights important methodological limitations in capturing individual differences related to illusion sensitivity.

- [**Try the experiment**](https://realitybending.github.io/IllusionGamePhenomenologicalControl/experiment/index?exp=readme)
- [**Stage 1 Registered Report (preprint)**](https://osf.io/preprints/psyarxiv/873th)
- [**Stage 2 manuscript (preprint)**](https://osf.io/preprints/psyarxiv/873th_v5)
- [**Data Cleaning Report**](https://realitybending.github.io/IllusionGamePhenomenologicalControl/analysis/1_cleaning.html)
- [**Data Analysis Report**](https://realitybending.github.io/IllusionGamePhenomenologicalControl/analysis/2_analysis.html)
- **Archived version (Zenodo)**: [DOI]

## Where to find what

| You are looking for… | Go to |
|---|---|
| The current version of the manuscript (Stage 2, revision 1) | [`paper/Stage2_R1/manuscript_R1.qmd`](paper/Stage2_R1/manuscript_R1.qmd) (rendered: `manuscript_R1.docx`) |
| The response to the recommender and reviewers | [`paper/Stage2_R1/IllusionPCS_Revision_response.docx`](paper/Stage2_R1/) |
| Previous versions of the manuscript | [`paper/R0/`](paper/R0/), [`paper/R1/`](paper/R1/) (Stage 1, initial submission and revision), [`paper/Stage2/`](paper/Stage2/) (Stage 2, initial submission) |
| The data | [`data/`](data/) (see [Data](#data)) |
| The analysis code | [`analysis/`](analysis/) (see [Analysis pipeline](#analysis-pipeline)) |
| The figures and tables used in the manuscript | [`analysis/figures/`](analysis/figures/) |
| The experiment code and stimuli | [`experiment/`](experiment/) |
| Ethics documents and PCS materials | [`documents/`](documents/) |

## Data

All data files are in [`data/`](data/). Participants are identified by codes (`S001`–`S500`, ordered by date of participation), which are consistent across files.

| File | Content | Produced by |
|---|---|---|
| `rawdata_participants.csv` | One row per recruited participant (N = 500): demographics, experiment metadata, PCS item responses and attention checks (`pcs_hello`, `pcs_noballs`, `pcs_press`), PID-5 and IPIP-6 items | `analysis/preprocessing.R` |
| `rawdata_illusion.csv` | One row per Illusion Game trial (240,000 trials): illusion type, illusion strength and difference, block, RT (in seconds), response, accuracy and error | `analysis/preprocessing.R` |
| `data_participants.csv` | Participants retained after all registered exclusions **except** the space bar attention check (N = 468), with computed questionnaire scores (e.g., `PID5_Psychoticism`) and exclusion flags (`PCS_Outlier_Press`, `IG_Outlier_RTBlock_Full`, `IG_Outlier_RTBlock_Half`) | `analysis/1_cleaning.qmd` |
| `data_illusion.csv` | Illusion Game trials of these participants, with the derived conditions (`Condition_Illusion`: Congruent / Mild / Strong; `Condition_Difficulty`: Easy / Hard) and the trial-level flag `RT_Outlier` (RT < 0.2 s or > 5 s) | `analysis/1_cleaning.qmd` |
| `data_participants_registered.csv` | Participants retained after **all** registered exclusion criteria, including the space bar check (N = 295) | `analysis/1_cleaning.qmd` |
| `data_illusion_registered.csv` | Illusion Game trials of the fully registered sample | `analysis/1_cleaning.qmd` |

Key variables of the trial-level files:

| Variable | Description |
|---|---|
| `Illusion_Type` | `Ebbinghaus`, `MullerLyer` or `VerticalHorizontal` |
| `Illusion_Strength` | Strength of the illusion (positive = incongruent, i.e., biasing towards the wrong answer; negative = congruent) |
| `Illusion_Difference` | Objective difference between the targets (task difficulty) |
| `Block` | `A` (first set) or `B` (second set) |
| `RT` | Response time, in seconds |
| `Response_Correct`, `Error` | Accuracy of the response |

PCS items are scored from 0 to 5; the PCS score is the mean of the 10 items (computed in `2_analysis.qmd`). PID-5 items are scored from 0 to 3.

## Analysis pipeline

The scripts are run in the following order. Each Quarto document renders to an HTML report documenting every step (links above).

1. **[`analysis/preprocessing.R`](analysis/preprocessing.R)** — Reads the raw jsPsych files (one per participant), extracts the participant- and trial-level data, recodes participants as `S001`–`S500`, and writes `rawdata_participants.csv` and `rawdata_illusion.csv`. The raw jsPsych files contain identifiers and are stored in a private OSF repository, so this step cannot be rerun without access to them; its (anonymised) outputs are provided in `data/`, and all following steps start from these.
2. **[`analysis/1_cleaning.qmd`](analysis/1_cleaning.qmd)** — Computes questionnaire scores, applies the exclusion criteria, and writes the cleaned data files (both samples) and the exclusion counts used in the flow diagram. Each exclusion step is labelled as registered or unregistered, and is followed by an *Apply* section where it is implemented. The report is organised as follows:
   - **Data Preparation**
     - *Experiment Duration*
     - *Personality Questionnaires*: IPIP6 and PID-5 scores
     - *Exclusions*
       - *PCS*: the three attention checks as registered (*PCS (registered)*), the deviation of not applying the space bar check in the main analysis (*PCS (unregistered)*), and *Apply*
       - *Illusion Game Participants*: error rate > 45% with the block-specific rule (*Error Rate (registered)*), mean RT > 4 SD (*Response Time (registered)*), the block-wise RT rule flagged for a sensitivity analysis (*Sensitivity: Block-Wise RT Rule (unregistered)*), and *Apply*
       - *Illusion Game Trials*: no trial-level criterion was registered (*Registered*); trials with RT < 0.2 s or > 5 s are flagged for a sensitivity analysis (*Unregistered*); and *Apply*
       - *Final Sample*: the fully registered sample, N = 295 (*Registered*), and the sample without the space bar check, N = 468 (*Without the Space Bar Check (unregistered)*), each with a summary and plots of age and gender, education and ethnicity
   - **Exclusion Counts**: the numbers used in the exclusion flow diagram
   - **Save**: writes the four cleaned data files
3. **[`analysis/2_analysis.qmd`](analysis/2_analysis.qmd)** — Computes the illusion sensitivity scores (error rate and inverse efficiency score, IES), runs the manipulation checks, the registered decision rule for collapsing Mild and Strong conditions, reliability analyses, the registered Bayesian correlations, and all sensitivity and exploratory analyses. Saves all tables (`.rds`) and figures (`.png`) used in the manuscript to `analysis/figures/`.
4. **[`paper/Stage2_R1/manuscript_R1.qmd`](paper/Stage2_R1/manuscript_R1.qmd)** — The manuscript, which reads the tables and figures from `analysis/figures/`.

### Registered and unregistered analyses

| Step | Status | Where |
|---|---|---|
| PCS attention checks (“Hello”, “no balls”) | Registered | `1_cleaning.qmd` → *Exclusions → PCS → PCS (registered)* |
| PCS space bar attention check | Registered; applied in the fully registered analysis only (deviation: not applied in the analysis without the space bar check) | `1_cleaning.qmd` → *Exclusions → PCS → PCS (registered)* and *PCS (unregistered)*; *Final Sample → Registered* |
| Error rate > 45% (block-specific rule) | Registered | `1_cleaning.qmd` → *Exclusions → Illusion Game Participants → Error Rate (registered)* |
| Mean RT > 4 SD (participant-level) | Registered | `1_cleaning.qmd` → *Exclusions → Illusion Game Participants → Response Time (registered)* |
| Block-wise RT rule | Unregistered (sensitivity analysis) | `1_cleaning.qmd` → *Exclusions → Illusion Game Participants → Sensitivity: Block-Wise RT Rule (unregistered)*; `2_analysis.qmd` → *Sensitivity Datasets* |
| Trial-level RT filter (< 0.2 s or > 5 s) | Unregistered (sensitivity analysis) | `1_cleaning.qmd` → *Exclusions → Illusion Game Trials → Unregistered*; `2_analysis.qmd` → *Sensitivity Datasets* |
| 97.5% HDI exclusion of extreme error rates | Unregistered (sensitivity analysis) | `2_analysis.qmd` → *Outlier Removal* |
| Manipulation checks (Bayesian *t*-tests) | Registered | `2_analysis.qmd` → *Manipulation Check* |
| Decision rule for collapsing Mild and Strong (r > .50) | Registered | `2_analysis.qmd` → *Should we collapse across Mild and Strong?* → *Registered Decision* |
| Reliability (Cronbach's α) | Registered | `2_analysis.qmd` → *Reliability* |
| Bayesian correlations (PCS and psychoticism × error rate and IES; r-scale = 1/3) | Registered | `2_analysis.qmd` → *Correlations* → *Registered Tests* |
| Mild and Strong analysed separately; Easy and Hard trials analysed separately | Exploratory | `2_analysis.qmd` → *Correlations* and *Sensitivity Analyses* |

## Reproducing the analyses

Requirements:

- [R](https://cran.r-project.org/) (analyses were run with R 4.6.1) and [Quarto](https://quarto.org/) (also bundled with RStudio).
- R packages: `tidyverse`, `easystats` (including `bayestestR`, `correlation`, `datawizard`, `insight`, `parameters`, `report`, `see`), `BayesFactor`, `ggdist`, `ggside`, `patchwork`, `psych`, `gt` and `kableExtra`; for the manuscript, also `flextable`, `ftExtra`, `officer`, `conflicted` and `knitr`.

```r
install.packages(c("tidyverse", "easystats", "BayesFactor", "ggdist", "ggside", "patchwork",
                   "psych", "gt", "kableExtra", "flextable", "ftExtra", "officer", "conflicted", "knitr"))
```

Then, from the repository root:

```bash
quarto render analysis/1_cleaning.qmd
quarto render analysis/2_analysis.qmd
quarto render paper/Stage2_R1/manuscript_R1.qmd --to apaquarto-docx
```

## Experiment

The experiment was implemented in [jsPsych](https://www.jspsych.org/) and is hosted on GitHub Pages ([try it](https://realitybending.github.io/IllusionGamePhenomenologicalControl/experiment/index?exp=readme)). The code is in [`experiment/`](experiment/): `index.html` defines the timeline, `IllusionGame.js` the Illusion Game, and `demographics.js` and `questionnaires.js` the consent form, demographics, PID-5 and IPIP-6. The Phenomenological Control Scale is loaded from [RealityBending/JSmisc](https://github.com/RealityBending/JSmisc) (`questionnaires/PCS/pcs_new.js`). The stimuli were generated with [*Pyllusion*](https://github.com/RealityBending/Pyllusion).
