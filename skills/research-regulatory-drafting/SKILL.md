---
name: research-regulatory-drafting
description: 整理医疗监管提交章节草稿与来源证据的文档工作流指南。原项目脚本缺少配套组件，使用 Codex 直接整理文稿时应说明执行范围。
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



# Regulatory Drafting

## Codex 调用

- **选择**：请求涉及“整理医疗监管提交章节草稿与来源证据”时使用；显式调用 `$research-regulatory-drafting`。
- **输入**：提交章节、临床研究资料、适用指导文件及可选文风要求。
- **预期产物**：标明来源、缺失信息与人工复核项的监管章节草稿；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 按正文目标整理有来源的文稿；这是按指南执行。旧 Python 包装器依赖未随附的原项目组件，不把启动该包装器作为 Codex 的前置条件。
- **原项目模块**：代码仍引用 `Skills.Agentic_AI.Agent_Architectures.Self_Correction.self_correction_agent`、`optimizer.meta_prompter`、`self_correction_agent`；选择旧代码路径前检查该分支是否有真实实现。Codex 文档工作流不自称执行了这些模块。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill implements the Regulatory Drafting workflow using Anthropic's Claude.

## Usage

```bash
python3 coworker.py
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->