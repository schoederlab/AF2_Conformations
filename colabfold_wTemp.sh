#!/bin/bash

# ColabFold version 1.5.2 (32359508e7890916a51b1680594418a78162d01c) was used for the respective project.

input_seq="input.fasta" # Input sequence file with its full path. Change it based on your/virus file name.Example: input_seq="input_data/Canonical/EBOV/3csy_Zaire1976_EBOV.fasta"
VIRUS="INPUT" # Virus name for selecting templates. Change it based on your virus. Example: VIRUS="EBOV"
TEMP_TYPE= "all" # Template type: options are "all", "pre", "post"

# Run for full-length-sequence with templates from specified folder
colabfold_batch --amber --use-gpu-relax --templates --custom-template-path ../templates/for_"$VIRUS"/"$TEMP_TYPE" --model-type alphafold2_multimer_v3 --num-recycle 5 --save-recycles $input_seq ./outputs/"$VIRUS"/wTemp_"$TEMP_TYPE"

# Run for cropped-sequence with templates from specified folder
#colabfold_batch --amber --use-gpu-relax --templates --custom-template-path ../templates/for_"$VIRUS"/"$TEMP_TYPE" --model-type alphafold2_multimer_v3 --num-recycle 5 --save-recycles $input_seq ./outputs_cropped_seq/"$VIRUS"/wTemp_"$TEMP_TYPE"

