#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

module load bioinfo
module load HyPhy

filename=gene_list
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

cd /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/hyphy
k=$k
endAfq="_aligned_2.fasta"
TP1=$k$endAfq
TPQ="/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/"
TPP=$TPQ$TP1


(echo "1"; echo "2"; echo "1"; echo $TPP; echo "/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/phylogenetic_trees/pruned.tree"; echo "1"; echo "1"; echo "0.1")| HYPHYMP 

done

