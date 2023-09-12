The workflow includes 4 scripts (one for pre-processing, one for running finemapping with UKB LD, one for finemapping with HRC and one for processing the finemapping results).
When running each one of these 4 scripts, the corresponding file shall be defined by *-S {file}* within the snakemake pipeline.

Order of running the different snakemake modules: 
- (1) fetch_UKB_LD_names,
- (2) fine-mapping (UKB panel),
- (3) fine-mapping_HRC (HRC panel), 
- (4) credible_sets.

### Note 1 
The module credible_sets is under beta-testing.

### Note 2
Make sure to download UKB precomputed LD matrices from https://alkesgroup.broadinstitute.org/UKBB_LD/ and amend the path to these accordingly. 
