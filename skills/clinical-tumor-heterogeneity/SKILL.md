---
name: clinical-tumor-heterogeneity
description: 提供整合多区域和单细胞数据量化肿瘤异质性的方法与调用指南；用于处理WES/WGS、CNV、纯度和样本元数据。
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



# Tumor Heterogeneity Agent

## Codex 调用

- **选择**：请求涉及“整合多区域和单细胞数据量化肿瘤异质性”时使用；显式调用 `$clinical-tumor-heterogeneity`。
- **输入**：WES/WGS、CNV、纯度和样本元数据。
- **预期产物**：克隆分配、系统发育树、ITH指标和可靶向亚克隆；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Oncology/Tumor_Heterogeneity_Agent/ith_analysis.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Tumor Heterogeneity Agent** provides comprehensive analysis of intratumor heterogeneity (ITH) for understanding clonal architecture, tracking subclonal evolution, and predicting therapy resistance. It integrates multi-region sequencing, single-cell data, and longitudinal samples to reconstruct tumor phylogenies and identify actionable subclones.

## When to Use This Skill

* When analyzing multi-region tumor sequencing for clonal architecture.
* For tracking clonal evolution under treatment pressure.
* To predict resistance emergence from subclonal populations.
* When assessing tumor heterogeneity impact on treatment response.
* For integrating single-cell and bulk sequencing for ITH analysis.

## Core Capabilities

1. **Clonal Deconvolution**: Infer clonal populations and their frequencies.

2. **Phylogeny Reconstruction**: Build tumor evolutionary trees from variants.

3. **Subclonal Tracking**: Monitor subclone dynamics over time.

4. **Resistance Prediction**: Identify pre-existing resistant subclones.

5. **Multi-Region Integration**: Combine spatial heterogeneity data.

6. **Single-Cell ITH**: Integrate scDNA-seq for ground-truth clones.

## Heterogeneity Metrics

| Metric | Definition | Clinical Relevance |
|--------|------------|-------------------|
| MATH Score | Mutant-allele tumor heterogeneity | ITH quantification |
| Shannon Index | Clonal diversity | Evolutionary potential |
| Clone Count | Number of distinct clones | Complexity |
| Truncal Fraction | % truncal mutations | Targetability |
| ITH Score | Composite heterogeneity | Prognosis |

## Workflow

1. **Input**: Multi-region/longitudinal WES/WGS, copy number, tumor purity.

2. **Preprocessing**: Variant calling, CNV calling, purity estimation.

3. **CCF Estimation**: Calculate cancer cell fraction for each mutation.

4. **Clustering**: Group mutations into clonal populations.

5. **Phylogeny**: Reconstruct evolutionary tree.

6. **Temporal Analysis**: Track clone dynamics over time.

7. **Output**: Clone structures, phylogenies, heterogeneity metrics.

## Example Usage

**User**: "Analyze the clonal architecture of this multi-region lung tumor sequencing to understand heterogeneity and identify resistant subclones."

**Agent Action**:
```bash
python3 Skills/Oncology/Tumor_Heterogeneity_Agent/ith_analysis.py \
    --multi_region_vcfs region1.vcf,region2.vcf,region3.vcf \
    --cnv_segments cnv_calls.seg \
    --purity 0.7,0.65,0.72 \
    --sample_names Primary,Met1,Met2 \
    --method pyclone-vi \
    --phylogeny_method citup \
    --output ith_analysis/
```

## Deconvolution Methods

| Method | Approach | Best For |
|--------|----------|----------|
| PyClone-VI | Variational inference | Large datasets |
| SciClone | Kernel density | High purity |
| EXPANDS | Probabilistic | Multi-region |
| Canopy | EM algorithm | CNV integration |
| Clonevol | Phylogeny-aware | Longitudinal |
| CITUP | Integer programming | Tree optimization |

## Input Requirements

| Input | Format | Required |
|-------|--------|----------|
| Somatic Variants | VCF with depth | Yes |
| Copy Number | SEG file | Yes |
| Tumor Purity | Float (0-1) | Yes |
| Sample Metadata | TSV | Yes |
| Normal BAM | BAM | Recommended |

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| Clone Assignments | Mutation-to-clone mapping | .csv |
| Clone Frequencies | Per-sample clone fractions | .csv |
| Phylogenetic Tree | Newick and visualization | .nwk, .pdf |
| ITH Metrics | Heterogeneity scores | .json |
| Subclone Variants | Clone-specific mutations | .vcf |
| Evolution Plot | Clone dynamics over time | .png |
| Actionable Subclones | Druggable clone mutations | .csv |

## Clonal Classification

| Clone Type | Definition | Implications |
|------------|------------|--------------|
| Truncal | Present in all samples | Ideal targets |
| Branch | Present in subset | Regional targets |
| Private | Single sample only | Local significance |
| Resistant | Expand under therapy | Resistance mechanism |

## AI/ML Components

**Clone Inference**:
- Variational autoencoders for CCF estimation
- Dirichlet process mixture models
- Graph neural networks for phylogeny

**Resistance Prediction**:
- Time-series models for clone trajectories
- Classification of resistant signatures
- Drug-clone interaction prediction

**Multi-Region Integration**:
- Multi-task learning across regions
- Spatial models for regional patterns
- Transfer learning across cancers

## Clinical Applications

| Application | ITH Insight | Clinical Action |
|-------------|-------------|-----------------|
| Treatment Selection | Truncal vs branch targets | Prioritize truncal targets |
| Resistance Monitoring | Pre-existing resistant clones | Early combination therapy |
| Prognosis | ITH score | Risk stratification |
| Biomarker Development | Clonal biomarkers | Robust biomarker selection |

## Cancer-Specific Patterns

| Cancer Type | Typical ITH | Key Drivers |
|-------------|-------------|-------------|
| Lung (NSCLC) | High | EGFR, KRAS subclonal |
| Breast | Moderate-High | PIK3CA, ESR1 evolution |
| Colorectal | Moderate | KRAS, BRAF clonal |
| Renal | Very High | VHL truncal, diverse branches |
| Melanoma | High | BRAF/NRAS truncal |

## Prerequisites

* Python 3.10+
* PyClone-VI, SciClone
* CITUP, Clonevol
* CNVkit/FACETS for CNV
* R with clonal evolution packages

## Related Skills

* ctDNA_Dynamics_MRD_Agent - Liquid biopsy tracking
* Single_Cell_CNV_Agent - scDNA-seq analysis
* HRD_Analysis_Agent - Genomic instability
* Pan_Cancer_MultiOmics_Agent - Multi-omic integration

## Phylogeny Visualization

| View Type | Shows | Best For |
|-----------|-------|----------|
| Fish Plot | Clone dynamics over time | Longitudinal |
| Tree Diagram | Branching evolution | Multi-region |
| Muller Plot | Population dynamics | Treatment response |
| Clone Map | Spatial distribution | Multi-region spatial |

## Special Considerations

1. **Sampling Bias**: Multi-region captures more heterogeneity
2. **Purity Effects**: Low purity reduces clone resolution
3. **CNV Complexity**: High CNV burden complicates CCF
4. **Single-Cell Validation**: Ground truth from scDNA-seq
5. **Temporal Resolution**: Frequent sampling improves tracking

## Resistance Mechanisms

| Mechanism | Detection | Intervention |
|-----------|-----------|--------------|
| Pre-existing resistant clone | Subclonal at baseline | Combination therapy |
| Acquired resistance | New clone emerges | Switch therapy |
| Phenotypic plasticity | Expression change | Monitor phenotype |
| Microenvironment | TME evolution | Immunotherapy |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->