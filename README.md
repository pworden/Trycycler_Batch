# Trycycler Scripts

## Repositories

The *Trycycler* github repository can be found here:
<https://github.com/rrwick/Trycycler>
Additional scripts to the *Trycycler* workflow, written by Daniel Bogema, can be found here:
<https://github.com/bogemad/trycycler_scripts>
Description of the Trycycler workflow using these additional scripts can be found here:
<https://github.com/pworden/Trycycler_summary>

## Conda environments

1. A conda environment with trycycler
   - Can set up a trycycler conda environment using the trycycler.yml file in the `Conda_envs` folder
     - <https://github.com/pworden/trycycler_Batch/tree/main/Conda_envs>
1. A conda environment with medaka (separate from trycycler)
   - Can set up a medaka conda environment using the medaka.yml file in the `Conda_envs` folder
     - <https://github.com/pworden/trycycler_Batch/tree/main/Conda_envs>
1. A conda environment that is separate from trycycler and medaka in which conda packages are installed to perform short read polishing (eg. sr_polish)
   - Can set up a medaka conda environment using the medaka.yml file in the `Conda_envs` folder
     - <https://github.com/pworden/trycycler_Batch/tree/main/Conda_envs>
     - Include packages such as: *BWA, polypolish, masurca (containing polca) and minimap2*.
     - Activate the environment and check if the required packages are present with 'conda list'

## Overview *- all scripts*
This repository is a summary of scripts that implement the Trycycler functions to assemble bacterial genomes. Initially flye, miniasm, raven and necat are used to assemble bacterial genomes from long read sequences, and then Trycycler functions are used to deliver a polished long read assembly. The final step involves short read polishing of each long-read polished assembly via the script `sr_polish.sh`.

---

### Long read genome assembly

**Uses 2 scripts**

1. `1_1_high_cov_run_command.sh`
1. `1_2_high_cov_assembly_script.sh`

`1_1_high_cov_run_command.sh` script is a wrapper script for `1_2_high_cov_assembly_script.sh`. The latter implements genome assembly using different assemblers. The wrapper script creates an output directory, sets the parameters and paths to be used, and calls the assembly script `1_2_high_cov_assembly_script.sh`. Only the wrapper script parameters should be changed, and only within the *user input* section.

#### 1_1_high_cov_run_command.sh - Table of user defined variables

| Variable Name | Brief Description |
| --- | --- |
| parentDirOf_fastqGz_files | Under this parent directory should be all fastq files of interest. The find command starts at this directory path. |
| targetFileSuffix | A string common to all fastq files of interest (eg. fastq.gz) |
| outputDirParent | The parent directory path under which all output files and folders will be saved. |
| scriptPath | The path to the script (`1_2_high_cov_assembly_script.sh`) that will perform the multiple assemblies. |
| genomeSize | The size of the genome being assembled in base pairs |
| threads | Number of threads this script will use. |

#### 1_2_high_cov_assembly_script.sh

See <https://github.com/bogemad/trycycler_scripts/blob/main/high_cov_assembly_script.sh>
For each long read file (fastq) the flye, miniasm, raven, and necat programs each create an assembly for later processing by trycycler.

---

### Reconcile assemblies

**Uses 2 scripts**

1. `2_1_exnrec_run_command.sh`
1. `2_2_exnrec.sh`

This is a manual step looking at one cluster of assemblies at a time. For a more detailed description see <https://github.com/pworden/Trycycler_summary> and the `2. Reconcile assemblies` section. Briefly, examine the log file (eg. barcode01.trycycler.log.txt) to determine which clusters per barcode to run the reconcile script on `2_2_exnrec.sh` using the wrapper script `2_1_exnrec_run_command.sh` to define the user inputs.

#### 2_1_exnrec_run_command.sh - Table of user defined variables

| Variable Name | Brief Description |
| --- | --- |
| clusterDirectory | The path to the cluster of assemblies that may pass `trycycler reconcile`. |
| longReads | The path the fastq appropriate to the claster under investigation (eg. for cluster002 from barcode01 the path to the barcode01 fastq is needed). |
| threads | Number of threads to use. |
| contigLettersToExclude | After examining the log file or error messages after running reconcile, exclude assemblies using one or more letters without spaces (eg. contigLettersToExclude="acg"). Flye='abc', miniasm='def', raven='ghi', necat='jkl' |

#### 2_2_exnrec.sh

See <https://github.com/bogemad/trycycler_scripts/blob/main/exnrec.sh>
Takes in inputs to run the trycycler reconcile step.

---

### Multiple Sequence Align

**Uses:** `3_0_trycycler_MSA_run_command.sh`

This is a wrapper script that performs batch processing of multiple sequence alignment of assemblies for each cluster that has passed the reconcile step. Summarised at step 3 at <https://github.com/pworden/Trycycler_summary>, or described in detail at <https://github.com/rrwick/Trycycler/wiki/Reconciling-contigs>.

#### 3_0_trycycler_MSA_run_command.sh - Table of user defined variables

| Variable Name | Description |
| --- | --- |
| trycyclerAssembliesParent | The parent directory under which can be found all the successfully reconciled clusters. |
| reconciledAssembliesName | The string that represents the successfully reconciled clusters (i.e. *2_all_seqs.fasta*) |

---

### Partitioning

**Uses:** `4_0_partitioning.sh`

This is a wrapper script for the "trycycler partition" function of trycycler. This script searches for multiple sequence alignment files "3_msa.fasta" under a defined parent directory. From the full path it will determine the barcode and the cluster the "3_msa.fasta" file belongs to, as well as the fastq file that the MSA was derived from.

#### 4_0_partitioning.sh - Table of user defined variables

| Variable Name | Description |
| --- | --- |
| trycyclerAssembliesParent | The parent directory under which can be found all the successful multiple sequence alignments |
| msaFastaName | The name of all MSA files `3_msa.fasta` |

---

### Consensus

**Uses:** `5_0_consensus.sh`

This is a wrapper script for the "trycycler consensus" function of Trycycler. It looks for all trycycler partion outputs (4_reads.fastq) under a parent directory and runs the "trycycler consensus" function on each.

#### 5_0_consensus.sh - Table of user defined variables

| Variable Name | Description |
| --- | --- |
| trycyclerAssembliesParent | The parent directory under which can be found all the successful partitions |
| msaFastaName | The name of all partition files `4_reads.fasta` |

---
### Long Read Polish using Medaka

See the Medaka github page here: <https://github.com/nanoporetech/medaka>

**Uses:** `6_0_Medaka_Polish.sh`

This is a wrapper script for the medaka_consensus.sh script from trycycler. It gathers the "7_final_consensus.fasta" files under a user defined parent directory and runs the "medaka_consensus.sh" script on each one from inputs gathered by this wrapper script.

#### 6_0_Medaka_Polish.sh - Table of user defined variables

| Variable Name | Description |
| --- | --- |
| trycyclerAssembliesParent | The parent directory under which can be found all the successful partitions |
| finalConsensusString | The name of all final consensus files `7_final_consensus.fasta` |
| NumCores | The number of cores to use in the analysis |
| modelSettings | The model to be input that is appropriate to the flow cell used in the Minion/Gridion run (eg. r1041_e82_400bps_sup_variant_v4.1.0)|

---

### Prepare TSV for short read polish

**Use:** `7_0_fromPartialStringFindFastq.sh`

This script takes in a 2-column TSV and uses the data and other inputs to construct a 4-column TSV that can be used as a look-up table for the following `8_0_prepare_sr_polish.sh` script that uses short reads to perform a final genome sequence polishing step. The four column headers of the output TSV are: fastqIlluminaPath_F, fastqIlluminaPath_R, partial_string, bar_code.

The structure of the TSV looks like this (no headers, filename of "barcodeAndPartialStringID.tsv"):
|  |  |
| --- | --- |
| barcode01 | T346 |
| barcode02 | T216 |
| barcode03 | T447 |

#### 7_0_fromPartialStringFindFastq.sh - Table of user defined variables

| Variable Name | Description |
| --- | --- |
| fastq_parent_directory | Parent directory that contains all the fastq files for each barcode used in the sequencing run or runs |
| inputTSV | The 2-column TSV that contains the barcode number (eg. *barcode01*) in the first column and a unique partial string in the second column (eg. *T346*). This partial string (in combination with the file extension strings `fileExtension_F` and `fileExtension_R` will be used to find the correct short reads (forward and reverse fastq files) for each barcode in the 2-column TSV. |
| output_file | The path and name that will be the 4-column TSV output from this script. |
| fileExtension_F | An approriate string to identify forward short reads (eg. R1_fastp.fq.gz) |
| fileExtension_R | An approriate string to identify reverse short reads (eg. R2_fastp.fq.gz) |

---

### Short Read Polish

**Uses 2 scripts:**

1. `8_0_sr_polish_run_command.sh`
1. `8_1_sr_polish.sh`

`8_0_sr_polish_run_command.sh` is a wrapper script used to collect the inputs needed to run the short read polish `(8_1_sr_polish.sh)` script. It first looks under a parent directory for all fasta files with the suffix `medaka.fasta`, and then for each medaka polished assembly found, the relevant inputs are obtained from the lookup table constructed by the previous script `7_0_fromPartialStringFindFastq.sh`. For each assembly the inputs are fed into the `8_1_sr_polish.sh` script which then performs a final polish on each medaka polished long reads (previous step) using short reads from the same originating sample or isolate.

| Variable Name | Description |
| --- | --- |
| inputTSV | A four column TSV with the following headers: fastqIlluminaPath_F, fastqIlluminaPath_R, partial_string, bar_code. |
| trycyclerParentDir |  The parent directory of Trycycler output. |
| stringToSearch | "medaka.fasta" (Used by 'find' to determine the path to all long read polished assemblies within the parent trycycler directory). |
| sr_polishPath | Path the the short read polish script (eg. /path/to/short/read/polish/script/8_1_sr_polish.sh). |
| numberOfThreads | The number of threads to use. |

---

8_1_sr_polish.sh
Script to use short reads (fastq files) to polish an assembly.
