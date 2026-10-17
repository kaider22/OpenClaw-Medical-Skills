---
name: sop-omics-biomaster-analysis
description: 编排RNA-seq、ChIP-seq、单细胞和Hi-C流程；用于处理YAML配置、原始数据、参考基因组和索引。
license: MIT
metadata:
  author: BioMaster Team
  version: 1.0.0
  source_extensions:
    keywords:
    - workflows
    - RNAseq
    - ChIPseq
    - automation
    - YAML
    measurable_outcome: Execute a configured pipeline end-to-end (including QC report + summary) within 24 hours of receiving inputs, logging every tool/parameter.
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


# BioMaster Workflows

## Codex 调用

- **选择**：请求涉及“编排RNA-seq、ChIP-seq、单细胞和Hi-C流程”时使用；显式调用 `$sop-omics-biomaster-analysis`。
- **输入**：YAML配置、原始数据、参考基因组和索引。
- **预期产物**：BAM、counts、peaks、QC报告和参数摘要；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[repo/run.py](repo/run.py)、[repo/run.sh](repo/run.sh)、[repo/runv.py](repo/runv.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`agents`、`gradio`、`langchain_core`、`yaml`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Orchestrate BioMaster’s multi-agent pipelines (RNA-seq, ChIP-seq, single-cell, Hi-C) using the provided configs and repos to deliver reproducible outputs.

## Workflow
1. **Config prep:** Populate YAML with tool paths, reference genomes, and workflow selection (`rnaseq`, `chipseq`, `singlecell`, `hic`).
2. **Environment:** `cd repo && pip install -r requirements.txt` (or container) prior to running.
3. **Launch:** `python repo/run.py --config repo/config.yaml` (or chosen config) and monitor progress.
4. **Error recovery:** Let BioMaster agents retry failing stages; review logs for missing reference/index files.
5. **Output packaging:** Collect BAMs/counts/peaks + QC + narrative summary of parameters and runtimes.

## Guardrails
- Fail fast when reference files or indices are absent to avoid wasted compute.
- Record tool versions for every stage (alignment, quantification, etc.).
- Require confirmation before deleting intermediates or rerunning destructive steps.

## References
- Full workflow descriptions, supported modalities, and repo links reside in `README.md`.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->