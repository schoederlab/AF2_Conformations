#!/bin/bash 
# Author: Sevilay Gulesen

# NOTE: RSV is processed for full-length, but skipped for cropped-sequence because of its postfusion structure

mkdir pLDDT_TM_scores

for j in default wTemp_all wTemp_pre wTemp_post
do
    for i in EBOV RSV LASV1 LASV2 MARV HA JUNV LUJV CHAV MACV
    do
    # --- Full-length case (Runs for ALL viruses) ---
        awk '/rank_/ {split($4, a, "=");print $3 ".pdb " a[2]}' outputs_full-length_seq/"$i"/"$j"/log.txt  >> pLDDT_TM_scores/plddt_"$i"_"$j".dat
        awk '/alphafold2_multimer_v3_model/ && !/rank/ && $4 ~ /=/ {split($4, a, "="); split($5, b, "=");print $3 ".r" a[2] ".pdb " b[2]}' outputs_full-length_seq/"$i"/"$j"/log.txt >> pLDDT_TM_scores/plddt_"$i"_"$j".dat

        echo -e "virus pdb plddt pre_TM post_TM" >> pLDDT_TM_scores/"$i"_plddt_TM_"$j".dat
        
        while read -r pdb plddt; do
            if [[ $pdb =~ rank ]]; then
                pre_TM=$(grep "_relaxed_${pdb}" outputs_full-length_seq/"$i"/"$j"/pref_tmscore.txt | awk '{print $4}')
                post_TM=$(grep "_relaxed_${pdb}" outputs_full-length_seq/"$i"/"$j"/postf_tmscore.txt | awk '{print $4}')
            else
                pre_TM=$(grep "$pdb" outputs_full-length_seq/"$i"/"$j"/pref_tmscore.txt | awk '{print $4}')
                post_TM=$(grep "$pdb" outputs_full-length_seq/"$i"/"$j"/postf_tmscore.txt | awk '{print $4}')
            fi
            echo -e "$i $pdb $plddt $pre_TM $post_TM" >> pLDDT_TM_scores/"$i"_plddt_TM_"$j".dat
        done < "pLDDT_TM_scores/plddt_"$i"_"$j".dat"

        rm pLDDT_TM_scores/plddt_"$i"_"$j".dat

    # --- Cropped-sequence case (Runs for everyone except RSV) ---
        if [[ "$i" != "RSV" ]]; then
            awk '/rank_/ {split($4, a, "=");print $3 ".pdb " a[2]}' outputs_cropped_seq/"$i"/"$j"/log.txt >> pLDDT_TM_scores/plddt_"$i"_cropped_"$j".dat
            awk '/alphafold2_multimer_v3_model/ && !/rank/ && $4 ~ /=/ {split($4, a, "="); split($5, b, "=");print $3 ".r" a[2] ".pdb " b[2]}' outputs_cropped_seq/"$i"/"$j"/log.txt >> pLDDT_TM_scores/plddt_"$i"_cropped_"$j".dat

            echo -e "virus pdb plddt pre_TM post_TM" >> pLDDT_TM_scores/"$i"_plddt_TM_cropped_"$j".dat

            while read -r pdb plddt; do
                if [[ $pdb =~ rank ]]; then
                    pre_TM=$(grep "_relaxed_${pdb}" outputs_cropped_seq/"$i"/"$j"/pref_tmscore.txt | awk '{print $4}')
                    post_TM=$(grep "_relaxed_${pdb}" outputs_cropped_seq/"$i"/"$j"/postf_tmscore.txt | awk '{print $4}')
                else
                    pre_TM=$(grep "$pdb" outputs_cropped_seq/"$i"/"$j"/pref_tmscore.txt | awk '{print $4}')
                    post_TM=$(grep "$pdb" outputs_cropped_seq/"$i"/"$j"/postf_tmscore.txt | awk '{print $4}')
                fi
                echo -e "$i $pdb $plddt $pre_TM $post_TM" >> pLDDT_TM_scores/"$i"_plddt_TM_cropped_"$j".dat
            done < "pLDDT_TM_scores/plddt_"$i"_cropped_"$j".dat"

            rm pLDDT_TM_scores/plddt_"$i"_cropped_"$j".dat
        fi
        
    done
done


# ==============================================================================
# Merge Results
# ==============================================================================


for j in default wTemp_all wTemp_pre wTemp_post
do
    # Merge Canonical benchmark set 
    echo -e "virus pdb plddt pre_TM post_TM" >> pLDDT_TM_scores/CB-plddt_TM_"$j".dat
    echo -e "virus pdb plddt pre_TM post_TM" >> pLDDT_TM_scores/CB-plddt_TM_cropped_"$j".dat
    for i in EBOV RSV LASV1 LASV2 MARV HA; do
        grep -v virus pLDDT_TM_scores/"$i"_plddt_TM_"$j".dat >> pLDDT_TM_scores/CB-plddt_TM_"$j".dat
        if [[ "$i" != "RSV" ]]; then
            grep -v virus pLDDT_TM_scores/"$i"_plddt_TM_cropped_"$j".dat >> pLDDT_TM_scores/CB-plddt_TM_cropped_"$j".dat
        fi
    done
    
    # Merge Real-World benchmark set
    echo -e "virus pdb plddt pre_TM post_TM" >> pLDDT_TM_scores/RW-plddt_TM_"$j".dat
    echo -e "virus pdb plddt pre_TM post_TM" >> pLDDT_TM_scores/RW-plddt_TM_cropped_"$j".dat
    for i in JUNV LUJV CHAV MACV; do 
        grep -v virus pLDDT_TM_scores/"$i"_plddt_TM_"$j".dat >> pLDDT_TM_scores/RW-plddt_TM_"$j".dat
        grep -v virus pLDDT_TM_scores/"$i"_plddt_TM_cropped_"$j".dat >> pLDDT_TM_scores/RW-plddt_TM_cropped_"$j".dat
    done
done



