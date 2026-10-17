---
name: omics-read-alignment-bowtie2-alignment
description: 提供用Bowtie2将短读长比对到参考序列的方法与调用指南；用于处理参考FASTA、Bowtie2索引和单或双端FASTQ。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: bowtie2
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


# Bowtie2 Alignment

## Codex 调用

- **选择**：请求涉及“用Bowtie2将短读长比对到参考序列”时使用；显式调用 `$omics-read-alignment-bowtie2-alignment`。
- **输入**：参考FASTA、Bowtie2索引和单或双端FASTQ。
- **预期产物**：SAM/BAM比对文件及比对率统计；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`bowtie2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Build Index

```bash
# Build index from reference FASTA
bowtie2-build reference.fa reference_index

# With threads (faster)
bowtie2-build --threads 8 reference.fa reference_index

# Creates: reference_index.1.bt2, .2.bt2, .3.bt2, .4.bt2, .rev.1.bt2, .rev.2.bt2
```

## Basic Alignment

```bash
# Paired-end reads
bowtie2 -p 8 -x reference_index -1 reads_1.fq.gz -2 reads_2.fq.gz -S aligned.sam

# Single-end reads
bowtie2 -p 8 -x reference_index -U reads.fq.gz -S aligned.sam

# Direct to sorted BAM
bowtie2 -p 8 -x reference_index -1 r1.fq.gz -2 r2.fq.gz | \
    samtools sort -@ 4 -o aligned.sorted.bam -
```

## Alignment Modes

```bash
# End-to-end mode (default) - align entire read
bowtie2 --end-to-end -x index -1 r1.fq -2 r2.fq -S aligned.sam

# Local mode - soft-clip ends for better alignment
bowtie2 --local -x index -1 r1.fq -2 r2.fq -S aligned.sam
```

## Sensitivity Presets

```bash
# Very fast (less sensitive)
bowtie2 --very-fast -x index -1 r1.fq -2 r2.fq -S aligned.sam

# Fast
bowtie2 --fast -x index -1 r1.fq -2 r2.fq -S aligned.sam

# Sensitive (default)
bowtie2 --sensitive -x index -1 r1.fq -2 r2.fq -S aligned.sam

# Very sensitive (slower but more accurate)
bowtie2 --very-sensitive -x index -1 r1.fq -2 r2.fq -S aligned.sam

# Local mode equivalents
bowtie2 --very-sensitive-local -x index -1 r1.fq -2 r2.fq -S aligned.sam
```

## ChIP-seq Alignment

```bash
# Typical ChIP-seq settings
bowtie2 -p 8 \
    --very-sensitive \
    --no-mixed \
    --no-discordant \
    -x index -1 chip_1.fq.gz -2 chip_2.fq.gz | \
    samtools view -bS -q 30 -F 4 - | \
    samtools sort -o chip.sorted.bam -
```

## ATAC-seq Alignment

```bash
# ATAC-seq with size selection
bowtie2 -p 8 \
    --very-sensitive \
    -X 2000 \                    # Max fragment length
    --no-mixed \
    --no-discordant \
    -x index -1 atac_1.fq.gz -2 atac_2.fq.gz | \
    samtools view -bS -q 30 - | \
    samtools sort -o atac.sorted.bam -
```

## Fragment Size Options

```bash
# Set expected insert size range
bowtie2 -p 8 \
    -I 100 \     # Minimum fragment length
    -X 500 \     # Maximum fragment length
    -x index -1 r1.fq -2 r2.fq -S aligned.sam
```

## Read Group and Output Options

```bash
# Add read group
bowtie2 -p 8 \
    --rg-id sample1 \
    --rg SM:sample1 \
    --rg PL:ILLUMINA \
    --rg LB:lib1 \
    -x index -1 r1.fq -2 r2.fq -S aligned.sam
```

## Multi-mapping Reads

```bash
# Report up to k alignments per read
bowtie2 -k 5 -x index -1 r1.fq -2 r2.fq -S aligned.sam

# Report all alignments
bowtie2 -a -x index -1 r1.fq -2 r2.fq -S aligned.sam
```

## Output Unmapped Reads

```bash
# Write unmapped reads to separate files
bowtie2 -p 8 \
    --un-conc-gz unmapped_%.fq.gz \
    -x index -1 r1.fq.gz -2 r2.fq.gz -S aligned.sam
```

## Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| -p | 1 | Number of threads |
| -x | - | Index basename |
| -1/-2 | - | Paired-end reads |
| -U | - | Single-end reads |
| -I | 0 | Min fragment length |
| -X | 500 | Max fragment length |
| -k | 1 | Report up to k alignments |
| --no-mixed | off | Suppress unpaired alignments |
| --no-discordant | off | Suppress discordant alignments |

## Alignment Statistics

```bash
# Bowtie2 prints alignment summary to stderr
bowtie2 -p 8 -x index -1 r1.fq -2 r2.fq -S aligned.sam 2> alignment_stats.txt
```

Example output:
```
1000000 reads; of these:
  1000000 (100.00%) were paired; of these:
    50000 (5.00%) aligned concordantly 0 times
    900000 (90.00%) aligned concordantly exactly 1 time
    50000 (5.00%) aligned concordantly >1 times
95.00% overall alignment rate
```

## Related Skills

- read-qc/fastp-workflow - Preprocess reads before alignment
- alignment-files/alignment-sorting - Post-alignment processing
- chip-seq/peak-calling - ChIP-seq analysis
- atac-seq/atac-peak-calling - ATAC-seq analysis


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->