The workflow directory includes the **envs** subdirectory, the **scripts** subdirectory and the 3 **Snakefiles** (one for pre-processing, one for running finemapping with UKB LD and one for finemapping with HRC LD).
When running each one of the Snakefiles, the corresponding file shall be defined by *-S {file}* within the snakemake command.

Order of running the different Snakefiles: 
- (1) fetch_UKB_LD_names,
- (2) fine-mapping (UKB panel),
- (3) fine-mapping_HRC (HRC panel)
  
### Note:
The Snakefiles with the **"_multiple"** extension can be used if you wish to run the pipeline for more than one GWAS at a time.

### Note:
Make sure to (i) download **UKB precomputed LD matrices** and **functional annotations** to compute Bayesian priors from the respective links in the Wiki Page and (ii) update accordingly the **paths** to these files within the Snakefiles.
