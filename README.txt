##########################
### LOGIN INTO BIOWULF
##########################

ssh leeh15@biowulf.nih.gov


##########################
### START SINTERACTIVE 
##########################

# This prevents that you get in trouble with Biowulf if an error occurs


sinteractive --mem=30g


#################################
### GO TO THE RNA-SEQ DIRECTORY
#################################

cd /data/leeh15/RNA-seq/RNA-Seq-star-paired



#################################
### ADAPT THE INPUT FILE
#################################

# be careful, that you have the same order!!!
input_1.txt
input_2.txt



#################################
### ADAPT THE run.swarm FILE
#################################

# change the date of the log file 



#################################
### START THE SWARM JOB (2hr/sample)
#################################
dos2unix run.swarm
dos2unix adapters.txt
dos2unix input-1.txt
dos2unix input-2.txt
dos2unix parameters-hg19
dos2unix all-steps-hg19.sh
dos2unix step-01-fastqc.sh
dos2unix step-02-trimming.sh
dos2unix step-03-mapping.sh
dos2unix step-04-htseq.sh
swarm -f run.swarm -t 40 -g 60 --time 36:00:00 --qos=cv19






swarm -f download-srafiles.swarm -t 16 -g 20 --time 24:00:00

#########################################################################################

#################################
### IF YOU WANT TO CHECK YOUR JOB
#################################

type: sjobs



#################################
### IF YOU WANT TO CANCEL YOUR JOB
#################################

type: scancel JOBID



#################################
### IF YOU WANT TO CHANGE THE RUNTIME
#################################

type: newwall --jobid JOBID --time 24:00:00



##### convert file format
dos2unix WGS-pipeline-step9-merge.sh


#####check the processing
less swarm_21082325_0.e



module avail star
