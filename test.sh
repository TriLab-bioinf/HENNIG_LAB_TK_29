#!/bin/sh
#$ -S /bin/sh

# read in input from command line
# parameter file
PARFILE=$1
source ./$PARFILE

echo $STEP1

if [ "$STEP1" = true ]; then
    echo  STEP1 = true
fi        

