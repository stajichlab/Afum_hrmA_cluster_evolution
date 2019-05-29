#!/usr/bin/bash
#SBATCH --ntasks 16 -p short --mem 24g --nodes 1 

module load fasta
module load hmmer/3
CPU=16

phmmer -E 1e-3 --cpu $CPU --domtbl hrmAp_Afu5g14900.domtbl hrmAp_Afu5g14900.seg all_pep.fasta > hrmAp_Afu5g14900.phmmer
phmmer -E 1e-3 --cpu $CPU --domtbl cgnA_Afu5g14910.domtbl cgnA_Afu5g14910.seg all_pep.fasta > cgnA_Afu5g14910.phmmer

ssearch36 -E 1e-3 -S hrmAp_Afu5g14900.seg all_pep.fasta > hrmAp_Afu5g14900.SSEARCH
ssearch36 -E 1e-2  -S cgnA_Afu5g14910.seg all_pep.fasta > cgnA_Afu5g14910.SSEARCH

ssearch36 -m 8c -E 1e-3 -S hrmAp_Afu5g14900.seg all_pep.fasta > hrmAp_Afu5g14900.SSEARCH.tab
ssearch36 -m 8c -E 1e-2  -S cgnA_Afu5g14910.seg all_pep.fasta > cgnA_Afu5g14910.SSEARCH.tab
