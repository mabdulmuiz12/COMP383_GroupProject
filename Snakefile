import os
from snakemake.io import glob_wildcards

# 1. Fallback paths (can be overridden via command line)
configfile: "config.yaml"
IN_DIR = config.get("input_dir", "data/raw")
OUT_DIR = config.get("output_dir", "data/harmonized")

# 2. Automatically find all GWAS files in the input directory
# This supports .tsv, .txt, or .csv (with or without .gz)
SAMPLES, = glob_wildcards(os.path.join(IN_DIR, "{sample}.tsv.gz"))

rule all:
    input:
        expand(os.path.join(OUT_DIR, "{sample}_harmonized.txt.gz"), sample=SAMPLES)

rule harmonize_any:
    input:
        data = os.path.join(IN_DIR, "{sample}.tsv.gz")
    output:
        os.path.join(OUT_DIR, "{sample}_harmonized.txt.gz")
    params:
        # Pulls specific column mappings from config, or uses an empty string
        extra = lambda wildcards: " ".join([
            f"--{k} {v}" for k, v in config.get("overrides", {}).get(wildcards.sample, {}).items()
        ])
    shell:
        """
        python3 run_gwas_harmonization.py \
            -i {input.data} \
            -o {output} \
            {params.extra}
        """
