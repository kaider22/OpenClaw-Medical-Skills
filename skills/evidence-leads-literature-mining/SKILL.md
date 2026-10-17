---
name: evidence-leads-literature-mining
description: 自动筛选、提取和综合文献证据的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: CC-BY-4.0
metadata:
  author: Nature Communications 2025
  version: 1.0.0
  source_extensions:
    keywords:
    - literature-mining
    - systematic-review
    - meta-analysis
    - pubmed
    - evidence-synthesis
    measurable_outcome: Complete a systematic review screen of 100+ papers with >90% inclusion/exclusion accuracy compared to human baseline.
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


# LEADS (Literature Mining Agent)

## Codex 调用

- **选择**：请求涉及“自动筛选、提取和综合文献证据”时使用；显式调用 `$evidence-leads-literature-mining`。
- **输入**：检索主题、PICO标准和全文文献。
- **预期产物**：预期筛选结果、证据表和PRISMA流程；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

A specialized LLM agent for automating systematic reviews and meta-analyses, capable of high-accuracy study selection and data extraction.

## When to Use

*   **Systematic Reviews**: Screening thousands of abstracts for inclusion criteria.
*   **Data Extraction**: Pulling specific metrics (e.g., hazard ratios, sample sizes) from full-text PDFs.
*   **Evidence Synthesis**: Aggregating findings across multiple studies.

## Core Capabilities

1.  **Study Selection**: Automated screening based on PICO criteria.
2.  **Data Extraction**: Structured extraction of study characteristics and results.
3.  **Quality Assessment**: Risk of bias evaluation.

## Workflow

1.  **Search**: Query PubMed/Embase.
2.  **Screen**: Apply inclusion/exclusion criteria to abstracts.
3.  **Extract**: Parse full text for data points.
4.  **Report**: Generate PRISMA flow diagram and evidence table.

## Example Usage

**User**: "Perform a systematic review on the efficacy of CAR-T in solid tumors."

**Agent Action**:
```bash
python -m leads.review --topic "CAR-T solid tumors" --criteria ./criteria.json
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->