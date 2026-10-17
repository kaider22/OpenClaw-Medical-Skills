---
name: omics-clip-seq-binding-site-annotation
description: 将CLIP结合位点归入UTR、CDS和其他转录特征的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: ChIPseeker
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


# Binding Site Annotation

## Codex 调用

- **选择**：请求涉及“将CLIP结合位点归入UTR、CDS和其他转录特征”时使用；显式调用 `$omics-clip-seq-binding-site-annotation`。
- **输入**：CLIP峰BED、TxDb/GTF或功能区BED。
- **预期产物**：特征交集、注释分类和分布图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **环境核对**：`ChIPseeker`、`pandas`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Using ChIPseeker (R)

```r
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)

txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

peaks <- readPeakFile('peaks.bed')
anno <- annotatePeak(peaks, TxDb = txdb)

plotAnnoPie(anno)
```

## Using BEDTools

```bash
# Annotate to UTRs
bedtools intersect -a peaks.bed -b 3utr.bed -wa -wb > peaks_3utr.bed
```

## Python Annotation

```python
import pandas as pd

def annotate_peaks(peaks_bed, annotation_gtf):
    '''Annotate peaks to genomic features'''
    # Load peaks and annotations
    # Intersect and categorize
    pass
```

## Related Skills

- clip-peak-calling - Get peaks
- genome-intervals/interval-arithmetic - Intersect peaks with genomic features


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->