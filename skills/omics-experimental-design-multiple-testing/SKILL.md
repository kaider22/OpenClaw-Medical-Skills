---
name: omics-experimental-design-multiple-testing
description: 提供对组学p值执行BH、q-value或Bonferroni多重校正的方法与调用指南；用于处理一组原始p值、检验家族、研究类型和预设alpha。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: qvalue
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


# Multiple Testing Correction

## Codex 调用

- **选择**：请求涉及“对组学p值执行BH、q-value或Bonferroni多重校正”时使用；显式调用 `$omics-experimental-design-multiple-testing`。
- **输入**：一组原始p值、检验家族、研究类型和预设alpha。
- **预期产物**：调整后p/q值、拒绝标记及适用阈值；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`qvalue`、`statsmodels`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## The Problem

Testing 20,000 genes at p < 0.05 yields ~1,000 false positives by chance. Correction is essential.

## Common Methods

### Bonferroni (Most Conservative)

```r
# Strict family-wise error rate control
p_adj <- p.adjust(pvalues, method = 'bonferroni')
# Threshold: alpha / n_tests
# Use for: small gene sets, confirmatory studies
```

### Benjamini-Hochberg FDR (Standard)

```r
# Controls false discovery rate
p_adj <- p.adjust(pvalues, method = 'BH')
# Most common for genomics
# FDR 0.05 = expect 5% of significant results to be false
```

### q-value (Recommended for Large-Scale)

```r
library(qvalue)
qobj <- qvalue(pvalues)
qvalues <- qobj$qvalues
pi0 <- qobj$pi0  # Estimated proportion of true nulls

# q-value directly estimates FDR for each gene
# More powerful than BH when many true positives exist
```

## Method Selection Guide

| Scenario | Recommended Method | Threshold |
|----------|-------------------|-----------|
| Genome-wide DE | BH or q-value | FDR < 0.05 |
| Candidate genes | Bonferroni | p < 0.05/n |
| Exploratory | BH | FDR < 0.10 |
| Validation study | Bonferroni | p < 0.05/n |
| GWAS | Bonferroni | p < 5e-8 |

## Python Equivalent

```python
from statsmodels.stats.multitest import multipletests

# Benjamini-Hochberg
rejected, pvals_corrected, _, _ = multipletests(pvalues, method='fdr_bh')

# Bonferroni
rejected, pvals_corrected, _, _ = multipletests(pvalues, method='bonferroni')
```

## Interpreting Results

- **FDR 0.05**: Among genes called significant, ~5% are false positives
- **FDR 0.01**: More stringent, fewer false positives but more false negatives
- **padj vs qvalue**: Both estimate FDR; q-value is slightly more powerful

## Related Skills

- differential-expression/de-results - Applying corrections to DE output
- population-genetics/association-testing - GWAS significance thresholds
- pathway-analysis/go-enrichment - Correcting enrichment p-values


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->