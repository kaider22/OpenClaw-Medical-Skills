---
name: omics-small-rna-seq-mirge3-analysis
description: 提供快速定量已知miRNA并分析isomiR/编辑的方法与调用指南；用于处理小RNA FASTQ、物种库和适配器序列。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: miRge3
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


# miRge3 Analysis

## Codex 调用

- **选择**：请求涉及“快速定量已知miRNA并分析isomiR/编辑”时使用；显式调用 `$omics-small-rna-seq-mirge3-analysis`。
- **输入**：小RNA FASTQ、物种库和适配器序列。
- **预期产物**：miRNA/isomiR计数、RPM、编辑结果和QC报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`miRge3`、`mirge3`、`numpy`、`pandas`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Basic Quantification

```bash
# Run miRge3 on FASTQ files
miRge3.0 annotate \
    -s sample1.fastq.gz,sample2.fastq.gz \
    -lib miRge3_libs \
    -on human \
    -db mirbase \
    -o output_dir \
    -a TGGAATTCTCGGGTGCCAAGG \
    --threads 8

# Key options:
# -s: Input FASTQ files (comma-separated)
# -lib: Path to miRge3 library
# -on: Organism name
# -db: Database (mirbase or mirgenedb)
# -a: 3' adapter sequence
```

## Install miRge3 Libraries

```bash
# Download pre-built libraries
miRge3.0 --download-library human mirbase

# Libraries include:
# - Bowtie indices for miRNAs, tRNAs, rRNAs
# - miRBase or MirGeneDB annotations
# - A-to-I editing sites
```

## IsomiR Detection

```bash
# Enable isomiR analysis
miRge3.0 annotate \
    -s sample.fastq.gz \
    -lib miRge3_libs \
    -on human \
    -db mirbase \
    --isomir \
    -o output_dir

# IsomiRs include:
# - 5' variants (templated and non-templated)
# - 3' variants (templated and non-templated)
# - Internal modifications
```

## A-to-I RNA Editing

```bash
# Detect A-to-I editing
miRge3.0 annotate \
    -s sample.fastq.gz \
    -lib miRge3_libs \
    -on human \
    -db mirbase \
    --AtoI \
    -o output_dir

# Outputs editing sites and frequencies
```

## Output Files

| File | Description |
|------|-------------|
| miR.Counts.csv | Raw read counts per miRNA |
| miR.RPM.csv | RPM normalized counts |
| isomiR.Counts.csv | IsomiR-level counts |
| isomiR.summary.csv | IsomiR summary per miRNA |
| annotation.report.html | Interactive QC report |

## Python API

```python
from mirge3.annotate import annotate

# Run programmatically
annotate(
    samples=['sample1.fastq.gz', 'sample2.fastq.gz'],
    lib_path='miRge3_libs',
    organism='human',
    database='mirbase',
    adapter='TGGAATTCTCGGGTGCCAAGG',
    output_dir='results',
    threads=8
)
```

## Parse miRge3 Output

```python
import pandas as pd

def load_mirge3_counts(output_dir):
    '''Load miRge3 count matrix'''
    counts = pd.read_csv(f'{output_dir}/miR.Counts.csv', index_col=0)
    return counts

def load_isomirs(output_dir):
    '''Load isomiR-level counts'''
    isomirs = pd.read_csv(f'{output_dir}/isomiR.Counts.csv', index_col=0)
    return isomirs

# Filter low-expressed miRNAs
def filter_low_counts(counts, min_total=10):
    '''Keep miRNAs with total count >= threshold'''
    return counts[counts.sum(axis=1) >= min_total]
```

## Compare Multiple Samples

```python
def normalize_rpm(counts):
    '''Normalize to reads per million'''
    total_per_sample = counts.sum(axis=0)
    rpm = counts / total_per_sample * 1e6
    return rpm

def log_transform(rpm, pseudocount=1):
    '''Log2 transform with pseudocount'''
    import numpy as np
    return np.log2(rpm + pseudocount)
```

## IsomiR Analysis

```python
def summarize_isomirs(isomir_counts):
    '''Summarize isomiR diversity per miRNA'''
    # Group by canonical miRNA
    isomir_counts['miRNA'] = isomir_counts.index.str.extract(r'(hsa-\w+-\d+[a-z]*)')[0]

    summary = isomir_counts.groupby('miRNA').agg({
        'count': ['sum', 'count', lambda x: x.idxmax()]
    })
    summary.columns = ['total_reads', 'n_isomirs', 'dominant_isomir']
    return summary
```

## Related Skills

- smrna-preprocessing - Prepare reads for miRge3
- mirdeep2-analysis - Alternative with novel miRNA discovery
- differential-mirna - DE analysis of miRge3 counts


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->