#!/bin/bash

# Start conda environment
source /home/wordenp/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
trycyclerAssembliesParent="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/Gridion_2Runs_Combined/try_Out"

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
