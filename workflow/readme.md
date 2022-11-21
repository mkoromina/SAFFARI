The workflow includes 4 scripts (one for pre-processing, one for running finemapping with UKB LD, one for finemapping with HRC and one for processing the finemapping results).
When running each one of these 4 scripts, the corresponding file shall be defined by *-S {file}* within the snakemake pipeline.

Order of running snakemake modules: 
(1) fetch_UKB_LD_names,
(2) fine-mapping (UKB panel),
and/or (3) fine-mapping_HRC (HRC panel), 
(4) credible_sets.
