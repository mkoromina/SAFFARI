# Fine-mapping pipeline implemented through snakemake
A comprehensive statistical and functional finemapping pipeline incorporating 4 fine-mapping tools (SuSiE, FINEMAP, Polyfun+SuSiE, Polyfun+FINEMAP), two reference panels (HRC, UKB) and two differential finemapping ranges/windows (3Mb window or windows defined by the LD structure).

The pipeline is comprised of the following 3 Snakemake modules:
- fetching the correct UKB LD matrix name for each GWS locus 
- running fine-mapping on cleaned GWAS summary statistics
- merging all independent fine-mapping jobs and processing these

#Prior to pipeline execution, install the following:
(i) Polyfun (Weissbrod et al., 2020), with installation instructions found in here https://github.com/omerwe/polyfun. 
(ii) FINEMAP software is available at http://www.christianbenner.com/#.}
(iii) Snakemake, https://snakemake.readthedocs.io/en/stable/getting_started/installation.html.
You will need to activate the snakemake conda/mamba environment prior to the pipeline execution.
Note that in order to run snakemake pipelines, you should follow one of the two options: 
(a) set up a slurm or lsf profile as in https://github.com/Snakemake-Profiles/slurm or https://github.com/Snakemake-Profiles/lsf which will parallelize job submission and execution, or, (b) run "snakemake -s Snakefile" from within the directory where your Snakefile is stored by using screen sessions.

#To add credits
