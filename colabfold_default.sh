#!/bin/bash

# ColabFold version 1.5.2 (32359508e7890916a51b1680594418a78162d01c) was used for the respective project.

input_seq="input.fasta" # Input sequence file with its full path. Change it based on your/virus file name. Example: input_seq="input_data/Canonical/EBOV/3csy_Zaire1976_EBOV.fasta"
VIRUS="INPUT" # Virus name for selecting templates. Change it based on your virus. Example: VIRUS="EBOV"

# Run for full-length-sequence with default features (no specific templates are provided)
colabfold_batch --amber --use-gpu-relax --templates --model-type alphafold2_multimer_v3 --num-recycle 5 --save-recycles  $input_seq ./outputs/"$VIRUS"/default

# Run for cropped-sequence with default features (no specific templates are provided)
#colabfold_batch --amber --use-gpu-relax --templates --model-type alphafold2_multimer_v3 --num-recycle 5 --save-recycles $input_seq ./outputs_cropped_seq/"$VIRUS"/default

