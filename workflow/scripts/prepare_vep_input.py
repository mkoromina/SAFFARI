import gzip

import pandas as pd


input_file = snakemake.input[0]
output_file = snakemake.output[0]

with gzip.open(input_file, "rt") as f:
    df = pd.read_csv(f, sep="\t")

unique_variants = set()

with open(output_file, "w") as f:
    for _, row in df.iterrows():
        try:
            int(row["BP"])
        except (ValueError, TypeError):
            continue

        variant_key = f"{row['CHR']}:{row['BP']}:{row['A2']}:{row['A1']}"

        if variant_key not in unique_variants:
            unique_variants.add(variant_key)

            vep_line = (
                f"{row['CHR']} "
                f"{row['BP']} "
                f"{row['BP']} "
                f"{row['A2']}/{row['A1']} +"
            )

            f.write(vep_line + "\n")
