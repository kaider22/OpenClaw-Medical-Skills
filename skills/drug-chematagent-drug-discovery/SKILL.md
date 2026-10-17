---
name: drug-chematagent-drug-discovery
description: 编排分子设计、ADMET预测和逆合成的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: CheMatAgent Team
  version: 1.0.0
  source_extensions:
    keywords:
    - chemistry
    - drug-discovery
    - tools
    - synthesis
    - property-prediction
    measurable_outcome: Plan a synthesis route and predict ADMET properties for a candidate molecule with >80% validity.
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


# CheMatAgent

## Codex 调用

- **选择**：请求涉及“编排分子设计、ADMET预测和逆合成”时使用；显式调用 `$drug-chematagent-drug-discovery`。
- **输入**：候选分子及目标性质、合成约束。
- **预期产物**：候选结构、性质预测和合成路线；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

A two-tiered agent system with access to 137 Python-wrapped chemical tools for drug discovery and materials science.

## When to Use

*   **Molecule Design**: Generating novel structures with specific properties.
*   **Property Prediction**: Estimating solubility, toxicity, and bioactivity.
*   **Synthesis Planning**: Designing retro-synthetic routes.

## Core Capabilities

1.  **Tool Orchestration**: Manages a library of 137 chemical tools.
2.  **Multi-Scale Modeling**: Bridges quantum mechanics and molecular dynamics.
3.  **Lab Automation**: Generates instructions for robotic synthesis platforms.

## Workflow

1.  **Goal**: Define target property (e.g., "LogP < 5").
2.  **Design**: Generate candidates.
3.  **Filter**: Use property prediction tools.
4.  **Plan**: Output synthesis recipe.

## Example Usage

**User**: "Design a molecule similar to Aspirin but with higher solubility."

**Agent Action**:
```bash
python -m chematagent.design --scaffold "Aspirin" --objective "maximize solubility"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->