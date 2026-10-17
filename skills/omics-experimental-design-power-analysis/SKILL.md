---
name: omics-experimental-design-power-analysis
description: 提供估算RNA-seq/ATAC-seq研究的检验功效与样本量的方法与调用指南；用于处理测序深度、CV、效应大小、alpha、目标power和ATAC参数。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: RNASeqPower
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


# Power Analysis for Sequencing Experiments

## Codex 调用

- **选择**：请求涉及“估算RNA-seq/ATAC-seq研究的检验功效与样本量”时使用；显式调用 `$omics-experimental-design-power-analysis`。
- **输入**：测序深度、CV、效应大小、alpha、目标power和ATAC参数。
- **预期产物**：给定样本量的power或达到目标power的样本量；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`RNASeqPower`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Core Concept

Power = probability of detecting a true effect. Underpowered studies waste resources; overpowered studies are inefficient.

## RNA-seq Power Analysis

```r
library(RNASeqPower)

# Typical parameters
# - depth: sequencing depth per sample (reads/gene)
# - cv: biological coefficient of variation (0.1-0.4 typical)
# - effect: fold change to detect (1.5 = 50% change)
# - alpha: significance level (0.05 standard)

# Calculate power for given sample size
rnapower(depth = 20, n = 3, cv = 0.4, effect = 2, alpha = 0.05)

# Calculate required samples for target power
rnapower(depth = 20, cv = 0.4, effect = 2, alpha = 0.05, power = 0.8)
```

## CV Guidelines

| Experiment Type | Typical CV | Notes |
|-----------------|------------|-------|
| Cell lines | 0.1-0.2 | Low variability |
| Inbred mice | 0.2-0.3 | Moderate |
| Human samples | 0.3-0.5 | High variability |
| Primary cells | 0.3-0.4 | Donor-dependent |

## ATAC-seq Power (ssizeRNA)

```r
library(ssizeRNA)

# For differential accessibility
size.zhao(m = 10000, m1 = 500, fc = 2, fdr = 0.05, power = 0.8,
          mu = 10, disp = 0.1)
```

## Quick Reference

| Effect Size | Recommended n (CV=0.4) |
|-------------|------------------------|
| 4-fold | 3 per group |
| 2-fold | 5-6 per group |
| 1.5-fold | 10-12 per group |
| 1.25-fold | 20+ per group |

## Related Skills

- experimental-design/sample-size - Detailed sample size calculations
- experimental-design/batch-design - Accounting for batch effects in design
- differential-expression/deseq2-basics - Running the actual DE analysis


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->