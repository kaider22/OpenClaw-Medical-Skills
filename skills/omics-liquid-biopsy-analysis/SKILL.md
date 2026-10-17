---
name: omics-liquid-biopsy-analysis
description: 整合ctDNA、CTC并评估MRD和疗效的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
metadata:
  source_extensions:
    keywords:
    - liquid-biopsy
    - ctdna
    - mrd
    - cancer-detection
    - treatment-response
    measurable_outcome: Detects circulating tumor DNA with 0.01% sensitivity and accurately predicts treatment response in longitudinal samples.
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



# Liquid Biopsy Analytics Agent

## Codex 调用

- **选择**：请求涉及“整合ctDNA、CTC并评估MRD和疗效”时使用；显式调用 `$omics-liquid-biopsy-analysis`。
- **输入**：VCF、甲基化/CTC数据、临床时间点和基线肿瘤。
- **预期产物**：突变轨迹、MRD判断和克隆演化报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Oncology/Liquid_Biopsy_Analytics_Agent/lb_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Liquid Biopsy Analytics Agent** provides comprehensive AI-driven analysis of blood-based cancer biomarkers. It integrates circulating tumor DNA (ctDNA), circulating tumor cells (CTCs), exosomes, and cell-free RNA for multi-cancer early detection (MCED), minimal residual disease (MRD) monitoring, and treatment response assessment.

## When to Use This Skill

* For multi-cancer early detection screening from blood samples.
* To monitor minimal residual disease (MRD) after curative treatment.
* When tracking tumor evolution and resistance during therapy.
* For real-time treatment response assessment.
* To detect cancer recurrence before clinical or imaging evidence.

## Core Capabilities

1. **ctDNA Mutation Analysis**: Variant calling, VAF tracking, and clonal evolution from cell-free DNA.

2. **Methylation-Based Detection**: cfDNA methylation patterns for cancer detection and tissue-of-origin identification.

3. **CTC Enumeration & Analysis**: AI-powered CTC detection, enumeration, and molecular characterization.

4. **Multi-Modal Integration**: Combines ctDNA, CTCs, and protein biomarkers with clinical/imaging data.

5. **MRD Monitoring**: Ultra-sensitive detection of residual disease post-treatment.

6. **Response Prediction**: AI models predicting treatment response from longitudinal liquid biopsy data.

## Analyte Types and Applications

| Analyte | Detection Method | Clinical Use |
|---------|------------------|--------------|
| ctDNA mutations | NGS, ddPCR | Therapy selection, resistance |
| ctDNA methylation | WGBS, targeted | MCED, tissue of origin |
| ctDNA fragmentation | WGS | Cancer detection |
| CTCs | CellSearch, microfluidics | Prognosis, monitoring |
| Exosomes | Immunocapture | Biomarker cargo |
| cfRNA | RT-qPCR, NGS | Gene expression |

## Workflow

1. **Input**: Liquid biopsy data (ctDNA variants, methylation, CTC counts, protein markers).

2. **Quality Control**: Assess sample quality, input DNA amount, background noise.

3. **Variant Analysis**: Call mutations, calculate VAF, filter artifacts (CHIP).

4. **Multi-analyte Integration**: Combine biomarker signals using ML fusion.

5. **Clinical Interpretation**: Generate actionable insights for treatment decisions.

6. **Longitudinal Tracking**: Model dynamics for response assessment and recurrence detection.

7. **Output**: Cancer detection probability, MRD status, treatment recommendations, clonal evolution.

## Example Usage

**User**: "Analyze longitudinal ctDNA data from this lung cancer patient to assess treatment response and detect resistance."

**Agent Action**:
```bash
python3 Skills/Oncology/Liquid_Biopsy_Analytics_Agent/lb_analyzer.py \
    --ctdna_variants longitudinal_ctdna.vcf \
    --timepoints week0,week4,week8,week12 \
    --tumor_markers cea_values.csv \
    --baseline_tissue baseline_tumor.maf \
    --analysis response_resistance \
    --chip_filter true \
    --output lb_report/
```

## AI/ML Models

**Multi-Cancer Early Detection (MCED)**:
- Methylation-based classifiers (sensitivity ~50-80% at 99% specificity)
- Multi-analyte combination models
- Tissue-of-origin prediction
- Integration with imaging and clinical risk

**MRD Detection**:
- Tumor-informed (personalized panels from tissue)
- Tumor-agnostic (fixed panels, methylation)
- Detection limits: 0.01% - 0.001% VAF

**Response Prediction**:
- Longitudinal VAF dynamics modeling
- Bayesian evolution frameworks
- Time-to-progression prediction

## Clonal Hematopoiesis Filtering

Critical challenge in liquid biopsy interpretation:

| Gene | Prevalence | Action |
|------|------------|--------|
| DNMT3A | 30-40% of CHIP | Filter if VAF stable, no tumor context |
| TET2 | 20-30% | Filter if VAF stable |
| ASXL1 | 10-15% | Filter if VAF stable |
| TP53 | 5-10% | Context-dependent (tumor vs CHIP) |
| Matched WBC | Gold standard | Subtract germline/CHIP variants |

## Commercial Platforms (Reference)

| Platform | Technology | Application |
|----------|------------|-------------|
| Guardant360 | ctDNA NGS | Therapy selection |
| FoundationOne Liquid | ctDNA NGS | Comprehensive profiling |
| Galleri | Methylation | MCED screening |
| Signatera | Tumor-informed | MRD monitoring |
| CellSearch | CTC | FDA-cleared enumeration |

## Clinical Decision Points

1. **Treatment Selection**: Actionable mutations (EGFR, ALK, ROS1, BRAF)
2. **Response Assessment**: ctDNA clearance correlates with outcomes
3. **Resistance Detection**: Emerging resistance mutations (T790M, C797S)
4. **Recurrence Monitoring**: Lead time of 3-6 months over imaging

## Prerequisites

* Python 3.10+
* NGS variant calling pipelines
* Methylation analysis tools
* Machine learning frameworks

## Related Skills

* ctDNA_Analysis - For detailed ctDNA workflows
* Tumor_Clonal_Evolution - For evolutionary analysis
* MRD_Detection - For residual disease focus

## Limitations and Considerations

- **False positives**: CHIP, benign tumors, inflammation
- **False negatives**: Low shedding tumors, early stage
- **Technical variability**: Pre-analytical factors critical
- **Cost**: Multi-analyte panels expensive

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->