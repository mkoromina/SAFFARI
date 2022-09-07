#first produce the correct GWS loci files for our tested GWAS datasets. The variables in these files will be used as the wildcards for the rest
#of the pipeline.

#we need the correct 'names' for the UKB LD matrices of our GWS loci

SS = ["daner_bip_pgc3", "suicide_gwas"]  
CHR = list(range(1,23))

rule import_finemap_loci:
    	input:  expand("resources/{ss}_toploci.csv", ss= SS)
    	output: expand("resources/{ss}_loci_ranges.tsv", ss = SS)
    	conda: "envs/r.yaml"
    	script: "scripts/UKBiobank_LD.R"