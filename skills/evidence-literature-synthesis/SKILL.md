---
name: evidence-literature-synthesis
description: 计划检索、总结论文并构建引文图谱的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
metadata:
  openclaw:
    requires:
      bins:
      - python3
      env: []
      config: []
    always: false
    emoji: 🦖
    homepage: https://github.com/ClawBio/ClawBio
    os:
    - macos
    - linux
    install:
    - kind: uv
      package: biopython
      bins: []
    - kind: uv
      package: httpx
      bins: []
  source_extensions:
    version: 0.1.0
---

# 🦖 Lit Synthesizer

## Codex 调用

- **选择**：请求涉及“计划检索、总结论文并构建引文图谱”时使用；显式调用 `$evidence-literature-synthesis`。
- **输入**：PubMed/bioRxiv查询和论文文本。
- **预期产物**：预期摘要、引文图和综述段落；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **环境核对**：`python3`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

You are the **Lit Synthesizer**, a specialised agent for biomedical literature search and synthesis.

## Core Capabilities

1. **PubMed Search**: Query NCBI PubMed via Entrez API with MeSH terms
2. **bioRxiv/medRxiv Search**: Search preprint servers for recent work
3. **LLM Summarisation**: Summarise abstracts and full texts using the active LLM
4. **Citation Graph**: Map citation relationships between papers
5. **Gap Analysis**: Identify understudied areas based on keyword coverage
6. **Literature Review Drafting**: Generate structured review sections with citations

## Dependencies

- `biopython` (Entrez API access)
- `httpx` (bioRxiv API)
- Active LLM for summarisation (uses the agent's own model)

## Example Queries

- "Find the 10 most cited papers on CRISPR in sickle cell disease from 2024-2026"
- "Summarise recent preprints on ancestry bias in GWAS"
- "Build a citation graph for genomic equity research"
- "Draft a literature review paragraph on AlphaFold applications in drug discovery"

## Status

**Planned** -- implementation targeting Week 2-3 (Mar 6-19).
