---
name: omics-scrna-qc
description: 用MAD和硬阈值完成scRNA细胞及基因质控过滤；用于处理h5ad、10x h5或10x目录及组织基因模式。
metadata:
  source_extensions:
    measurable_outcome: Produce filtered .h5ad files, before/after plots, and qc_summary.json within 20 minutes per dataset.
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


## At-a-Glance

## Codex 调用

- **选择**：请求涉及“用MAD和硬阈值完成scRNA细胞及基因质控过滤”时使用；显式调用 `$omics-scrna-qc`。
- **输入**：h5ad、10x h5或10x目录及组织基因模式。
- **预期产物**：过滤AnnData、前后QC图和参数摘要JSON；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[qc_core.py](qc_core.py)、[qc_analysis.py](qc_analysis.py)、[qc_plotting.py](qc_plotting.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`anndata`、`matplotlib`、`numpy`、`qc_core`、`qc_plotting`、`scanpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

- **description (10-20 chars):** QC autopilot
- **keywords:** scRNAseq, MAD, h5ad, QC, plots

## Workflow
1. Accept `.h5ad`, 10x `.h5`, or 10x directory inputs; set mitochondrial/ribosomal patterns as needed.
2. Run `qc_analysis.py` (CLI) or call `qc_core` helpers to compute metrics, apply MAD thresholds, and filter cells/genes.
3. Generate standard plots (metrics before/after, threshold overlays) plus filtered data artifacts.
4. Document parameters (mad_counts/genes/mt, mt_threshold, min_cells, log1p flag) inside the summary JSON.
5. Provide guidance on next steps (doublet detection, downstream analysis).

## Guardrails
- Adjust MT% expectations for tissue context; avoid over-filtering rare populations.
- This workflow is QC only—doublet handling and batch correction stay separate.
- Keep reproducibility by storing command invocations and environment info.

## References
- See `README.md`, `qc_core.py`, `qc_analysis.py`, and `qc_plotting.py` for API usage and schema details.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->