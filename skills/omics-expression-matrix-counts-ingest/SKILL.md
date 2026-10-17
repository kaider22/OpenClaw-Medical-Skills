---
name: omics-expression-matrix-counts-ingest
description: 提供读取并整合CSV/TSV、featureCounts、Salmon和10X计数的方法与调用指南；用于处理计数文件、定量目录、10X矩阵或AnnData/RDS。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: pandas
    measurable_outcome: Execute skill workflow successfully with valid output within 15 minutes.
    allowed-tools:
    - read_file
    - run_shell_command
---
<!--
# COPYRIGHT NOTICE
# This file is part of the "Universal Biomedical Skills" project.
# Copyright (c) 2026 MD BABU MIA, PhD <md.babu.mia@mssm.edu>
# All Rights Reserved.
#
# This code is proprietary and confidential.
# Unauthorized copying of this file, via any medium is strictly prohibited.
#
# Provenance: Authenticated by MD BABU MIA

-->


# Count Matrix Ingestion

## Codex 调用

- **选择**：请求涉及“读取并整合CSV/TSV、featureCounts、Salmon和10X计数”时使用；显式调用 `$omics-expression-matrix-counts-ingest`。
- **输入**：计数文件、定量目录、10X矩阵或AnnData/RDS。
- **预期产物**：统一的基因×样本矩阵、TPM及可保存的AnnData；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`anndata`、`pandas`、`pyreadr`、`scanpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Basic CSV/TSV Loading

```python
import pandas as pd

# TSV with gene IDs as first column
counts = pd.read_csv('counts.tsv', sep='\t', index_col=0)

# CSV with header
counts = pd.read_csv('counts.csv', index_col=0)

# Skip comment lines
counts = pd.read_csv('counts.txt', sep='\t', index_col=0, comment='#')
```

## featureCounts Output

```python
import pandas as pd

# featureCounts format has 6 metadata columns before counts
fc = pd.read_csv('featurecounts.txt', sep='\t', comment='#')
counts = fc.set_index('Geneid').iloc[:, 5:]  # Skip Chr, Start, End, Strand, Length
counts.columns = [c.replace('.bam', '').split('/')[-1] for c in counts.columns]
```

## Salmon Quant Files

```python
import pandas as pd
from pathlib import Path

def load_salmon_quants(quant_dirs, column='NumReads'):
    '''Load multiple Salmon quant.sf files into a count matrix.'''
    dfs = {}
    for qdir in quant_dirs:
        sample = Path(qdir).name
        sf = pd.read_csv(f'{qdir}/quant.sf', sep='\t', index_col=0)
        dfs[sample] = sf[column]
    return pd.DataFrame(dfs)

# Usage
quant_dirs = ['salmon_out/sample1', 'salmon_out/sample2', 'salmon_out/sample3']
counts = load_salmon_quants(quant_dirs, column='NumReads')
tpm = load_salmon_quants(quant_dirs, column='TPM')
```

## kallisto Abundance Files

```python
import pandas as pd
from pathlib import Path

def load_kallisto_quants(abundance_files, column='est_counts'):
    '''Load multiple kallisto abundance.tsv files.'''
    dfs = {}
    for f in abundance_files:
        sample = Path(f).parent.name
        ab = pd.read_csv(f, sep='\t', index_col=0)
        dfs[sample] = ab[column]
    return pd.DataFrame(dfs)

# Usage
files = ['kallisto_out/sample1/abundance.tsv', 'kallisto_out/sample2/abundance.tsv']
counts = load_kallisto_quants(files, column='est_counts')
tpm = load_kallisto_quants(files, column='tpm')
```

## 10X Genomics Sparse Matrix

```python
import scanpy as sc

# Load 10X directory (contains matrix.mtx, genes.tsv/features.tsv, barcodes.tsv)
adata = sc.read_10x_mtx('filtered_feature_bc_matrix/')

# Load 10X H5 file
adata = sc.read_10x_h5('filtered_feature_bc_matrix.h5')

# Convert to dense DataFrame if needed
counts = adata.to_df()
```

## AnnData H5AD Files

```python
import anndata as ad
import scanpy as sc

# Load h5ad
adata = sc.read_h5ad('data.h5ad')

# Access count matrix
counts = adata.to_df()  # Dense DataFrame
sparse_counts = adata.X  # Sparse matrix (if stored sparse)

# Access raw counts if normalized data is in .X
raw_counts = adata.raw.to_adata().to_df()
```

## RDS Files (from R)

```python
import pyreadr

# Read RDS file
result = pyreadr.read_r('counts.rds')
counts = result[None]  # Access the data

# For Seurat objects, use anndata2ri or convert in R first
```

## Combine Multiple Files

```python
import pandas as pd
from pathlib import Path

def combine_count_files(file_pattern, index_col=0, sep='\t'):
    '''Combine multiple count files into one matrix.'''
    files = sorted(Path('.').glob(file_pattern))
    dfs = {}
    for f in files:
        sample = f.stem.replace('_counts', '')
        dfs[sample] = pd.read_csv(f, sep=sep, index_col=index_col).iloc[:, 0]
    return pd.DataFrame(dfs)

# Usage
counts = combine_count_files('counts/*_counts.tsv')
```

## Filter Low-Count Genes

```python
# Keep genes with at least 10 counts in at least 3 samples
min_counts, min_samples = 10, 3
expressed = (counts >= min_counts).sum(axis=1) >= min_samples
counts_filtered = counts.loc[expressed]

# Alternative: total counts threshold
counts_filtered = counts[counts.sum(axis=1) >= 50]
```

## Handle Gene ID Versions

```python
# Remove Ensembl version numbers (ENSG00000123456.12 -> ENSG00000123456)
counts.index = counts.index.str.split('.').str[0]

# Or keep as-is for compatibility
```

## Save Count Matrix

```python
# Save as TSV
counts.to_csv('count_matrix.tsv', sep='\t')

# Save as compressed
counts.to_csv('count_matrix.tsv.gz', sep='\t', compression='gzip')

# Save as AnnData
import anndata as ad
adata = ad.AnnData(counts)
adata.write_h5ad('counts.h5ad')
```

## R Loading Equivalents

```r
# Basic CSV/TSV
counts <- read.csv('counts.csv', row.names=1)
counts <- read.delim('counts.tsv', row.names=1)

# featureCounts
fc <- read.delim('featurecounts.txt', comment.char='#', row.names=1)
counts <- fc[, 6:ncol(fc)]

# tximport for Salmon/kallisto
library(tximport)
files <- file.path('salmon_out', samples, 'quant.sf')
txi <- tximport(files, type='salmon', txOut=TRUE)
counts <- txi$counts
```

## Related Skills

- rna-quantification/featurecounts-counting - Generate featureCounts output
- rna-quantification/alignment-free-quant - Generate Salmon/kallisto output
- expression-matrix/sparse-handling - Memory-efficient storage
- expression-matrix/gene-id-mapping - Convert gene identifiers


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->