---
name: imaging-multimodal-radpath-fusion
description: 规划影像、病理、组学的多模态融合分析的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# Multimodal Radiology-Pathology Fusion Agent

## Codex 调用

- **选择**：请求涉及“规划影像、病理、组学的多模态融合分析”时使用；显式调用 `$imaging-multimodal-radpath-fusion`。
- **输入**：CT/MRI/PET、WSI、VCF/RNA和临床数据。
- **预期产物**：诊断、疗效/生存预测及特征归因；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Clinical/Multimodal_Radpath_Fusion_Agent/multimodal_fusion.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Multimodal Radpath Fusion Agent** integrates diverse clinical data sources including radiology imaging (CT, MRI, PET), digital pathology whole slide images, genomic profiling, and electronic health records using state-of-the-art multimodal deep learning for comprehensive cancer diagnosis, treatment response prediction, and prognostic modeling.

## When to Use This Skill

* When integrating radiology and pathology for unified tumor assessment.
* For treatment response prediction using multimodal imaging.
* To predict molecular features from imaging (imaging genomics).
* When building comprehensive prognostic models.
* For tumor board decision support with AI second opinion.

## Core Capabilities

1. **Radiology-Pathology Fusion**: Integrate macro and microscopic views.

2. **Imaging-Genomics Correlation**: Predict molecular features from imaging.

3. **Treatment Response Prediction**: Multi-modal response modeling.

4. **Survival Prediction**: Comprehensive prognostic models.

5. **Tumor Characterization**: Integrate phenotype from all modalities.

6. **Clinical Decision Support**: AI-assisted tumor board recommendations.

## Supported Modalities

| Modality | Data Type | Features Extracted |
|----------|-----------|-------------------|
| CT | DICOM volumes | Radiomics, deep features |
| MRI | Multi-sequence DICOM | Texture, perfusion, ADC |
| PET | SUV maps | Metabolic features |
| H&E WSI | SVS/NDPI images | Histology, spatial patterns |
| IHC | Stained slides | Biomarker quantification |
| WES/WGS | VCF | Mutations, TMB, signatures |
| RNA-seq | Expression matrix | Pathway signatures |
| Clinical | EHR data | Demographics, labs, history |

## Fusion Architectures

| Architecture | Method | Best For |
|--------------|--------|----------|
| AMRI-Net | Attention fusion | Radiology focus |
| PathOmCLIP | Contrastive learning | Path-omics alignment |
| SMuRF | Swin Transformer | Multi-region integration |
| MultiModal Transformer | Self-attention | All modalities |
| GNN Fusion | Graph networks | Spatial relationships |

## Workflow

1. **Data Ingestion**: Collect radiology, pathology, genomics, clinical.

2. **Preprocessing**: Standardize each modality.

3. **Feature Extraction**: Extract modality-specific features.

4. **Alignment**: Temporal and spatial alignment of data.

5. **Fusion**: Multi-modal deep learning integration.

6. **Prediction**: Diagnosis, response, survival prediction.

7. **Output**: Integrated report with explanations.

## Example Usage

**User**: "Integrate this lung cancer patient's CT scan, biopsy pathology, and genomic profiling for comprehensive assessment and treatment recommendation."

**Agent Action**:
```bash
python3 Skills/Clinical/Multimodal_Radpath_Fusion_Agent/multimodal_fusion.py \
    --ct_dicom ct_chest/ \
    --pet_dicom pet_scan/ \
    --wsi_path biopsy.svs \
    --genomic_vcf tumor_wes.vcf \
    --rna_expression expression.tsv \
    --clinical_ehr patient_data.json \
    --task treatment_recommendation \
    --cancer_type nsclc \
    --output integrated_assessment/
```

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| Integrated Diagnosis | Multi-modal classification | .json |
| Treatment Prediction | Response probabilities | .json |
| Survival Estimate | Prognostic curves | .json, .png |
| Feature Attribution | Modality importance | .json |
| Attention Maps | Visual explanations | .npy, .png |
| Clinical Report | Summary for tumor board | .pdf |
| Confidence Scores | Prediction uncertainty | .json |

## Clinical Applications

| Application | Modalities | Performance |
|-------------|------------|-------------|
| NSCLC IO Response | CT + H&E + PD-L1 | AUC 0.85 |
| HCC Treatment Selection | MRI + H&E + AFP | AUC 0.82 |
| Breast Neoadjuvant | MRI + H&E + HER2 | AUC 0.88 |
| HNSCC HPV/Prognosis | CT + H&E + p16 | AUC 0.89 |
| GBM Survival | MRI + H&E + MGMT | C-index 0.76 |

## Imaging-Genomics Predictions

| Molecular Feature | Imaging Modality | Accuracy |
|-------------------|------------------|----------|
| EGFR mutation | CT | 75-80% |
| KRAS mutation | CT | 70-75% |
| PD-L1 expression | CT + H&E | 80-85% |
| MSI status | H&E | 85-90% |
| TMB level | H&E | 75-80% |
| HRD status | H&E | 78-83% |

## AI/ML Components

**Feature Extraction**:
- 3D ResNet for CT/MRI volumes
- Vision Transformers for WSI
- Foundation models (CONCH, UNI)

**Fusion Methods**:
- Cross-attention mechanisms
- Multimodal transformers
- Contrastive multimodal learning

**Prediction Models**:
- Multi-task learning
- Survival analysis (DeepSurv)
- Uncertainty quantification

## Prerequisites

* Python 3.10+
* PyTorch, transformers
* SimpleITK, OpenSlide
* Foundation model weights
* GPU with 32GB+ VRAM (recommended)

## Related Skills

* Radiomics_Pathomics_Fusion_Agent - Imaging-specific fusion
* Pathology_AI/CONCH_Agent - Pathology foundation model
* Pan_Cancer_MultiOmics_Agent - Genomic integration
* Virtual_Lab_Agent - AI research coordination

## Integration with Clinical Workflow

| Integration Point | System | Purpose |
|-------------------|--------|---------|
| PACS | Radiology archive | Image retrieval |
| LIS | Pathology system | Slide access |
| EHR | Medical records | Clinical data |
| Tumor Board | MDT platform | Decision support |
| Reporting | Clinical reports | Documentation |

## Special Considerations

1. **Data Alignment**: Ensure temporal correspondence
2. **Missing Modalities**: Handle incomplete multimodal data
3. **Privacy**: HIPAA compliance for clinical integration
4. **Validation**: Multi-site validation essential
5. **Explainability**: Clinical trust requires interpretability

## Explainability Methods

| Method | Output | Purpose |
|--------|--------|---------|
| Attention Maps | Heatmaps | Important regions |
| SHAP Values | Feature importance | Modality contribution |
| GradCAM | Activation maps | Visual explanation |
| Counterfactuals | What-if analysis | Decision boundaries |

## Quality Control

| QC Check | Threshold | Action |
|----------|-----------|--------|
| Image Quality | Score >0.7 | Flag for review |
| Data Completeness | >80% fields | Proceed or wait |
| Prediction Confidence | >0.6 | Report with confidence |
| Calibration | ECE <0.1 | Trust probabilities |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->