#!/usr/bin/env python3

import os,csv
from Bio import SeqIO

from os import listdir
from os.path import isfile, join
db='all-genomes.fasta'
report='cluster_search_results.all.txt'

idx = os.path.join(db +".idx")
if not os.path.isfile(idx):
    SeqIO.index_db(idx,db,'fasta')

seqdict = SeqIO.index_db(idx)

with open(report,'r') as fh:
    reader = csv.reader(fh,delimiter="\t")
    for row in reader:
        
