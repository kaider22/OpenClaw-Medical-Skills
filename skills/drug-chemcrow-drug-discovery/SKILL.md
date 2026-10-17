---
name: drug-chemcrow-drug-discovery
description: 提供分子描述符、毒性警示和ADMET筛选辅助的本地原型指南；代码含模拟或替代分支，真实计算与服务结果需分别核验。
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



# ChemCrow

## Codex 调用

- **选择**：请求涉及“提供分子描述符、毒性警示和ADMET筛选辅助”时使用；显式调用 `$drug-chemcrow-drug-discovery`。
- **输入**：SMILES及筛选任务，需RDKit等化学工具。
- **预期产物**：性质、SA/PAINS/毒性提示和筛选建议；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[chem_tools.py](chem_tools.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`rdkit`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

ChemCrow is an open-source package for the accurate integration of Large Language Models (LLMs) with chemistry tools. It is designed to autonomously plan and execute chemical syntheses, research materials, and discover new drugs.

## When to Use This Skill

*   **Synthesis Planning**: "How do I synthesize Ibuprofen?"
*   **Property Prediction**: "What is the logP of this molecule?"
*   **Safety Checks**: "Is this reaction explosive?"
*   **Literature Search**: "Find patents related to this substructure."

## Core Capabilities

1.  **Synthesis Planning**: Uses tools like RXN4Chemistry or local retrosynthesis models to plan routes.
2.  **Molecule Manipulation**: Add/remove functional groups, generate SMILES (RDKit).
3.  **Safety Assessment**: Checks reagents against safety databases (PubChem, GHS).
4.  **Web Search**: Google/Patent search for chemical literature.

## Tools (Expanded List - v2.0)

*   **RDKit**: Cheminformatics (MolToSmiles, SmilesToMol, descriptors).
*   **PubChem**: Search for properties and safety data.
*   **LiteratureSearch**: Search arXiv, patents.
*   **Synthesis**: IBM RXN, OPLS.
*   **Name2SMILES**: Convert chemical names to structures.

## Example Usage

**User**: "Plan a synthesis for a derivative of Aspirin that might have better solubility."

**Agent Action**:
1.  Retrieves Aspirin structure (SMILES).
2.  Modifies structure (e.g., adds a polar group) using RDKit.
3.  Checks solubility prediction.
4.  Plans synthesis route for the new molecule.
5.  Checks safety of reagents.

<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->