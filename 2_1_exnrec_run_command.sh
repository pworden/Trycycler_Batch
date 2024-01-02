#!/bin/bash


source /home/wordenp/mambaforge/etc/profile.d/conda.sh # Path to conda
conda activate trycycler

# ------------------------------ USER INPUT ------------------------------
clusterDirectory="/path/to/Gridion-run/Trycycler_Output/barcode24_OUT/barcode24.trycycler/cluster_001"
longReads=""/path/to/Gridion-run/Trycycler_Output/barcode24_OUT/filtlong/barcode24.minion.fastq" # FASTQ
threads=30
contigLettersToExclude=""
# ---------------------------- END User Input ---------------------------

# ------------- Full Command -------------
	# Last 2 flags are optional
# bash "/path/to/scripts/exnrec.sh" ${clusterDirectory} ${longReadsDirectory} ${threads} ${contig_letters_to_exclude} [${max_add_seq_percent}] [${max_length_diff}]
# ----------------------------------------

bash "/home/wordenp/Scripts/General_Scripts/Trycycler/2_2_exnrec.sh" ${clusterDirectory} ${longReads} ${threads} ${contigLettersToExclude}
