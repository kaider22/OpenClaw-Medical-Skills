---
name: evidence-research-task-coordination
description: 并行检索文献并汇总多代理研究结果的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: Biomedical OS Team
  version: 1.0.0
  source_extensions:
    keywords:
    - research
    - literature
    - swarm
    - multi-agent
    - hypothesis
    measurable_outcome: Generates comprehensive literature review with >50 citations in <5 minutes.
    compatibility:
    - system: Python 3.10+
    allowed-tools:
    - run_shell_command
    - read_file
    - google_web_search
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


# DeepResearch Swarm

## Codex 调用

- **选择**：请求涉及“并行检索文献并汇总多代理研究结果”时使用；显式调用 `$evidence-research-task-coordination`。
- **输入**：研究主题、深度参数和文献检索工具。
- **预期产物**：综合综述和引文集合；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`src/research/agents/agent_coordinator.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

A coordinated swarm of agents designed to perform deep, parallelized research into biomedical literature, aggregating findings into comprehensive reports.

## When to Use This Skill

*   When you need an exhaustive review of a specific medical topic.
*   When connecting disparate pieces of evidence across thousands of papers.
*   When generating hypotheses based on recent literature.

## Core Capabilities

1.  **Parallel Search**: Querying multiple databases simultaneously.
2.  **Evidence Synthesis**: Combining facts into a coherent narrative.
3.  **Citation Verification**: Ensuring all claims are backed by sources.

## Example Usage

**User**: "Research the latest advancements in mRNA cancer vaccines."

**Agent Action**:
```bash
python3 src/research/agents/agent_coordinator.py --topic "mRNA cancer vaccines" --depth "deep"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->