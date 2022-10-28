#!/bin/sh
#$ -S /bin/sh

#Analysis directory
AD=`pwd`
export AD

# used moduels
module load fastqc/0.11.9
module load bowtie/1.1.2 
module load trimmomatic/0.36
module load samtools/1.9
module load STAR/2.7.9a #STAR/2.5.4a
module load htseq/0.11.4
module load picard/2.9.2

# Number of threads
NT=${SLURM_CPUS_PER_TASK}

# Read in the arguments from the command line
# parameter file
PARFILE=$1
source ./$PARFILE
# replace string in parameter file by the number of threads
sed -i "s/NUMBERTHREADS/$NT/g" $PARFILE

# input file
INPUTFILE_1=$2
INPUTFILE_2=$3

# LOG file
LOGFILE=$4

# analyse each file from the input list
while IFS= read -r line1 && IFS= read -r line2 <&3;
do

 

 	#gunzip $line1
 	FASTQ_ORG_1=`basename $line1`
 	FASTQ_1=${FASTQ_ORG_1%.*}
 	SAMPLE_1=${FASTQ_1%.*}
 
 	#gunzip $line2
 	FASTQ_ORG_2=`basename $line2`
 	FASTQ_2=${FASTQ_ORG_2%.*}
 	SAMPLE_2=${FASTQ_2%.*}
 
 	PWDRAW=`dirname $line1`	
 
  	echo "#################################"
  	echo "### "$SAMPLE_1
  	echo "#################################"
 
 
 
 	# FASTQC report
 	echo ""
 	echo ""
 	echo "### FASTQC RAW DATA"
 	sh step-01-fastqc.sh $PARFILE $PWDRAW/$FASTQ_ORG_1 01-fastq-hg19
 	sh step-01-fastqc.sh $PARFILE $PWDRAW/$FASTQ_ORG_2 01-fastq-hg19
 	
 
 	# TRIMMING TRIMMOMATIC
 	echo ""
 	echo ""
 	echo "### TRIMMING"
 	sh step-02-trimming.sh $PARFILE $PWDRAW/$FASTQ_ORG_1 $PWDRAW/$FASTQ_ORG_2 02-trimming-hg19
 
 	while read helper1
 	do	 
 		TRIMMINGOUT_1=$helper1
 	done < env_var1.txt
 
 	while read helper2
 	do	 
 		TRIMMINGOUT_2=$helper2
 	done < env_var2.txt
 	
 	while read helper3
 	do	 
 		TRIMMINGOUT_3=$helper3
 	done < env_var3.txt
 
 	while read helper4
 	do	 
 		TRIMMINGOUT_4=$helper4
 	done < env_var4.txt
 	
 	
 
 	# FASTQC report
 	echo ""
 	echo ""
 	echo "### FASTQC TRIMMED DATA"
 	sh step-01-fastqc.sh $PARFILE $TRIMMINGOUT_1 03-fastqc-hg19
 	sh step-01-fastqc.sh $PARFILE $TRIMMINGOUT_2 03-fastqc-hg19
 
 
 	# MAPPING
 	echo ""
 	echo ""
 	echo "### MAPPING"
 	sh step-03-mapping.sh $PARFILE $TRIMMINGOUT_1 $TRIMMINGOUT_2 04-mapping-hg19
 
 	while read helper5
 	do	 
 		MAPPINGOUT=$helper5
 	done < env_var5.txt
 
 
 	FASTQ_UNIQUE=`basename $MAPPINGOUT`
 	PWD_MAPPING=`dirname $MAPPINGOUT `
 
 
 	
	# ZIP FASTQ FILE
 	#echo ""
 	#echo "zipping FASTQ files..."
 	#echo "### "$SAMPLE
 
 	#gzip $TRIMMINGOUT_1
	#gzip $TRIMMINGOUT_2
 	#gzip $PWDRAW/$SAMPLE_1".fastq"
 	#gzip $PWDRAW/$SAMPLE_2".fastq"
 	#gzip $TRIMMINGOUT_3
 	#gzip $TRIMMINGOUT_4
	  
 
 	if [ $CLEANUP != 0 ];
 	 	then
 		rm -f env_var1.txt
 		rm -f env_var2.txt
 		rm -f env_var3.txt
 		rm -f env_var4.txt
 		rm -f env_var5.txt
 	fi

# 2>&1 2 is stderr und 1 is stdout, so stderr goes whereever stdout goes 
done < $INPUTFILE_1 3<$INPUTFILE_2 > $LOGFILE 2>&1

# Unify splice junctions across all samples
echo ""
echo ""
echo "### Collecting new splice sites in *SJ.out.tab files"
newsjdb=$(find ./04-mapping-hg19 -type f -name "*SJ.out.tab"|perl -e 'while(<>){chomp;s/^\.\///;push @x, $_};print join(" ",@x)')
export newsjdb

# analyse each file from the input list
while IFS= read -r line1 && IFS= read -r line2 <&3;
do
    FASTQ_ORG_1=`basename $line1`
    FASTQ_1=${FASTQ_ORG_1%.*}
    SAMPLE_1=${FASTQ_1%.*}

    FASTQ_ORG_2=`basename $line2`
    FASTQ_2=${FASTQ_ORG_2%.*}
    SAMPLE_2=${FASTQ_2%.*}

    TRIMMINGOUT_1=${AD}/04-mapping-hg19/clean-${FASTQ_1}-paired.fastq/clean-${FASTQ_1}-paired.fastq.gz
    TRIMMINGOUT_2=${AD}/04-mapping-hg19/clean-${FASTQ_1}-paired.fastq/clean-${FASTQ_2}-paired.fastq.gz

    echo CMD = sh step-04-remapping.sh $PARFILE $TRIMMINGOUT_1 $TRIMMINGOUT_2 05-remapping-hg19
    
    # MAPPING
    echo ""
    echo ""
    echo "### REMAPPING"
    sh step-04-remapping.sh $PARFILE $TRIMMINGOUT_1 $TRIMMINGOUT_2 05-remapping-hg19

    while read helper5
    do
          MAPPINGOUT=$helper5
    done < env_var5.txt


    # HTSEQ COUNTS
    echo ""
    echo ""
    echo "### HTSEQ"
    sh step-04-htseq.sh $PARFILE $MAPPINGOUT 05-htseq-hg19

    if [ $CLEANUP != 0 ];
       then
       rm -f env_var1.txt
       rm -f env_var2.txt
       rm -f env_var3.txt
       rm -f env_var4.txt
       rm -f env_var5.txt
    fi

done < $INPUTFILE_1 3<$INPUTFILE_2 >> $LOGFILE 2>&1        


