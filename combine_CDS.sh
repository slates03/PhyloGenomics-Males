#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00


filename=AMEL_protein_id
exec 4<$filename
echo $filename
echo Start
while read -u4 k ; do
	pidlist_sampe=""
	echo $k
	k=$k
	m=$(grep -A 1  $k AMEL_CDS.fasta | awk 'NR == 1')


echo $k
grep -A 1  $m AMEL_CDS.fasta | sed "/$m/d" | tr '\n' ' ' |tr -d "[:space:]" | awk -v v="$m" 'NR==1{print v}1'| cat >> AMEL_ortho_combined.fasta

done