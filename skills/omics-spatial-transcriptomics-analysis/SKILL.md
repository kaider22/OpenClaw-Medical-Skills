---
name: omics-spatial-transcriptomics-analysis
description: 加载Visium/Xenium数据并执行QC、SVG检测与空间绘图；用于处理Spaceranger目录或空间数据路径、目标基因及输出路径。
license: MIT
metadata:
  author: MD BABU MIA, PhD
  version: 1.0.0
  source_extensions:
    keywords:
    - spatial-transcriptomics
    - visium
    - xenium
    - scanpy
    - squidpy
    measurable_outcome: Process a Visium dataset, identify spatially variable genes, and generate spatial feature plots within 30 minutes.
    compatibility:
    - system: python 3.9+
    allowed-tools:
    - run_shell_command
    - read_file
    - write_file
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


# Spatial Transcriptomics Skill

## Codex 调用

- **选择**：请求涉及“加载Visium/Xenium数据并执行QC、SVG检测与空间绘图”时使用；显式调用 `$omics-spatial-transcriptomics-analysis`。
- **输入**：Spaceranger目录或空间数据路径、目标基因及输出路径。
- **预期产物**：预处理AnnData、空间变异基因和表达叠加图；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[spatial_analyzer.py](spatial_analyzer.py)、[STAgent/st_agent_wrapper.py](STAgent/st_agent_wrapper.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`matplotlib`、`numpy`、`pandas`、`scanpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**Version:** 1.0.0
**Author:** MD BABU MIA, PhD
**Date:** February 2026

## Overview
This skill provides automated analysis capabilities for Spatial Transcriptomics data, specifically designed for 10x Visium and Xenium platforms. It enables the integration of histological data with gene expression profiles to uncover spatial organization of cell types.

## Capabilities
1.  **Data Loading:** Supports Spaceranger output (h5, images).
2.  **QC & Preprocessing:** Spatial QC metrics, normalization.
3.  **Spatial Variable Features:** Identification of spatially variable genes (SVGs) using Moran's I and Geary's C.
4.  **Deconvolution:** Interface for cell type deconvolution (mapping scRNA-seq to spatial).
5.  **Visualization:** Interactive spatial plots overlaying gene expression on tissue images.

## Usage
```python
from Skills.Genomics.Spatial_Transcriptomics.spatial_analyzer import SpatialAnalyzer

# Initialize
sa = SpatialAnalyzer(data_path="./data/visium_sample1")

# Run Pipeline
sa.load_data()
sa.preprocess()
sa.find_spatial_features()
sa.plot_spatial("INS", save_path="./output/insulin_spatial.png")
```

## Requirements
*   scanpy
*   squidpy
*   anndata
*   matplotlib

<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->