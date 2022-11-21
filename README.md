# Snakemake fine-mapping pipeline
A comprehensive statistical and functional finemapping pipeline incorporating 4 fine-mapping tools (SuSiE, FINEMAP, Polyfun+SuSiE, Polyfun+FINEMAP), two reference panels (HRC, UKB) and two differential finemapping ranges/windows (3Mb window or windows defined by the LD structure).

The pipeline is comprised of the following 3 Snakemake modules:
- fetching the correct UKB LD matrix name for each GWS locus 
- running fine-mapping on cleaned GWAS summary statistics
- merging all independent fine-mapping jobs and processing these

## Dependencies

- [Polyfun](https://github.com/omerwe/polyfun)
- [FINEMAP](http://www.christianbenner.com/)
- [SuSiE](https://github.com/stephenslab/susieR)
- [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
- *optional* [LDStorev2](http://www.christianbenner.com/#)

You will need to activate the snakemake conda/mamba environment prior to the pipeline execution.
Note that in order to run snakemake pipelines, you should follow one of the two options: 
- set up a slurm or lsf profile as in https://github.com/Snakemake-Profiles/slurm or https://github.com/Snakemake-Profiles/lsf which will parallelize job submission and execution, or, 
- run *snakemake -s Snakefile* from within the directory where your Snakefile is stored by using screen sessions.

## Credits
This work would not have been feasible without the contribution and wonderful work of other researchers:
- Omer Weissbrod (Polyfun & PolyPred),
- Jonathan Coleman (tackling fine-mapping issues),
- Ashvin Ravi (tackling fine-mapping issues),
- Brian Fulton-Howard (snakemake issues).
