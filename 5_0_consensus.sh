#!/bin/bash

# Start conda environment
source /path/to/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
# Parent directory containing all barcodes assembled using trycycler
# Under this all "3_msa.fasta" multiple sequence alignment fasta files are found
trycyclerAssembliesParent="/path/to/Gridion-run/Trycycler_Output"

# Multiple Sequence Alignment file/s to look for under each barcode 
consensusFastaName="4_reads.fastq"
# ---------------------------- END User Input ---------------------------
# Find paths to the MSA files under the parent directory "$trycyclerAssembliesParent"
consensusFastaFilesPaths=($( find "$trycyclerAssembliesParent" -maxdepth 4 -type f -name "$consensusFastaName" ))

# For each MSA file gather information to run "trycycler partition"

# consensusPath="${consensusFastaFilesPaths[0]}"

for consensusPath in "${consensusFastaFilesPaths[@]}"
do
    # Cluster Dir
    clusterDir=${consensusPath%/*}
    # Trycycler consensus command
    trycycler consensus --cluster_dir $clusterDir
done
