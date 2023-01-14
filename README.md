# Snakemake fine-mapping pipeline
A comprehensive statistical and functional finemapping pipeline incorporating 4 fine-mapping tools (SuSiE, FINEMAP, Polyfun+SuSiE, Polyfun+FINEMAP), two reference panels (HRC, UKB) and two differential finemapping ranges/windows (3Mb window or windows defined by the LD structure).

The pipeline is comprised of the following 3 Snakemake modules:
- fetching the correct UKB LD matrix name for each GWS locus 
- running fine-mapping on cleaned GWAS summary statistics
- merging all independent fine-mapping jobs and processing the derived files.

## Dependencies

- [Polyfun](https://github.com/omerwe/polyfun)
- [FINEMAP](http://www.christianbenner.com/)
- [SuSiE](https://github.com/stephenslab/susieR)
- [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
- *optional* [LDStorev2](http://www.christianbenner.com/#)

You will need to activate the snakemake conda/mamba environment prior to the pipeline execution.
Note that in order to run snakemake pipelines, you should follow one of the two options: 
- set up a slurm or lsf profile as in https://github.com/Snakemake-Profiles/slurm or https://github.com/Snakemake-Profiles/lsf which will parallelize job submission and execution. The pipelines modules can then be run by running ```snakemake --profile lsf```
- run ```snakemake -s Snakefile``` from within the directory, in which your Snakefile is stored, by using screen sessions in your local cluster. In this case, make sure that you add the ```use-conda``` flag in you command.


## Inputs

To run this Snakemake pipeline with the different modules, you will need two main inputs: (i) formatted and cleaned GWAS summary sumstats ( in a ```.gz``` format) and (ii) a list of top loci to finemap (usually stored as a ```.csv```file). GWAS sumstats should be cleaned and any duplicate SNPs shall be removed beforehand. Both the top loci file and the GWAS sumstats should include the columns as outputted from [Ricopili](https://sites.google.com/a/broadinstitute.org/ricopili/overview).

Future impovements in the pipeline include creating rules for GWAS sumstats processing and creating the top loci file. In the meantime, GWAS sumstats from Ricopili are accepted as input.

GWAS columns from Ricopili include:
- ```CHR```    ```SNP```     ```BP```    ```A1```    ```A2```    ```FRQ_A_41917```    ```FRQ_U_371549```    ```INFO```    ```OR```    ```SE```    ```P```  ```ngt```    ```Direction```    ```HetISqt```    ```HetDf```    ```HetPVa```   ```Nca```    ```Nco```   ```Neff_half```
(if you need to filter according to the MAF then the FRQ columns shall be renamed)

Top loci file is derived from the Ricopili clumping procedure and should include the minimum fields:
- ```SNP```    ```Chromosome```    ```Position```    ```Gene```    ```Locus```    ```range.left```    ```range.right```
(Gene, Locus fields can include the same information, range.left and range.right are defined as the 'fine-mapping windows')

## Credits
This work would not have been feasible without the contribution and wonderful work of other researchers:
- Omer Weissbrod,
- Jonathan Coleman,
- Ashvin Ravi,
- Brian Fulton-Howard,
- Brian Schilder.


## Issues 
Shall any issues occur when running the pipeline, please feel free to list them down by providing a mini reproducible example.
Contributions are also more than welcome.
