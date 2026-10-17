---
name: omics-variant-interpretation-acmg
description: 按ACMG证据码汇总并生成变异分类报告；用于处理VCF或基因、HGVS、后果及证据码。
metadata:
  source_extensions:
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



# Variant Interpretation (ACMG)

## Codex 调用

- **选择**：请求涉及“按ACMG证据码汇总并生成变异分类报告”时使用；显式调用 `$omics-variant-interpretation-acmg`。
- **输入**：VCF或基因、HGVS、后果及证据码。
- **预期产物**：致病性分级、证据权重和解释报告；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[acmg_classifier.py](acmg_classifier.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`adapters`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **原项目模块**：代码仍引用 `optimizer.meta_prompter`；选择旧代码路径前检查该分支是否有真实实现。Codex 文档工作流不自称执行了这些模块。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Variant Interpretation Skill** automates the classification of genetic variants (Pathogenic, Benign, VUS) using a rules-based engine derived from ACMG guidelines.

## When to Use This Skill

*   When analyzing a VCF file for clinical reporting.
*   To determine the clinical significance of a specific mutation (e.g., BRCA1 c.123A>G).
*   To aggregate evidence (population freq, computational predictions) into a final verdict.

## Core Capabilities

1.  **Rule Scoring**: Applies codes like PVS1 (Null variant), PM2 (Rare), PP3 (In silico).
2.  **Classification**: Combines scores to reach a verdict (Pathogenic, Likely Pathogenic, VUS, etc.).
3.  **Explanation**: Provides the logic/evidence used for the classification.

## Workflow

1.  **Input**: Variant details (Gene, HGVS, Consequence) or Evidence codes directly.
2.  **Process**: Sums weights of applied ACMG criteria.
3.  **Output**: Final classification and score breakdown.

## Example Usage

**User**: "Classify a variant with evidence PVS1 and PM2."

**Agent Action**:
```bash
python3 acmg_classifier.py \
    --evidence "PVS1,PM2"
```



<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->