#!/bin/bash


source /home/wordenp/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
clusterDirectory="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/Gridion_2Runs_Combined/Trycycler_Output/barcode24_OUT/barcode24.trycycler/cluster_001"
longReads="/home/wordenp/projects/AFB_project/analyses/Gridion_11and12-12-23/Gridion_2Runs_Combined/Trycycler_Output/barcode24_OUT/filtlong/barcode24.minion.fastq" # FASTQ
threads=30
contigLettersToExclude=""
# ---------------------------- END User Input ---------------------------

# ------------- Full Command -------------
	# Last 2 flags are optional
# bash "/home/wordenp/scripts/exnrec.sh" ${clusterDirectory} ${longReadsDirectory} ${threads} ${contig_letters_to_exclude} [${max_add_seq_percent}] [${max_length_diff}]
# ----------------------------------------

bash "/home/wordenp/Scripts/General_Scripts/Trycycler/2_2_exnrec.sh" ${clusterDirectory} ${longReads} ${threads} ${contigLettersToExclude}
