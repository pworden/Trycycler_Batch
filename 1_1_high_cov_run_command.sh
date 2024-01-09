#!/bin/bash

# Start conda environment
source /path/to/mamba/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
# 
# Parent directory under which the read files can all be found (and their paths):
parentDirOf_fastqGz_files="/Path/to/Fastq_Parent_Directory"
targetFileSuffix="*.fastq.gz"
# Parent output directory
outputDirParent="/path/to/Gridion-run/trycycler_output"
# Script Path
scriptPath="/path/to/script/1_2_high_cov_assembly_script.sh"


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
