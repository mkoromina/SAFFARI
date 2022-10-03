# Fine-mapping pipeline implemented through snakemake
A comprehensive statistical and functional finemapping pipeline incorporating 4 fine-mapping tools (SuSiE, FINEMAP, Polyfun+SuSiE, Polyfun+FINEMAP), two reference panels and two differential finemapping ranges/windows.

The pipeline is comprised of the following 3 components:
- fetching the correct UKB LD matrix name for each GWS locus 
- running fine-mapping on cleaned GWAS summary statistics
- merging all independent fine-mapping jobs and processing these (in prep)
