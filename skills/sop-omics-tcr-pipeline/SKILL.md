---
name: sop-omics-tcr-pipeline
description: 从TCR/BCR测序构建克隆型并分析多样性；用于处理TCR/BCR FASTQ、物种和文库类型。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: MiXCR
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


# TCR/BCR Analysis Pipeline

## Codex 调用

- **选择**：请求涉及“从TCR/BCR测序构建克隆型并分析多样性”时使用；显式调用 `$sop-omics-tcr-pipeline`。
- **输入**：TCR/BCR FASTQ、物种和文库类型。
- **预期产物**：克隆型表、多样性、样本重叠和V/J图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文 SOP 顺序调用所列软件，逐阶段核对输入、输出和质量检查；有分支时按当前数据选择，不把流程文档当作已完成的运行。
- **环境核对**：`MiXCR`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Pipeline Overview

```
FASTQ → MiXCR align → Assemble → Export → VDJtools diversity → Visualization
```

## Step 1: MiXCR Processing

```bash
# Align reads to V(D)J segments
mixcr align -s hsa -p rna-seq \
    R1.fastq.gz R2.fastq.gz \
    aligned.vdjca

# Assemble clonotypes
mixcr assemble aligned.vdjca clones.clns

# Export
mixcr exportClones clones.clns clones.txt
```

## Step 2: VDJtools Analysis

```bash
# Convert to VDJtools format
vdjtools Convert -S mixcr clones.txt vdjtools/

# Diversity metrics
vdjtools CalcDiversityStats vdjtools/clones.txt diversity/

# Sample overlap
vdjtools CalcPairwiseDistances vdjtools/*.txt overlap/
```

## Step 3: Visualization

```bash
# Spectratype plot
vdjtools PlotFancySpectratype vdjtools/clones.txt spectra/

# V usage
vdjtools PlotFancyVJUsage vdjtools/clones.txt usage/
```

## QC Checkpoints

1. **After alignment**: Check V/J assignment rate (>70% typical)
2. **After assembly**: Verify clonotype count and coverage
3. **After diversity**: Compare metrics to expected range

## Related Skills

- tcr-bcr-analysis/mixcr-analysis - Detailed MiXCR usage
- tcr-bcr-analysis/vdjtools-analysis - Diversity metrics
- tcr-bcr-analysis/repertoire-visualization - Plots


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->