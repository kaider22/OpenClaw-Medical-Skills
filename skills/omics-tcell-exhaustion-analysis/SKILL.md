---
name: omics-tcell-exhaustion-analysis
description: 提供按耗竭签名划分T细胞状态并评估表观耗竭程序的方法与调用指南；用于处理TIL/PBMC scRNA、CITE-seq或scATAC数据及签名集。
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



# T-Cell Exhaustion Analysis Agent

## Codex 调用

- **选择**：请求涉及“按耗竭签名划分T细胞状态并评估表观耗竭程序”时使用；显式调用 `$omics-tcell-exhaustion-analysis`。
- **输入**：TIL/PBMC scRNA、CITE-seq或scATAC数据及签名集。
- **预期产物**：耗竭状态比例、TCF1+细胞和响应预测；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Immunology_Vaccines/TCell_Exhaustion_Analysis_Agent/exhaustion_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **T-Cell Exhaustion Analysis Agent** provides comprehensive profiling of T-cell dysfunction states in cancer and chronic infection. It analyzes exhaustion signatures, identifies stem-like progenitor populations, characterizes epigenetic scarring, and predicts checkpoint immunotherapy response.

## When to Use This Skill

* When profiling tumor-infiltrating lymphocyte (TIL) exhaustion states from scRNA-seq data.
* To identify stem-like exhausted T-cells (Tex-prog) that predict checkpoint blockade response.
* For analyzing epigenetic exhaustion programs via ATAC-seq or CUT&Tag.
* To assess exhaustion reversal potential and re-exhaustion risk.
* When designing combination immunotherapy strategies.

## Core Capabilities

1. **Exhaustion State Classification**: Distinguishes progenitor exhausted (Tex-prog), intermediate, and terminally exhausted (Tex-term) populations using transcriptional signatures.

2. **Stem-like T-Cell Detection**: Identifies TCF1+ stem-like exhausted cells that sustain anti-tumor immunity and respond to PD-1 blockade.

3. **Epigenetic Scarring Analysis**: Characterizes chromatin accessibility patterns that maintain exhaustion programs despite checkpoint blockade.

4. **Checkpoint Expression Profiling**: Quantifies inhibitory receptors (PD-1, TIM-3, LAG-3, TIGIT, CTLA-4) at single-cell resolution.

5. **Response Prediction**: Machine learning models predict checkpoint blockade response based on exhaustion profiles.

6. **TME Interaction Analysis**: Maps suppressive cell interactions (Tregs, MDSCs, TAMs) promoting exhaustion.

## Exhaustion Signatures

**Progenitor Exhausted (Tex-prog)**:
- TCF1+, SLAMF6+, PD-1+
- Self-renewal capacity
- Proliferative burst upon checkpoint blockade
- Good prognosis marker

**Terminal Exhausted (Tex-term)**:
- TCF1-, TIM-3+, CD39+
- Effector-like but dysfunctional
- Limited proliferative potential
- Epigenetically fixed exhaustion

## Workflow

1. **Input**: scRNA-seq, CITE-seq, or scATAC-seq data from TILs or PBMCs.

2. **Preprocessing**: Quality control, normalization, batch correction.

3. **Clustering**: Identify T-cell subsets and exhaustion states.

4. **Signature Scoring**: Apply exhaustion gene signatures (TOX, NR4A, NFAT targets).

5. **Epigenetic Analysis**: Assess chromatin accessibility at exhaustion loci.

6. **Prediction**: Model checkpoint response from exhaustion profiles.

7. **Output**: Exhaustion state proportions, stem-like cell fractions, response predictions.

## Example Usage

**User**: "Analyze T-cell exhaustion states in this TIL scRNA-seq dataset and predict anti-PD-1 response."

**Agent Action**:
```bash
python3 Skills/Immunology_Vaccines/TCell_Exhaustion_Analysis_Agent/exhaustion_analyzer.py \
    --input til_scrnaseq.h5ad \
    --tcells CD8A+CD3E+ \
    --signatures exhaustion_signatures.gmt \
    --epigenetic til_scatacseq.h5ad \
    --predict_response true \
    --output exhaustion_report/
```

## Key Markers and Genes

| Category | Markers | Role |
|----------|---------|------|
| Exhaustion TFs | TOX, TOX2, NR4A1-3 | Exhaustion program drivers |
| Stem-like | TCF7 (TCF1), LEF1, SLAMF6 | Progenitor maintenance |
| Terminal | HAVCR2 (TIM-3), ENTPD1 (CD39), LAYN | Terminal exhaustion |
| Checkpoints | PDCD1, CTLA4, LAG3, TIGIT | Inhibitory receptors |
| Effector | GZMB, PRF1, IFNG | Cytotoxic function |

## Epigenetic Exhaustion Program

The exhaustion epigenetic landscape is largely resistant to checkpoint blockade:

* **Stable open chromatin** at exhaustion-associated genes (TOX, NR4A, checkpoint loci)
* **Epigenetic scars** maintained even after PD-1 therapy
* **Re-exhaustion** occurs upon cessation of checkpoint blockade
* **Therapeutic implications**: Epigenetic modifiers may enhance durability

## Prerequisites

* Python 3.10+
* Scanpy/Seurat for scRNA-seq
* ArchR/Signac for scATAC-seq
* CellTypist or custom classifiers

## Related Skills

* CAR_T_Design - For engineering exhaustion-resistant CAR-T cells
* Immune_Repertoire_Analysis - For TCR clonotype tracking
* Tumor_Microenvironment - For TIL context analysis

## Clinical Implications

1. **Patient Selection**: High stem-like Tex predicts checkpoint response
2. **Combination Therapy**: TIGIT + PD-1 for resistant tumors
3. **Epigenetic Therapy**: DNMT/HDAC inhibitors to reprogram exhausted cells
4. **CAR-T Engineering**: TOX knockout to prevent CAR-T exhaustion

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->