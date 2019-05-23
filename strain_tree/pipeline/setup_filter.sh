#!/usr/bin/bash

#SBATCH --nodes 1 --ntasks 16 --mem 16G -p short
CPU=16
# fix one strain name

module load bcftools/1.9
FILTER=A_fumigiatus_Af293.Popgen6.selected_nofixed_repeatfilter.SNP.vcf.gz
if [ ! -f $FILTER ]; then
	perl -p -e 's/P\/11/P-11/' A_fumigiatus_Af293.Popgen6.selected_nofixed.SNP.vcf | bcftools view -Oz -o $FILTER --threads $CPU --min-af 0.1 --targets-file ^repeat-regions.tab --
fi
bcftools view --min-af 0.1 -S highqual_samples.tab -Oz -o highqual.Popgen6.SNP.vcf.gz $FILTER

