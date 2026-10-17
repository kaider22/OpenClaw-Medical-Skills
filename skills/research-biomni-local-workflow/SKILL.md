---
name: research-biomni-local-workflow
description: 提供调度本地Biomni工具、教程和多步生物医学流程的方法与调用指南；用于处理研究问题、数据、仓库环境和运行模式。
metadata:
  source_extensions:
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


## At-a-Glance

## Codex 调用

- **选择**：请求涉及“调度本地Biomni工具、教程和多步生物医学流程”时使用；显式调用 `$research-biomni-local-workflow`。
- **输入**：研究问题、数据、仓库环境和运行模式。
- **预期产物**：多工具分析产物、版本记录和引用摘要；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

- **description (10-20 chars):** Omni bio agent
- **keywords:** multi-tool, know-how, tutorials, protocols, databases
- **measurable_outcome:** Execute a Biomni workflow that touches ≥2 tool categories and returns a cited research summary or artifact within 15 minutes per request.

## Workflow
1. **Environment:** `cd repo && pip install .` (or follow tutorials env set up). Activate the environment with required GPUs if using heavy models.
2. **Select mode:** Choose Standard (full stack), Light (API-only), or Commercial (license-safe) per task.
3. **Plan tools:** Query the Know-How library for relevant protocols/databases before executing.
4. **Execute notebooks/scripts:** Use `repo/tutorials` or CLI entrypoints to run pipelines; log tool versions.
5. **Summarize:** Provide outputs + citations pulled from the Know-How metadata.

## Guardrails
- Respect tool/data licenses when selecting Light vs Commercial mode.
- Track provenance (tool versions, dataset snapshots) in final response.
- Keep workflows modular—reuse Biomni recipes rather than ad-hoc scripts when possible.

## References
- Full capability list, tool inventory, and tutorial notebooks documented in `README.md` and `repo/tutorials/`.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->