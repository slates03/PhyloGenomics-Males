#!/bin/bash
#FILENAME: X


filename=gene_list.txt
exec 4<$filename
echo $filename
echo Start
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

cd /Users/garettslater/Desktop/hyphy

k=$k
endAfq="_aligned_3.fasta"
TP1=$k$endAfq
TPQ="/Users/garettslater/Desktop/Alignment/"
TPP=$TPQ$TP1


(echo $TPP; echo "/Users/garettslater/Desktop/pruned.tree")| ./HYPHYMP /Users/garettslater/Desktop/FitMG94/FitMG94.bf  


done