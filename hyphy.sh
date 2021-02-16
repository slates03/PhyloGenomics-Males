#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 20 - 00:00:00

filename=gene_list_al
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

module load bioinfo
module load HyPhy

k=$k
pidlist_sampe=""


(echo "1"; echo "2"; echo "1"; echo "/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/$k"; echo "/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/phylogenetic_trees/pruned.tree"; echo "1"; echo "1"; echo "0.1")| HYPHYMP 

done

