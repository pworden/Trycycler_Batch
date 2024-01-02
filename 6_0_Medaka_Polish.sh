#!/bin/bash

# Start conda environment
source /home/wordenp/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate medaka

# ------------------------------ USER INPUT ------------------------------
# Parent directory containing all barcodes assembled using trycycler
# Under this all "7_final_consensus.fasta" final consensus fasta files are found
trycyclerAssembliesParent="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/Gridion_2Runs_Combined/try_Out"
# Consensus fasta file/s to look for under each barcode 
finalConsensusString="7_final_consensus.fasta"
# Set number of cores
NumCores=32
# Minion/Gridion model setting
modelSettings=r1041_e82_400bps_sup_variant_v4.1.0
# ---------------------------- END User Input ---------------------------
# Find paths to the MSA files under the parent directory "$trycyclerAssembliesParent"
finalConsensusPaths=($( find "$trycyclerAssembliesParent" -maxdepth 4 -type f -name "$finalConsensusString" ))
# Loop through all the draft assemblies (consensus sequences - "7_final_consensus.fasta")
for draftAssembly in "${finalConsensusPaths[@]}"
do
    # Get the path to the file
    clusterDir=${draftAssembly%/*}
    # Extract the barcode parent directory
    barcodeDir=${draftAssembly%%_OUT/*}_OUT
    # Get the path to the filtlong filtered FASTQ file
    barcodeFastqPath=($( find "$barcodeDir" -maxdepth 2 -type f -name "*.minion.fastq" ))
    # Run "medaka_consensus" script
    medaka_consensus -i ${barcodeFastqPath} -d ${draftAssembly} -o ${clusterDir} -t ${NumCores} -m ${modelSettings}
        # -------------------- Construct an output filename -------------------
        finalConsensusPath=$( find "$clusterDir" -maxdepth 4 -type f -name "consensus.fasta" )
        # Extract barcode directory without "_OUT" using parameter expansion
        barcodeDir="${finalConsensusPath%%_OUT*}"
        # Extract cluster using parameter expansion and string manipulation
        cluster="${finalConsensusPath%/*}"
        cluster="${cluster##*/}"
        # Combine barcode and cluster
        finalConsensusName="7z_${barcodeDir##*/}_${cluster}_medaka.fasta"
        # ---------------------------------------------------------------------
    # Make a copy and rename the final medaka polished consensus
    cp $finalConsensusPath $clusterDir/$finalConsensusName
done
