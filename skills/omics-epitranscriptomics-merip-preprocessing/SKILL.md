---
name: omics-epitranscriptomics-merip-preprocessing
description: 提供比对并质控MeRIP-seq的IP/Input样本的方法与调用指南；用于处理IP/Input FASTQ、参考基因组、GTF和样本重复。
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


# MeRIP-seq Preprocessing

## Codex 调用

- **选择**：请求涉及“比对并质控MeRIP-seq的IP/Input样本”时使用；显式调用 `$omics-epitranscriptomics-merip-preprocessing`。
- **输入**：IP/Input FASTQ、参考基因组、GTF和样本重复。
- **预期产物**：坐标排序BAM、索引、flagstat和重复相关性图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`STAR`、`deeptools`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Alignment with STAR

```bash
# Build index (once)
STAR --runMode genomeGenerate \
    --genomeDir star_index \
    --genomeFastaFiles genome.fa \
    --sjdbGTFfile genes.gtf

# Align IP and input samples
for sample in IP_rep1 IP_rep2 Input_rep1 Input_rep2; do
    STAR --genomeDir star_index \
        --readFilesIn ${sample}_R1.fastq.gz ${sample}_R2.fastq.gz \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate \
        --outFileNamePrefix ${sample}_
done
```

## QC Metrics

```bash
# Index BAMs
for bam in *Aligned.sortedByCoord.out.bam; do
    samtools index $bam
done

# Check IP enrichment
# Good MeRIP: IP should have peaks, input should be uniform
samtools flagstat IP_rep1_Aligned.sortedByCoord.out.bam
```

## IP/Input Correlation

```python
import deeptools.plotCorrelation as pc

# Check replicate correlation
multiBamSummary bins \
    -b IP_rep1.bam IP_rep2.bam Input_rep1.bam Input_rep2.bam \
    -o results.npz

plotCorrelation -in results.npz \
    --corMethod spearman \
    -o correlation.png
```

## Related Skills

- read-qc/quality-reports - Raw read quality assessment
- read-alignment/star-alignment - General alignment concepts
- m6a-peak-calling - Next step after preprocessing


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->