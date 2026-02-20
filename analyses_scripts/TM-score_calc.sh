#!/bin/bash
# Author: Sevilay Gulesen

for i in EBOV RSV LASV1 LASV2 MARV HA JUNV LUJV CHAV MACV
do
    
    if [[ "$i" == "EBOV" ]]; then
        REF_STR_PRE="reference_structures/3csy_clean.pdb"
        REF_STR_POST="reference_structures/2ebo_clean.pdb"
    elif [[ "$i" == "RSV" ]]; then
        REF_STR_PRE="reference_structures/4mms_clean.pdb"
        REF_STR_POST="reference_structures/3rki_clean.pdb"
    elif [[ "$i" == "LASV1" ]]; then
        REF_STR_PRE="reference_structures/7puy_clean.pdb"
        REF_STR_POST="reference_structures/5omi_clean.pdb"
    elif [[ "$i" == "LASV2" ]]; then
        REF_STR_PRE="reference_structures/5vk2_clean.pdb"
        REF_STR_POST="reference_structures/6jgy_clean.pdb"
    elif [[ "$i" == "MARV" ]]; then
        REF_STR_PRE="reference_structures/6bp2_clean.pdb"
        REF_STR_POST="reference_structures/4g2k_clean.pdb"
    elif [[ "$i" == "HA" ]]; then
        REF_STR_PRE="reference_structures/1hgg_clean.pdb"
        REF_STR_POST="reference_structures/1htm_clean.pdb"
    elif [[ "$i" == "JUNV" ]]; then 
        REF_STR_PRE="reference_structures/7puy_clean.pdb" # There was no prefusion structure for JUNV, so used LASV's prefusion structure when project started
        REF_STR_POST="reference_structures/5omi_clean.pdb" # There was no postfusion structure for JUNV, so used LASV's postfusion structure when project started
    elif [[ "$i" == "LUJV" ]]; then
        REF_STR_PRE="reference_structures/7puy_clean.pdb" # There was no prefusion structure for LUJV, so used LASV's prefusion structure when project started
        REF_STR_POST="reference_structures/5omi_clean.pdb" # There was no postfusion structure for LUJV, so used LASV's postfusion structure when project started
    elif [[ "$i" == "CHAV" ]]; then
        REF_STR_PRE="reference_structures/7puy_clean.pdb" # There was no prefusion structure for CHAV, so used LASV's prefusion structure when project started
        REF_STR_POST="reference_structures/5omi_clean.pdb" # There was no postfusion structure for CHAV, so used LASV's postfusion structure when project started
    elif [[ "$i" == "MACV" ]]; then
        REF_STR_PRE="reference_structures/7puy_clean.pdb" # There was no prefusion structure for MACV, so used LASV's prefusion structure when project started
        REF_STR_POST="reference_structures/5omi_clean.pdb" # There was no postfusion structure for MACV, so used LASV's postfusion structure when project started
    fi

    for j in default wTemp_all wTemp_pre wTemp_post
    do

        while read LINE
        do
            ./software/USalign  outputs_full-length_seq/"$i"/"$j"/"$LINE" "$REF_STR_PRE" -mm 1 -ter 1 -outfmt 2 >> outputs_full-length_seq/"$i"/"$j"/pref_tmscore.txt 
            ./software/USalign  outputs_full-length_seq/"$i"/"$j"/"$LINE" "$REF_STR_POST" -mm 1 -ter 1 -outfmt 2 >> outputs_full-length_seq/"$i"/"$j"/postf_tmscore.txt
        done < outputs_full-length_seq/"$i"/"$j"/pdb_list
        
        if [[ "$i" != "RSV" ]]; then

            while read LINE
            do
                ./software/USalign outputs_cropped_seq/"$i"/"$j"/"$LINE" "$REF_STR_PRE" -mm 1 -ter 1 -outfmt 2 >> outputs_cropped_seq/"$i"/"$j"/pref_tmscore.txt 
                ./software/USalign  outputs_cropped_seq/"$i"/"$j"/"$LINE" "$REF_STR_POST" -mm 1 -ter 1 -outfmt 2 >> outputs_cropped_seq/"$i"/"$j"/postf_tmscore.txt
            done < outputs_cropped_seq/"$i"/"$j"/pdb_list
        fi
    done
done

