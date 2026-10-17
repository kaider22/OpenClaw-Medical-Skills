---
name: omics-protein-structure-prediction
description: 从氨基酸序列预测三维蛋白结构；用于处理FASTA氨基酸序列。
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



# Protein Structure Prediction (ESMFold/AF3)

## Codex 调用

- **选择**：请求涉及“从氨基酸序列预测三维蛋白结构”时使用；显式调用 `$omics-protein-structure-prediction`。
- **输入**：FASTA氨基酸序列。
- **预期产物**：PDB坐标和逐残基pLDDT指标；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[esmfold_client.py](esmfold_client.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Protein Structure Prediction Skill** provides an interface to state-of-the-art folding models. It takes an amino acid sequence and returns a PDB file or structure metrics (pLDDT).

## When to Use This Skill

*   When you have a protein sequence and need its 3D coordinates.
*   To check if a designed sequence folds into a stable structure.
*   To prepare a receptor for docking simulations.

## Core Capabilities

1.  **Folding**: Generates atomic coordinates (PDB format).
2.  **Confidence Scoring**: Returns pLDDT scores per residue.
3.  **Visualization**: (Optional) Generates a static view of the structure.

## Workflow

1.  **Input**: Amino acid sequence (FASTA string).
2.  **Process**: Sends sequence to ESMFold API (or local inference).
3.  **Output**: Saves `.pdb` file and returns confidence metrics.

## Example Usage

**User**: "Fold this sequence: MKTIIALSY..."

**Agent Action**:
```bash
python3 esmfold_client.py \
    --sequence "MKTIIALSYIFCLVFDYDY" \
    --output structure.pdb
```



<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->