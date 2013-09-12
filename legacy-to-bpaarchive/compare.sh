#!/bin/bash

cd ~/tree-compare/legacy-to-bpaarchive || exit 1

## # melanoma / ramaciotti - DONE
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops132_melanoma_ramaciotti.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/ramaciotti/BRLOPS-132/ \
##         -x brlops132_melanoma_ramaciotti.sh \
##         /pbstore/groupfs/bpa/legacy/melanoma/raw/ramaciotti/ \
##         /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/ramaciotti/
## 
## # melanoma / agrf - DONE
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops134_melanoma_agrf.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/agrf/BRLOPS-134/ \
##         -x brlops134_melanoma_agrf.sh \
##         /pbstore/groupfs/bpa/legacy/melanoma/raw/agrf/ \
##         /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/agrf/
## 
## # wheat / cultivar - DONE
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops135_wheat_cultivar.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/raw/unknown/BRLOPS-135/ \
##         -x brlops135_wheat_cultivar.sh \
##         /pbstore/groupfs/bpa/legacy/wheat/cultivar/ \
##         /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/
## 
## # wheat / pathogen - DONE
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops136_wheat_pathogen.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Pathogens/raw/unknown/BRLOPS-136/ \
##         -x brlops136_wheat_pathogen.sh \
##         /pbstore/groupfs/bpa/legacy/wheat/pathogen/ \
##         /pbstore/groupfs/bpa/bpaarchive/Wheat_Pathogens/
## 
## #   # legacy / raw - DONE
## #   ~/tree-compare/tree-compare.py \
## #           -c treecompcache.json.bz2 \
## #           -l legacy_raw.csv \
## #           -t /pbstore/groupfs/bpa/bpaarchive/BRLOPS-137/ \
## #           -x melanoma_new.sh \
## #           /pbstore/groupfs/bpa/legacy/raw/ \
## #           /pbstore/groupfs/bpa/bpaarchive/

## # # melanoma / new NOT DONE
## # ~/tree-compare/tree-compare.py \
## #         -c treecompcache.json.bz2 \
## #         -l brlops133_melanoma_new.csv \
## #         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/BRLOPS-133/ \
## #         -x brlops133_melanoma_new.sh \
## #         /pbstore/groupfs/bpa/legacy/melanoma/raw/new/ \
## #         /pbstore/groupfs/bpa/bpaarchive/Melanoma/
## 

# RUNNING
# ~/tree-compare/tree-compare.py \
#         -c treecompcache.json.bz2 \
#         -l brlops144_melanoma_anu.csv \
#         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/anu/BRLOPS-144/ \
#         -x brlops144_melanoma_anu.sh \
#         /pbstore/groupfs/bpa/ANU/melanoma_ANU/ \
#         /pbstore/groupfs/bpa/bpaarchive/
# ~/tree-compare/tree-compare.py \
#         -c treecompcache.json.bz2 \
#         -l brlops146_wheat_wyalcatchem.csv \
#         -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/raw/agrf/BRLOPS-146 \
#         -x brlops146_wheat_wyalcatchem.sh \
#         /pbstore/groupfs/bpa/legacy/raw/agrf/run152/ \
#         /pbstore/groupfs/bpa/bpaarchive/
# ~/tree-compare/tree-compare.py \
#         -c treecompcache.json.bz2 \
#         -l brlops147_wheat_wheat7a.csv \
#         -t /pbstore/groupfs/bpa/bpaarchive/Wheat7a/raw/anu/BRLOPS-147 \
#         -x brlops147_wheat_wheat7a.sh \
#         /pbstore/groupfs/bpa/temp/wheat7a/raw_data/ \
#         /pbstore/groupfs/bpa/bpaarchive/
# ~/tree-compare/tree-compare.py \
#         -c treecompcache.json.bz2 \
#         -l brlops149_unsw_melanoma.csv \
#         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/unsw/BRLOPS-149 \
#         -x brlops149_unsw_melanoma.sh \
#         /pbstore/groupfs/bpa/UNSW/ \
#         /pbstore/groupfs/bpa/bpaarchive/

exit 0

# final x-check
~/tree-compare/tree-compare.py \
        -c treecompcache.json.bz2 \
        -l final_legacy_bpaarchive.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/XXXFIXME/ \
        -x final_legacy_bpaarchive.sh \
        /pbstore/groupfs/bpa/legacy/ \
        /pbstore/groupfs/bpa/bpaarchive/

# finally final x-check
~/tree-compare/tree-compare.py \
        -c treecompcache.json.bz2 \
        -l final_final.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/XXXFIXME/ \
        -x final_final.sh \
        /pbstore/groupfs/bpa/ \
        /pbstore/groupfs/bpa/bpaarchive/

