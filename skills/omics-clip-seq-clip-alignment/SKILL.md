---
name: omics-clip-seq-clip-alignment
description: 提供比对CLIP reads并进行UMI去重的方法与调用指南；用于处理trimmed CLIP FASTQ、STAR/Bowtie2索引和UMI信息。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: STAR
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


# CLIP-seq Alignment

## Codex 调用

- **选择**：请求涉及“比对CLIP reads并进行UMI去重”时使用；显式调用 `$omics-clip-seq-clip-alignment`。
- **输入**：trimmed CLIP FASTQ、STAR/Bowtie2索引和UMI信息。
- **预期产物**：坐标排序、索引及去重BAM；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`STAR`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## STAR Alignment

```bash
STAR --runMode alignReads \
    --genomeDir STAR_index \
    --readFilesIn trimmed.fq.gz \
    --readFilesCommand zcat \
    --outFilterMultimapNmax 1 \
    --outFilterMismatchNmax 1 \
    --alignEndsType EndToEnd \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix clip_
```

## Bowtie2 Alternative

```bash
bowtie2 -x genome_index \
    -U trimmed.fq.gz \
    --very-sensitive \
    -p 8 \
    | samtools view -bS - \
    | samtools sort -o aligned.bam
```

## Post-Alignment Processing

```bash
# Index
samtools index aligned.bam

# Deduplicate with UMIs
umi_tools dedup \
    --stdin=aligned.bam \
    --stdout=deduped.bam
```

## Related Skills

- clip-preprocessing - Prepare reads
- clip-peak-calling - Call peaks


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->