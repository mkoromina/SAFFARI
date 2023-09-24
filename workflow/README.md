The workflow includes the **envs** directory, the **scripts** directory and the 3 **Snakefiles** (one for pre-processing, one for running finemapping with UKB LD and one for finemapping with HRC).
When running each one of the Snakefiles , the corresponding file shall be defined by *-S {file}* within the snakemake command.

Order of running the different Snakefiles: 
- (1) fetch_UKB_LD_names,
- (2) fine-mapping (UKB panel),
- (3) fine-mapping_HRC (HRC panel)
  

### Note:
Make sure to download UKB precomputed LD matrices and functional priors from the respective links in the Wiki and update accordingly the path to these within the Snakefiles.
