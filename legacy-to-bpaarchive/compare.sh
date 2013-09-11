#!/bin/bash

cd ~/tree-compare/legacy-to-bpaarchive || exit 1

## # melanoma / ramaciotti
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops132_melanoma_ramaciotti.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/ramaciotti/BRLOPS-132/ \
##         -x brlops132_melanoma_ramaciotti.sh \
##         /pbstore/groupfs/bpa/legacy/melanoma/raw/ramaciotti/ \
##         /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/ramaciotti/
## 
## # # melanoma / new
## # ~/tree-compare/tree-compare.py \
## #         -c treecompcache.json.bz2 \
## #         -l brlops133_melanoma_new.csv \
## #         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/BRLOPS-133/ \
## #         -x brlops133_melanoma_new.sh \
## #         /pbstore/groupfs/bpa/legacy/melanoma/raw/new/ \
## #         /pbstore/groupfs/bpa/bpaarchive/Melanoma/
## 
## # melanoma / agrf
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops134_melanoma_agrf.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/agrf/BRLOPS-134/ \
##         -x brlops134_melanoma_agrf.sh \
##         /pbstore/groupfs/bpa/legacy/melanoma/raw/agrf/ \
##         /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/agrf/
## 
## # wheat / cultivar
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops135_wheat_cultivar.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/raw/unknown/BRLOPS-135/ \
##         -x brlops135_wheat_cultivar.sh \
##         /pbstore/groupfs/bpa/legacy/wheat/cultivar/ \
##         /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/
## 
## # wheat / pathogen
## ~/tree-compare/tree-compare.py \
##         -c treecompcache.json.bz2 \
##         -l brlops136_wheat_pathogen.csv \
##         -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Pathogens/raw/unknown/BRLOPS-136/ \
##         -x brlops136_wheat_pathogen.sh \
##         /pbstore/groupfs/bpa/legacy/wheat/pathogen/ \
##         /pbstore/groupfs/bpa/bpaarchive/Wheat_Pathogens/
## 
## #   # legacy / raw
## #   ~/tree-compare/tree-compare.py \
## #           -c treecompcache.json.bz2 \
## #           -l legacy_raw.csv \
## #           -t /pbstore/groupfs/bpa/bpaarchive/BRLOPS-137/ \
## #           -x melanoma_new.sh \
## #           /pbstore/groupfs/bpa/legacy/raw/ \
## #           /pbstore/groupfs/bpa/bpaarchive/

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

