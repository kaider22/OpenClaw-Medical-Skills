---
name: drug-nk-cell-therapy-planning
description: 提供规划CAR-NK构建、KIR/HLA匹配和扩增方案的方法与调用指南；用于处理靶抗原、肿瘤类型、NK来源及供者HLA/KIR。
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



# NK Cell Therapy Agent

## Codex 调用

- **选择**：请求涉及“规划CAR-NK构建、KIR/HLA匹配和扩增方案”时使用；显式调用 `$drug-nk-cell-therapy-planning`。
- **输入**：靶抗原、肿瘤类型、NK来源及供者HLA/KIR。
- **预期产物**：CAR设计、供者候选、培养方案和QC指标；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Immunology_Vaccines/NK_Cell_Therapy_Agent/nk_designer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **NK Cell Therapy Agent** provides AI-driven design and optimization of natural killer cell therapies for cancer treatment. It covers CAR-NK engineering, cytokine-induced memory-like (CIML) NK generation, KIR/HLA matching, and NK cell expansion optimization.

## When to Use This Skill

* When designing CAR-NK constructs for tumor targeting.
* To optimize KIR/HLA mismatch for allogeneic NK therapy.
* For generating memory-like NK cells with enhanced persistence.
* When predicting NK cell activation against specific tumor types.
* To analyze NK cell receptor repertoires and function.

## Core Capabilities

1. **CAR-NK Design**: Design chimeric antigen receptors optimized for NK cell biology (NK-specific signaling domains).

2. **KIR/HLA Matching**: Predict KIR-HLA interactions for donor selection in allogeneic therapy.

3. **Memory-Like NK Generation**: Optimize CIML protocol with IL-12/15/18 cytokine preactivation.

4. **Expansion Optimization**: ML models for feeder-free NK expansion conditions.

5. **Tumor Target Prediction**: Match NK receptor profiles to tumor ligand expression.

6. **Persistence Enhancement**: Engineering strategies for improved in vivo survival.

## NK Cell Advantages Over T Cells

| Feature | NK Cells | T Cells |
|---------|----------|---------|
| MHC requirement | No | Yes |
| Allogeneic use | Yes (no GVHD) | Limited (GVHD risk) |
| CRS risk | Lower | Higher |
| Off-the-shelf | Yes | Autologous typical |
| Antigen escape | Multiple receptors | Single CAR |
| Persistence | Shorter | Longer |

## CAR-NK Architecture

```
[scFv] - [Hinge] - [Transmembrane] - [Costimulatory] - [Signaling]

NK-Optimized Domains:
- Transmembrane: NKG2D, CD8α, or CD28
- Costimulatory: 2B4, DAP10, or CD28
- Signaling: CD3ζ (with NK-specific adaptations)
- Additional: Cytokine secretion (IL-15), suicide switch
```

## Workflow

1. **Input**: Target antigen, tumor type, NK source (PB, UCB, iPSC, cell line).

2. **CAR Design**: Generate optimized CAR-NK construct sequence.

3. **KIR Analysis**: Determine KIR genotype and HLA matching for donors.

4. **Activation Protocol**: Optimize cytokine cocktail for desired phenotype.

5. **Expansion**: Design feeder-based or feeder-free expansion protocol.

6. **Quality Prediction**: Predict NK product functionality.

7. **Output**: CAR sequence, donor recommendations, expansion protocol, QC metrics.

## Example Usage

**User**: "Design a CAR-NK targeting CD19 for B-cell malignancies with enhanced persistence."

**Agent Action**:
```bash
python3 Skills/Immunology_Vaccines/NK_Cell_Therapy_Agent/nk_designer.py \
    --target CD19 \
    --tumor_type b_cell_lymphoma \
    --nk_source ucb \
    --persistence_strategy il15_secretion \
    --costimulatory 2B4_DAP10 \
    --donors donor_hla_kir.json \
    --output carnk_design/
```

## NK Receptor-Ligand Interactions

**Activating Receptors**:

| Receptor | Ligands | Tumor Expression |
|----------|---------|------------------|
| NKG2D | MICA/B, ULBPs | Stress-induced |
| DNAM-1 | CD155, CD112 | Broadly expressed |
| NKp30 | B7-H6, BAG6 | Tumor-specific |
| NKp46 | Unknown tumor | Variable |
| CD16 | IgG Fc | ADCC trigger |

**Inhibitory Receptors**:

| Receptor | Ligands | Function |
|----------|---------|----------|
| KIR2DL1 | HLA-C2 | Self tolerance |
| KIR2DL2/3 | HLA-C1 | Self tolerance |
| KIR3DL1 | HLA-Bw4 | Self tolerance |
| NKG2A | HLA-E | Checkpoint |

## Memory-Like NK (CIML) Protocol

**Cytokine Preactivation**:
- IL-12 (10 ng/mL) + IL-15 (50 ng/mL) + IL-18 (50 ng/mL)
- 16-18 hour stimulation
- Enhanced IFN-γ, cytotoxicity upon restimulation
- Improved in vivo persistence

**Clinical Evidence**: Effective in relapsed/refractory AML

## KIR/HLA Matching Optimization

**Missing-Self Recognition**:
- Donor KIR + / Patient HLA -
- Enhanced NK cytotoxicity
- Important for allo-HSCT

**Prediction Model**:
- Input: Donor KIR genotype, patient HLA
- Output: Predicted NK alloreactivity score
- Validated in transplant outcomes

## AI/ML Components

**CAR-NK Optimization**:
- Adapted CARMSeD for NK biology
- NK-specific signaling domain preferences
- Tonic signaling prediction

**Expansion Prediction**:
- Fold-expansion from culture conditions
- Phenotype shift modeling
- Exhaustion marker prediction

## Prerequisites

* Python 3.10+
* HLA/KIR databases
* NK receptor databases
* Flow cytometry analysis tools

## Related Skills

* CART_Design_Optimizer_Agent - For CAR engineering principles
* Epitope_Prediction_Agent - For target selection
* Flow_Cytometry_AI - For NK phenotyping

## Clinical Development

**Current CAR-NK Programs**:
- CD19 CAR-NK (MD Anderson - AML, lymphoma)
- NKG2D CAR-NK (various solid tumors)
- CD70 CAR-NK (renal cell carcinoma)
- HER2 CAR-NK (breast cancer)

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->