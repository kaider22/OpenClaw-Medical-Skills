---
name: drug-pdx-response-analysis
description: 分析PDX药敏、保真度和患者转化的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# PDX Model Analysis Agent

## Codex 调用

- **选择**：请求涉及“分析PDX药敏、保真度和患者转化”时使用；显式调用 `$drug-pdx-response-analysis`。
- **输入**：PDX分子数据、药敏曲线和患者肿瘤数据。
- **预期产物**：药物排名、生物标志物和治疗建议；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Oncology/PDX_Model_Analysis_Agent/pdx_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **PDX Model Analysis Agent** provides AI-driven analysis of patient-derived xenograft models for preclinical drug testing, translational research, and personalized oncology. It correlates PDX drug responses with patient outcomes and molecular profiles for treatment selection.

## When to Use This Skill

* When selecting drug treatments based on PDX drug response data.
* To correlate PDX molecular profiles with patient tumor characteristics.
* For analyzing PDX-patient concordance in drug sensitivity.
* When designing preclinical drug combination studies.
* To identify biomarkers predicting PDX and patient drug response.

## Core Capabilities

1. **PDX-Patient Concordance**: Analyze molecular similarity between PDX and donor tumor.

2. **Drug Response Modeling**: ML models correlating PDX drug sensitivity to patient outcomes.

3. **Biomarker Discovery**: Identify molecular features predicting drug response in PDX panels.

4. **Combination Screening**: Analyze synergy in PDX drug combination studies.

5. **Translational Prediction**: Project PDX findings to patient treatment selection.

6. **Quality Assessment**: Evaluate PDX fidelity and stability across passages.

## PDX Quality Metrics

| Metric | Threshold | Interpretation |
|--------|-----------|----------------|
| Genetic concordance | >90% | Variants maintained |
| Expression correlation | >0.85 | Transcriptome preserved |
| CNV fidelity | >85% | Copy number stable |
| Tumor take rate | Variable | Engraftment success |
| Passage stability | <P5 recommended | Minimal drift |

## Workflow

1. **Input**: PDX molecular data, drug response curves, patient tumor data.

2. **Concordance Analysis**: Compare PDX to donor tumor at molecular level.

3. **Drug Response Processing**: Calculate IC50, AUC, TGI from growth curves.

4. **Biomarker Analysis**: Correlate molecular features with drug sensitivity.

5. **Patient Prediction**: Project findings to patient treatment recommendations.

6. **Quality Assessment**: Flag PDX models with significant drift.

7. **Output**: Drug rankings, biomarker associations, treatment recommendations.

## Example Usage

**User**: "Analyze PDX drug response data for this breast cancer patient and recommend treatments."

**Agent Action**:
```bash
python3 Skills/Oncology/PDX_Model_Analysis_Agent/pdx_analyzer.py \
    --pdx_rnaseq pdx_expression.tsv \
    --pdx_mutations pdx_variants.maf \
    --patient_tumor patient_expression.tsv \
    --drug_responses pdx_drug_panel.csv \
    --tumor_type breast_cancer \
    --concordance_check true \
    --output pdx_recommendations/
```

## Drug Response Metrics

| Metric | Calculation | Interpretation |
|--------|-------------|----------------|
| IC50 | Concentration for 50% inhibition | Potency |
| AUC | Area under dose-response curve | Overall sensitivity |
| TGI | Tumor growth inhibition % | In vivo efficacy |
| T/C | Treated/Control volume ratio | Treatment effect |
| Best response | Maximum tumor regression | Depth of response |

## PDX Resource Integration

| Resource | Coverage | Data Types |
|----------|----------|------------|
| PDXFINDER | 4000+ models | Multi-omic, drug response |
| PDMR (NCI) | 500+ models | Genomic, drug response |
| Champions/Crown | 1500+ models | Drug response |
| EurOPDX | 1000+ models | European cohort |

## AI/ML Models

**Drug Response Prediction**:
- Gradient boosting on multi-omic features
- Gene expression signatures for drug classes
- Mutation-based response predictors

**PDX-Patient Translation**:
- Transfer learning from PDX to patient
- Domain adaptation for species differences
- Concordance-weighted predictions

**Combination Synergy**:
- Bliss independence model
- Loewe additivity analysis
- Machine learning synergy prediction

## Clinical Translation Considerations

**Factors Affecting Translation**:
1. **Tumor heterogeneity**: PDX from single biopsy
2. **Microenvironment**: Mouse vs human stroma
3. **Immune system**: Immunodeficient hosts
4. **Pharmacokinetics**: Species differences
5. **Passage number**: Drift over time

**Best Practices**:
- Use early passage PDX (P1-P5)
- Confirm molecular concordance
- Test drug at clinically-relevant doses
- Consider humanized PDX for immunotherapy

## Prerequisites

* Python 3.10+
* scikit-learn, pandas
* Drug response databases
* PDX molecular datasets

## Related Skills

* Drug_Repurposing - For alternative drug identification
* Multi_Omics_Integration - For PDX characterization
* Clinical_Trials - For trial matching

## Output Report

1. **Concordance Summary**: PDX-patient molecular similarity
2. **Drug Rankings**: Predicted efficacy from PDX data
3. **Biomarker Associations**: Features driving sensitivity
4. **Quality Flags**: PDX reliability assessment
5. **Treatment Recommendations**: Prioritized drug list

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->