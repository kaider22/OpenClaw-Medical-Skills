---
name: clinical-radiology-report-explanation
description: 将影像报告改写为患者可懂的说明的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: Stanford Medicine
  version: 1.0.0
  source_extensions:
    keywords:
    - radiology
    - report-generation
    - patient-friendly
    - summarization
    - explanation
    measurable_outcome: Generate a patient-friendly explanation of a radiology report with <1% hallucination rate within 30 seconds.
    compatibility:
    - system: Python 3.9+
    allowed-tools:
    - run_shell_command
    - read_file
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


# RadGPT (Radiology Report Assistant)

## Codex 调用

- **选择**：请求涉及“将影像报告改写为患者可懂的说明”时使用；显式调用 `$clinical-radiology-report-explanation`。
- **输入**：原始放射学报告文本。
- **预期产物**：结构化摘要、关键发现和问答说明；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

An LLM-based agent designed to summarize and explain complex radiology reports for patients and clinicians.

## When to Use

*   **Patient Communication**: Converting technical findings into plain language.
*   **Clinician Review**: Highlighting critical findings (e.g., "Pneumothorax detected").
*   **Follow-up**: Suggesting appropriate next steps based on findings.

## Core Capabilities

1.  **Simplification**: Translates "bilateral opacity" to "cloudiness in both lungs".
2.  **Entity Extraction**: Identifies key anatomical structures and pathologies.
3.  **Q&A**: Answers follow-up questions about the report.

## Workflow

1.  **Input**: Raw text of the radiology report.
2.  **Process**: LLM summarizes and identifies key findings.
3.  **Output**: Structured summary or conversational explanation.

## Example Usage

**User**: "Explain this chest X-ray report to the patient."

**Agent Action**:
```bash
python -m radgpt.explain --report ./report.txt --target_audience patient
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->