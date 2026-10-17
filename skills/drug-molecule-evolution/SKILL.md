---
name: drug-molecule-evolution
description: 生成分子改造候选并记录演化过程的本地原型指南；代码含模拟或替代分支，真实计算与服务结果需分别核验。
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



# Molecule Evolution Agent

## Codex 调用

- **选择**：请求涉及“生成分子改造候选并记录演化过程”时使用；显式调用 `$drug-molecule-evolution`。
- **输入**：种子分子、靶蛋白名和迭代代数。
- **预期产物**：候选SMILES与分子演化历史；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[evolution_agent.py](evolution_agent.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`adapters`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Molecule Evolution Agent** acts as an autonomous medicinal chemist. It takes a starting molecule (or uses a default like Aspirin) and iteratively modifies its structure to optimize binding for a specific protein target.

## When to Use This Skill

*   **Lead Optimization**: When you have a hit molecule and want to improve its potency.
*   **De Novo Design**: To explore chemical space around a target protein.
*   **Idea Generation**: To get creative structural modifications suggested by an LLM.

## Core Capabilities

1.  **SMILES Manipulation**: Reads and writes chemical structures in SMILES format.
2.  **LLM Chemist**: Uses an LLM to suggest chemically valid modifications (e.g., "Add a fluorine group to the ring").
3.  **Mock Scoring**: (Currently) Uses a mock scoring function to simulate docking affinity.

## Workflow

1.  **Input**: Target Protein Name (e.g., "GPRC5D").
2.  **Process**: 
    *   Start with a seed molecule.
    *   Loop for *N* generations.
    *   Ask LLM for a modification.
    *   Score the new molecule.
    *   Keep the best candidate.
3.  **Output**: Top candidate SMILES and the evolution history.

## Example Usage

**User**: "Design a better binder for GPRC5D."

**Agent Action**:
```bash
python3 evolution_agent.py
# (Note: The script currently defaults to GPRC5D, but can be extended for arguments)
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->