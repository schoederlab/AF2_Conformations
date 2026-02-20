#!/bin/bash
# Author: Sevilay Gulesen
# creates list of output pdb files inside each output folder for TM-score calculations

for j in default wTemp_all wTemp_pre wTemp_post
do
    for i in EBOV RSV LASV1 LASV2 MARV HA JUNV LUJV CHAV MACV
    do
        ls -l outputs_full-length_seq/"$i"/"$j" | awk '{print $NF}' | grep .pdb > outputs_full-length_seq/"$i"/"$j"/pdb_list
        if [[ "$i" != "RSV" ]]; then
            ls -l outputs_cropped_seq/"$i"/"$j" | awk '{print $NF}' | grep .pdb > outputs_cropped_seq/"$i"/"$j"/pdb_list
        fi
    done
done

