---
name: drug-interaction-checker
description: 检查药物相互作用并按严重度分类；用于处理药物名称列表。
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



# Drug-Drug Interaction (DDI) Checker

## Codex 调用

- **选择**：请求涉及“检查药物相互作用并按严重度分类”时使用；显式调用 `$drug-interaction-checker`。
- **输入**：药物名称列表。
- **预期产物**：相互作用、严重度和机制报告；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[impl.py](impl.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill analyzes a list of medications to identify known interactions, focusing on safety and contraindications.

## When to Use This Skill

*   Reviewing patient medication lists.
*   Prescribing new medications.
*   Pharmacovigilance monitoring.

## Core Capabilities

1.  **Interaction Detection**: Identifies pairs of drugs with known interactions.
2.  **Severity Grading**: Classifies interactions as Minor, Moderate, or Major.
3.  **Clinical Recommendations**: Provides actionable advice (e.g., "Monitor K+ levels").

## Workflow

1.  **Input**: List of drug names (e.g., "Warfarin, Aspirin").
2.  **Analysis**: Queries internal interaction database.
3.  **Output**: Interaction report with severity and mechanisms.

## Example Usage

**User**: "Check interactions for Warfarin and Aspirin."

**Agent Action**:
```bash
python3 impl.py --drugs "Warfarin, Aspirin"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->