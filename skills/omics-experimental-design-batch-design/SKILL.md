---
name: omics-experimental-design-batch-design
description: 提供规划平衡随机的批次布局，降低条件与批次混杂的方法与调用指南；用于处理样本条件/协变量、批次数、批次容量和对照信息。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: sva
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


# Batch Design and Mitigation

## Codex 调用

- **选择**：请求涉及“规划平衡随机的批次布局，降低条件与批次混杂”时使用；显式调用 `$omics-experimental-design-batch-design`。
- **输入**：样本条件/协变量、批次数、批次容量和对照信息。
- **预期产物**：样本分配表、批次平衡方案和需记录的设计因素；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`sva`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Core Principle

Batch effects are unavoidable. Good design makes them correctable.

## Design Rules

1. **Never confound batch with condition** - Each batch must contain all conditions
2. **Balance samples across batches** - Equal numbers per condition per batch
3. **Randomize within constraints** - Avoid systematic patterns
4. **Include controls** - Same samples across batches if possible

## Balanced Design Example

```r
# BAD: Confounded design
# Batch 1: All treated samples
# Batch 2: All control samples
# -> Cannot separate batch from treatment

# GOOD: Balanced design
# Batch 1: 3 treated, 3 control
# Batch 2: 3 treated, 3 control
# -> Batch effect can be estimated and removed
```

## Sample Assignment

```r
library(designit)

# Create balanced assignment
samples <- data.frame(
  sample_id = paste0('S', 1:24),
  condition = rep(c('ctrl', 'treat'), each = 12),
  sex = rep(c('M', 'F'), 12)
)

# Optimize batch assignment
batch_design <- osat(samples, batch_size = 8,
                     balance_cols = c('condition', 'sex'))
```

## Detecting Batch Effects

```r
library(sva)

# From count matrix
mod <- model.matrix(~condition, colData)
mod0 <- model.matrix(~1, colData)

# Estimate number of surrogate variables (hidden batches)
n_sv <- num.sv(counts_normalized, mod)

# Estimate surrogate variables
svobj <- sva(counts_normalized, mod, mod0, n.sv = n_sv)
```

## Correction Methods

| Method | When to Use |
|--------|-------------|
| ComBat | Known batches, moderate effects |
| SVA | Unknown batches, exploratory |
| RUVseq | Using control genes |
| limma::removeBatchEffect | Visualization only |

## Documenting Design

Always record:
- Date of sample processing
- Reagent lot numbers
- Operator
- Equipment/lane assignments
- Any deviations from protocol

## Related Skills

- experimental-design/power-analysis - Account for batch in power calculations
- differential-expression/batch-correction - Correcting batch effects in analysis
- single-cell/batch-integration - scRNA-seq batch correction


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->