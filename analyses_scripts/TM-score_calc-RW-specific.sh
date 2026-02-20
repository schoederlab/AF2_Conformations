#!/bin/bash
# Author: Sevilay Gulesen

mkdir RW_Prefusion-Specific_analyses/

for i in JUNV LUJV CHAV MACV
do
    
    if [[ "$i" == "JUNV" ]]; then 
        REF_STR_PRE="reference_structures/9ghj_clean.pdb" # Aa a specific analyses, JUNV's prefusion structure was used
        PRE="9ghj"
    elif [[ "$i" == "LUJV" ]]; then
        REF_STR_PRE="reference_structures/8p4t_clean.pdb" # As a specific analyses, LUJV's prefusion structure was used
        PRE="8p4t"
    elif [[ "$i" == "CHAV" ]]; then
        REF_STR_PRE="reference_structures/9ghj_clean.pdb" # As a specific analyses, CHAV's prefusion structure was not available, so JUNV's prefusion structure was used since they are closely related than LASV
        PRE="9ghj"
    elif [[ "$i" == "MACV" ]]; then
        REF_STR_PRE="reference_structures/9ghi_clean.pdb" # As a specific analyses, MACV's prefusion structure was used
        PRE="9ghi"
    fi

    for j in default wTemp_all wTemp_pre wTemp_post
    do
        while read LINE
        do
            ./software/USalign  outputs_full-length_seq/"$i"/"$j"/"$LINE" "$REF_STR_PRE" -mm 1 -ter 1 -outfmt 2 >> RW_Prefusion-Specific_analyses/"$i"_"$j"_pref_tm-"$PRE".dat 
        done < outputs_full-length_seq/"$i"/"$j"/pdb_list
        
        while read LINE
        do
            ./software/USalign outputs_cropped_seq/"$i"/"$j"/"$LINE" "$REF_STR_PRE" -mm 1 -ter 1 -outfmt 2 >> RW_Prefusion-Specific_analyses/"$i"_"$j"_cropped_pref_tm-"$PRE".dat 
        done < outputs_cropped_seq/"$i"/"$j"/pdb_list
    done
done

