---
name: omics-read-alignment-bwa-alignment
description: 提供用BWA-MEM2将DNA短读长比对到参考基因组的方法与调用指南；用于处理参考FASTA、双或单端FASTQ和read group。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: bwa-mem2
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


# BWA-MEM2 Alignment

## Codex 调用

- **选择**：请求涉及“用BWA-MEM2将DNA短读长比对到参考基因组”时使用；显式调用 `$omics-read-alignment-bwa-alignment`。
- **输入**：参考FASTA、双或单端FASTQ和read group。
- **预期产物**：排序索引BAM及比对结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`bwa-mem2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Build Index

```bash
# Index reference genome (required once)
bwa-mem2 index reference.fa

# Creates: reference.fa.0123, reference.fa.amb, reference.fa.ann, reference.fa.bwt.2bit.64, reference.fa.pac
```

## Basic Alignment

```bash
# Paired-end reads
bwa-mem2 mem -t 8 reference.fa reads_1.fq.gz reads_2.fq.gz > aligned.sam

# Single-end reads
bwa-mem2 mem -t 8 reference.fa reads.fq.gz > aligned.sam
```

## Alignment with Read Groups

```bash
# Add read group information (required for GATK)
bwa-mem2 mem -t 8 \
    -R '@RG\tID:sample1\tSM:sample1\tPL:ILLUMINA\tLB:lib1' \
    reference.fa reads_1.fq.gz reads_2.fq.gz > aligned.sam
```

## Direct to Sorted BAM

```bash
# Pipe to samtools for sorted BAM output
bwa-mem2 mem -t 8 \
    -R '@RG\tID:sample1\tSM:sample1\tPL:ILLUMINA' \
    reference.fa reads_1.fq.gz reads_2.fq.gz | \
    samtools sort -@ 4 -o aligned.sorted.bam -

# Index the BAM
samtools index aligned.sorted.bam
```

## Mark Duplicates Pipeline

```bash
# Full pipeline: align, fixmate, sort, markdup
bwa-mem2 mem -t 8 -R '@RG\tID:sample1\tSM:sample1\tPL:ILLUMINA' \
    reference.fa reads_1.fq.gz reads_2.fq.gz | \
    samtools fixmate -m -@ 4 - - | \
    samtools sort -@ 4 - | \
    samtools markdup -@ 4 - aligned.markdup.bam

samtools index aligned.markdup.bam
```

## Common Options

```bash
bwa-mem2 mem -t 8 \         # Threads
    -M \                     # Mark shorter split hits as secondary (Picard compatible)
    -Y \                     # Use soft clipping for supplementary alignments
    -K 100000000 \           # Process INT input bases in each batch
    -R '@RG\tID:s1\tSM:s1' \ # Read group
    reference.fa r1.fq r2.fq
```

## Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| -t | 1 | Number of threads |
| -k | 19 | Minimum seed length |
| -w | 100 | Band width for extension |
| -r | 1.5 | Re-seeding trigger ratio |
| -c | 500 | Skip seeds with more than INT hits |
| -A | 1 | Match score |
| -B | 4 | Mismatch penalty |
| -O | 6 | Gap open penalty |
| -E | 1 | Gap extension penalty |
| -M | off | Mark secondary alignments |

## Output Filters

```bash
# Filter unmapped and low quality
bwa-mem2 mem -t 8 reference.fa r1.fq r2.fq | \
    samtools view -@ 4 -bS -q 20 -F 4 - | \
    samtools sort -@ 4 -o aligned.filtered.bam -
```

## Split Read Alignment

```bash
# For SV detection, use -Y for soft clipping
bwa-mem2 mem -t 8 -Y reference.fa r1.fq r2.fq > aligned.sam
```

## Memory Requirements

- Index loading: ~10GB for human genome
- Per thread: ~1-2GB
- Typical human WGS: 30-50GB RAM with 8 threads

## BWA-MEM (Alternative)

```bash
# Build index
bwa index reference.fa

# Paired-end alignment
bwa mem -t 8 reference.fa reads_1.fq.gz reads_2.fq.gz > aligned.sam

# With read groups
bwa mem -t 8 -R '@RG\tID:sample1\tSM:sample1\tPL:ILLUMINA' \
    reference.fa reads_1.fq.gz reads_2.fq.gz > aligned.sam

# Direct to sorted BAM
bwa mem -t 8 -R '@RG\tID:sample1\tSM:sample1\tPL:ILLUMINA' \
    reference.fa reads_1.fq.gz reads_2.fq.gz | \
    samtools sort -@ 4 -o aligned.sorted.bam -
```

## BWA-MEM vs BWA-MEM2

| Feature | BWA-MEM | BWA-MEM2 |
|---------|---------|----------|
| Status | Active | Archived |
| Speed | 1x | 2-3x faster |
| Index format | .bwt | .bwt.2bit.64 |
| Results | Baseline | Nearly identical |
| Memory | ~5GB | ~10GB |

## Related Skills

- read-qc/fastp-workflow - Preprocess reads before alignment
- alignment-files/alignment-sorting - Post-alignment processing
- alignment-files/duplicate-handling - Mark duplicates
- variant-calling/variant-calling - Call variants from BAM


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->