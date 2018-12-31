#!/usr/bin/bash
#SBATCH -p short --ntasks 4 --mem 32G

module load fasta
CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=1
fi
OUTDIR=results
mkdir -p $OUTDIR
for file in query/*.fa
do
	q=$(basename $file .fa)
	for dbfile in idx/*.fasta
	do
		db=$(basename $dbfile .fasta)
		fasta36 -T $CPU -m 8c -E 1e-10 -O $OUTDIR/$q-vs-$db.clustersearch.FASTA.tab $file $dbfile
	done
done

cat $OUTDIR/*.tab > cluster_search_results.2.txt
