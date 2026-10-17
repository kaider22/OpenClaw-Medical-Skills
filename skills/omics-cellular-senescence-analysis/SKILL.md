---
name: omics-cellular-senescence-analysis
description: 评估转录组中的衰老信号、SASP和药物敏感性的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# Cellular Senescence Agent

## Codex 调用

- **选择**：请求涉及“评估转录组中的衰老信号、SASP和药物敏感性”时使用；显式调用 `$omics-cellular-senescence-analysis`。
- **输入**：bulk/scRNA表达、蛋白组或成像数据。
- **预期产物**：衰老分数、SASP谱、负荷和候选药物；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Longevity_Aging/Cellular_Senescence_Agent/senescence_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Cellular Senescence Agent** provides comprehensive AI-driven analysis of cellular senescence signatures for aging research, cancer biology, and senolytic therapeutic development.

## When to Use This Skill

* When identifying senescent cells in tissue or single-cell data.
* To analyze senescence-associated secretory phenotype (SASP).
* For predicting senolytic drug sensitivity.
* When studying therapy-induced senescence in cancer.
* To assess senescence burden in aging and disease.

## Core Capabilities

1. **Senescence Scoring**: Calculate senescence signatures from transcriptomic data.

2. **SASP Profiling**: Characterize senescence-associated secretory phenotype composition.

3. **Single-Cell Detection**: Identify senescent cells in scRNA-seq data.

4. **Senolytic Prediction**: Predict sensitivity to senolytic drugs.

5. **Tissue Aging**: Assess senescence burden across tissues.

6. **Cancer Senescence**: Analyze therapy-induced senescence.

## Senescence Markers

| Category | Markers | Detection |
|----------|---------|-----------|
| Cell cycle | p16INK4a, p21CIP1, p53 | Expression, IHC |
| SA-β-gal | GLB1 (lysosomal) | Activity assay |
| SASP | IL-6, IL-8, MMP3, PAI-1 | Expression, secretion |
| DNA damage | γH2AX, 53BP1 foci | Immunofluorescence |
| Morphology | Enlarged, flattened | Imaging |
| Epigenetic | SAHF, SAHMs | Chromatin marks |

## Workflow

1. **Input**: Bulk or single-cell RNA-seq, proteomics, imaging data.

2. **Signature Scoring**: Apply senescence gene signatures.

3. **SASP Analysis**: Profile secretory phenotype.

4. **Cell Identification**: Flag senescent cells (single-cell).

5. **Senolytic Prediction**: Match to drug sensitivity profiles.

6. **Burden Estimation**: Quantify senescence load.

7. **Output**: Senescence scores, SASP profile, drug recommendations.

## Example Usage

**User**: "Analyze senescence signatures in this aging tissue dataset and identify senolytic candidates."

**Agent Action**:
```bash
python3 Skills/Longevity_Aging/Cellular_Senescence_Agent/senescence_analyzer.py \
    --rnaseq tissue_expression.tsv \
    --singlecell tissue_scrnaseq.h5ad \
    --signatures fridman_sasp,reactome_senescence \
    --senolytic_prediction true \
    --tissue liver \
    --output senescence_report/
```

## Senescence Gene Signatures

| Signature | Genes | Application |
|-----------|-------|-------------|
| Fridman (2017) | CDKN1A, CDKN2A, SERPINE1... | Pan-senescence |
| SenMayo | 125 genes | Tissue senescence |
| SASP Core | IL6, IL8, CXCL1, MMP1... | Secretory phenotype |
| p16/p21 pathway | CDKN2A, CDKN1A, MDM2... | Cell cycle arrest |

## SASP Components

**Pro-inflammatory**:
- Interleukins: IL-1α/β, IL-6, IL-8
- Chemokines: CXCL1, CXCL2, CCL2
- Growth factors: TGF-β, VEGF

**Matrix Remodeling**:
- MMPs: MMP1, MMP3, MMP10
- Serpins: PAI-1 (SERPINE1)

**Effects on Microenvironment**:
- Paracrine senescence spread
- Immune cell recruitment
- ECM remodeling
- Tumor promotion (chronic) vs suppression (acute)

## Senolytic Drugs

| Drug | Target | Clinical Status |
|------|--------|-----------------|
| Dasatinib | Src/tyrosine kinases | Trials (with Q) |
| Quercetin | PI3K, serpins | Trials (with D) |
| Navitoclax | BCL-2/BCL-xL | Trials |
| Fisetin | Multiple | Early trials |
| UBX1325 | BCL-xL | Phase 2 (macular) |

## AI/ML Components

**Senescence Classifier**:
- Multi-gene signature scoring
- ML classifiers on expression
- Single-cell senescence probability

**Drug Response**:
- GDSC/CCLE senescence sensitivity
- SASP-drug correlations
- Synergy predictions

**Aging Clock Integration**:
- Epigenetic age correlation
- Transcriptomic age
- Senescence-aging relationships

## Cancer Applications

**Therapy-Induced Senescence (TIS)**:
- Chemotherapy, radiation
- CDK4/6 inhibitors (palbociclib)
- Dual outcomes: tumor suppression vs SASP-driven recurrence

**Senescence + Senolytics**:
- Induce senescence → clear with senolytics
- "One-two punch" approach
- Clinical trials ongoing

## Prerequisites

* Python 3.10+
* Gene signature tools (GSVA, ssGSEA)
* Single-cell analysis (Scanpy)
* Drug response databases

## Related Skills

* Single_Cell - For scRNA-seq analysis
* Cancer_Metabolism_Agent - For metabolic senescence
* Tumor_Microenvironment - For SASP effects

## Research Applications

1. **Aging Research**: Quantify senescence burden
2. **Cancer Therapy**: Monitor TIS response
3. **Drug Development**: Senolytic efficacy
4. **Fibrosis**: Senescence in fibrotic disease
5. **Regeneration**: Senescence in tissue repair

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->