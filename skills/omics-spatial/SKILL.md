---
name: omics-spatial
description: 根据空间域和差异基因提出组织机制与细胞互作假设的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# SpatialAgent

## Codex 调用

- **选择**：请求涉及“根据空间域和差异基因提出组织机制与细胞互作假设”时使用；显式调用 `$omics-spatial`。
- **输入**：已处理空间转录组、空间域注释和各域DEG列表。
- **预期产物**：知识检索摘要、配体受体线索与可检验假设；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

SpatialAgent focuses on the biological interpretation of spatial transcriptomics data, specifically aiming to propose mechanistic hypotheses about tissue organization and cellular interactions.

## When to Use This Skill

*   **Mechanistic Interpretation**: When you have clusters or spatial domains and need to understand *why* they are organized that way.
*   **Cell-Cell Interaction**: To predict and interpret ligand-receptor interactions in a spatial context.
*   **Hypothesis Generation**: To propose biological mechanisms driving the observed spatial heterogeneity.

## Core Capabilities

1.  **Tissue Organization Analysis**: Decodes the structural logic of tissues (e.g., layers, niches).
2.  **Cellular Interaction Prediction**: Identifies potential signaling pathways active at domain boundaries.
3.  **Hypothesis Proposal**: Generates testable biological hypotheses based on spatial data.

## Workflow

1.  **Input Analysis**: Accepts processed ST data (e.g., cluster annotations, DEG lists per spatial domain).
2.  **Knowledge Retrieval**: Queries biological knowledge bases regarding the observed cell types and genes.
3.  **Synthesis**: Constructs a narrative explaining the spatial arrangement (e.g., "The proximity of fibroblasts and tumor cells suggests a desmoplastic reaction mediated by TGF-beta signaling...").

## Example Usage

**User**: "Why are the macrophages located at the boundary of the tumor core in this sample?"

**Agent Action**:
1.  Analyzes the gene expression of macrophages and adjacent tumor cells.
2.  Checks for ligand-receptor pairs (e.g., CSF1-CSF1R).
3.  Proposes: "Macrophages are likely recruited by CSF1 secreted by the tumor cells, forming an immunosuppressive barrier..."


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->