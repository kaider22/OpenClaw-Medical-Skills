---
name: omics-single-cell-interactive-exploration
description: 交互探索单细胞表达、聚类和标记基因；用于处理h5ad单细胞数据及自然语言查询。
license: MIT
metadata:
  author: CompBioAgent Team
  version: 1.0.0
  source_extensions:
    keywords:
    - single-cell
    - visualization
    - web-app
    - cellxgene
    - exploration
    measurable_outcome: Launch a local web instance for interactive scRNA-seq exploration and generate 3+ custom visualizations per session.
    compatibility:
    - system: Python 3.9+
    allowed-tools:
    - run_shell_command
    - web_fetch
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


# CompBioAgent (Single-Cell Explorer)

## Codex 调用

- **选择**：请求涉及“交互探索单细胞表达、聚类和标记基因”时使用；显式调用 `$omics-single-cell-interactive-exploration`。
- **输入**：h5ad单细胞数据及自然语言查询。
- **预期产物**：本地交互页面、表达图和探索结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：使用正文明确的 API/服务协议，通过当前可用的 HTTP、终端或已配置连接器执行。先确认端点、凭据和访问范围；不假定存在专用 MCP 工具。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

An LLM-powered web application for single-cell RNA-seq data exploration, integrating with CellDepot and Cellxgene VIP.

## When to Use

*   **Interactive Exploration**: When you need to visually explore a dataset without writing code.
*   **Hypothesis Generation**: Quickly checking expression of specific markers across clusters.
*   **Sharing**: Presenting data to non-computational collaborators.

## Core Capabilities

1.  **Natural Language Querying**: "Show me the expression of TP53 in the B-cell cluster."
2.  **Cellxgene Integration**: Leverages robust visualization tools.
3.  **Data Integration**: Connects with CellDepot for dataset retrieval.

## Workflow

1.  **Setup**: `pip install compbioagent`.
2.  **Launch**: `compbioagent start --data ./data.h5ad`.
3.  **Interact**: Open the local URL (e.g., http://localhost:8050) and chat with the agent to generate plots.

## Example Usage

**User**: "Launch the explorer for my kidney dataset."

**Agent Action**:
```bash
compbioagent launch --port 8080 --data ./kidney_atlas.h5ad
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->