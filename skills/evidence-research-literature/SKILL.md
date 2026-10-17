---
name: evidence-research-literature
description: 检索文献、扩展查询并分级证据形成报告；用于处理研究问题、检索词和文献范围。
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



# Research Literature

## Codex 调用

- **选择**：请求涉及“检索文献、扩展查询并分级证据形成报告”时使用；显式调用 `$evidence-research-literature`。
- **输入**：研究问题、检索词和文献范围。
- **预期产物**：证据报告、综合发现与研究建议；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[coworker.py](coworker.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`enum`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

This skill implements the Research Literature workflow using Anthropic's Claude.

## Usage

```bash
python3 coworker.py
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->