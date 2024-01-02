#!/bin/bash

# Start conda environment
source /home/wordenp/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
# 
# Parent directory under which the read files can all be found (and their paths):
parentDirOf_fastqGz_files="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/Gridion_2Runs_Combined_Fastq"
targetFileSuffix="sup_000filtlong*.fastq.gz"
# Parent output directory
outputDirParent="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/trycycler_output"
# Script Path
scriptPath="/home/wordenp/Scripts/General_Scripts/Trycycler/1_2_high_cov_assembly_script.sh"


# Check before changing the following:
genomeSize=4600000
threads=24
# END User Input
# ---------------------------- END User Input ---------------------------

# Create output directory if needed
if [ -e $outputDirParent ]; then echo "Folder exists!"; else mkdir $outputDirParent; echo "Creating folder: $outputDirParent"; fi

# Get input files and their paths
fastqGzFilePathList=($( find $parentDirOf_fastqGz_files -maxdepth 2 -type f -name "*"$targetFileSuffix ))
# get input paths without their files
parentInputPath=( ${fastqGzFilePathList[@]%/*} )
# Get the name of each directory (just the directory) in which a "fastq.gz" file is found 
finalDirectoriesList=( ${parentInputPath[@]##*/}  )
fileCount=$(( ${#finalDirectoriesList[@]}-1 ))


for a in $(seq 0 $fileCount) ; do sampleName=${finalDirectoriesList[a]}; \
	readsAndPath=${fastqGzFilePathList[a]}; outputDir=$outputDirParent/${finalDirectoriesList[a]}"_OUT"; \
	bash $scriptPath $sampleName $readsAndPath $genomeSize $threads $outputDir; \
	# echo $scriptPath $sampleName $readsAndPath $genomeSize $threads $outputDir; \
done
