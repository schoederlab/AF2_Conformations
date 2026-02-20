#!/bin/bash
# Author: Sevilay Gulesen

for j in default wTemp_all wTemp_pre wTemp_post
do
    for i in JUNV LUJV CHAV MACV
    do
        
        head -n 1 pLDDT_TM_scores/"$i"_plddt_TM_"$j".dat >  RW_Prefusion-Specific_analyses/"$i"_plddt_TM_"$j"_prefusion-specific.dat

        tail -n +2 pLDDT_TM_scores/"$i"_plddt_TM_"$j".dat  | while IFS=' ' read -r col1 col2 col3 col4 rest; do
            match=$(grep -F "$col2" RW_Prefusion-Specific_analyses/"$i"_"$j"_pref_tm-*.dat | head -n1)
            if [[ -n "$match" ]]; then
                read -r m1 m2 m3 m4 _ <<< "$match"
                col4="$m4"
            fi
            echo "$col1 $col2 $col3 $col4 $rest"
        done >> RW_Prefusion-Specific_analyses/"$i"_plddt_TM_"$j"_prefusion-specific.dat

        head -n 1 pLDDT_TM_scores/"$i"_plddt_TM_cropped_"$j".dat >  RW_Prefusion-Specific_analyses/"$i"_plddt_TM_cropped_"$j"_prefusion-specific.dat

        tail -n +2 pLDDT_TM_scores/"$i"_plddt_TM_cropped_"$j".dat  | while IFS=' ' read -r col1 col2 col3 col4 rest; do
            match=$(grep -F "$col2" RW_Prefusion-Specific_analyses/"$i"_"$j"_cropped_pref_tm-*.dat | head -n1)
            if [[ -n "$match" ]]; then
                read -r m1 m2 m3 m4 _ <<< "$match"
                col4="$m4"
            fi
            echo "$col1 $col2 $col3 $col4 $rest"
        done >> RW_Prefusion-Specific_analyses/"$i"_plddt_TM_cropped_"$j"_prefusion-specific.dat
    done


    # Merge Real-World benchmark set
    echo -e "virus pdb plddt pre_TM post_TM" >> RW_Prefusion-Specific_analyses/RW-plddt_TM_"$j"_prefusion-specific.dat
    echo -e "virus pdb plddt pre_TM post_TM" >> RW_Prefusion-Specific_analyses/RW-plddt_TM_cropped_"$j"_prefusion-specific.dat
    for i in JUNV LUJV CHAV MACV
    do 
        grep -v virus RW_Prefusion-Specific_analyses/"$i"_plddt_TM_"$j"_prefusion-specific.dat >> RW_Prefusion-Specific_analyses/RW-plddt_TM_"$j"_prefusion-specific.dat
        grep -v virus RW_Prefusion-Specific_analyses/"$i"_plddt_TM_cropped_"$j"_prefusion-specific.dat >> RW_Prefusion-Specific_analyses/RW-plddt_TM_cropped_"$j"_prefusion-specific.dat
    done

done 

