---
name: omics-varcadd-pathogenicity
description: 按所述流程为VCF变异生成致病性分数的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: Non-Commercial
metadata:
  author: Genome Medicine 2025
  version: 1.0.0
  source_extensions:
    keywords:
    - variant-interpretation
    - CADD
    - pathogenicity
    - genomics
    - prediction
    measurable_outcome: Return pathogenicity scores for a VCF of 1000 variants within 2 minutes, flagging top 1% deleterious hits.
    compatibility:
    - system: Python 3.9+
    allowed-tools:
    - run_shell_command
    - read_file
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


# varCADD (Variant Pathogenicity Predictor)

## Codex 调用

- **选择**：请求涉及“按所述流程为VCF变异生成致病性分数”时使用；显式调用 `$omics-varcadd-pathogenicity`。
- **输入**：VCF文件和待设定的分数阈值。
- **预期产物**：带分数的VCF或排序变异表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Genome-wide pathogenicity prediction leveraging standing variation data to improve accuracy over traditional CADD scores.

## When to Use

*   **Variant Prioritization**: Ranking candidate variants in rare disease cases.
*   **VUS Interpretation**: Assessing variants of uncertain significance.
*   **Research**: Annotating novel variants in population studies.

## Core Capabilities

1.  **Score Generation**: Calculate C-scores for SNVs and indels.
2.  **Annotation**: Add functional context (conservation, protein domains).
3.  **Filtering**: Identify likely pathogenic variants based on thresholds.

## Workflow

1.  **Input**: VCF file.
2.  **Annotate**: Run varCADD model.
3.  **Filter**: Keep variants with Score > X.
4.  **Output**: Annotated VCF or ranked table.

## Example Usage

**User**: "Score these variants from patient X."

**Agent Action**:
```bash
varcadd score --input patient.vcf --output scored.vcf
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->