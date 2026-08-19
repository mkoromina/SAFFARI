import gzip
import pandas as pd


# Snakemake exposes the rule inputs/outputs/wildcards through the `snakemake` object.
input_file = snakemake.input[0]
output_file = snakemake.output[0]
method = snakemake.wildcards.method

with gzip.open(input_file, "rt") as f:
    df = pd.read_csv(f, sep="\t")

df["PIP"] = pd.to_numeric(df["PIP"], errors="coerce")
df = df.dropna(subset=["PIP"])

if "susie" in method:
    filtered_df = df[df["PIP"] > 0.5]

elif "finemap" in method:
    df["CREDIBLE_SET"] = pd.to_numeric(
        df["CREDIBLE_SET"], errors="coerce"
    )
    df = df.dropna(subset=["CREDIBLE_SET"])
    filtered_df = df[
        (df["PIP"] > 0.5) &
        (df["CREDIBLE_SET"] != 0)
    ]

else:
    raise ValueError(f"Unknown method: {method}")

with gzip.open(output_file, "wt") as f:
    filtered_df.to_csv(f, sep="\t", index=False)
