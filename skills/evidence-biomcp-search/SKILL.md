---
name: evidence-biomcp-search
description: 通过MCP统一检索文献、试验、变异和实体注释；用于处理MCP客户端、检索词、实体或变异标识。
license: MIT
metadata:
  author: BioMCP Team
  version: 1.0.0
  source_extensions:
    keywords:
    - MCP
    - PubMed
    - ClinicalTrials
    - server
    - uv
    measurable_outcome: Stand up a working BioMCP endpoint (pip or uv) and return ≥1 PubMed + ≥1 ClinicalTrials.gov response to the client within 10 minutes.
    compatibility:
    - system: MCP-compliant clients
    allowed-tools:
    - web_fetch
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


# BioMCP Server

## Codex 调用

- **选择**：请求涉及“通过MCP统一检索文献、试验、变异和实体注释”时使用；显式调用 `$evidence-biomcp-search`。
- **输入**：MCP客户端、检索词、实体或变异标识。
- **预期产物**：文献、试验、注释及变异查询结果；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[bio_mcp_server.py](bio_mcp_server.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Deploy and operate the BioMCP server so MCP-compatible clients (Claude Desktop, LobeChat, etc.) can query biomedical databases via a single standardized interface.

## When to Use
- Unified literature search (PubMed/PMC) inside MCP clients.
- Entity normalization via PubTator3 or genomic variant lookups.
- ClinicalTrials.gov queries without bespoke API wrappers.

## Core Capabilities
1. **PubMed/PMC search:** Execute complex literature queries.
2. **PubTator3 annotations:** Map text to genes, diseases, chemicals, species.
3. **ClinicalTrials.gov:** Retrieve trial metadata/protocols.
4. **Genomic variant lookups:** Fetch variant/gene summaries from connected sources.

## Deployment Workflow
1. **Install deps:** `cd repo && uv sync` (preferred) or `pip install .`.
2. **Run server:** `python -m biomcp.server` or `make run`; Docker Compose provided.
3. **Configure client:** Add command/args snippet from `README.md` into MCP client config (Claude Desktop, BioKernel, etc.).
4. **Test tools:** Invoke PubMed + ClinicalTrials + variant endpoints to ensure connectivity.
5. **Monitor:** Capture logs, rate-limit statuses, and data-source versions for audit.

## Guardrails
- Keep API keys/env secrets outside the repo.
- Respect upstream rate limits to avoid throttling or bans.
- Document which data sources are enabled per deployment and update when they change.

## References
- Source repo + configuration examples in `README.md`, `repo/docker-compose.yml`, and `repo/Makefile`.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->