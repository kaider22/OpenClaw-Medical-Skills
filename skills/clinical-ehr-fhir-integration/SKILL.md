---
name: clinical-ehr-fhir-integration
description: 从FHIR服务器检索患者和队列临床数据；用于处理FHIR R4服务器、认证信息和资源查询条件。
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



# EHR/FHIR Integration

## Codex 调用

- **选择**：请求涉及“从FHIR服务器检索患者和队列临床数据”时使用；显式调用 `$clinical-ehr-fhir-integration`。
- **输入**：FHIR R4服务器、认证信息和资源查询条件。
- **预期产物**：Patient及临床资源JSON或Pandas数据；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[fhir_client.py](fhir_client.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`fhir`、`fhirpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **EHR/FHIR Integration Skill** enables AI agents to interact with FHIR servers to search, read, and analyze clinical data.

## When to Use This Skill

*   When you need to retrieve patient demographics, conditions, medications, or lab results from an EHR.
*   When performing population health analysis on a cohort of patients.
*   When validating clinical data against the FHIR R4 standard.

## Core Capabilities

1.  **Patient Search**: Find patients by name, birthdate, or ID.
2.  **Clinical Data Retrieval**: Fetch Conditions, Observations, MedicationRequests, and Procedures.
3.  **Data Export**: Export clinical data to JSON or Pandas-ready formats.

## Workflow

1.  **Configure**: Set up the FHIR server URL and authentication (if needed).
2.  **Execute**: Run the `fhir_client.py` script with the desired resource and parameters.

## Example Usage

**User**: "Find patient John Smith born after 1980."

**Agent Action**:
```bash
python3 fhir_client.py \
    --server https://hapi.fhir.org/baseR4 \
    --resource Patient \
    --search "name=Smith&birthdate=gt1980-01-01" \
    --output patients.json
```



<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->