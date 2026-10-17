---
name: omics-small-rna-seq-smrna-preprocessing
description: 提供去除小RNA接头并按长度和质量筛选的方法与调用指南；用于处理FASTQ及建库试剂盒对应适配器。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: cutadapt
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


# Small RNA Preprocessing

## Codex 调用

- **选择**：请求涉及“去除小RNA接头并按长度和质量筛选”时使用；显式调用 `$omics-small-rna-seq-smrna-preprocessing`。
- **输入**：FASTQ及建库试剂盒对应适配器。
- **预期产物**：trimmed FASTQ、长度筛选和collapsed FASTA；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`cutadapt`、`matplotlib`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Adapter Trimming with Cutadapt

Small RNA libraries have specific 3' adapters that must be removed:

```bash
# Standard Illumina TruSeq small RNA adapter
cutadapt \
    -a TGGAATTCTCGGGTGCCAAGG \
    -m 18 \
    -M 30 \
    --discard-untrimmed \
    -o trimmed.fastq.gz \
    input.fastq.gz

# -a: 3' adapter sequence
# -m 18: Minimum length (miRNAs are 18-25 nt)
# -M 30: Maximum length (exclude longer fragments)
# --discard-untrimmed: Remove reads without adapter (likely not small RNA)
```

## Common Small RNA Adapters

| Kit | 3' Adapter Sequence |
|-----|---------------------|
| Illumina TruSeq | TGGAATTCTCGGGTGCCAAGG |
| NEBNext | AGATCGGAAGAGCACACGTCT |
| QIAseq | AACTGTAGGCACCATCAAT |
| Lexogen | TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC |

## Size Selection

```bash
# Filter by length after trimming
cutadapt \
    -a TGGAATTCTCGGGTGCCAAGG \
    -m 18 -M 26 \
    -o mirna_length.fastq.gz \
    input.fastq.gz

# miRNA: 18-26 nt (typically 21-23 nt)
# piRNA: 26-32 nt
# snoRNA: variable, typically longer
```

## Quality Trimming

```bash
# Trim low-quality bases from 3' end before adapter removal
cutadapt \
    -q 20 \
    -a TGGAATTCTCGGGTGCCAAGG \
    -m 18 \
    -o trimmed.fastq.gz \
    input.fastq.gz
```

## Using fastp for Small RNA

```bash
# fastp with small RNA settings
fastp \
    --in1 input.fastq.gz \
    --out1 trimmed.fastq.gz \
    --adapter_sequence TGGAATTCTCGGGTGCCAAGG \
    --length_required 18 \
    --length_limit 30 \
    --html report.html

# Note: fastp auto-detects adapters but specifying is more reliable
```

## Collapse Identical Reads

For small RNAs, collapsing identical sequences reduces computation:

```bash
# Using seqkit
seqkit rmdup -s trimmed.fastq.gz -o collapsed.fasta

# Using fastx_toolkit (legacy)
fastx_collapser -i trimmed.fastq -o collapsed.fasta
```

## Python Preprocessing

```python
import gzip
from collections import Counter

def collapse_reads(fastq_path):
    '''Collapse identical sequences and count occurrences'''
    counts = Counter()

    with gzip.open(fastq_path, 'rt') as f:
        while True:
            header = f.readline()
            if not header:
                break
            seq = f.readline().strip()
            f.readline()  # +
            f.readline()  # qual

            # Only keep reads in miRNA size range
            if 18 <= len(seq) <= 26:
                counts[seq] += 1

    return counts

# Write collapsed FASTA
def write_collapsed_fasta(counts, output_path):
    with open(output_path, 'w') as f:
        for i, (seq, count) in enumerate(counts.most_common()):
            f.write(f'>seq_{i}_x{count}\n{seq}\n')
```

## QC Metrics for Small RNA

Key metrics to check:
- Read length distribution (should peak at 21-23 nt for miRNA)
- Adapter content (high if library is good)
- Percentage of reads in target size range

```python
import matplotlib.pyplot as plt
from collections import Counter

def plot_length_distribution(fastq_path):
    lengths = Counter()
    with gzip.open(fastq_path, 'rt') as f:
        for i, line in enumerate(f):
            if i % 4 == 1:  # Sequence line
                lengths[len(line.strip())] += 1

    plt.bar(lengths.keys(), lengths.values())
    plt.xlabel('Read Length')
    plt.ylabel('Count')
    plt.title('Small RNA Length Distribution')
    plt.savefig('length_dist.png')
```

## Related Skills

- mirdeep2-analysis - Novel miRNA discovery
- mirge3-analysis - Fast miRNA quantification
- read-qc/adapter-trimming - General adapter trimming


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->