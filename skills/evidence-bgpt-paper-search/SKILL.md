---
name: evidence-bgpt-paper-search
description: 检索论文并抽取方法、样本量和定量结果；用于处理科研问题、检索词和BGPT MCP配置。
license: MIT
metadata:
  skill-author: BGPT
  website: https://bgpt.pro/mcp
  github: https://github.com/connerlambden/bgpt-mcp
  source_extensions:
    allowed-tools: Bash
---

# BGPT Paper Search

## Codex 调用

- **选择**：请求涉及“检索论文并抽取方法、样本量和定量结果”时使用；显式调用 `$evidence-bgpt-paper-search`。
- **输入**：科研问题、检索词和BGPT MCP配置。
- **预期产物**：含DOI的结构化证据表与质量字段；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：使用正文明确的 API/服务协议，通过当前可用的 HTTP、终端或已配置连接器执行。先确认端点、凭据和访问范围；不假定存在专用 MCP 工具。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview

BGPT is a remote MCP server that searches a curated database of scientific papers built from raw experimental data extracted from full-text studies. Unlike traditional literature databases that return titles and abstracts, BGPT returns structured data from the actual paper content — methods, quantitative results, sample sizes, quality assessments, and 25+ metadata fields per paper.

## When to Use This Skill

Use this skill when:
- Searching for scientific papers with specific experimental details
- Conducting systematic or scoping literature reviews
- Finding quantitative results, sample sizes, or effect sizes across studies
- Comparing methodologies used in different studies
- Looking for papers with quality scores or evidence grading
- Needing structured data from full-text papers (not just abstracts)
- Building evidence tables for meta-analyses or clinical guidelines

## Setup

BGPT is a remote MCP server — no local installation required.

### Claude Desktop / Claude Code

Add to your MCP configuration:

```json
{
  "mcpServers": {
    "bgpt": {
      "command": "npx",
      "args": ["mcp-remote", "https://bgpt.pro/mcp/sse"]
    }
  }
}
```

### npm (alternative)

```bash
npx bgpt-mcp
```

## Usage

Once configured, use the `search_papers` tool provided by the BGPT MCP server:

```
Search for papers about: "CRISPR gene editing efficiency in human cells"
```

The server returns structured results including:
- **Title, authors, journal, year, DOI**
- **Methods**: Experimental techniques, models, protocols
- **Results**: Key findings with quantitative data
- **Sample sizes**: Number of subjects/samples
- **Quality scores**: Study quality assessments
- **Conclusions**: Author conclusions and implications

## Pricing

- **Free tier**: 50 searches per network, no API key required
- **Paid**: $0.01 per result with an API key from [bgpt.pro/mcp](https://bgpt.pro/mcp)

## Complementary Skills

Pairs well with:
- `literature-review` — Use BGPT to gather structured data, then synthesize with literature-review workflows
- `pubmed-database` — Use PubMed for broad searches, BGPT for deep experimental data
- `biorxiv-database` — Combine preprint discovery with full-text data extraction
- `citation-management` — Manage citations from BGPT search results
