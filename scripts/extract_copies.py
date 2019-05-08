#!/usr/bin/env python3

import os
from Bio import SeqIO

from os import listdir
from os.path import isfile, join
folder = 'genomes'
fafiles = [f for f in listdir(folder) if isfile(join(folder, f)) and 
           f.endswith('.fasta')]

for file in fafiles:
    print(file)
    idx = os.path.join(folder,file+".idx")
    if not os.path.isfile(idx):
        SeqIO.index_db(idx,os.path.join(folder,file),'fasta')


SeqIO.index_db(idx)
