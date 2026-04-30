
#GWASLab Pipeline

##Overview
This section describes how to download the required data, set up the virtual environment, and run GWASLab in order to harmonizae GWAS summary statistics for downstream analysis with S-PrediXcan

Due to the research of this project, GWASLab was used with hardcoding, leading to the result of preprocessing work and manual labor from the user. Further down the project, the sumstats from GWASLab must be changed to match the column names within the summary statistics.

## Dependencies
### Software
- conda -> virtual environment to run GWASLab
- Linux or macOS
- Python

### Python Packages
- gwaslab

#First, individuals should use wget to access the reference genome required for individual usage. For the purposes of this test, we are using the GRCh38 human genome.

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz

#Once the file has been downloaded, unzip it using the command gunzip

gunzip GCF_000001405.40_GRCh38.p14_genomic.fna.gz

#Next, a virtual environment was then used within the terminal to run GWASLab within the class server and was named .venv

python3 -m venv .venv

source .venv/bin/activate

#install GWASLab inside the virtual environment
pip install gwaslab

#For testing purposes, download a GWAS summary statistic from the GWAS catalog by using wget

wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90568001-GCST90569000/GCST90568441/GCST90568441.tsv.gz

#unzip the statistic file

gunzip GCST90568441.tsv.gz
##GWASLab harmonization script

The following script is used for GWASLab summary statistics, which is used to do quality control and overall produce harmonized data with the GRCh38 reference genome

#import the gwaslab library to be used for downstream harmonization from the GWAS summary statistics
import gwaslab as gl

#provide a certain pathway to the test data
#mysumstats provides an interpretation on each column provided in the file
mysumstats = gl.Sumstats(
    "/home/nalde/GCST90568441.tsv.gz",
    snpid="rsid",
    chrom="chromosome",
    pos="base_pair_location",
    ea="effect_allele",
    nea="other_allele",
    beta="beta",
    se="standard_error",
    p="p_value",
    sep=r"\s+"
)

#these column names will vary depending on the summary statistic, in which users must change manually

#basic quality control checks
mysumstats.basic_check()

#harmonization step (using GRCh38 reference genome)
mysumstats.harmonize(
    ref_seq="/home/nalde/GRCh38.fa",
    verbose=True
)

#create a new file with the harmonized data
mysumstats.to_csv("harmonized_sumstats.tsv", sep="\t", index=False)
