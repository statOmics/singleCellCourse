#!/bin/sh

## get fasta
### Too large to download from net in this session; we work with reduced dataset

### index transcriptome self
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M27/gencode.vM27.transcripts.fa.gz

## build salmon index
salmon index -t gencode.vM27.transcripts.fa.gz -i gencode.vM27.transcripts_index -k 31 --gencode

### create tx2gene using GTF
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M27/gencode.vM27.annotation.gtf.gz
bioawk -c gff '$feature=="transcript" {print $group}' <(gunzip -c gencode.vM27.annotation.gtf.gz) | awk -F ' ' '{print substr($4,2,length($4)-3) "\t" substr($2,2,length($2)-3)}' - > txp2gene.tsv

## quantify subsample
salmon alevin -l ISR \
 -1 SRR1853178_1_subsampled40k.fastq \
 -2 SRR1853178_2_subsampled40k.fastq \
 --dropseq \
 -i gencode.vM27.transcripts_index \
 -p 1 \
 -o SRR1853178_out_40k \
 --tgMap txp2gene.tsv

#  preprocessDropseq_lab.sh
#  
#
#  Created by Koen Van den Berge on 11/5/21, adapted by Jeroen Gilis on 11/23/21
#
