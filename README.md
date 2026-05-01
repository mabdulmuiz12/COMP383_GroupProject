# COMP383_GroupProject
Project 3 - Harmonize GWAS Summary Statistics for S-PrediXcan

## Project Overview
The purpose of this project was to evaluate different GWAS Harmonization tools, MungeSumstats, GWASLab, and Metaxcan, and determined the best one to use. Through the evaluation of the three harmonization tools, seen in Tool_Comparision.md, we determined that MetaXcan was the most efficient tool to use. Below contains instructions to install and run Metaxcan. We have also included instructions to run harmonized data on S-PrediXcan. Code used to run the other harmonization tools is available in Munge_Sumstats.R and GWASLAB_Project3_test.py

## Dependencies Used
### Softwares
- conda 
- Linux or macOS
- Python 
- R 
### Python Pakcages
	- numpy 
	- scipy
	- pandas
	
### external tools 
	- summary-gwas-imputation
	- All of us 
	- GWAS Catalog datasets
	- Pan-UK BioBank

### Cloning Repo and Downloading GWAS
cloned this repo
```bash
git clone https://github.com/christina2564/COMP383_GroupProject
```
In this repo you should now have run_gwas_harmonization.py 


To test MetaXcan  harmonization, download this ADHD-GWAS file from GWAS Bank. 
```bash
cd COMP383_GroupProject
wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90568001-GCST90569000/GCST90568441/GCST90568441.tsv.gz
```

Or you can also use the All of Us GWAS found in the class server. 
Path for All of us: /home/data/Project3/AoU_AFR_phenotype_836850_ACAF_sumstats_for_S-PrediXcan.txt.gz

## Instructions

STEP 1
Cloned the Metaxcan harmonization tool lab repo under this directory:
```bash
cd ~/COMP383_GroupProject #move into the COMP383_GroupProject directory
git clone https://github.com/hakyimlab/summary-gwas-imputation.git
```
Verify it downloaded correctly and that gwas_parsing.py is in the folder:
```bash
ls ~/COMP383_GroupProject/summary-gwas-imputation/src/ # can check to see if gwas_parsing.py is in this directory
```
gwas_parsing.py is in the output.


### Installing Metaxcan (S-Predixcan)
STEP 2 

Clone the MetaXcan repo into my Final_Project directory:
```bash
cd ~/COMP383_GroupProject
git clone https://github.com/hakyimlab/MetaXcan.git
```

Verify SPrediXcan.py is there:
```bash
ls ~/Final_Project/MetaXcan/software/SPrediXcan.py
```

For more information/instructions on downloading Metaxcan, go to the Metaxcan Lab GitHub: https://github.com/hakyimlab/MetaXcan/blob/master/README.md 

### Installing Dependencies 
STEP 3 

Check that numpy, pandas, and scipy are available:
Run on the command line:
```bash
python3 -c "import numpy, pandas, scipy; print('OK')" # if dependcies are downloaded, you will see OK printed 
```
If they are not already downloaded, run this on the command line:

```bash
pip install numpy pandas scipy
```

Install pyliftover which is required by gwas_parsing.py:

```bash
pip install pyliftover --break-system-packages
```


Check that genomic_tools_lib is accessible:
```bash
python3 -c "import sys; sys.path.insert(0, '~/COMP383_GroupProject/summary-gwas-imputation/src'); import genomic_tools_lib; print('OK')"
```

### PATCH gwas_parsing.py
STEP 4 

There is a bug in gwas_parsing.py that causes a crash when the input file does not have a sample_size column. Apply this fix on the command line:

```bash
sed -i 's/\[int(x) if not math.isnan(x) else "NA" for x in d.sample_size\]/[int(x) if (not isinstance(x, str) and not math.isnan(x)) else "NA" for x in d.sample_size]/' ~/COMP383_GroupProject/summary-gwas-imputation/src/gwas_parsing.py
```
This only needs to be done once after cloning the repo.



### Running Harmonization Script
STEP 5 

Run the code on the command line 

The script automatically detects column names from the input file.
We do not need to specify column names for most standard GWAS files.

On command line (to use with your own gwas summary statistics with a different name, replace path/to/your_gwas_file.tsv.gz with path to your file: 
Only two inputs needed with Metaxcan: path of raw data, and path to harmonized data
```bash
python3 run_gwas_harmonization.py \
        -i /path/to/your_gwas_file.tsv.gz \
        -o /path/to/your_harmonized_output.txt.gz
```

To use with the GWAS from the class server:

```bash
    python3 run_gwas_harmonization.py \
        -i /home/data/Project3/AoU_AFR_phenotype_836850_ACAF_sumstats_for_S-PrediXcan.txt.gz \
        -o ~/COMP383_GroupProject/AoU_harmonized.txt.gz
```

Example using the GWAS Catalog file on this repo:

```bash
    python3 run_gwas_harmonization.py \
        -i ~/COMP383_GroupProject/GCST90568441.tsv.gz \
        -o ~/COMP383_GroupProject/GCST90568441_harmonized.txt.gz
```

If auto-detection fails for any column, we can override manually (example):
```bash
    python3 run_gwas_harmonization.py \
        -i ~/COMP383_GroupProject/my_gwas.tsv.gz \
        -o ~/COMP383_GroupProject/my_harmonized.txt.gz \
        --snp_col SNP \
        --pvalue_col P \
        --beta_col BETA
```

Available column override flags:
```bash
    --snp_col           SNP/variant ID column
    --effect_allele_col Effect allele column
    --other_allele_col  Non-effect allele column
    --beta_col          Beta/effect size column
    --se_col            Standard error column
    --pvalue_col        P-value column
    --freq_col          Allele frequency column
    --chr_col           Chromosome column
    --pos_col           Base pair position column
```
### Using a Reference Panel for Coordinate-based Variant IDs
STEP 6
Some GWAS files (e.g., All of Us) use coordinate-based variant IDs (e.g., chr1:61920:G:A) instead of rsIDs. S-PrediXcan cannot match these against its model unless you provide a reference panel.

Download the 1000 Genomes reference panel:
```bash 
cd ~/Final_Project
wget -0 sample_data. tar "https://zenodo.org/record/3657902/files/sample_data.tar?download=1"
tar -xf sample_data.tar
```
The file you need is:
```bash
~/COMP383_GroupProject/sample_data/1000G_hg38/variant_metadata.txt.gz
```

Run harmonization with the reference panel:
```bash
python3 run_gwas_harmonization.py \
-i /path/to/your_aou_gwas.tsv.gz \
-0 / path/to/your_harmonized
_output. txt.gz
--reference_panel ~/COMP_383GroupProject/sample_data/1000G_hg38/variant_metadata.txt.gz
```

### Running Predixcan on Hamronized Output
STEP 7 
To run S-Predixcan you must navigate to the software folder in the folder Metaxcan

Activate the conda environment to run Predixcan in:

```bash
conda activate imlabtools
```

if conda is not installed, run:

```bash
conda env create -f /path/to/this/repo/software/conda_env.yaml
```

After running MetaXcan and harmonizaing data, run S-PrediXcan using the standardized column names that the harmonization script will always output:

To run your own harmonized GWAS on S-Predixcan:

```bash
    python3 ~/COMP383_GroupProject/MetaXcan/software/SPrediXcan.py \
        --model_db_path /home/data/model_used.db \
        --covariance /home/data/model_used..txt.gz \
        --gwas_folder /path/to/harmonized/output/folder \
        --gwas_file_pattern "your_harmonized_output.txt.gz" \
        --snp_column variant_id \
        --effect_allele_column effect_allele \
        --non_effect_allele_column non_effect_allele \
        --beta_column effect_size \
        --se_column standard_error \
        --pvalue_column pvalue \
        --pvalue_column pvalue \
        --keep_non_rsid \
        --output_file /path/to/results/spredixcan_results.csv
```

Example with harmonized All of Us from class server:

```bash
    python3 ~/COMP383_GroupProject/MetaXcan/software/SPrediXcan.py \
        --model_db_path /home/data/Project3/elastic-net-with-phi/en_Whole_Blood.db \
        --covariance /home/data/Project3/elastic-net-with-phi/en_Whole_Blood.txt.gz \
        --gwas_folder ~/COMP383_GroupProject \
        --gwas_file_pattern "AoU_harmonized.txt.gz" \
        --snp_column variant_id \
        --effect_allele_column effect_allele \
        --non_effect_allele_column non_effect_allele \
        --beta_column effect_size \
        --se_column standard_error \
        --pvalue_column pvalue \
        --pvalue_column pvalue \
        --keep_non_rsid \
        --output_file ~/COMP383_GroupProject/spredixcan_results_AoU.csv
```


Example using the harmonized ADHD-GWAS Catalog file:

```bash
    python3 ~/COMP383_GroupProject/MetaXcan/software/SPrediXcan.py \
        --model_db_path /home/data/Project3/elastic-net-with-phi/en_Whole_Blood.db \
        --covariance /home/data/Project3/elastic-net-with-phi/en_Whole_Blood.txt.gz \
        --gwas_folder ~/COMP383_GroupProject \
        --gwas_file_pattern "GCST90568441_harmonized.txt.gz" \
        --snp_column variant_id \
        --effect_allele_column effect_allele \
        --non_effect_allele_column non_effect_allele \
        --beta_column effect_size \
        --se_column standard_error \
        --pvalue_column pvalue \
        --keep_non_rsid \
        --model_db_snp_key varID \ 
        --output_file ~/COMP383_GroupProject/spredixcan_results_GCST90568441.csv
```

To view the first 10 lines of your S-PrediXcan results:
```bash
cat ~/COMP383_GroupProject/spredixcan_results_AoU.csv | head -10
```
