---
name: clinical-ehr-question-answering
description: 用自然语言查询和总结患者EHR记录的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: Apache-2.0
metadata:
  author: Stanford Medicine
  version: 1.0.0
  source_extensions:
    keywords:
    - EHR
    - clinical
    - summarization
    - patient-records
    - FHIR
    measurable_outcome: Answer 5 clinical queries and generate a discharge summary from a patient record with <10s latency.
    compatibility:
    - system: Python 3.10+
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


# ChatEHR

## Codex 调用

- **选择**：请求涉及“用自然语言查询和总结患者EHR记录”时使用；显式调用 `$clinical-ehr-question-answering`。
- **输入**：FHIR资源、患者标识和临床问题。
- **预期产物**：病历问答、病史摘要或出院摘要；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

AI software for clinicians to interact with patient medical records via natural language queries and automatic chart summarization.

## When to Use

*   **Rapid Review**: "Summarize the patient's cardiology history."
*   **Data Extraction**: "What was the last creatinine level?"
*   **Documentation**: Generating draft notes or discharge summaries.

## Core Capabilities

1.  **Chart Summarization**: Condense complex history into readable notes.
2.  **QA**: Answer specific questions about the patient's data.
3.  **FHIR Integration**: Works with standard FHIR resources.

## Workflow

1.  **Connect**: Authenticate with the EHR system (sandbox or secure instance).
2.  **Select Patient**: Load patient context.
3.  **Query**: Submit natural language questions.

## Example Usage

**User**: "Summarize the last 3 oncology visits."

**Agent Action**:
```bash
python -m chatehr.query --patient_id 12345 --prompt "Summarize last 3 oncology visits"
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->