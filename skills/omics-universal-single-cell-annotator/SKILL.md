---
name: omics-universal-single-cell-annotator
description: 为AnnData单细胞数据进行标记基因或CellTypist注释的本地原型指南；代码含模拟或替代分支，真实计算与服务结果需分别核验。
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



# Universal Single-Cell Annotator

## Codex 调用

- **选择**：请求涉及“为AnnData单细胞数据进行标记基因或CellTypist注释”时使用；显式调用 `$omics-universal-single-cell-annotator`。
- **输入**：AnnData对象、标记基因列表或CellTypist模型。
- **预期产物**：adata.obs细胞类型列及群体标记结果；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[universal_annotator.py](universal_annotator.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`celltypist`、`numpy`、`pandas`、`scanpy`、`universal_annotator`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill wraps multiple cell type annotation strategies into a single Python class. It allows agents to flexibly choose between rule-based (markers), data-driven (CellTypist), or reasoning-based (LLM) approaches depending on the context.

## When to Use This Skill

*   **Initial Analysis**: When processing raw AnnData objects.
*   **Validation**: When cross-referencing automated labels with known markers.
*   **Discovery**: When identifying rare cell types using LLM reasoning on marker lists.

## Core Capabilities

1.  **Marker-Based Scoring**: Scores cells based on provided gene lists (e.g., "T-cell": ["CD3D", "CD3E"]).
2.  **Deep Learning Reference**: Wraps `celltypist` to transfer labels from massive atlases.
3.  **LLM Reasoning**: Extracts top markers per cluster and constructs prompts for LLM interpretation.

## Workflow

1.  **Load Data**: Ensure data is in `AnnData` format (standard for Scanpy).
2.  **Choose Strategy**:
    *   Use **Markers** if you have a known gene panel.
    *   Use **CellTypist** for broad immune/tissue profiling.
    *   Use **LLM** for novel clusters.
3.  **Annotate**: Run the corresponding method.
4.  **Inspect**: Check `adata.obs` for the new annotation columns.

## Example Usage

**User**: "Annotate this dataset looking for T-cells and B-cells."

**Agent Action**:
```python
from universal_annotator import UniversalAnnotator
import scanpy as sc

adata = sc.read_h5ad('data.h5ad')
annotator = UniversalAnnotator(adata)

markers = {
    'T-cell': ['CD3D', 'CD3E', 'CD8A'],
    'B-cell': ['CD79A', 'MS4A1']
}

annotator.annotate_marker_based(markers)
# Results in adata.obs['predicted_cell_type']
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->