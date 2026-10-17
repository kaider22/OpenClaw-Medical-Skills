---
name: omics-nicheformer-spatial
description: 用空间表达数据发现细胞生态位和空间邻域的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# Nicheformer Spatial Agent

## Codex 调用

- **选择**：请求涉及“用空间表达数据发现细胞生态位和空间邻域”时使用；显式调用 `$omics-nicheformer-spatial`。
- **输入**：含坐标的空间转录组、模型权重和参考图谱。
- **预期产物**：空间嵌入、生态位标签、地图和交互网络；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Genomics/Nicheformer_Spatial_Agent/nicheformer_analysis.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Nicheformer Spatial Agent** leverages the Nicheformer foundation model, trained on over 53 million spatially resolved cells, to model cellular architecture and tissue microenvironments with unprecedented accuracy. It enables spatial context-aware cell type annotation, niche discovery, and tissue organization analysis.

## When to Use This Skill

* When analyzing spatial transcriptomics requiring deep cellular context understanding.
* For identifying tissue niches and cellular neighborhoods.
* To predict cell-cell interactions based on spatial proximity.
* When transferring annotations from atlases to new spatial data.
* For studying tissue architecture and organization patterns.

## Core Capabilities

1. **Spatial Context Embeddings**: Generate embeddings that capture both gene expression and spatial context.

2. **Niche Discovery**: Identify recurrent cellular neighborhoods across tissues.

3. **Zero-Shot Cell Type Annotation**: Transfer cell type labels without retraining.

4. **Spatial Perturbation Prediction**: Predict effects of removing cell types from niches.

5. **Cross-Tissue Transfer**: Apply models trained on one tissue to another.

6. **Tissue Architecture Analysis**: Quantify spatial organization patterns.

## Model Architecture

| Component | Description | Parameters |
|-----------|-------------|------------|
| Expression Encoder | Gene expression transformer | ~100M |
| Spatial Encoder | Neighborhood graph attention | ~50M |
| Fusion Layer | Cross-attention expression + spatial | ~30M |
| Pretraining Data | 53M+ spatially resolved cells | Multi-tissue |

## Supported Spatial Technologies

| Platform | Coverage | Resolution |
|----------|----------|------------|
| 10x Xenium | Full support | Subcellular |
| MERFISH | Full support | Subcellular |
| CosMx | Full support | Subcellular |
| Visium | Supported | 55 μm spot |
| Slide-seq | Supported | 10 μm bead |
| seqFISH+ | Supported | Subcellular |
| STARmap | Supported | Subcellular |

## Workflow

1. **Input**: Spatial transcriptomics data with coordinates.

2. **Preprocessing**: Normalize, filter, construct spatial graphs.

3. **Embedding Generation**: Compute Nicheformer embeddings per cell/spot.

4. **Niche Clustering**: Identify spatial domains and niches.

5. **Annotation Transfer**: Map cell types from reference atlases.

6. **Interaction Analysis**: Predict cell-cell communication in niches.

7. **Output**: Annotated spatial data, niche assignments, interaction networks.

## Example Usage

**User**: "Use Nicheformer to identify cellular niches in this tumor spatial transcriptomics dataset."

**Agent Action**:
```bash
python3 Skills/Genomics/Nicheformer_Spatial_Agent/nicheformer_analysis.py \
    --spatial_data xenium_tumor.h5ad \
    --model_weights nicheformer_pretrained.pt \
    --k_neighbors 15 \
    --niche_resolution 0.5 \
    --reference_atlas tabula_sapiens.h5ad \
    --output tumor_niches_analysis/
```

## Niche Analysis Outputs

| Output | Description | Format |
|--------|-------------|--------|
| Cell Embeddings | Spatial-aware embeddings | .h5ad obsm |
| Niche Labels | Cluster assignments | .csv |
| Niche Signatures | Defining gene programs | .csv |
| Spatial Maps | Visualizations | .png, .pdf |
| Interaction Network | Cell-cell edges | .graphml |
| Architecture Metrics | Tissue organization scores | .json |

## Niche Types Detected

| Niche Category | Examples | Markers |
|----------------|----------|---------|
| Immune Aggregates | TLS, germinal centers | CD20, CD3, PD1 |
| Tumor Core | Hypoxic, proliferative | HIF1A, MKI67 |
| Invasion Front | EMT, matrix remodeling | VIM, MMP9 |
| Stromal | Fibroblast niches | COL1A1, ACTA2 |
| Vascular | Perivascular zones | PECAM1, VWF |
| Neural | Nerve-associated | NCAM1, NGF |

## AI/ML Components

**Foundation Model**:
- Transformer backbone with spatial attention
- Pretrained on 53M cells across tissues
- Self-supervised contrastive learning

**Spatial Graph Construction**:
- Delaunay triangulation
- k-NN with distance threshold
- Hierarchical multi-scale graphs

**Transfer Learning**:
- Zero-shot annotation via embedding similarity
- Few-shot fine-tuning for novel cell types
- Domain adaptation for new tissues

## Performance Benchmarks

| Task | Metric | Performance |
|------|--------|-------------|
| Cell Type Annotation | Accuracy | 92-96% |
| Niche Recovery | ARI | 0.85-0.92 |
| Cross-Tissue Transfer | F1 | 0.88-0.94 |
| Batch Integration | kBET | 0.90+ |

## Prerequisites

* Python 3.10+
* PyTorch 2.0+, PyTorch Geometric
* Scanpy, Squidpy
* Nicheformer pretrained weights
* GPU with 16GB+ VRAM recommended

## Related Skills

* SIMO_Multiomics_Integration_Agent - For multi-omics spatial integration
* scGPT_Agent - For single-cell foundation models
* Cell_Cell_Communication - For ligand-receptor analysis
* Spatial_Epigenomics_Agent - For spatial epigenomics

## Spatial Architecture Metrics

| Metric | Description | Interpretation |
|--------|-------------|----------------|
| Moran's I | Spatial autocorrelation | Clustering degree |
| Ripley's K | Point pattern analysis | Aggregation vs dispersion |
| Neighborhood Enrichment | Cell type co-occurrence | Preferential associations |
| Connectivity | Graph topology | Tissue organization |

## Special Considerations

1. **Gene Panel Overlap**: Ensure sufficient overlap with training data genes
2. **Tissue Context**: Model performance varies by tissue type
3. **Resolution Effects**: Aggregate for spot-based technologies
4. **GPU Memory**: Batch processing for large datasets
5. **Validation**: Compare with known tissue architecture

## Applications

| Domain | Application |
|--------|-------------|
| Oncology | Tumor microenvironment niches |
| Immunology | Tertiary lymphoid structures |
| Development | Organ patterning and morphogenesis |
| Neuroscience | Brain region architecture |
| Pathology | Disease-specific spatial signatures |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->