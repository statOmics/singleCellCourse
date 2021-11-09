#!/bin/sh

wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR1853178/SRR1853178
/Applications/sratoolkit.2.11.1-mac64/bin/fasterq-dump SRR1853178

salmon alevin -l ISR \
 -1 SRR1853178_1.fq.gz \
 -2 SRR1853178_2.fq.gz \
 --dropseq \
 -i INDEX \
 -p 1 \
 -o SRR1853178_out \
 --tgMap TXGENEMAP


#  preprocessDropseq.sh
#  
#
#  Created by Koen Van den Berge on 11/5/21.
#  
