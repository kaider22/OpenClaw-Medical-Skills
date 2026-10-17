---
name: research-biokernel-task-routing
description: 负责多代理任务路由、上下文和MCP资源管理的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: Biomedical OS Team
  version: 1.0.0
  source_extensions:
    keywords:
    - kernel
    - os
    - mcp
    - api
    - system
    measurable_outcome: Routes 100% of API requests to correct sub-agent with <200ms latency.
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


# BioKernel

## Codex 调用

- **选择**：请求涉及“负责多代理任务路由、上下文和MCP资源管理”时使用；显式调用 `$research-biokernel-task-routing`。
- **输入**：用户查询、会话状态和子代理配置。
- **预期产物**：路由结果、会话状态及MCP调用入口；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`platform/biokernel/server.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The BioKernel is the central orchestration layer of the Biomedical OS, managing context, routing tasks to specialized agents via MCP (Model Context Protocol), and handling system resources.

## When to Use This Skill

*   **System Internal**: This is primarily a background skill for routing.
*   When initializing the Biomedical OS environment.
*   When managing state across multiple agent interactions.

## Core Capabilities

1.  **Task Routing**: Dispatches user queries to the correct specialist agent.
2.  **Context Management**: Maintains long-term memory and session state.
3.  **MCP Server**: Exposes tools and resources via standard protocol.

## Example Usage

**User**: "Start the BioKernel server."

**Agent Action**:
```bash
python3 platform/biokernel/server.py --port 8000
```


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->