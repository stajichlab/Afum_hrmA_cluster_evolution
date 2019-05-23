#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 8 --mem 24G --time 48:00:00 -p intel --out logs/iqtree.log


CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

if [[ -f config.txt ]]; then
	source config.txt
else
	echo "Need a config.txt"
	exit
fi

if [[ -z $REFNAME ]]; then
	REFNAME=REF
fi
module load IQ-TREE

for TYPE in SNP
do
    FAS=$TREEDIR/$PREFIX.nofixed.$TYPE.mfa
    iqtree-omp -nt $CPU -s $FAS -m GTR -bb 1000
done
