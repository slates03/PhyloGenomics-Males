#!/bin/bash
#FILENAME: Slater_HB_RNAseq
#SBATCH -A lenders
#SBATCH -n 1
#SBATCH -t 75:00:00

module load bioinfo
module load blast



cd /depot/bharpur/data/projects/slater/Resources/orthologs


makeblastdb -in GCF_003254395.2_Amel_HAv3.1_protein.faa -dbtype prot -parse_seqids 
makeblastdb -in GCF_000214255.1_Bter_1.0_protein.faa -dbtype prot -parse_seqids 
makeblastdb -in GCF_000188095.3_BIMP_2.2_protein.faa -dbtype prot -parse_seqids 
makeblastdb -in GCF_000220905.1_MROT_1.0_protein.faa -dbtype prot -parse_seqids 
makeblastdb -in Tetragonula_carbonaria.proteins.fa -dbtype prot -parse_seqids #<------- for TCARB, you'll have to replace NAMHERE with TCARB fasta name 
makeblastdb -in Edil_OGS_v1.1_prot.fa -dbtype prot -parse_seqids 



#make all BLAST
#amel vs all
blastp	-query GCF_000214255.1_Bter_1.0_protein.faa -subject GCF_003254395.2_Amel_HAv3.1_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BTvamel
blastp	-query GCF_000188095.3_BIMP_2.2_protein.faa -subject GCF_003254395.2_Amel_HAv3.1_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BIvamel
blastp	-query GCF_000220905.1_MROT_1.0_protein.faa -subject GCF_003254395.2_Amel_HAv3.1_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > MRvamel
blastp	-query Tetragonula_carbonaria.proteins.fa  -subject GCF_003254395.2_Amel_HAv3.1_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > TCvamel
blastp	-query Edil_OGS_v1.1_prot.fa -subject GCF_003254395.2_Amel_HAv3.1_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > EDvamel

#ED vs all
blastp	-query GCF_003254395.2_Amel_HAv3.1_protein.faa -subject Edil_OGS_v1.1_prot.fa -evalue 1e-10 -outfmt 6 -num_alignments 5 > AMvedil
blastp	-query GCF_000188095.3_BIMP_2.2_protein.faa -subject Edil_OGS_v1.1_prot.fa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BIvedil
blastp	-query GCF_000214255.1_Bter_1.0_protein.faa -subject Edil_OGS_v1.1_prot.fa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BTvedil
blastp	-query Tetragonula_carbonaria.proteins.fa  -subject Edil_OGS_v1.1_prot.fa -evalue 1e-10 -outfmt 6 -num_alignments 5 > TCvedil
blastp	-query GCF_000220905.1_MROT_1.0_protein.faa -subject Edil_OGS_v1.1_prot.fa -evalue 1e-10 -outfmt 6 -num_alignments 5 > MRvedil

#BT
blastp	-query GCF_003254395.2_Amel_HAv3.1_protein.faa -subject GCF_000214255.1_Bter_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > AMvbter
blastp	-query GCF_000188095.3_BIMP_2.2_protein.faa -subject GCF_000214255.1_Bter_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BIvbter
blastp	-query GCF_000220905.1_MROT_1.0_protein.faa -subject GCF_000214255.1_Bter_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > MRvbter
blastp	-query Tetragonula_carbonaria.proteins.fa  -subject GCF_000214255.1_Bter_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > TCvbter
blastp	-query Edil_OGS_v1.1_prot.fa -subject GCF_000214255.1_Bter_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > EDvbter


#MR vs all
blastp	-query GCF_003254395.2_Amel_HAv3.1_protein.faa -subject GCF_000220905.1_MROT_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > AMvmrot
blastp	-query GCF_000188095.3_BIMP_2.2_protein.faa -subject GCF_000220905.1_MROT_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BIvmrot
blastp	-query GCF_000214255.1_Bter_1.0_protein.faa -subject GCF_000220905.1_MROT_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BTvmrot
blastp	-query Tetragonula_carbonaria.proteins.fa  -subject GCF_000220905.1_MROT_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > TCvmrot
blastp	-query Edil_OGS_v1.1_prot.fa -subject GCF_000220905.1_MROT_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > EDvmrot



#TC vs all #<------------- UPDATE
blastp	-query GCF_003254395.2_Amel_HAv3.1_protein.faa -subject Tetragonula_carbonaria.proteins.fa  -evalue 1e-10 -outfmt 6 -num_alignments 5 > AMvtcarb
blastp	-query GCF_000188095.3_BIMP_2.2_protein.faa -subject    Tetragonula_carbonaria.proteins.fa  -evalue 1e-10 -outfmt 6 -num_alignments 5 > BIvtcarb
blastp	-query GCF_000214255.1_Bter_1.0_protein.faa -subject    Tetragonula_carbonaria.proteins.fa  -evalue 1e-10 -outfmt 6 -num_alignments 5 > BTvtcarb
blastp	-query Edil_OGS_v1.1_prot.fa -subject                   Tetragonula_carbonaria.proteins.fa  -evalue 1e-10 -outfmt 6 -num_alignments 5 > EDvtcarb
blastp	-query GCF_000220905.1_MROT_1.0_protein.faa -subject    Tetragonula_carbonaria.proteins.fa  -evalue 1e-10 -outfmt 6 -num_alignments 5 > MRvtcarb


#BI
blastp	-query GCF_003254395.2_Amel_HAv3.1_protein.faa -subject GCF_000188095.3_BIMP_2.2_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > AMvbimp
blastp	-query GCF_000220905.1_MROT_1.0_protein.faa -subject GCF_000188095.3_BIMP_2.2_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > MRvbimp
blastp	-query Tetragonula_carbonaria.proteins.fa  -subject GCF_000188095.3_BIMP_2.2_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > TCvbimp
blastp	-query Edil_OGS_v1.1_prot.fa -subject GCF_000188095.3_BIMP_2.2_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > EDvbimp
blastp	-query GCF_000214255.1_Bter_1.0_protein.faa -subject GCF_000214255.1_Bter_1.0_protein.faa -evalue 1e-10 -outfmt 6 -num_alignments 5 > BTvbimp
