---
name: omics-cellagent-cell-annotation
description: 提供为scRNA-seq聚类生成细胞类型标签和证据的方法与调用指南；用于处理h5ad、marker列表、物种组织和参考图谱。
license: MIT
metadata:
  author: CellAgent Team
  version: 1.0.0
  source_extensions:
    keywords:
    - single-cell
    - markers
    - annotation
    - confidence
    - tissue
    measurable_outcome: Label every provided cluster with a cell type + confidence + marker evidence (or "ambiguous") within 15 minutes per dataset.
    compatibility:
    - system: Python 3.9+
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


# CellAgent Annotation

## Codex 调用

- **选择**：请求涉及“为scRNA-seq聚类生成细胞类型标签和证据”时使用；显式调用 `$omics-cellagent-cell-annotation`。
- **输入**：h5ad、marker列表、物种组织和参考图谱。
- **预期产物**：标签、置信度、marker证据和歧义标记；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Genomics/Single_Cell/CellAgent/repo/main.py`、`repo/main.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Use CellTypeAgent to interpret marker genes, annotate scRNA-seq clusters, and coordinate multi-agent workflows for downstream analysis.

## When to Use
- Automated annotation of scRNA-seq datasets without manual curation.
- Multi-step workflows (QC → clustering → annotation → DE analysis).
- Integrating multiple batches requiring consistent labeling.

## Core Capabilities
1. **Planning:** Multi-agent planner decomposes analysis goals into steps.
2. **Tool execution:** Generates Scanpy/Seurat code and runs it autonomously.
3. **Self-correction:** Detects execution errors and retries with fixes.

## Workflow
1. Gather marker lists per cluster, plus species/tissue context and optional atlas references.
2. Run CellTypeAgent (`pip install -r requirements.txt` then `python repo/main.py --data data.h5ad --goal annotate`).
3. Review outputs for supporting markers; downgrade ambiguous clusters when signals conflict.
4. Produce final table (cluster, label, confidence, supporting markers, notes) and cite references when used.

## Example Usage
```bash
python3 Skills/Genomics/Single_Cell/CellAgent/repo/main.py --data "./data.h5ad" --goal "annotate"
```

## Guardrails
- Avoid over-specific lineages if markers overlap; default to broader types.
- Flag clusters showing multiple signatures for manual review.
- Respect species/tissue differences when interpreting markers.

## References
- README + upstream paper (Mao et al., 2025 / arXiv 2407.09811).


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->