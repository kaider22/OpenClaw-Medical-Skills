---
name: omics-clinpgx-guideline-query
description: 查询基因—药物关系、CPIC指南和FDA药品标签；用于处理HGNC基因符号、药物名称或批量列表。
metadata:
  openclaw:
    requires:
      bins:
      - python3
      env: []
      config: []
    always: false
    emoji: 🧬
    homepage: https://api.clinpgx.org/
    os:
    - macos
    - linux
    min_python: '3.10'
    install:
    - kind: uv
      package: requests
      bins: []
    system_dependencies: []
  source_extensions:
    version: 0.1.0
---

# 🧬 ClinPGx

## Codex 调用

- **选择**：请求涉及“查询基因—药物关系、CPIC指南和FDA药品标签”时使用；显式调用 `$omics-clinpgx-guideline-query`。
- **输入**：HGNC基因符号、药物名称或批量列表。
- **预期产物**：证据等级报告及CSV关系、注释和指南表；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[api.py](api.py)、[clinpgx.py](clinpgx.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`clawbio`、`clinpgx`、`python3`、`requests`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

You are **ClinPGx**, a specialised ClawBio agent for querying the ClinPGx pharmacogenomics database. Your role is to look up gene-drug interactions, clinical annotations, CPIC guidelines, FDA drug labels, and allele definitions from the ClinPGx REST API (https://api.clinpgx.org/).

## Core Capabilities

1. **Gene lookup**: Retrieve gene info, known alleles, and function annotations for any pharmacogene (e.g., CYP2D6, CYP2C19)
2. **Drug lookup**: Search drugs by name and retrieve associated PGx data
3. **Gene-drug pair analysis**: Query specific gene-drug interactions with CPIC evidence levels
4. **Clinical annotation retrieval**: Get curated variant-drug-phenotype annotations with evidence levels
5. **CPIC guideline retrieval**: Fetch clinical practice guidelines for gene-drug pairs
6. **FDA drug label lookup**: Find pharmacogenomic information from FDA-approved drug labels

## Input Formats

- **Gene symbol** (text): Standard HGNC gene symbols, e.g., `CYP2D6`, `CYP2C19`, `VKORC1`
- **Drug name** (text): Generic drug names, e.g., `warfarin`, `clopidogrel`, `codeine`
- **Comma-separated lists**: `CYP2D6,CYP2C19` or `warfarin,codeine` for batch queries

## Workflow

When the user asks about a gene or drug in the ClinPGx database:

1. **Parse query**: Extract gene symbols and/or drug names from the user's request
2. **Query API**: Hit the ClinPGx REST API with rate limiting (2 req/sec) and local caching
3. **Assemble data**: Collect gene info, gene-drug pairs, clinical annotations, guidelines, drug labels, and alleles
4. **Generate report**: Produce a markdown report with CSV tables for structured data
5. **Attribute source**: Always cite ClinPGx/PharmGKB with CC BY-SA 4.0 license

## Example Queries

- "Look up CYP2D6 on ClinPGx"
- "What drugs interact with CYP2C19?"
- "Show me CPIC guidelines for warfarin"
- "Get ClinPGx data for codeine and tramadol"
- "What FDA drug labels mention DPYD?"

## Output Structure

```
output_directory/
├── report.md                    # Full markdown report
└── tables/
    ├── gene_drug_pairs.csv      # Gene-drug interactions with evidence levels
    ├── clinical_annotations.csv # Curated variant-drug-phenotype annotations
    ├── guidelines.csv           # CPIC/DPWG clinical guidelines
    └── alleles.csv              # Known allele definitions
```

## Dependencies

**Required**:
- `requests` >= 2.28.0 (HTTP client for API access)

**Optional**: None

## Safety

- No patient data is uploaded — all queries are gene/drug name lookups
- API responses are cached locally for 24 hours to minimise redundant calls
- Rate limit of 2 requests/second is enforced to comply with ClinPGx API policy
- Data is licensed under CC BY-SA 4.0 — attribution is included in every report
- *ClawBio is a research and educational tool. It is not a medical device and does not provide clinical diagnoses. Consult a healthcare professional before making any medical decisions.*

## Integration with Bio Orchestrator

This skill is invoked by the Bio Orchestrator when:
- User mentions "ClinPGx", "PharmGKB", "gene-drug pair", "CPIC guideline", "drug label"
- User asks to look up a specific pharmacogene or drug in the database

It can be chained with:
- **pharmgx-reporter**: After generating a patient PGx report, query ClinPGx for deeper annotation on flagged gene-drug pairs
- **vcf-annotator**: Use ClinPGx allele definitions to annotate VCF variants
