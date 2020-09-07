#! /bin/bash
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -J QoRTs
#SBATCH -o OUT/qorts-%j.out
#SBATCH -t 12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=alc217@pitt.edu

## set-up
module load gcc/8.2.0
module load qorts/1.3.0
module load r/3.5.1

set -x

# files
BAMs=
out=


multiqc_r=./qortsGenMultiQC.R

decoder_file=./tab_Decoder.txt

mkdir -p $out

# references
ref=/bgfs/genomics/workshops/2020s/RNASeq_data_analysis/Refs/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa
gtf=/bgfs/genomics/workshops/2020s/RNASeq_data_analysis/Refs/Homo_sapiens.GRCh38.97.gtf


for file in $BAMs/*.bam
do
    file_base=`basename $file`
    sample=${file_base%.bam}

    java -Xmx8G -jar ./QoRTs.jar QC \
            --generatePlots \
             --generateMultiPlot \
            --addFunctions calcDetailedGeneCounts \
            --maxReadLength 150 \
            --keepMultiMapped \
            $file \
            $gtf \
            $out/$file_base 
done
wait


Rscript $multiqc_r $out $decoder_file $out



