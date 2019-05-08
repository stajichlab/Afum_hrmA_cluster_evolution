#!/usr/bin/bash
#SBATCH -p short --ntasks 4 --mem 4G --out logs/cluster_search.%a.log -J clusterSrch

module load fasta
module load hmmer/3
module load exonerate/2.4.0
CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=1
fi

N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

OUTDIR=results
COPIES=gene_copies
FINAL=gene_aln
QUERY=query
mkdir -p $OUTDIR tmp
querypep=cluster.pep
query=cluster.fa

dbfile=$(ls ref_genomes/*.fasta | sed -n ${N}p)
db=$(basename $dbfile .fasta)
if [ ! -f $dbfile.ssi ]; then
	esl-sfetch --index $dbfile
fi
if [ ! -s $OUTDIR/$db.clustersearch.TFASTY.tab ]; then
	time tfasty36 -S -T $CPU -m 8c -E 1e-5 $querypep $dbfile > $OUTDIR/$db.clustersearch.TFASTY.tab
fi

if [ ! -s $OUTDIR/$db.clustersearch.FASTA.tab ]; then
	time fasta36 -S -T $CPU -m 8c -E 1e-5 $query $dbfile > $OUTDIR/$db.clustersearch.FASTA.tab
fi

cat $OUTDIR/$db.clustersearch.TFASTY.tab | while read Q S P GO GE QS QE SS SE E B
do
	echo "$Q $S $P $SS $SE"
	if [ ! -f tmp/$Q.$S.fasta ]; then
		esl-sfetch $dbfile $S > tmp/$Q.$S.fasta
		exonerate -m p2g -q $QUERY/$Q -t tmp/$Q.$S.fasta --bestn 2 -s 300 --refine region --ryo '>%ti__%tab-%tae %qi alnlen=%tal score=%s\n%tas' \
		--showalignment no --showtargetgff no --showvulgar no --verbose 0 > $COPIES/$S.$Q.fa 
		rm tmp/$Q.$S.fasta
	fi
done
