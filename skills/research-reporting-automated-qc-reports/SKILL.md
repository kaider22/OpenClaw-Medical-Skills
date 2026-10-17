---
name: research-reporting-automated-qc-reports
description: 提供用MultiQC聚合多工具指标生成标准QC报告的方法与调用指南；用于处理FastQC、比对、定量等工具结果。
metadata:
  source_extensions:
    tool_type: cli
    primary_tool: multiqc
    measurable_outcome: Execute skill workflow successfully with valid output within 15 minutes.
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


# Automated QC Reports with MultiQC

## Codex 调用

- **选择**：请求涉及“用MultiQC聚合多工具指标生成标准QC报告”时使用；显式调用 `$research-reporting-automated-qc-reports`。
- **输入**：FastQC、比对、定量等工具结果。
- **预期产物**：HTML QC报告、数据表和自定义指标；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`multiqc`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Basic Usage

```bash
# Aggregate all QC outputs in directory
multiqc results/ -o qc_report/

# Specify output name
multiqc results/ -n my_project_qc

# Include specific tools only
multiqc results/ --module fastqc --module star
```

## Supported Tools

MultiQC recognizes outputs from 100+ bioinformatics tools:

| Category | Tools |
|----------|-------|
| Read QC | FastQC, fastp, Cutadapt |
| Alignment | STAR, HISAT2, BWA, Bowtie2 |
| Quantification | featureCounts, Salmon, kallisto |
| Variant Calling | bcftools, GATK |
| Single-cell | CellRanger, STARsolo |

## Configuration

Create `multiqc_config.yaml`:

```yaml
title: "RNA-seq QC Report"
subtitle: "Project XYZ"
intro_text: "QC metrics for all samples"

# Custom sample name cleaning
extra_fn_clean_exts:
  - '.sorted'
  - '.dedup'

# Report sections to include
module_order:
  - fastqc
  - star
  - featurecounts

# Highlight samples
table_cond_formatting_rules:
  pct_mapped:
    fail: [{lt: 50}]
    warn: [{lt: 70}]
```

## Custom Data

```bash
# Add custom data file
# File format: sample\tmetric1\tmetric2
multiqc results/ --data-format tsv --custom-data-file custom_metrics.tsv
```

## Python API

```python
from multiqc import run as multiqc_run

# Run programmatically
multiqc_run(analysis_dir='results/', outdir='qc_report/')
```

## Related Skills

- read-qc/quality-reports - Generate input FastQC reports
- read-qc/fastp-workflow - Preprocessing QC
- workflows/rnaseq-to-de - Full workflow with QC


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->