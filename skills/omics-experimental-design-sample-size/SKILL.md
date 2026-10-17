---
name: omics-experimental-design-sample-size
description: 提供按预期DE效应和先验数据估计各组样本量的方法与调用指南；用于处理基因数、先验分散度、效应、FDR、power或pilot数据。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: ssizeRNA
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


# Sample Size Estimation

## Codex 调用

- **选择**：请求涉及“按预期DE效应和先验数据估计各组样本量”时使用；显式调用 `$omics-experimental-design-sample-size`。
- **输入**：基因数、先验分散度、效应、FDR、power或pilot数据。
- **预期产物**：每组样本量、分散度估计或单细胞模拟power；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`ssizeRNA`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## RNA-seq Sample Size

```r
library(ssizeRNA)

# Estimate sample size for RNA-seq
# m = total genes, m1 = expected DE genes
# fc = fold change, fdr = target FDR
result <- ssizeRNA_single(nGenes = 20000, pi0 = 0.9, m = 200,
                          mu = 10, disp = 0.1, fc = 2,
                          fdr = 0.05, power = 0.8)
result$ssize  # Required n per group
```

## DESeq2-based Estimation

```r
library(DESeq2)

# From pilot data
dds_pilot <- DESeqDataSetFromMatrix(pilot_counts, colData, ~condition)
dds_pilot <- DESeq(dds_pilot)

# Extract dispersion estimates for power calculation
dispersions <- mcols(dds_pilot)$dispGeneEst
median_disp <- median(dispersions, na.rm = TRUE)
# Use median_disp in power calculations
```

## Single-cell Sample Size

```r
library(powsimR)

# Estimate for scRNA-seq
# Accounts for dropout and cell-to-cell variability
params <- estimateParam(pilot_sce)
power <- simulateDE(params, n1 = 100, n2 = 100,
                    p.DE = 0.1, pLFC = 1)
```

## Sample Size by Assay Type

| Assay | Min Recommended | For Small Effects |
|-------|-----------------|-------------------|
| Bulk RNA-seq | 3 | 6-12 |
| scRNA-seq | 3 samples, 1000 cells | 6+ samples |
| ATAC-seq | 2 | 4-6 |
| ChIP-seq | 2 | 3-4 |
| Proteomics | 3 | 6-10 |
| Methylation | 4 | 8-12 |

## Budget Optimization

When resources are limited, prioritize:
1. Biological replicates over technical replicates
2. More samples over deeper sequencing (after ~20M reads for RNA-seq)
3. Balanced designs (equal n per group)

## Related Skills

- experimental-design/power-analysis - Power calculations
- experimental-design/batch-design - Optimal batch assignment
- single-cell/preprocessing - scRNA-seq experimental design


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->