head -n 1 hrmA_cluster_iTol.tab | cut -f1,2,4,5 > hrmA_cluster_iTol.3genes.tab
for file in $(cat tree/round-2-added_F11698/highqual_samples.tab); do grep $file hrmA_cluster_iTol.tab; done | cut -f1,2,4,5  >> hrmA_cluster_iTol.3genes.tab

