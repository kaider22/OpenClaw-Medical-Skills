---
name: research-kragen-knowledge-graph
description: 用生物医学知识图谱回答多跳机制问题的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: Bioinformatics Oxford
  version: 1.0.0
  source_extensions:
    keywords:
    - knowledge-graph
    - RAG
    - reasoning
    - graph-of-thoughts
    - biomedical-qa
    measurable_outcome: Return a reasoning path and an answer supported by ≥3 knowledge graph nodes for complex biomedical questions with <5s latency.
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


# KRAGEN (Knowledge Graph Enhanced RAG)

## Codex 调用

- **选择**：请求涉及“用生物医学知识图谱回答多跳机制问题”时使用；显式调用 `$research-kragen-knowledge-graph`。
- **输入**：自然语言问题及可用知识图谱/文本索引。
- **预期产物**：推理路径、答案和图谱节点引用；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

A knowledge graph-enhanced Retrieval-Augmented Generation system for biomedical problem solving, using Graph-of-Thoughts (GoT) reasoning.

## When to Use

*   **Complex Reasoning**: Questions requiring multi-hop deduction (e.g., "How does gene A influence disease B via protein C?").
*   **Hypothesis Verification**: Checking if a proposed mechanism is supported by existing knowledge graphs.
*   **Literature Synthesis**: Combining facts from structured DBs and unstructured text.

## Core Capabilities

1.  **Graph Retrieval**: Query biomedical knowledge graphs (e.g., PrimeKG, SPOKE).
2.  **Graph-of-Thoughts**: structured reasoning over retrieved nodes.
3.  **Vector DB Integration**: Combines graph data with vector embeddings for hybrid search.

## Workflow

1.  **Input**: Natural language question.
2.  **Retrieval**: Fetch relevant sub-graph and similar text chunks.
3.  **Reasoning**: LLM traverses the graph to find connecting paths.
4.  **Answer**: Generate response with citation of graph nodes.

## Example Usage

**User**: "Explain the mechanism connecting BRCA1 mutations to ovarian cancer."

**Agent Action**:
```bash
python -m kragen.solve --question "BRCA1 mutations to ovarian cancer mechanism"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->