---
name: omics-epitranscriptomics-modification-visualization
description: 提供绘制m6A元基因分布、信号轨迹和热图的方法与调用指南；用于处理m6A峰BED、IP/Input BAM、bigWig及转录注释。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: Guitar
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


# Modification Visualization

## Codex 调用

- **选择**：请求涉及“绘制m6A元基因分布、信号轨迹和热图”时使用；显式调用 `$omics-epitranscriptomics-modification-visualization`。
- **输入**：m6A峰BED、IP/Input BAM、bigWig及转录注释。
- **预期产物**：PDF元基因图、浏览器轨迹、bigBed和热图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`Guitar`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Metagene Plots with Guitar

```r
library(Guitar)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)

# Load m6A peaks
peaks <- import('m6a_peaks.bed')

# Create metagene plot
# Shows distribution relative to transcript features
GuitarPlot(
    peaks,
    txdb = TxDb.Hsapiens.UCSC.hg38.knownGene,
    saveToPDFprefix = 'm6a_metagene'
)
```

## Custom Metagene with deepTools

```bash
# Create bigWig from IP/Input ratio
bamCompare -b1 IP.bam -b2 Input.bam \
    --scaleFactors 1:1 \
    --ratio log2 \
    -o IP_over_Input.bw

# Metagene around stop codons
computeMatrix scale-regions \
    -S IP_over_Input.bw \
    -R genes.bed \
    --regionBodyLength 2000 \
    -a 500 -b 500 \
    -o matrix.gz

plotProfile -m matrix.gz -o metagene.pdf
```

## Browser Tracks

```bash
# Create normalized bigWig for genome browser
bamCoverage -b IP.bam \
    --normalizeUsing CPM \
    -o IP_normalized.bw

# Peak BED to bigBed
bedToBigBed m6a_peaks.bed chrom.sizes m6a_peaks.bb
```

## Heatmaps

```r
library(ComplexHeatmap)

# m6A signal around peaks
Heatmap(
    signal_matrix,
    name = 'm6A signal',
    cluster_rows = TRUE,
    show_row_names = FALSE
)
```

## Related Skills

- epitranscriptomics/m6a-peak-calling - Generate peaks for visualization
- data-visualization/genome-tracks - IGV, UCSC integration
- chip-seq/chipseq-visualization - Similar techniques


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->