---
name: omics-crispr-guide-design
description: 扫描PAM、评分sgRNA并筛选候选靶点；用于处理目标序列/基因、物种基因组、Cas/PAM和变异设置。
license: MIT
metadata:
  author: CRISPR-GPT Team
  version: 1.0.0
  source_extensions:
    keywords:
    - CRISPR
    - sgRNA
    - Doench
    - off-target
    - oligos
    measurable_outcome: Return the requested number of guides (default ≥4) with efficiency + specificity scores, coordinates, and cloning oligos within 10 minutes per gene.
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


# CRISPR Design Agent

## Codex 调用

- **选择**：请求涉及“扫描PAM、评分sgRNA并筛选候选靶点”时使用；显式调用 `$omics-crispr-guide-design`。
- **输入**：目标序列/基因、物种基因组、Cas/PAM和变异设置。
- **预期产物**：候选guide、效率/特异性评分及克隆寡核苷酸；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[crispr_designer.py](crispr_designer.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Automate sgRNA selection, scoring, off-target evaluation, and oligo generation for CRISPR experiments using the documented workflow.

## When to Use
- Designing CRISPR knockout/knock-in experiments that need validated guides.
- Locating all PAM-compatible target sites in a gene or locus.
- Filtering guides by efficiency/off-target metrics before cloning.

## Core Capabilities
1. **Target discovery:** Scan sequences for PAM motifs (e.g., NGG).
2. **Efficiency scoring:** Evaluate GC content, homopolymers, Doench/DeepCRISPR/CFD scores.
3. **Filtering & ranking:** Remove risky guides (SNP overlap, off-target hits) and output the best candidates.

## Workflow
1. Resolve gene symbol + organism to canonical transcript coordinates and target region.
2. Enumerate PAM-compatible sites; extract spacers for the chosen Cas variant.
3. Score guides (efficiency + specificity) and compute GC metrics.
4. Run off-target search (≤3 mismatches) to flag problematic loci.
5. Filter/rank guides, generate cloning oligos/primers, and emit JSON/CSV outputs with coordinates.

## Example Usage
```bash
python3 crispr_designer.py \
    --sequence "ATGGAGGAGCCGCAGTCAGATCCTAGCGTCGAGCCCCCTCTGAGTCAGGAAACATTTTCAGACCTATGGAAACTGTGAGTGGATCCATTGGAAGGGC" \
    --output guides.json
```

## Guardrails
- Always state genome build and Cas variant assumptions.
- Avoid guides overlapping common SNPs when `avoid_variants` is true.
- Flag high off-target density near coding regions for manual review.

## References
- See `README.md` and `prompt.md` for detailed schema plus supporting literature.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->