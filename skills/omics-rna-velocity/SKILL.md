---
name: omics-rna-velocity
description: 提供从剪接计数推断细胞状态转移与分化轨迹的方法与调用指南；用于处理含spliced/unspliced层的scRNA-seq数据。
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



# RNA Velocity Agent

## Codex 调用

- **选择**：请求涉及“从剪接计数推断细胞状态转移与分化轨迹”时使用；显式调用 `$omics-rna-velocity`。
- **输入**：含spliced/unspliced层的scRNA-seq数据。
- **预期产物**：速度向量、轨迹图、驱动基因和latent time；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Genomics/RNA_Velocity_Agent/velocity_analyzer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **RNA Velocity Agent** analyzes RNA velocity from single-cell RNA sequencing to predict cellular state transitions, differentiation trajectories, and dynamic transcriptional regulation. It implements velocyto, scVelo, and deep learning approaches for trajectory inference.

## When to Use This Skill

* When inferring cell fate decisions and differentiation trajectories from scRNA-seq.
* To identify driver genes of cellular transitions.
* For predicting future cell states from current transcriptional profiles.
* When analyzing developmental processes or disease progression dynamics.
* To study cell cycle dynamics and quiescence transitions.

## Core Capabilities

1. **Splicing-Based Velocity**: Calculate RNA velocity from spliced/unspliced transcript ratios.

2. **Dynamic Modeling**: Deep learning models (scVelo dynamical mode) for accurate velocity estimation.

3. **Trajectory Inference**: Project velocity vectors onto UMAP/PCA for differentiation flow visualization.

4. **Driver Gene Identification**: Identify genes driving cell state transitions.

5. **Latent Time Estimation**: Reconstruct cellular pseudotime from velocity fields.

6. **Multi-Modal Velocity**: Integrate protein (CITE-seq) or chromatin (ATAC) velocity.

## RNA Velocity Fundamentals

```
Transcription → Unspliced RNA → Splicing → Spliced (mature) mRNA → Degradation

Velocity = d[spliced]/dt = β[unspliced] - γ[spliced]

- Positive velocity: Gene upregulating
- Negative velocity: Gene downregulating
- Zero velocity: Steady state
```

## Workflow

1. **Input**: scRNA-seq data with spliced/unspliced counts (from STARsolo, velocyto, kallisto-bustools).

2. **Quality Control**: Filter genes by splice detection rates and expression levels.

3. **Velocity Computation**: Calculate velocity using steady-state or dynamical models.

4. **Embedding Projection**: Project velocity onto low-dimensional representations.

5. **Trajectory Analysis**: Identify root cells, terminal states, and differentiation paths.

6. **Driver Analysis**: Rank genes by velocity-based contribution to transitions.

7. **Output**: Velocity vectors, trajectory plots, driver genes, latent time estimates.

## Example Usage

**User**: "Analyze RNA velocity in this hematopoiesis scRNA-seq dataset to map differentiation trajectories."

**Agent Action**:
```bash
python3 Skills/Genomics/RNA_Velocity_Agent/velocity_analyzer.py \
    --adata hematopoiesis.h5ad \
    --spliced_layer spliced \
    --unspliced_layer unspliced \
    --model dynamical \
    --n_top_genes 2000 \
    --identify_roots true \
    --output velocity_results/
```

## Model Comparison

| Model | Method | Best For | Limitations |
|-------|--------|----------|-------------|
| velocyto (steady-state) | Linear regression | Quick overview | Assumes equilibrium |
| scVelo stochastic | Moment-based | General use | Limited dynamics |
| scVelo dynamical | Likelihood-based | Complex trajectories | Computationally intensive |
| UniTVelo | Deep learning | Multi-lineage | Training requirements |
| veloVI | Variational inference | Uncertainty quantification | Complex |

## Key Analyses

**1. Root Cell Identification**
- Cells with high unspliced fractions
- Beginning of differentiation trajectories
- Stem/progenitor populations

**2. Terminal State Detection**
- Cells approaching steady state
- End of velocity streams
- Differentiated cell types

**3. Driver Gene Analysis**
- Genes with high velocity contributions
- Transition-specific regulators
- Transcription factors driving fate decisions

**4. Latent Time**
- Continuous measure of differentiation progress
- Aligns with biological time
- Enables dynamic gene expression modeling

## Quality Control Metrics

| Metric | Threshold | Interpretation |
|--------|-----------|----------------|
| Fraction unspliced | >10% of reads | Adequate capture |
| Genes with velocity | >1000 genes | Sufficient coverage |
| Velocity confidence | >0.8 | Reliable estimates |
| Coherence score | >0.3 | Consistent trajectories |

## Advanced Applications

**Cell Cycle Analysis**:
- Separate velocity due to cell cycle from differentiation
- Identify cycling vs quiescent populations

**Perturbation Effects**:
- Compare velocity between conditions
- Identify acceleration/deceleration of differentiation

**Disease Dynamics**:
- Track progression in tumor samples
- Identify aberrant differentiation paths

## Prerequisites

* Python 3.10+
* scVelo, velocyto
* Scanpy for preprocessing
* GPU recommended for deep learning models

## Related Skills

* Single_Cell - For general scRNA-seq analysis
* Single_Cell_Foundation_Models - For cell annotation
* Spatial_Transcriptomics - For spatial velocity

## Output Visualizations

1. **Velocity Stream Plot**: Arrows on UMAP showing differentiation flow
2. **Phase Portraits**: Spliced vs unspliced for individual genes
3. **Latent Time Coloring**: Cells colored by differentiation progress
4. **Driver Gene Heatmaps**: Top genes driving each transition

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->