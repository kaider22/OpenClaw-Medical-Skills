---
name: omics-spatial-transcriptomics
description: 运行空间转录组质控、聚类、SVG检测与报告生成；用于处理Visium/Xenium表达数据、H&E图像和样本元数据。
license: MIT
metadata:
  author: LiuLab
  version: 1.0.0
  source_extensions:
    keywords:
    - spatial
    - h5ad
    - H&E
    - clustering
    - SVG
    measurable_outcome: For each sample, deliver ≥1 spatial domain map + SVG list + narrative interpretation within 30 minutes.
    compatibility:
    - system: Python 3.9+
    allowed-tools:
    - run_shell_command
    - read_file
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


# Spatial Transcriptomics Agent

## Codex 调用

- **选择**：请求涉及“运行空间转录组质控、聚类、SVG检测与报告生成”时使用；显式调用 `$omics-spatial-transcriptomics`。
- **输入**：Visium/Xenium表达数据、H&E图像和样本元数据。
- **预期产物**：空间域图、SVG表、QC参数及文献支持报告；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[st_agent_wrapper.py](st_agent_wrapper.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **外部/示例入口**：`repo/src/main.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Run STAgent to align histology images with expression matrices, perform clustering/SVG detection, and generate literature-backed spatial reports.

## When to Use
- Analysis of Visium/Xenium or similar ST datasets.
- Visual reasoning over spatial plots, H&E images, or cluster maps.
- Automatically generating Scanpy/Squidpy code for new ST workflows.
- Hypothesis generation about spatial gene expression patterns.

## Core Capabilities
1. **Dynamic code generation:** Create/execute Python scripts for QC, clustering, SVG detection.
2. **Visual reasoning:** Interpret spatial plots to identify tissue domains and cell neighborhoods.
3. **Literature retrieval:** Pull references that contextualize findings.
4. **Report generation:** Deliver publication-style writeups with plots and SVG tables.

## Workflow
1. **Env setup:** `conda env create -f environment.yml && conda activate STAgent`.
2. **Data prep:** Supply `expression_path` (`.h5ad`/Spaceranger) + `image_path` (H&E/IF) and metadata.
3. **Task selection:** Choose tasks such as `cluster`, `find_svg`, `annotate_domains`, or composite instructions; run `python repo/src/main.py --data_path ... --task "..."`.
4. **Execute & interpret:** Let STAgent generate scripts, run analyses, and interpret results with literature references.
5. **Package outputs:** Save UMAP/spatial plots, SVG tables, QC details, and summary markdown.

## Example Usage
```text
User: "Analyze this breast cancer ST dataset, find immune infiltrates."
Agent: loads data, runs `sqidpy.gr.spatial_neighbors`, computes Leiden clusters, plots marker genes (CD3D, CD19), and summarizes which clusters map to tumor core vs. stromal/immune zones.
```

## Guardrails
- Document coordinate systems and any scaling between imaging and expression coordinates.
- Avoid definitive cell-type labels without supporting markers.
- Capture QC parameters for reproducibility.

## References
- Source repo: https://github.com/LiuLab-Bioelectronics-Harvard/STAgent
- See local `README.md` for detailed instructions.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->