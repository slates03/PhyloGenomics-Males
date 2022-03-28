#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

module load bioinfo
module load HyPhy

filename=Gene_list_4
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

module load bioinfo
module load HyPhy


cd /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/hyphy
k=$k
endAfq="_aligned_2.fasta"
TP1=$k$endAfq
TPQ="/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/"
TPP=$TPQ$TP1


(echo "1"; echo "6"; echo "1"; echo $TPP; echo "/depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/phylogenetic_trees/IQTree_80p_pruned.tree"; echo "1")| HYPHYMP 

done