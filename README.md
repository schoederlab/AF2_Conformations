# Prediction of pre- and postfusion conformations of class I fusion proteins with AlphaFold2

This repository contains an end-to-end bioinformatics workflow for modeling viral proteins using **ColabFold (AlphaFold2 Multimer v3)**, featuring automated structural analysis using pLDDT confidence metrics and TM-score alignment.

This project implements a computational workflow for:
- **Protein structure prediction** using local ColabFold (AlphaFold2 Multimer v3)
- **High-throughput analysis** across multiple viral proteins with custom templates
- **Structure validation** via TM-score calculations against reference structures
- **Confidence analysis** using pLDDT (predicted Local Distance Difference Test) scores

Benchmark info could be find the end of the page.

## Installation & Requirements
### Dependencies

- **ColabFold** v1.5.2 
- **Python** 3.8+
- **R** (for visualization scripts)
- **USalign** (for TM-score calculations)

For **ColabFold installation and setup**, please refer to the official documentation:

- [ColabFold GitHub Repository](https://github.com/sokrypton/ColabFold)

This project uses **ColabFold v1.5.2** running on a cluster in batch mode.

### ColabFold Parameters Used

```
--model-type alphafold2_multimer_v3   # Multimer model for prediction
--num-recycle 5                       # Recycling iterations for refinement
--save-recycles                       # Save intermediate recycles
--use-gpu-relax                       # GPU-accelerated structure relaxation
--amber                               # AMBER force field relaxation
--templates                           # Use template guidance (when applicable)
```

## Usage
### Structure Prediction (Default - Template-free)

```bash
# Change fasta file and virus name
vim colabfold_default.sh
# For cropped-sequence case, please comment out line 9 and uncomment line 12.

# Run prediction
bash colabfold_default.sh
```
**Output:** Ranked models, relaxed structures, and alignment logs in `outputs_full-length_seq/{VIRUS}/default/`

### Structure Prediction (With Custom Templates)

```bash
# Edit script based on fasta file, virus name and template folder type (as all, pre and post template structures)
vim colabfold_wTemp.sh
# For cropped-sequence case, please comment out line 10 and uncomment line 13.

# Run prediction with templates
bash colabfold_wTemp.sh
```
**Output:** Template-guided predictions as ranked models, relaxed structures, and alignment logs in `outputs_full-length_seq/{VIRUS}/wTemp_{all|pre|post}/`

### TM-Score Calculation
Compare predicted structures against reference structures:

```bash
bash analysis_scripts/TM-score_calc.sh
```
Calculates TM-scores with comparing prefusion and postfusion reference structures. Results store in `pLDDT_TM_scores/`.

### Extract Quality Metrics
Extract pLDDT and TM-score data:

```bash
bash analysis_scripts/get_plddt-TM.sh
```
Generates combined metrics files: `pLDDT_TM_scores/{VIRUS}_plddt_TM_{method}.dat`

### Visualization
Generate publication-quality plots:

```bash
# Install R dependencies if not already installed
Rscript -e "install.packages(c('ggplot2', 'dplyr', 'tidyr'))"
```

```bash
# TM-score comparison plots for both FirstBenchmark and Real-World benchmark set
Rscript analysis_scripts/TM-score_graphs.r

# pLDDT vs TM-score scatter plots for both FirstBenchmark and Real-World benchmark set
Rscript analysis_scripts/TM-plddt_graphs.r
```
Plots store as png in `pLDDT_TM_scores`

```bash
# pLDDT vs TM-score scatter plots for only RealWorld prefusion-specific analysis
Rscript analysis_scripts/TM-plddt_graphs_RW-prefsuion-specific.r
```

## Output Files
### Prediction Outputs
- `rank_*.pdb` -> Top-ranked predicted structures
- `*_relaxed_rank_*.pdb` -> AMBER-relaxed structures
- `log.txt` -> Prediction metadata (pLDDT, confidence)
- `result_*.pkl` -> Full model outputs with alignment data

### Analysis Outputs
- `pref_tmscore.txt` -> TM-scores for prefusion conformation
- `postf_tmscore.txt` -> TM-scores for postfusion conformation
- `*_plddt_TM_*.dat` -> Combined metrics table: virus, pdb, pLDDT, pre_TM and post_TM

## Real-World Prefusion Specific Analysis Extensions
For Real-World prefusion specific analysis:

```bash
bash analysis_scripts/TM-score_calc-RW-specific.sh
bash analysis_scripts/get_plddt-TM_RW_prefusion_specific.sh
Rscript analysis_scripts/TM-plddt_graphs_RW-prefsuion-specific.r
```

## Helper Scripts

`clean_pdb.py` (sourced from [RosettaCommons](https://github.com/RosettaCommons)) were used to prepare reference and template pdb files. This script sanitizes the pdb by removing all ligand and water atoms, ensuring only the protein chains remain. Ensure `amino_acids.py` is present in the same directory as the script, as it is a required dependency.

```bash
python clean_pdb.py {input_name}.pdb ignorechain
```

## Benchmark 
**First-Benchmark Set:**
- EBOV - Ebola virus (Zaire- Mayinga 1976 (3CSY & 2EBO))
- RSV - Respiratory Syncytial virus (RAV-A_Strain A (3RKI & 4MMS))
- HA - Influenza Hemagglutinin (A/Aichi/2/1968-H3N2(1HTM & 1HGG))
- LASV1 - Lassa virus (Mouse/Sierra Leone/Josiah/1976 (7PUY & 5OMI))
- LASV2 - Lassa virus (Mouse/Sierra Leone/Josiah/1976 (5VK2 & 6JGY))
- MARV - Marburg virus (Lake Victoria(Kenya)_Ravn87 (6BP2 & 4G2K))

**Real-World Benchmark Set:**
- CHAV - Chapare virus (YP_001816782 - Bolivia 2003)
- JUNV - Junin virus (NP_899218)
- LUJV - Lujo virus (ACR56359)
- MACV - Machupo virus (NP_8999212)

## References
- **AlphaFold2**: Jumper et al., Nature (2021)
- **ColabFold**: Mirdita et al., Nature Methods (2022)
- **US-align**: Zhang et al., Nature Methods (2022)

## License
MIT License. 
Copyright (c) 2025 Sevilay Gulesen

**Last Updated:** 2025 | **ColabFold Version:** 1.5.2
