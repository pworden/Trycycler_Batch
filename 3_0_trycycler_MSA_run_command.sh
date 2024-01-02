#!/bin/bash

# Start conda environment
source /path/to/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
trycyclerAssembliesParent="/path/to/Gridion-run/Trycycler_Output"

reconciledAssembliesName="2_all_seqs.fasta"
# ---------------------------- END User Input ---------------------------

# Get input files and their paths
reconsiledAssembliesPaths=($( find "$trycyclerAssembliesParent" -maxdepth 4 -type f -name "$reconciledAssembliesName" ))
echo "${reconsiledAssembliesPaths[@]}"

for assemblyPath in "${reconsiledAssembliesPaths[@]}"
do
    # Multiple sequence alignment
    assemblyDir=${assemblyPath%/*}
    # Run trycycler on current assembly directory
    trycycler msa --cluster_dir $assemblyDir
done
