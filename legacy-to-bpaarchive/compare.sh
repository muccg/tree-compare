#!/bin/bash

cd ~/tree-compare/legacy-to-bpaarchive || exit 1

# melanoma / ramaciotti
~/tree-compare/tree-compare.py \
        -c treecompcache.json \
        -l melanoma_ramaciotti.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/XXFIXME/ \
        -x melanoma_ramaciotti.sh \
        /pbstore/groupfs/bpa/legacy/melanoma/raw/ramaciotti/ \
        /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/Ramaciotti/

# melanoma / new
~/tree-compare/tree-compare.py \
        -c treecompcache.json \
        -l melanoma_new.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/XXFIXME/ \
        -x melanoma_new.sh \
        /pbstore/groupfs/bpa/legacy/melanoma/raw/new/ \
        /pbstore/groupfs/bpa/bpaarchive/Melanoma/

# melanoma / agrf
~/tree-compare/tree-compare.py \
        -c treecompcache.json \
        -l melanoma_agrf.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/Melanoma/XXFIXME/ \
        -x melanoma_agrf.sh \
        /pbstore/groupfs/bpa/legacy/melanoma/raw/agrf/ \
        /pbstore/groupfs/bpa/bpaarchive/Melanoma/raw/AGRF/

# wheat / cultivar
~/tree-compare/tree-compare.py \
        -c treecompcache.json \
        -l wheat_cultivar.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/XXFIXME/ \
        -x wheat_cultivar.sh \
        /pbstore/groupfs/bpa/legacy/wheat/cultivar/ \
        /pbstore/groupfs/bpa/bpaarchive/Wheat_Cultivars/

# wheat / pathogen
~/tree-compare/tree-compare.py \
        -c treecompcache.json \
        -l wheat_pathogen.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/Wheat_Pathogens/XXFIXME/ \
        -x wheat_pathogen.sh \
        /pbstore/groupfs/bpa/legacy/wheat/pathogen/ \
        /pbstore/groupfs/bpa/bpaarchive/Wheat_Pathogens/

# legacy / raw
~/tree-compare/tree-compare.py \
        -c treecompcache.json \
        -l legacy_raw.csv \
        -t /pbstore/groupfs/bpa/bpaarchive/XXFIXME/ \
        -x melanoma_new.sh \
        /pbstore/groupfs/bpa/legacy/raw/ \
        /pbstore/groupfs/bpa/bpaarchive/
