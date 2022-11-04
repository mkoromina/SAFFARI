# Fine-mapping pipeline implemented through snakemake
A comprehensive statistical and functional finemapping pipeline incorporating 4 fine-mapping tools (SuSiE, FINEMAP, Polyfun+SuSiE, Polyfun+FINEMAP), two reference panels (HRC, UKB) and two differential finemapping ranges/windows (3Mb window or windows defined by the LD structure).

The pipeline is comprised of the following 3 components:
- fetching the correct UKB LD matrix name for each GWS locus 
- running fine-mapping on cleaned GWAS summary statistics
- merging all independent fine-mapping jobs and processing these


First ensure that you have installed snakemake in your computer, local computing cluster etc. To do this, follow the instructions as found here https://snakemake.readthedocs.io/en/stable/getting_started/installation.html.
Make sure to create a conda/mamba snakemake environment that you need to activate prior to the pipeline execution.
To run snakemake pipelines as this one, follow one of the two options: (i) set up a slurm or lsf profile as in https://github.com/Snakemake-Profiles/slurm or https://github.com/Snakemake-Profiles/lsf which will parallelize job submission and execution  (ii) run "snakemake -s Snakefile" from within the directory where your Snakefile is stored by using screen sessions.

