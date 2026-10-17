---
name: clinical-myeloma-residual-disease-assessment
description: 提供整合骨髓瘤流式、NGS和质谱评估MRD的方法与调用指南；用于处理FCS、克隆型、M蛋白质谱和临床数据。
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



# Myeloma MRD Agent

## Codex 调用

- **选择**：请求涉及“整合骨髓瘤流式、NGS和质谱评估MRD”时使用；显式调用 `$clinical-myeloma-residual-disease-assessment`。
- **输入**：FCS、克隆型、M蛋白质谱和临床数据。
- **预期产物**：MRD状态、IMWG分层和动力学预后；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Hematology/Myeloma_MRD_Agent/myeloma_mrd.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Myeloma MRD Agent** provides comprehensive AI-driven minimal residual disease assessment for multiple myeloma. It integrates next-generation flow cytometry (NGF), NGS-based clonotype tracking, and mass spectrometry M-protein detection for ultra-sensitive MRD monitoring.

## When to Use This Skill

* When assessing MRD status in multiple myeloma patients post-treatment.
* To select optimal MRD testing modality (NGF vs NGS vs MS).
* For predicting progression-free survival based on MRD kinetics.
* When integrating MRD with other response criteria (IMWG).
* To guide treatment intensification or de-escalation decisions.

## Core Capabilities

1. **NGF Analysis**: AI-enhanced next-generation flow cytometry for MRD detection at 10^-5 to 10^-6 sensitivity.

2. **NGS Clonotype Tracking**: Analyze IGH/IGK/IGL rearrangements for molecular MRD.

3. **Mass Spectrometry**: MALDI-TOF or LC-MS/MS for M-protein detection.

4. **Multi-Modal Integration**: Combine modalities for comprehensive MRD assessment.

5. **Kinetic Modeling**: Track MRD dynamics and predict outcomes.

6. **Response Classification**: Apply IMWG MRD criteria.

## MRD Detection Methods

| Method | Sensitivity | Sample | Advantages |
|--------|-------------|--------|------------|
| NGF (EuroFlow) | 10^-5 to 10^-6 | BM | Standardized, fast |
| NGS (clonoSEQ) | 10^-6 | BM | Ultra-sensitive |
| ASO-qPCR | 10^-5 | BM | Quantitative |
| PET-CT | N/A | Whole body | Extramedullary |
| MS (MALDI/LC-MS) | 10^-5 | Serum | Non-invasive |

## IMWG MRD Response Criteria

| Category | Definition |
|----------|------------|
| MRD-negative (10^-5) | No clonal plasma cells by NGF or NGS at 10^-5 |
| MRD-negative (10^-6) | No clonal plasma cells at 10^-6 sensitivity |
| Sustained MRD-neg | MRD-neg confirmed ≥1 year apart |
| Flow MRD-neg | NGF negative, sensitivity ≥10^-5 |
| Sequencing MRD-neg | NGS negative, sensitivity ≥10^-5 |

## Workflow

1. **Input**: Flow cytometry FCS files, NGS clonotype data, M-protein MS data, clinical parameters.

2. **NGF Analysis**: AI-assisted gating and aberrant plasma cell identification.

3. **NGS Analysis**: Clonotype frequency calculation and threshold application.

4. **MS Analysis**: M-protein peak detection and quantification.

5. **Integration**: Combine multi-modal MRD data.

6. **Kinetics**: Model MRD trajectory and predict outcomes.

7. **Output**: MRD status, response category, prognostic estimate.

## Example Usage

**User**: "Analyze MRD status for this myeloma patient using flow and NGS data."

**Agent Action**:
```bash
python3 Skills/Hematology/Myeloma_MRD_Agent/myeloma_mrd.py \
    --flow_fcs bone_marrow_ngf.fcs \
    --ngs_clonotype clonoseq_results.json \
    --ms_mprotein maldi_spectrum.csv \
    --baseline_clone diagnosis_clone.json \
    --treatment_phase post_consolidation \
    --output mrd_report.json
```

## NGF Panel (EuroFlow-Based)

**Tube 1**: CD138/CD38/CD45/CD19/CD56/CD27/CD81/CD117

**Aberrant Plasma Cell Phenotype**:
- CD138+, CD38++
- CD19- or dim (normal PC: CD19+)
- CD56+ (normal PC: CD56-)
- CD45- or dim (normal PC: CD45+)
- CD27- or dim
- CD117+ (often aberrant)

## AI-Assisted Flow Cytometry

**Automated Gating**:
- CNN-based plasma cell identification
- Aberrant vs normal PC discrimination
- Consistent quantification across samples

**Quality Control**:
- Sample adequacy assessment
- Hemodilution detection
- Event count validation

## NGS Clonotype Analysis

**Process**:
1. Identify dominant clone at diagnosis (IGH/IGK/IGL)
2. Design clone-specific assay or use multiplex (clonoSEQ)
3. Track clonal frequency in follow-up samples
4. Apply MRD threshold (typically 10^-5 or 10^-6)

**Considerations**:
- Clonal evolution may affect tracking
- Biclonal disease requires tracking both
- IGK/IGL backup if IGH fails

## Prognostic Significance

| MRD Status | PFS HR | OS HR |
|------------|--------|-------|
| MRD-neg (10^-5) | 0.35-0.45 | 0.40-0.50 |
| MRD-neg (10^-6) | 0.25-0.35 | 0.30-0.40 |
| Sustained MRD-neg | 0.20-0.30 | 0.25-0.35 |

## Clinical Decision Support

**MRD-Guided Treatment**:
- De-escalation in sustained MRD-neg
- Intensification if MRD conversion
- Maintenance duration decisions

**Monitoring Frequency**:
- Post-induction
- Post-consolidation
- Post-transplant (Day +100)
- Every 6-12 months on maintenance

## Prerequisites

* Python 3.10+
* FlowJo or equivalent for FCS files
* NGS analysis pipelines
* Mass spectrometry processing tools

## Related Skills

* Flow_Cytometry_AI - For general flow analysis
* Multiple_Myeloma_AI - For disease-specific analysis
* Liquid_Biopsy_Analytics_Agent - For ctDNA approaches

## Emerging Methods

1. **Circulating tumor cells**: Blood-based PC detection
2. **Cell-free DNA**: Myeloma-specific mutations
3. **Imaging**: PET/MRI for extramedullary disease
4. **Serum-based NGS**: M-protein sequencing

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->