The workflow includes 4 scripts (one for pre-processing, one for running finemapping with UKB LD, one for finemapping with HRC and one for processing the finemapping results).
When running each one of these 4 scripts, the corresponding file shall be defined by *-S {file}* within the snakemake pipeline.

Order of running the different snakemake modules: 
- (1) fetch_UKB_LD_names,
- (2) fine-mapping (UKB panel),
- (3) fine-mapping_HRC (HRC panel), 
- (4) credible_sets.
## module credible_sets is under beta-testing.

## Important note
- Make sure that you edit the Snakefiles accordingly to point to the directory where Polyfun and the precomputed UKB LD matrices are stored.
UKB precomputed LD matrices can be downloaded from https://alkesgroup.broadinstitute.org/UKBB_LD/. 
