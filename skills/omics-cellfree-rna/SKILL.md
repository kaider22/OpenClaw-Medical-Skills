---
name: omics-cellfree-rna
description: 分析cfRNA并推断组织来源、癌症分数和标志物的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# Cell-Free RNA Analysis Agent

## Codex 调用

- **选择**：请求涉及“分析cfRNA并推断组织来源、癌症分数和标志物”时使用；显式调用 `$omics-cellfree-rna`。
- **输入**：血浆cfRNA测序、参考基因组和组织图谱。
- **预期产物**：QC、组织组成、癌症分数和RNA标志物；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Genomics/CellFree_RNA_Agent/cfrna_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Cell-Free RNA Analysis Agent** provides comprehensive analysis of circulating cell-free RNA (cfRNA) from plasma and other biofluids for cancer detection, tissue-of-origin identification, and non-invasive transcriptomic profiling.

## When to Use This Skill

* When analyzing plasma cfRNA for cancer detection and monitoring.
* To identify tissue-of-origin from circulating transcripts.
* For non-invasive transcriptomic profiling of tumors.
* When integrating cfRNA with cfDNA for comprehensive liquid biopsy.
* To discover RNA-based biomarkers from accessible biofluids.

## Core Capabilities

1. **cfRNA Profiling**: Quantify mRNA, lncRNA, and small RNA from plasma.

2. **Tissue Deconvolution**: Identify tissue sources contributing to cfRNA pool.

3. **Cancer Detection**: ML models detecting cancer from cfRNA profiles.

4. **Tumor Transcriptomics**: Infer tumor gene expression non-invasively.

5. **Integration with cfDNA**: Combine RNA and DNA liquid biopsy analytes.

6. **Biomarker Discovery**: Identify diagnostic and prognostic RNA markers.

## cfRNA Biology

**Sources**:
- Cell death (apoptosis, necrosis)
- Active secretion (EVs, RNA-binding proteins)
- Cell surface-associated RNA

**Protection Mechanisms**:
- Extracellular vesicles
- Protein complexes (AGO2, NPM1)
- Lipoproteins

**Half-life**: Minutes to hours (shorter than cfDNA)

## Workflow

1. **Input**: Plasma cfRNA sequencing data (total RNA, small RNA, or targeted).

2. **Quality Control**: Assess library complexity, mapping rates, contamination.

3. **Quantification**: Normalize and quantify transcripts.

4. **Deconvolution**: Estimate tissue contributions.

5. **Classification**: Apply cancer detection models.

6. **Integration**: Combine with cfDNA if available.

7. **Output**: Tissue composition, cancer score, biomarker profiles.

## Example Usage

**User**: "Analyze plasma cfRNA to detect cancer and identify tissue of origin."

**Agent Action**:
```bash
python3 Skills/Genomics/CellFree_RNA_Agent/cfrna_analyzer.py \
    --input plasma_cfrna.fastq.gz \
    --protocol total_rna \
    --reference gencode_v44 \
    --deconvolution true \
    --cancer_detection true \
    --output cfrna_results/
```

## Tissue Deconvolution

**Reference Transcriptomes**:
- GTEx tissue expression atlas
- Single-cell reference atlases
- Tissue-specific marker genes

**Methods**:
- Non-negative least squares
- Support vector regression
- Deep learning deconvolution

**Clinical Applications**:
- Organ injury detection (liver, heart, brain)
- Tumor burden estimation
- Post-transplant monitoring

## Cancer Detection Applications

| Cancer Type | Key Markers | Performance |
|-------------|-------------|-------------|
| Lung | XIST, MALAT1, specific mRNAs | AUC 0.80-0.90 |
| Breast | HER2, ER/PR transcripts | Monitoring |
| Colorectal | KRAS, panel genes | Early detection |
| Prostate | PCA3, TMPRSS2-ERG | Established |
| Liver | AFP, specific ncRNAs | HCC surveillance |

## Technical Considerations

**Pre-analytical Factors**:
- Sample collection (EDTA, cell stabilization)
- Processing time (<4 hours recommended)
- Storage temperature (-80°C)
- Hemolysis avoidance (critical)

**Library Preparation**:
- Total RNA (captures mRNA, lncRNA)
- Small RNA (miRNA, piRNA)
- Targeted panels (specific genes)
- UMI-based for quantification

## AI/ML Components

**Cancer Classifier**:
- Gradient boosting on gene panels
- Neural networks for full transcriptome
- Multi-cancer detection models

**Tissue Predictor**:
- Reference-based deconvolution
- Supervised tissue classifiers
- Anomaly detection for novel sources

## Integration with Other Analytes

| Analyte | Strength | Combination Benefit |
|---------|----------|---------------------|
| cfDNA | Mutations, methylation | Genomic + transcriptomic |
| CTCs | Single-cell analysis | Cellular confirmation |
| Exosomes | Protected RNA | Source identification |
| Proteins | Functional markers | Multi-modal biomarkers |

## Prerequisites

* Python 3.10+
* STAR/Salmon for alignment
* DESeq2/edgeR for quantification
* Tissue deconvolution tools

## Related Skills

* Liquid_Biopsy_Analytics_Agent - For comprehensive liquid biopsy
* Exosome_EV_Analysis_Agent - For EV-derived RNA
* ctDNA_Analysis - For DNA-based markers

## Emerging Technologies

1. **Targeted cfRNA**: Gene panels for specific cancers
2. **Single-molecule**: Direct RNA sequencing
3. **Spatial deconvolution**: Mapping cfRNA to tissue regions
4. **Longitudinal monitoring**: Treatment response tracking

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->