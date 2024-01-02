#!/bin/bash

# Start conda environment
source /path/to/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
# Parent directory containing all barcodes assembled using trycycler
# Under this all "3_msa.fasta" multiple sequence alignment fasta files are found
trycyclerAssembliesParent="/path/to/Gridion-run/Trycycler_Output"

# Multiple Sequence Alignment file/s to look for under each barcode 
msaFastaName="3_msa.fasta"
# ---------------------------- END User Input ---------------------------
# Find paths to the MSA files under the parent directory "$trycyclerAssembliesParent"
msaFastaFilesPaths=($( find "$trycyclerAssembliesParent" -maxdepth 4 -type f -name "$msaFastaName" ))

# For each MSA file gather information to run "trycycler partition"
for msaPath in "${msaFastaFilesPaths[@]}"
do
    # Cluster Dir
    clusterDir=${msaPath%/*}
    # Parent path for the barcode
    barcodeDir=${msaPath%%_OUT/*}_OUT
    # The path to the filtlong filtered fastq file for the input barcode
        # There should only be one input fastq per barcode
    filtlongFastqForBarcode=($( find "$barcodeDir" -maxdepth 2 -type f -name "*.minion.fastq" ))
    # Trycycler command
    trycycler partition --reads $filtlongFastqForBarcode --cluster_dirs $clusterDir
done
