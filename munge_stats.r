library(MungeSumstats)

# our summary stats file relates to GRch38, so we need to install SNPlocs.Hsapiens.dbSNP144.GRCh38 and BSgenome.Hsapiens.NCBI.GRCh38 from Bioconductor as follows: 

BiocManager::install("SNPlocs.Hsapiens.dbSNP144.GRCh38")
# dowload BiocManager::install("SNPlocs.Hsapiens.dbSNP155.GRCh38") instead

BiocManager::install("BSgenome.Hsapiens.NCBI.GRCh38")
# this takes a lot of time 
# if the summary stats file of interest is realted to GRch37, then we woudl have to do the smae thing with 37
# these are big downloads of 800kb
reformatted <- 
  MungeSumstats::format_sumstats(path="/home/data/Project3/AoU_AFR_phenotype_836850_ACAF_sumstats_for_S-PrediXcan.txt.gz",
                                 ref_genome="GRCh38")

# need to know genome build before running 
# columns must be spaced out or deliminated
# need to download GRCh38 (hg38) because we need reference genome build before running, Null does not work and it won't infer what genome build it is before 
# 