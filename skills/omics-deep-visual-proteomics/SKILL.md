---
name: omics-deep-visual-proteomics
description: 提供关联组织图像表型、激光切割和质谱蛋白组的方法与调用指南；用于处理组织图像、分割模型、LMD坐标和MaxQuant/DIA-NN结果。
metadata:
  source_extensions:
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



# Deep Visual Proteomics Agent

## Codex 调用

- **选择**：请求涉及“关联组织图像表型、激光切割和质谱蛋白组”时使用；显式调用 `$omics-deep-visual-proteomics`。
- **输入**：组织图像、分割模型、LMD坐标和MaxQuant/DIA-NN结果。
- **预期产物**：空间蛋白图、表型关联、通路和候选标志物；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Proteomics/Deep_Visual_Proteomics_Agent/dvp_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Deep Visual Proteomics Agent** implements the Deep Visual Proteomics (DVP) workflow that combines AI-driven image analysis of cellular phenotypes with automated laser microdissection and ultra-high-sensitivity mass spectrometry. It links protein abundance to complex cellular or subcellular phenotypes while preserving spatial context.

## When to Use This Skill

* When studying spatially-resolved protein expression in tissue sections.
* To link single-cell morphological phenotypes to proteome profiles.
* For identifying cell-type specific protein signatures in heterogeneous tissues.
* When analyzing subcellular proteome compartmentalization.
* To discover spatially-restricted biomarkers in tumor microenvironments.

## Core Capabilities

1. **AI Image Segmentation**: Deep learning models segment cells and identify phenotypes from brightfield, H&E, or immunofluorescence images.

2. **Phenotype Classification**: CNN/transformer classifiers identify cell types, disease states, and morphological abnormalities.

3. **LMD Coordinate Generation**: Automated generation of laser microdissection coordinates for cells of interest.

4. **MS Data Integration**: Processes MaxQuant/DIA-NN output to link protein abundances to spatial coordinates.

5. **Spatial Proteome Mapping**: Creates spatially-resolved proteome maps linking morphology to molecular profiles.

6. **Biologically-Informed Analysis**: Neural networks incorporating pathway knowledge for interpretable biomarker discovery.

## DVP Workflow

```
Tissue Section
     ↓
[AI Image Analysis] → Cell Segmentation → Phenotype Classification
     ↓
[Region Selection] → LMD Coordinates → Automated Microdissection
     ↓
[Sample Processing] → Low-input LC-MS/MS → Proteome Quantification
     ↓
[Data Integration] → Spatial Proteome Map → Pathway Analysis
```

## Example Usage

**User**: "Identify tumor vs. stroma cells in this H&E image and generate proteome profiles for each population."

**Agent Action**:
```bash
python3 Skills/Proteomics/Deep_Visual_Proteomics_Agent/dvp_analyzer.py \
    --image tissue_section.tiff \
    --segmentation cellpose \
    --classifier tumor_stroma_cnn \
    --generate_lmd true \
    --ms_data maxquant_output/ \
    --analysis differential \
    --output dvp_results/
```

## Key Components

| Component | Tool/Method | Description |
|-----------|-------------|-------------|
| Segmentation | Cellpose, StarDist | Instance segmentation of cells |
| Classification | Custom CNN/ViT | Phenotype assignment |
| LMD Interface | Leica LMD7, PALM | Coordinate export formats |
| MS Processing | MaxQuant, DIA-NN | Protein quantification |
| Integration | Custom Python | Spatial mapping |

## Analysis Outputs

1. **Spatial Protein Maps**: Protein abundance overlaid on tissue coordinates
2. **Phenotype-Proteome Links**: Proteins enriched in specific cell types
3. **Pathway Activation**: Spatial patterns of pathway activity
4. **Differential Analysis**: Comparison between regions/phenotypes
5. **Biomarker Candidates**: Spatially-restricted markers

## Biologically-Informed Neural Networks (BINNs)

The agent implements BINNs that integrate:
- A priori knowledge of protein-pathway relationships
- Sparse neural network architecture mirroring biological networks
- Enhanced interpretability for clinical applications
- Validated in septic AKI, COVID-19, and ARDS cohorts

```
Input: Protein abundances
  ↓
Pathway Layer: Proteins → Pathways (sparse connections)
  ↓
Process Layer: Pathways → Biological processes
  ↓
Output: Phenotype classification + pathway importance scores
```

## Prerequisites

* Python 3.10+
* PyTorch with vision models
* Cellpose/StarDist for segmentation
* MS data processing tools
* GPU recommended for image analysis

## Related Skills

* Pathology_AI - For histopathology analysis
* Proteomics_MS - For standard proteomics workflows
* Spatial_Transcriptomics - For complementary spatial RNA

## Applications

1. **Tumor Heterogeneity**: Map proteome across tumor microenvironment regions
2. **Single-Cell Resolution**: Proteome profiles of rare cell populations
3. **Disease Mechanisms**: Link morphological changes to molecular drivers
4. **Drug Response**: Spatial patterns of treatment response

## Technical Specifications

**Sensitivity**: 100-500 cells per sample for robust quantification
**Throughput**: 1,000-5,000 proteins per sample
**Resolution**: Single-cell to ~10-cell resolution
**Formats**: TIFF/SVS images, MaxQuant/DIA-NN output

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->