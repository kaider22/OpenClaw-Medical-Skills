---
name: imaging-computational-pathology
description: 读取WSI、分割组织并提取病理图像块；用于处理SVS/NDPI/TIFF切片及可选核分割模型权重。
license: MIT
metadata:
  author: MD BABU MIA, PhD
  version: 1.0.0
  source_extensions:
    keywords:
    - wsi
    - digital-pathology
    - deep-learning
    - resnet
    - openslide
    measurable_outcome: Preprocess and extract tissue patches from a 1GB+ .svs slide within 15 minutes for downstream ML tasks.
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


# Computational Pathology Agent

## Codex 调用

- **选择**：请求涉及“读取WSI、分割组织并提取病理图像块”时使用；显式调用 `$imaging-computational-pathology`。
- **输入**：SVS/NDPI/TIFF切片及可选核分割模型权重。
- **预期产物**：组织patch、核分割结果和特征向量；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[wsi_analyzer.py](wsi_analyzer.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`numpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**Version:** 1.0.0
**Author:** MD BABU MIA, PhD
**Date:** February 2026

## Overview
This agent specializes in the analysis of Whole Slide Images (WSIs) for digital pathology. It leverages Deep Learning models (ResNet, ViT, HoverNet) to perform segmentation, classification, and feature extraction from gigapixel histology images.

## Capabilities
1.  **WSI Handling:** Efficient reading/tiling of .svs, .ndpi, .tiff files (using OpenSlide/TiffSlide).
2.  **Tissue Segmentation:** Separation of tissue from background.
3.  **Patch Extraction:** Automated generation of patches for ML training/inference.
4.  **Nuclei Segmentation:** Integration with StarDist/HoverNet for cellular analysis.
5.  **Feature Extraction:** Generating feature vectors for slide-level clustering.

## Usage
```python
from Skills.Pathology_AI.Computational_Pathology_Agent.wsi_analyzer import WSIAnalyzer

# Initialize
path_agent = WSIAnalyzer(slide_path="./data/biopsy_001.svs")

# Extract tissue patches
path_agent.extract_patches(patch_size=256, level=1)

# Analyze Nuclei (requires model weights)
# path_agent.segment_nuclei()
```

## Requirements
*   openslide-python
*   opencv-python
*   pytorch
*   scikit-image

<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->