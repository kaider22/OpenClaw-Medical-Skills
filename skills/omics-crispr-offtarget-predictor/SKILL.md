---
name: omics-crispr-offtarget-predictor
description: 按错配和PAM预测sgRNA潜在脱靶；用于处理20nt sgRNA、PAM及参考序列库。
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



# CRISPR Off-Target Predictor

## Codex 调用

- **选择**：请求涉及“按错配和PAM预测sgRNA潜在脱靶”时使用；显式调用 `$omics-crispr-offtarget-predictor`。
- **输入**：20nt sgRNA、PAM及参考序列库。
- **预期产物**：脱靶位置、错配信息和风险分级；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[impl.py](impl.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill identifies potential off-target binding sites for a specific sgRNA sequence. It helps researchers assess the specificity of their CRISPR design.

## When to Use This Skill

*   Designing new CRISPR experiments.
*   Validating sgRNA specificity before synthesis.
*   Analyzing potential safety risks in gene editing protocols.

## Core Capabilities

1.  **Mismatch Scoring**: Calculates mismatch penalties for potential sites.
2.  **PAM Validation**: Filters targets based on PAM (Protospacer Adjacent Motif) compatibility.
3.  **Risk Assessment**: Categorizes off-targets as Low, Medium, or High risk.

## Workflow

1.  **Input**: sgRNA sequence (20nt) and PAM (e.g., NGG).
2.  **Analysis**: Scans a reference library (mocked for this version) for similar sequences.
3.  **Output**: List of potential off-targets with locations and risk scores.

## Example Usage

**User**: "Check sgRNA 'GAGTCCGAGCAGAAGAAGAA' for off-targets."

**Agent Action**:
```bash
python3 impl.py --sequence GAGTCCGAGCAGAAGAAGAA --pam NGG
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->