---
name: omics-ctdna-dynamics-analysis
description: 提供分析纵向ctDNA动力学并评估MRD和复发风险的方法与调用指南；用于处理纵向ctDNA测量、时间点、治疗日期和跟踪突变。
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



# ctDNA Dynamics MRD Agent

## Codex 调用

- **选择**：请求涉及“分析纵向ctDNA动力学并评估MRD和复发风险”时使用；显式调用 `$omics-ctdna-dynamics-analysis`。
- **输入**：纵向ctDNA测量、时间点、治疗日期和跟踪突变。
- **预期产物**：MRD状态、动力学参数、复发预测和轨迹图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Oncology/ctDNA_Dynamics_MRD_Agent/ctdna_mrd_analysis.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **ctDNA Dynamics MRD Agent** provides comprehensive analysis of circulating tumor DNA dynamics for molecular residual disease (MRD) detection, treatment response monitoring, and early relapse prediction. It integrates tumor-informed and tumor-naive approaches with temporal modeling for longitudinal ctDNA analysis.

## When to Use This Skill

* When monitoring minimal/molecular residual disease post-treatment.
* For tracking treatment response through ctDNA kinetics.
* To predict relapse before clinical/radiological detection.
* When assessing tumor burden dynamics during therapy.
* For early detection of acquired resistance mutations.

## Core Capabilities

1. **MRD Detection**: Ultra-sensitive detection of residual disease (LOD 0.001% VAF).

2. **Kinetic Modeling**: Model ctDNA clearance and doubling time.

3. **Response Prediction**: Predict treatment response from early ctDNA dynamics.

4. **Relapse Prediction**: Identify molecular relapse months before imaging.

5. **Resistance Monitoring**: Track emergence of resistance mutations.

6. **Multi-Timepoint Integration**: Analyze longitudinal ctDNA trajectories.

## Detection Approaches

| Approach | Method | LOD | Best Use Case |
|----------|--------|-----|---------------|
| Tumor-Informed | Track known mutations | 0.001% | Post-surgical MRD |
| Tumor-Naive | Panel-based detection | 0.1% | Screening, unknown primary |
| WGS-Based | Fragmentomics + mutations | 0.01% | Comprehensive profiling |
| Methylation | cfDNA methylation | 0.1% | Tissue of origin, early detection |

## Kinetic Parameters

| Parameter | Definition | Clinical Meaning |
|-----------|------------|------------------|
| ctDNA Half-Life | Time to 50% reduction | Treatment sensitivity |
| Doubling Time | Time to 2x increase | Tumor growth rate |
| Nadir | Lowest ctDNA level | Depth of response |
| Time to Nadir | Days to reach nadir | Response kinetics |
| Clearance Rate | Exponential decay constant | Treatment efficacy |
| Lead Time | MRD+ to clinical relapse | Early detection window |

## Workflow

1. **Input**: Serial ctDNA measurements (VAF or copies/mL), timepoints, treatment dates.

2. **QC**: Assess sequencing quality, coverage, tumor fraction.

3. **Mutation Tracking**: Quantify tracked variants across timepoints.

4. **Kinetic Modeling**: Fit exponential/sigmoidal models to dynamics.

5. **MRD Calling**: Determine MRD status with confidence intervals.

6. **Resistance Detection**: Identify emerging resistant clones.

7. **Output**: MRD status, kinetic parameters, predictions, visualizations.

## Example Usage

**User**: "Analyze this patient's serial ctDNA data to assess MRD status and predict relapse risk."

**Agent Action**:
```bash
python3 Skills/Oncology/ctDNA_Dynamics_MRD_Agent/ctdna_mrd_analysis.py \
    --ctdna_data serial_ctdna.tsv \
    --tracked_mutations tumor_mutations.vcf \
    --sample_times 0,14,42,90,180 \
    --treatment_start 0 \
    --surgery_date 7 \
    --cancer_type colorectal \
    --output mrd_analysis/
```

## Input Data Format

```tsv
Sample_ID  Timepoint_Days  Mutation  VAF  Copies_per_mL  Coverage
PT001_T0   0               TP53_R248Q  5.2  1500          15000
PT001_T1   14              TP53_R248Q  2.1  620           18000
PT001_T2   42              TP53_R248Q  0.05 15            20000
PT001_T3   90              TP53_R248Q  0.002 0.6          22000
```

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| MRD Status | Positive/Negative at each timepoint | .csv |
| Kinetic Parameters | Half-life, doubling time, nadir | .json |
| Response Classification | Major/Minor/No response | .csv |
| Relapse Risk | Probability and predicted time | .json |
| Dynamics Plot | ctDNA trajectory visualization | .png, .pdf |
| Resistance Variants | Emerging mutations | .vcf |
| Clonal Evolution | Clone frequency over time | .csv |

## Response Definitions

| Response Category | ctDNA Change | Clinical Correlation |
|-------------------|--------------|---------------------|
| Major Molecular Response | >2 log reduction | Excellent prognosis |
| Molecular Response | 1-2 log reduction | Good prognosis |
| Stable Molecular Disease | <1 log change | Intermediate |
| Molecular Progression | >0.5 log increase | Poor prognosis |

## Cancer-Specific Parameters

| Cancer Type | Typical Half-Life | MRD Lead Time | ctDNA Shedding |
|-------------|-------------------|---------------|----------------|
| Colorectal | 1-2 days | 6-12 months | High |
| Lung (NSCLC) | 1-3 days | 3-6 months | High |
| Breast | 2-5 days | 6-18 months | Moderate |
| Pancreatic | 1-2 days | 3-6 months | High |
| Melanoma | 2-4 days | 3-9 months | Variable |

## AI/ML Components

**Kinetic Modeling**:
- Non-linear mixed effects models
- Bayesian hierarchical models
- Gaussian process regression

**MRD Detection**:
- Error-suppressed variant calling
- Machine learning noise filtering
- Duplex UMI deduplication

**Relapse Prediction**:
- Time-series forecasting (LSTM, Transformers)
- Survival analysis (Cox, Random Survival Forests)
- Multi-mutation integration

## Clinical Trial Support

| Application | Endpoint | ctDNA Metric |
|-------------|----------|--------------|
| Neoadjuvant | pathCR surrogate | Pre-surgery clearance |
| Adjuvant | DFS surrogate | Post-surgery MRD |
| Metastatic | PFS/OS surrogate | ctDNA dynamics |
| Maintenance | Duration decision | MRD negativity |

## Prerequisites

* Python 3.10+
* Variant callers (Mutect2, Strelka)
* UMI-aware pipelines
* scipy, lifelines, survival analysis tools
* PyTorch for deep learning models

## Related Skills

* MRD_EDGE_Detection_Agent - Ultra-sensitive MRD detection
* Liquid_Biopsy_Analytics_Agent - Comprehensive liquid biopsy
* Tumor_Heterogeneity_Agent - Clonal evolution tracking
* HRD_Analysis_Agent - Genomic biomarkers

## Special Considerations

1. **Tumor Fraction**: Low tumor fraction limits sensitivity
2. **Pre-Analytical**: Plasma processing affects cfDNA quality
3. **Clonal Hematopoiesis**: CHIP variants can confound results
4. **Panel Design**: Ensure sufficient mutation coverage
5. **Timing**: Sample timing relative to treatment critical

## FDA-Cleared ctDNA Tests

| Test | Cancer Types | Application |
|------|--------------|-------------|
| Guardant360 CDx | Pan-cancer | Treatment selection |
| FoundationOne Liquid CDx | Pan-cancer | Treatment selection |
| Signatera | Solid tumors | MRD monitoring |
| Guardant Reveal | CRC | MRD detection |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->