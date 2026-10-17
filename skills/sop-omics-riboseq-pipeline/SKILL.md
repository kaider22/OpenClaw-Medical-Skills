---
name: sop-omics-riboseq-pipeline
description: 从Ribo-seq读段估计翻译效率并寻找ORF；用于处理Ribo/RNA BAM、注释GTF和P-site校准数据。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: Plastid
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


# Ribo-seq Pipeline

## Codex 调用

- **选择**：请求涉及“从Ribo-seq读段估计翻译效率并寻找ORF”时使用；显式调用 `$sop-omics-riboseq-pipeline`。
- **输入**：Ribo/RNA BAM、注释GTF和P-site校准数据。
- **预期产物**：P-site偏移、TE表和ORF列表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文 SOP 顺序调用所列软件，逐阶段核对输入、输出和质量检查；有分支时按当前数据选择，不把流程文档当作已完成的运行。
- **环境核对**：`Plastid`、`numpy`、`plastid`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Pipeline Overview

```
FASTQ → Preprocessing → rRNA removal → Alignment → P-site → TE → ORF calling
```

## Step 1: Preprocessing

```bash
# Remove adapters
cutadapt -a CTGTAGGCACCATCAAT \
    --minimum-length 25 --maximum-length 35 \
    -o trimmed.fastq.gz reads.fastq.gz

# Remove rRNA
bowtie2 -x rRNA_index --un non_rrna.fastq.gz -U trimmed.fastq.gz
```

## Step 2: Alignment

```bash
# Align to transcriptome
STAR --genomeDir star_index \
    --readFilesIn non_rrna.fastq.gz \
    --readFilesCommand zcat \
    --outFilterMismatchNmax 2 \
    --alignEndsType EndToEnd \
    --outSAMtype BAM SortedByCoordinate
```

## Step 3: P-site Calibration

```python
from plastid import BAMGenomeArray

# Build metagene profile
metagene_generate annotation.gtf ribo.bam metagene_output/

# Calculate P-site offsets
psite annotation.gtf metagene_output/profile.txt psite_offsets.txt
```

## Step 4: Translation Efficiency

```python
# TE = Ribo-seq RPKM / RNA-seq RPKM
from plastid import BAMGenomeArray
import numpy as np

ribo_counts = count_reads(ribo_bam, genes)
rna_counts = count_reads(rna_bam, genes)
te = ribo_counts / rna_counts
```

## Step 5: ORF Detection

```bash
# RiboCode for ORF calling
RiboCode -a annotation.gtf -c config.txt -o ribocoded_orfs
```

## Related Skills

- ribo-seq/ - Individual Ribo-seq analysis skills
- differential-expression - For differential TE


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->