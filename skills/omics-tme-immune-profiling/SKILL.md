---
name: omics-tme-immune-profiling
description: 提供整合bulk、单细胞和空间数据进行肿瘤免疫微环境分型的方法与调用指南；用于处理bulk RNA、scRNA、空间数据/IHC图像及临床响应标签。
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



# TME Immune Profiling Agent

## Codex 调用

- **选择**：请求涉及“整合bulk、单细胞和空间数据进行肿瘤免疫微环境分型”时使用；显式调用 `$omics-tme-immune-profiling`。
- **输入**：bulk RNA、scRNA、空间数据/IHC图像及临床响应标签。
- **预期产物**：免疫细胞比例、TME分类、空间生态位与响应预测；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Immunology_Vaccines/TME_Immune_Profiling_Agent/tme_profiling.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **TME Immune Profiling Agent** provides comprehensive tumor microenvironment (TME) immune profiling by integrating multiple data modalities including bulk RNA-seq deconvolution, single-cell transcriptomics, spatial transcriptomics, and multiplex immunofluorescence. It enables biomarker discovery for immunotherapy response and TME-based patient stratification.

## When to Use This Skill

* When characterizing immune composition of tumor microenvironment.
* For predicting immunotherapy response from TME profiles.
* To identify immune cell states and functional programs.
* When analyzing spatial organization of immune infiltrates.
* For discovering TME-based biomarkers and therapeutic targets.

## Core Capabilities

1. **Bulk Deconvolution**: Estimate immune cell fractions from bulk RNA-seq.

2. **Single-Cell Immune Profiling**: Deep characterization of immune populations.

3. **Spatial Immune Architecture**: Map immune cell locations and neighborhoods.

4. **Immune Phenotype Classification**: Hot/cold/excluded tumor classification.

5. **Functional State Analysis**: Exhaustion, activation, memory signatures.

6. **Response Prediction**: Multi-modal immunotherapy response models.

## Immune Cell Types Profiled

| Cell Type | Subtypes | Key Markers |
|-----------|----------|-------------|
| T cells | CD8+, CD4+, Treg, Th1/2/17 | CD3, CD8, CD4, FOXP3 |
| B cells | Naive, memory, plasma | CD19, CD20, CD138 |
| NK cells | CD56bright, CD56dim | NKG7, NCAM1 |
| Macrophages | M1, M2, TAM | CD68, CD163, CD206 |
| Dendritic | cDC1, cDC2, pDC | CLEC9A, CD1C, BDCA2 |
| MDSC | M-MDSC, PMN-MDSC | CD33, CD11b, ARG1 |
| CAF | myCAF, iCAF, apCAF | FAP, ACTA2, COL1A1 |

## Deconvolution Methods

| Method | Algorithm | Cell Types | Best For |
|--------|-----------|------------|----------|
| CIBERSORTx | SVR | 22 | Gold standard |
| xCell | ssGSEA | 64 | Comprehensive |
| EPIC | Constrained regression | 8 | Tumor/stroma |
| MCP-counter | Marker genes | 10 | Robust scores |
| quanTIseq | Deconvolution | 10 | Pan-cancer |
| TIMER2.0 | Multiple | Variable | Integrated |

## Workflow

1. **Input**: Bulk RNA-seq, scRNA-seq, spatial data, or IHC images.

2. **Deconvolution**: Estimate cell fractions from bulk data.

3. **Single-Cell Analysis**: Deep immune phenotyping if available.

4. **Spatial Mapping**: Localize immune populations in tissue.

5. **Integration**: Combine modalities for comprehensive profile.

6. **Classification**: Assign TME phenotype (hot/cold/excluded).

7. **Output**: Immune profiles, visualizations, response predictions.

## Example Usage

**User**: "Profile the tumor microenvironment of this lung cancer cohort to identify immunotherapy responders."

**Agent Action**:
```bash
python3 Skills/Immunology_Vaccines/TME_Immune_Profiling_Agent/tme_profiling.py \
    --bulk_rna expression_matrix.tsv \
    --scRNA_data scRNA_lung.h5ad \
    --spatial_data visium_tumor.h5ad \
    --cancer_type nsclc \
    --deconvolution_methods cibersortx,epic,mcpcounter \
    --response_labels clinical_response.csv \
    --output tme_profiles/
```

## TME Phenotypes

| Phenotype | Characteristics | Immunotherapy Response |
|-----------|-----------------|----------------------|
| Immune Hot | High TIL infiltration, PD-L1+ | Favorable |
| Immune Cold | Low TIL, low inflammation | Poor |
| Immune Excluded | TILs at margin, not penetrating | Intermediate |
| Immune Suppressed | TILs + MDSCs/Tregs | Variable |

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| Cell Fractions | Per-sample immune estimates | .csv |
| TME Classification | Hot/cold/excluded labels | .csv |
| Immune Scores | Composite signatures | .csv |
| Spatial Maps | Cell type locations | .h5ad |
| Neighborhood Analysis | Immune niches | .csv |
| Response Prediction | IO probability | .json |
| Visualizations | Deconvolution plots | .png, .pdf |

## Immune Signatures

| Signature | Genes | Interpretation |
|-----------|-------|----------------|
| Cytotoxic | PRF1, GZMB, GNLY | T cell killing |
| Exhaustion | PDCD1, LAG3, HAVCR2, TIGIT | T cell dysfunction |
| IFN-gamma | IFNG, STAT1, IRF1 | Inflammation |
| TLS | CD20, CD4, BCL6 | Tertiary lymphoid |
| Exclusion | TGFB1, FAP, COL1A1 | Stromal barrier |

## AI/ML Components

**Deconvolution Enhancement**:
- Deep learning deconvolution
- Multi-method ensemble
- Single-cell reference optimization

**Response Prediction**:
- Multi-modal fusion (bulk + spatial)
- Survival analysis integration
- Transfer learning across cancers

**Spatial Analysis**:
- Graph neural networks for niches
- Attention for region importance
- Cell-cell interaction networks

## Clinical Applications

| Application | TME Feature | Clinical Decision |
|-------------|-------------|-------------------|
| IO Selection | Immune hot phenotype | Prioritize IO |
| Combination | Cold + excluded | Consider combo |
| Prognosis | TLS presence | Favorable outcome |
| Biomarker | CD8+ density | Response prediction |
| Resistance | MDSC enrichment | Address suppression |

## Performance Benchmarks

| Task | Dataset | Performance |
|------|---------|-------------|
| IO Response | NSCLC | AUC 0.78 |
| IO Response | Melanoma | AUC 0.82 |
| TME Classification | Pan-cancer | Accuracy 85% |
| Survival | TCGA | C-index 0.72 |

## Prerequisites

* Python 3.10+
* CIBERSORTx, EPIC, xCell
* Scanpy, Squidpy
* PyTorch for deep learning
* R for certain deconvolution methods

## Related Skills

* TCR_Repertoire_Analysis_Agent - T cell specificity
* TCell_Exhaustion_Analysis_Agent - Exhaustion phenotyping
* Spatial_Epigenomics_Agent - Spatial analysis
* Nicheformer_Spatial_Agent - Spatial foundation models

## Spatial Immune Metrics

| Metric | Definition | Clinical Relevance |
|--------|------------|-------------------|
| Immune Distance | Distance to tumor edge | Exclusion |
| Clustering Coefficient | Immune aggregation | TLS formation |
| CD8/Treg Ratio | Spatial ratio | Effector balance |
| Contact Score | Immune-tumor contacts | Direct killing |
| Neighborhood Entropy | Mixing vs segregation | TME organization |

## Special Considerations

1. **Reference Panel**: Use cancer-type specific references
2. **Batch Correction**: Normalize across samples/platforms
3. **Purity Effects**: Account for tumor purity in deconvolution
4. **Single-Cell Validation**: Validate bulk estimates with scRNA
5. **Spatial Context**: Bulk loses spatial information

## Therapeutic Implications

| TME State | Therapeutic Strategy |
|-----------|---------------------|
| Hot, PD-L1+ | Anti-PD-1/PD-L1 |
| Cold | Oncolytic virus, radiation, chemo |
| Excluded | TGF-beta inhibition, VEGF targeting |
| Suppressed | Treg depletion, MDSC targeting |
| TLS+ | Excellent IO candidate |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->