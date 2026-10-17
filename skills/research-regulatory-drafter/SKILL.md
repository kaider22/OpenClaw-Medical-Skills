---
name: research-regulatory-drafter
description: 把研究资料整理成CTD章节草稿并链接来源的文档工作流指南。原项目脚本缺少配套组件，使用 Codex 直接整理文稿时应说明执行范围。
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



# Regulatory Drafter Skill

## Codex 调用

- **选择**：请求涉及“把研究资料整理成CTD章节草稿并链接来源”时使用；显式调用 `$research-regulatory-drafter`。
- **输入**：临床研究报告、文献PDF和目标CTD章节。
- **预期产物**：带注释、引用和审计线索的文档草稿；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 按正文目标整理有来源的文稿；这是按指南执行。旧 Python 包装器依赖未随附的原项目组件，不把启动该包装器作为 Codex 的前置条件。
- **环境核对**：`regulatory_drafter`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **外部/示例入口**：`Skills/Anthropic_Health_Stack/regulatory_drafter.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **原项目模块**：代码仍引用 `Skills.Agentic_AI.Agent_Architectures.Self_Correction.self_correction_agent`、`Skills.Anthropic_Health_Stack.regulatory_drafter`、`self_correction_agent`；选择旧代码路径前检查该分支是否有真实实现。Codex 文档工作流不自称执行了这些模块。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill assists regulatory affairs professionals by automatically generating sections of the Common Technical Document (CTD) from raw data and literature. It focuses on accuracy, traceability, and adherence to FDA/EMA guidelines.

## When to Use This Skill

*   **Drafting CTD Sections**: Automatically generate Module 2.4 (Nonclinical Overview) or Module 2.5 (Clinical Overview).
*   **Citation Management**: When you need to synthesize multiple PDFs into a coherent narrative with inline citations.
*   **Audit Trails**: When every claim must be traceable back to a source document.

## Core Capabilities

1.  **Document Synthesis**: Ingests clinical study reports (CSRs) and literature to write narrative text.
2.  **Citation Linking**: Inserts hyperlinks or references to the source material.
3.  **Style Compliance**: Adheres to eCTD formatting standards.

## Workflow

1.  **Ingest Data**: Point the agent to a folder of source PDFs/Data.
2.  **Draft**: Run the drafter with a specific section target (e.g., "Nonclinical Overview").
3.  **Review**: The agent outputs a Markdown/Word draft with annotations.

## Example Usage

**User**: "Draft the Nonclinical Overview based on the toxicology reports in ./data/tox."

**Agent Action**:
```bash
python3 Skills/Anthropic_Health_Stack/regulatory_drafter.py --input "./data/tox" --section "2.4"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->