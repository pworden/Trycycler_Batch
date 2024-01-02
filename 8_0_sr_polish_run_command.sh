#!/bin/bash

# Start conda environment
source /path/to/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate shortReadPolish

# ---------------------------------- USER INPUT ----------------------------------
# --------------------------------------------------------------------------------
inputTSV="/path/to/Gridion-run/Trycycler_Output/fastqIlluminaPaths.tsv"
trycyclerParentDir="/path/to/Gridion-run/Trycycler_Output"
stringToSearch="medaka.fasta"
sr_polishPath="path/to/trycycler-scripts/8_1_sr_polish.sh"
numberOfThreads="30"
# --------------------------------------------------------------------------------
# -------------------------------- End User Input --------------------------------

# Load TSV into an associative array
declare -A lookupTable
while IFS=$'\t' read -r c1 c2 c3 barcode; do
    lookupTable["$barcode"]="$c1 $c2"
done < "$inputTSV"

# --------------------------------------------------------------------------------
longreadPolishedPaths=($(find "$trycyclerParentDir" -maxdepth 4 -type f -name "7z*$stringToSearch"))
echo "${longreadPolishedPaths[@]}"

# lr_polished_path="${longreadPolishedPaths[0]}"

for lr_polished_path in "${longreadPolishedPaths[@]}"; do
    # Assembly file name
	assemblyFileName=${lr_polished_path##*/}
	# Remove the string $stringToSearch ("medaka.fasta")
	baseFileName=${assemblyFileName%*"_$stringToSearch"}
	# Add the suffix "sr_polish.fasta"
	polishedAssemblyName="${baseFileName}_sr_polish.fasta"
	# change the "7" at the start of the filename to "8"
	polishedAssemblyName="${polishedAssemblyName/7/8}"
	# Get the path to the file (also the output directory)
    dir_of_lr_polished=${lr_polished_path%/*}
    # Extract the barcode parent directory
	barcodeDir="${lr_polished_path%%_OUT*}_OUT"
	# Remove the "_OUT" string
    currentBarcode="${barcodeDir%%_OUT}"
    # Extract the barcode by removing the path prefix
    currentBarcode=${currentBarcode##*/}
	# ----------
    # Use the lookup table to find paths based on the barcode
    barcodePaths=${lookupTable["$currentBarcode"]}
	# If the barcode exist in the table get the read paths
    if [ -n "$barcodePaths" ]; then
        # Split the space-separated paths into an array
        IFS=' ' read -ra pathsArray <<< "$barcodePaths"
        # Access the paths using indices
        R1_name="${pathsArray[0]}"
        R2_name="${pathsArray[1]}"        
			# # Now you can use $firstPath and $secondPath as needed
			# echo "First Path: $firstPath"
			# echo "Second Path: $secondPath"
    else
        echo "Barcode not found in the TSV: $currentBarcode"
    fi
	polished_output="$dir_of_lr_polished/$polishedAssemblyName"
	# Basic run command: sr_polish.sh <long_read_assembly.fasta> <short_reads.r1.fastq.gz> <short_reads.r2.fastq.gz> <polished_output.fasta> <threads>
    bash ${sr_polishPath} ${lr_polished_path} ${R1_name} ${R2_name} ${polished_output} ${numberOfThreads} &> "$dir_of_lr_polished/sr_polish_logs.log"
done
