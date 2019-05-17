#!/usr/bin/bash

# after running cluster_search.sh arrayjobs
for file in results/*.FASTA.tab; do sort -k 2,2 $file; echo "//"; done > hrmA_search_results.txt
