#!/usr/bin/bash
#SBATCH -p short --ntasks 16 --nodes 1 --mem 64G --out logs/cluster_search_all.%A.log

module load fasta
module load hmmer/3
module load exonerate
CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=1
fi
OUTDIR=results_allinone
COPIES=gene_copies
FINAL=gene_aln
QUERY=query
mkdir -p $OUTDIR tmp $COPIES $FINAL
db=all-genomes.fasta
if [ ! -e $db ]; then
    cat idx/*.fasta > $db
fi

if [[ ! -e $db.ssi || $db.ssi -ot $db ]]; then
    esl-sfetch --index $db
fi

if [ ! -f $OUTDIR/clustersearch.FASTA.tab ]; then
    query=cluster.fa
    time fasta36 -T $CPU -m 8c -E 1e-5 $query $db > $OUTDIR/clustersearch.FASTA.tab
fi
if [ ! -f $OUTDIR/clustersearch.TFASTX.tab ]; then
querypep=cluster.pep
time tfasty36 -T $CPU -m 8c -E 1e-5 $querypep $db > $OUTDIR/clustersearch.TFASTX.tab

fi

rm -f $COPIES/*

cat $OUTDIR/clustersearch.TFASTX.tab | while read Q S P GO GE QS QE SS SE E B
do
    echo "$Q $S $P $SS $SE"
    if [ ! -f tmp/$Q.$S.fasta ]; then
	esl-sfetch $db $S > tmp/$Q.$S.fasta    
	exonerate -m p2g -q $QUERY/$Q -t tmp/$Q.$S.fasta --bestn 2 -s 300 --refine region --ryo '>%ti__%tab-%tae %qi alnlen=%tal score=%s\n%tas'  --showalignment no --showtargetgff no --showvulgar no --verbose 0 > $COPIES/$S.$Q.fa
    fi
done

rm -f tmp/*

module load muscle
module load trimal
for name in cgnA hrmA
do
    cat $COPIES/*$name* > $FINAL/$name.cds.fasta
    muscle -in $FINAL/$name.cds.fasta -out $FINAL/$name.cds.fasaln
    trimal -in $FINAL/$name.cds.fasaln -out $FINAL/$name.cds.aln -clustal
done
