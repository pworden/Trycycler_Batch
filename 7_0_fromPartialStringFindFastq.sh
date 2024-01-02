#!/bin/bash

# ---------------------------------- USER INPUT ----------------------------------
# --------------------------------------------------------------------------------
fastq_parent_directory="/home/wordenp/projects/AFB_project/raw/sequence_data/Select_Bee_AFB_Illumina_fastq"
inputTSV="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/Gridion_2Runs_Combined/try_Out/barcodeAndPartialStringID.tsv"
output_file="fastqIlluminaPaths.tsv"
# Illumina forward read file extension
fileExtension_F="R1_fastp.fq.gz"
# Illumina reverse read file extension
fileExtension_R="R2_fastp.fq.gz"
# -------------------------------- End User Input --------------------------------
# --------------------------------------------------------------------------------

outputDir=${inputTSV%/*}

barcodes=($(cut -f1 "$inputTSV"))
partial_strings=($(cut -f2 "$inputTSV"))

# Get the length of the array
array_length=${#barcodes[@]}

# # Change directory to the output Directory
# cd ${outputDir}

# Write header to the output file
echo -e "fastqIlluminaPath_F\tfastqIlluminaPath_R\tpartial_string\tbar_code" > "$outputDir/$output_file"

# Use a for loop to iterate over the number of elements (array length) in the "barcodes" array
for ((i = 0; i < array_length; i++)); do
    fastqIlluminaPath_F=$(find "$fastq_parent_directory" -maxdepth 4 -type f -name "*${partial_strings[i]}*${fileExtension_F}")
    fastqIlluminaPath_R=$(find "$fastq_parent_directory" -maxdepth 4 -type f -name "*${partial_strings[i]}*${fileExtension_R}")
    bar_code="${barcodes[i]}"
    # Append the values to the output file
    echo -e "$fastqIlluminaPath_F\t$fastqIlluminaPath_R\t${partial_strings[i]}\t$bar_code" >> "$outputDir/$output_file"
done
