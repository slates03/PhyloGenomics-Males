#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

filename=orthologs_fullrows
exec 4<$filename
echo $filename
echo Start
done=false
while read -u4 k || [ -n "$k" ]; do
pidlist_sampe=""

k=$(sed -r 's/[|]+/ /g' <<<$k)
a=$(echo $k | awk '{ print $1}')
b=$(echo $k | awk '{ print $2}')
c=$(echo $k | awk '{ print $3}')
d=$(echo $k | awk '{ print $4}')
e=$(echo $k | awk '{ print $5}')


end=".fasta"
end_t=$a$end

grep -A 1 $a AMEL_ortho_combined_final.fasta | awk '{if (NR!=1) {print}}' | awk 'NR==1{$0=">GEN_apis_mellifera\n"$0}1' >  /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/$end_t
grep -A 1 $b BIMP_ortho_combined_final.fasta | awk '{if (NR!=1) {print}}' | awk 'NR==1{$0=">GEN_bombus_impatiens\n"$0}1' >>  /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/$end_t
grep -A 1 $c TCARB_ortho_combined_final.fasta | awk '{if (NR!=1) {print}}' | awk 'NR==1{$0=">TR_tetragonula_carbonaria\n"$0}1' >>  /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/$end_t
grep -A 1 $d MROT_ortho_combined_final.fasta | awk '{if (NR!=1) {print}}' | awk 'NR==1{$0=">GEN_megachile_rotundata\n"$0}1' >>  /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/$end_t
grep -A 1 $e EDIL_ortho_combined_final.fasta | awk '{if (NR!=1) {print}}' | awk 'NR==1{$0=">TR_euglossa_dilemma\n"$0}1' >>  /depot/bharpur/data/projects/slater/Phylo_MaleEvolution/Resources/Alignment/$end_t



done
