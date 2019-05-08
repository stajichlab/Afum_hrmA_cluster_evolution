#!/usr/bin/bash

for file in genomes/*.sorted.fasta
do
	b=$(basename $file .sorted.fasta)
	if [ ! -f idx/$b.fasta ]; then
		perl -p -e "s/>/>$b./" $file > idx/$b.fasta
	fi
done
