---
name: omics-microbiome-cancer-association
description: 提供分析微生物组与癌症疗效的关联的方法与调用指南；用于处理16S/shotgun测序、肿瘤数据和临床结局。
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



# Microbiome-Cancer Interaction Agent

## Codex 调用

- **选择**：请求涉及“分析微生物组与癌症疗效的关联”时使用；显式调用 `$omics-microbiome-cancer-association`。
- **输入**：16S/shotgun测序、肿瘤数据和临床结局。
- **预期产物**：菌群谱、多样性、功能及响应预测结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **外部/示例入口**：`Skills/Microbiome/Microbiome_Cancer_Agent/microbiome_cancer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Microbiome-Cancer Interaction Agent** analyzes relationships between the microbiome and cancer, including tumor-associated bacteria, gut microbiome effects on immunotherapy, and microbiome-targeted therapeutic strategies.

## When to Use This Skill

* When analyzing tumor microbiome composition from sequencing data.
* To predict immunotherapy response based on gut microbiome profiles.
* For identifying microbiome-based biomarkers in cancer.
* When assessing antibiotic impact on cancer treatment efficacy.
* To design microbiome-modulating therapeutic interventions.

## Core Capabilities

1. **Tumor Microbiome Analysis**: Profile intratumoral bacteria from tumor sequencing data.

2. **Gut-Cancer Axis**: Analyze fecal microbiome associations with cancer outcomes.

3. **ICI Response Prediction**: Predict checkpoint inhibitor response from microbiome.

4. **Metabolite Profiling**: Link microbial metabolites to cancer phenotypes.

5. **Antibiotic Impact**: Model antibiotic effects on treatment efficacy.

6. **FMT/Probiotic Design**: Support microbiome-modulating interventions.

## Microbiome-Cancer Associations

| Cancer Type | Key Bacteria | Association |
|-------------|--------------|-------------|
| Colorectal | Fusobacterium nucleatum | Promotion, poor prognosis |
| Colorectal | Bacteroides fragilis (ETBF) | Carcinogenesis |
| Gastric | Helicobacter pylori | Established carcinogen |
| Pancreatic | Gammaproteobacteria | Drug metabolism |
| Breast | Fusobacterium | Metastasis |
| Oral | Porphyromonas gingivalis | Oral SCC |

## Workflow

1. **Input**: 16S/shotgun metagenomics, tumor sequencing, clinical data.

2. **Taxonomy Profiling**: Identify bacterial composition at genus/species level.

3. **Diversity Analysis**: Calculate alpha and beta diversity metrics.

4. **Association Testing**: Correlate microbiome with outcomes.

5. **Functional Prediction**: Infer metabolic potential (PICRUSt2, HUMAnN).

6. **Prediction Modeling**: Build response prediction models.

7. **Output**: Microbiome profile, associations, predictions, interventions.

## Example Usage

**User**: "Analyze gut microbiome from melanoma patients and predict anti-PD-1 response."

**Agent Action**:
```bash
python3 Skills/Microbiome/Microbiome_Cancer_Agent/microbiome_cancer.py \
    --metagenomics fecal_shotgun.fastq.gz \
    --tumor_data melanoma_rnaseq.tsv \
    --clinical treatment_outcomes.csv \
    --analysis ici_response \
    --reference metaphlan_db \
    --output microbiome_report/
```

## ICI Response and Microbiome

**Favorable Microbiome**:
- Akkermansia muciniphila
- Faecalibacterium prausnitzii
- Bifidobacterium spp.
- Ruminococcaceae family
- High diversity

**Unfavorable Microbiome**:
- Bacteroidales (in some studies)
- Low diversity
- Post-antibiotic dysbiosis

## Microbial Metabolites in Cancer

| Metabolite | Source | Effect |
|------------|--------|--------|
| Butyrate | Clostridia | Anti-inflammatory, anti-tumor |
| Inosine | Akkermansia | Enhanced ICI response |
| TMAO | Various | Pro-tumorigenic |
| Secondary bile acids | Various | Variable, context-dependent |
| LPS | Gram-negative | Inflammation, mixed effects |

## AI/ML Components

**Response Prediction**:
- Random forest on microbiome features
- Neural networks for metagenomic profiles
- Integration with host factors

**Microbiome-Metabolite Linking**:
- Genome-scale metabolic models
- Correlation networks
- Causal inference methods

**Intervention Design**:
- FMT donor selection
- Probiotic consortium optimization
- Antibiotic avoidance recommendations

## Tumor Microbiome Analysis

**Challenges**:
- Low bacterial biomass in tumors
- Contamination from reagents/environment
- Batch effects
- Need for stringent controls

**Best Practices**:
- Negative controls (extraction, PCR)
- Decontamination algorithms (decontam, SCRuB)
- Multiple validation methods
- Orthogonal confirmation (FISH, culture)

## Clinical Implications

1. **Biomarker Development**: Microbiome-based response prediction
2. **Intervention Timing**: Avoid antibiotics pre-ICI
3. **FMT Trials**: Responder microbiome transfer
4. **Probiotics**: Rationally designed consortia
5. **Prebiotics**: Fiber to support beneficial bacteria

## Prerequisites

* Python 3.10+
* QIIME2, Metaphlan, HUMAnN
* R (phyloseq, vegan)
* ML frameworks

## Related Skills

* Metagenomics - For general microbiome analysis
* Immune_Checkpoint_Combination_Agent - For ICI optimization
* Metabolomics - For metabolite analysis

## Research Frontiers

1. **Intratumoral bacteria**: Direct tumor effects
2. **Phage therapy**: Targeting pathobionts
3. **Engineered probiotics**: Drug-producing bacteria
4. **Diet interventions**: Modulating microbiome for therapy

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->