---
name: omics-mcpmed-bioinformatics-server
description: 通过MCP查询GEO、STRING和Cell Browser的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
license: MIT
metadata:
  author: Artificial Intelligence Group
  version: 1.0.0
  source_extensions:
    compatibility:
    - system: Python 3.10+
    allowed-tools:
    - run_shell_command
---

# MCPmed Bioinformatics Web Services

## Codex 调用

- **选择**：请求涉及“通过MCP查询GEO、STRING和Cell Browser”时使用；显式调用 `$omics-mcpmed-bioinformatics-server`。
- **输入**：基因、GEO数据集或单细胞查询参数。
- **预期产物**：预期元数据、互作网络或细胞浏览数据；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Adapts the Model Context Protocol (MCP) to bioinformatics web server backends. This creates a standardized, machine-actionable layer for LLMs to interact with external biological resources, matching the 2026 standard for agentic tools.

## When to Use This Skill

*   "Query STRING database for protein-protein interactions via MCP"
*   "Fetch dataset metadata from GEO using MCPmed"
*   "Access UCSC Cell Browser data through MCP"

## Core Capabilities

1.  **GEO Integration**: Search and retrieve Gene Expression Omnibus metadata autonomously.
2.  **STRING DB Access**: Query protein-protein interaction networks contextually.
3.  **UCSC Cell Browser**: Programmatic access to single-cell datasets.

## Workflow

1.  **Step 1**: Start the MCPmed server to expose the bioinformatics backend tools.
2.  **Step 2**: Connect the LLM client using MCP to query the integrated databases.

## Example Usage

**User**: "Query the STRING database for interactions with TP53."

**Agent Action**:
```bash
python3 -m mcpmed.cli query string --gene TP53
```
