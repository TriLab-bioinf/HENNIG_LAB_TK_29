#!/bin/sh
#$ -S /bin/sh

#Analysis directory
AD=`pwd`

# load modules
module load bbtools/37.36
module load bwa/0.7.15
module load picard/2.9.2
module load GATK/3.8-0

# get input files

#PARFILE=$1
#source ./$PARFILE
INPUTFILE_1=$1
LOGFILE=$2

# run samples
while IFS= read -r line1;
do


		# Prepare filenames file 1
		FASTQF_1=`basename ${line1}` # BNT_Aus_1_1st_R1_001.fastq.gz
        BASEN_1=${FASTQF_1%.*}            # BNT_Aus_1_1st_R1_001.fastq
        SAMPLE=${FASTQF_1%_R*}            # BNT_Aus_1_1st
		
        echo "line1=$line1 fastqf_1=$FASTQF_1 basen_1=$BASEN_1 sample=$SAMPLE"
		
		# Number of threads
		NT=${SLURM_CPUS_PER_TASK}
		MEM=${SLURM_MEM_PER_NODE}

		echo "MEMORY PER NODE"
		echo $MEM

		echo "#################################"
		echo "### "$SAMPLE
		echo "#################################"
		echo ""
		echo "Sample start:"
		TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
		echo $TIMESTAMP
		echo ""


 		MAPDIR=05-remapping-hg19/clean-${BASEN_1}-paired.fastq

		SAMPLE=$SAMPLE


		#######################
		### MARK DUPLICATES ###
		#######################

		DUPDIR="07-removeDuplicates"

		mkdir -p -m 777 $DUPDIR
		cd ${AD}/${DUPDIR}

		echo ""
		echo REMOVING DUPLICATES ...
		
		java -Xmx60g -XX:ParallelGCThreads=${NT} -jar ${PICARDJARPATH}/picard.jar MarkDuplicates \
		    INPUT=${AD}/${MAPDIR}/clean-${BASEN_1}-paired.fastq_sorted.bam \
            OUTPUT=dedup-${SAMPLE}.bam \
            METRICS_FILE=metrics-${SAMPLE}.txt

		echo CREATE BAM INDEX ...
		java -Xmx60g -jar ${PICARDJARPATH}/picard.jar BuildBamIndex INPUT=dedup-${SAMPLE}.bam
		cd ${AD}


		echo ""
		echo Finished marking duplicates
		TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
		echo $TIMESTAMP
		echo ""		
		
		
		
done <$INPUTFILE_1 > WGS-pipeline-step6-MarkDuplicates.log 2>&1
