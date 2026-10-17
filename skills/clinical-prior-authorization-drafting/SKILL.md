---
name: clinical-prior-authorization-drafting
description: 按保单条件审查临床记录并生成审批文本的文档工作流指南。原项目脚本缺少配套组件，使用 Codex 直接整理文稿时应说明执行范围。
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



# Prior Authorization Coworker

## Codex 调用

- **选择**：请求涉及“按保单条件审查临床记录并生成审批文本”时使用；显式调用 `$clinical-prior-authorization-drafting`。
- **输入**：临床记录、操作代码和政策条件。
- **预期产物**：审批决定、理由JSON、审计轨迹和申诉信；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 按正文目标整理有来源的文稿；这是按指南执行。旧 Python 包装器依赖未随附的原项目组件，不把启动该包装器作为 Codex 的前置条件。
- **原型边界**：随附代码含模拟、mock 或替代分支。运行时明确记录实际走到的分支；模拟结果不能标作真实查询、模型预测或实验验证。
- **原项目模块**：代码仍引用 `Skills.Agentic_AI.Agent_Architectures.Self_Correction.self_correction_agent`、`optimizer.meta_prompter`、`self_correction_agent`；选择旧代码路径前检查该分支是否有真实实现。Codex 文档工作流不自称执行了这些模块。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill acts as an automated utilization management reviewer. It takes unstructured clinical notes and a procedure code, compares them against internal policy criteria (e.g., conservative therapy failure), and renders a decision.

## When to Use This Skill

*   When a user asks to "review a prior auth request".
*   When checking if a patient qualifies for a specific procedure (e.g., MRI).
*   When you need to generate a structured approval/denial letter justification.

## Core Capabilities

1.  **Policy Matching**: Checks against specific criteria (e.g., "Pain > 6 weeks").
2.  **Trace Generation**: Produces an "Anthropic-style" `<thinking>` trace for auditability.
3.  **Structured Output**: Returns a JSON object with decision, reasoning, and timestamps.

## Workflow

1.  **Extract Data**: Parse the clinical note and procedure code from the user's input.
2.  **Execute Review**: Run the coworker script.
3.  **Present Decision**: Output the JSON decision and the reasoning trace.

## Example Usage

**User**: "Check if this patient qualifies for an MRI of the Lumbar Spine: Patient has had back pain for 2 months, tried PT but it didn't work."

**Agent Action**:
```bash
python3 anthropic_coworker.py --code "MRI-L-SPINE" --note "Patient has back pain > 2 months. Failed PT."
```

## Supported Policies

*   `MRI-L-SPINE` (Lumbar Spine MRI)


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->