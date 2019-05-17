tail -n +2 public_highqual.tab | while read SampleID	Strain	CONTIG COUNT 	L50 	L90 	MAX 	MEAN 	MEDIAN 	MIN 	N50 	N90 	TOTAL LENGTH 	BUSCO_Complete	BUSCO_Single	BUSCO_Duplicate	BUSCO_Fragmented	BUSCO_Missing	BUSCO_NumGenes
do
	echo $Strain
	perl -p -e "s/>/>$Strain./" genomes/$SampleID.sorted.fasta > idx/$Strain.fasta
done
