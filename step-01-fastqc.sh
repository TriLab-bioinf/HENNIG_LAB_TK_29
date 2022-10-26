#!/bin/sh
#$ -S /bin/sh

# read in input from command line
# parameter file
PARFILE=$1
source ./$PARFILE

# fastq
FASTQF=$2

# output directory
QCDIR=$3
mkdir -p -m 777 $QCDIR


FASTQC=fastqc

BASEN=`basename $FASTQF .fastq`
QCOUT=$QCDIR"/"$BASEN

mkdir $QCOUT
$FASTQC -o $QCOUT -a adapters.txt $FASTQF 


