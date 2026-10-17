---
name: sop-omics-smrna-pipeline
description: 从小RNA测序识别miRNA差异并预测靶基因；用于处理小RNA FASTQ、基因组、成熟和发夹参考序列。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: miRDeep2
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


# Small RNA-seq Pipeline

## Codex 调用

- **选择**：请求涉及“从小RNA测序识别miRNA差异并预测靶基因”时使用；显式调用 `$sop-omics-smrna-pipeline`。
- **输入**：小RNA FASTQ、基因组、成熟和发夹参考序列。
- **预期产物**：miRNA定量、差异结果和靶基因列表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文 SOP 顺序调用所列软件，逐阶段核对输入、输出和质量检查；有分支时按当前数据选择，不把流程文档当作已完成的运行。
- **环境核对**：`miRDeep2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Pipeline Overview

```
FASTQ → cutadapt trim → miRDeep2 → Quantification → DESeq2 → Target prediction
```

## Step 1: Preprocessing

```bash
# Adapter trimming and size selection
cutadapt -a TGGAATTCTCGGGTGCCAAGG \
    --minimum-length 18 --maximum-length 30 \
    -o trimmed.fastq.gz reads.fastq.gz
```

## Step 2: miRDeep2 Analysis

```bash
# Align to genome
mapper.pl trimmed.fastq.gz -e -h -i -j -l 18 \
    -m -p genome_index -s reads_collapsed.fa \
    -t reads_collapsed_vs_genome.arf

# miRNA quantification and novel prediction
miRDeep2.pl reads_collapsed.fa genome.fa \
    reads_collapsed_vs_genome.arf \
    mature_ref.fa none hairpin_ref.fa
```

## Step 3: Differential Expression

```r
library(DESeq2)
counts <- read.csv('mirna_counts.csv', row.names = 1)
dds <- DESeqDataSetFromMatrix(counts, colData, ~condition)
dds <- DESeq(dds)
results <- results(dds)
```

## Step 4: Target Prediction

```bash
# miRanda for target prediction
miranda mature_mirnas.fa target_3utrs.fa -out targets.txt
```

## QC Checkpoints

1. **After trimming**: Size distribution should peak at 21-23nt
2. **After alignment**: >70% mapping rate expected
3. **After DE**: Check volcano plot and PCA

## Related Skills

- small-rna-seq/mirdeep2-analysis - Detailed miRDeep2
- small-rna-seq/differential-mirna - DE analysis
- small-rna-seq/target-prediction - Target analysis


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->