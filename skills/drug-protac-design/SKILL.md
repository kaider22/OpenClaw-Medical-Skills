---
name: drug-protac-design
description: 提供提出PROTAC组分、连接子和候选排序的方法与调用指南；用于处理靶蛋白结构/序列及已知配体。
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



# PROTAC Design Agent

## Codex 调用

- **选择**：请求涉及“提出PROTAC组分、连接子和候选排序”时使用；显式调用 `$drug-protac-design`。
- **输入**：靶蛋白结构/序列及已知配体。
- **预期产物**：候选结构、复合物模型和ADMET表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Drug_Discovery/PROTAC_Design_Agent/design_protac.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **PROTAC Design Agent** provides AI-assisted design of Proteolysis Targeting Chimeras (PROTACs) for targeted protein degradation. It integrates machine learning for ternary complex prediction, linker design, E3 ligase selection, and ADMET optimization to accelerate degrader drug discovery for oncology and other therapeutic areas.

## When to Use This Skill

* When designing PROTAC degraders for a target protein.
* For optimizing linker chemistry and length.
* To predict ternary complex formation and degradation efficiency.
* When selecting optimal E3 ligase (CRBN, VHL) for the target.
* For optimizing ADMET properties of degrader molecules.

## Core Capabilities

1. **Warhead Selection**: Identify optimal target protein ligands.

2. **E3 Ligase Selection**: Choose CRBN, VHL, or other E3 recruiters.

3. **Linker Design**: Optimize linker length, chemistry, and rigidity.

4. **Ternary Complex Prediction**: Model POI-PROTAC-E3 formation.

5. **Degradation Efficiency Modeling**: Predict DC50 and Dmax.

6. **ADMET Optimization**: Balance potency with drug-like properties.

## PROTAC Components

| Component | Function | Optimization Target |
|-----------|----------|---------------------|
| Warhead | Binds target protein (POI) | Affinity, selectivity |
| E3 Ligand | Recruits E3 ubiquitin ligase | CRBN/VHL binding |
| Linker | Connects warhead to E3 ligand | Length, flexibility, solubility |

## E3 Ligase Options

| E3 Ligase | Ligand | Tissue Expression | Advantages |
|-----------|--------|-------------------|------------|
| CRBN | Thalidomide analogs | Ubiquitous | Well-characterized |
| VHL | VHL ligands | Ubiquitous | High selectivity |
| MDM2 | Nutlin analogs | Variable | p53-independent |
| IAP | SMAC mimetics | High in cancer | Dual mechanism |
| DCAF15 | Indisulam | Variable | Novel chemistry |

## Workflow

1. **Input**: Target protein structure/sequence, known ligands (optional).

2. **Warhead Design**: Generate/optimize POI binding moiety.

3. **E3 Selection**: Choose optimal E3 ligase for target/tissue.

4. **Linker Library**: Generate diverse linker options.

5. **Ternary Complex Modeling**: Predict complex formation.

6. **Ranking**: Score by predicted degradation and ADMET.

7. **Output**: Ranked PROTAC designs with synthesis routes.

## Example Usage

**User**: "Design a PROTAC to degrade BRD4 using CRBN as the E3 ligase, optimizing for oral bioavailability."

**Agent Action**:
```bash
python3 Skills/Drug_Discovery/PROTAC_Design_Agent/design_protac.py \
    --target BRD4 \
    --target_structure pdb:3MXF \
    --warhead_smiles "JQ1_core_smiles" \
    --e3_ligase CRBN \
    --linker_library peg,alkyl,piperdine \
    --linker_length_range 4,12 \
    --optimize_oral true \
    --output protac_designs/
```

## Linker Design Parameters

| Parameter | Options | Consideration |
|-----------|---------|---------------|
| Length | 2-20 atoms | Ternary complex geometry |
| Chemistry | PEG, alkyl, piperazine, triazole | Solubility, stability |
| Rigidity | Flexible vs constrained | Entropic penalty |
| Attachment | Connectivity points | Exit vector matching |
| MW Contribution | Varies | Total MW impact |

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| PROTAC Structures | Designed molecules | .sdf, SMILES |
| Ternary Models | POI-PROTAC-E3 complexes | .pdb |
| Predicted DC50 | Degradation potency | .csv |
| Predicted Dmax | Maximum degradation | .csv |
| ADMET Predictions | Solubility, permeability, etc. | .csv |
| Synthesis Routes | Retrosynthetic analysis | .json |
| Ranking | Prioritized designs | .csv |

## Degradation Efficiency Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| DC50 | Concentration for 50% degradation | <100 nM |
| Dmax | Maximum degradation achieved | >90% |
| Kinetics | Time to half-degradation | <4 hours |
| Selectivity | Off-target degradation | Minimal |
| Hook Effect | High-dose attenuation | Minimal |

## AI/ML Components

**Ternary Complex Prediction**:
- AlphaFold-Multimer adaptation
- Geometric deep learning
- Molecular dynamics validation

**Degradation Modeling**:
- Quantitative degradation prediction
- Transfer learning from degrader databases
- Multi-task learning (DC50, Dmax, kinetics)

**Linker Optimization**:
- Generative models (VAE, diffusion)
- Reinforcement learning
- Multi-objective Bayesian optimization

**ADMET Prediction**:
- Property prediction models
- Chameleonicity assessment
- Oral bioavailability scoring

## Clinical Pipeline Status (2026)

| PROTAC | Target | Phase | E3 Ligase |
|--------|--------|-------|-----------|
| ARV-471 | ER | Phase 3, NDA filed | CRBN |
| ARV-110 | AR | Phase 2 | CRBN |
| BGB-16673 | BTK | Phase 3 | CRBN |
| NX-2127 | BTK | Phase 2 | CRBN |
| KT-474 | IRAK4 | Phase 2 | CRBN |

## Design Considerations

| Factor | PROTAC Challenge | Solution |
|--------|------------------|----------|
| High MW | Poor permeability | Chameleonicity |
| Low Solubility | Limited exposure | Solubilizing groups |
| Hook Effect | Reduced efficacy at high doses | Optimize binding balance |
| E3 Saturation | Competition with other PROTACs | Target expression |

## Prerequisites

* Python 3.10+
* RDKit, Open Babel
* AlphaFold2/3
* Molecular dynamics (GROMACS/OpenMM)
* PyTorch for ML models

## Related Skills

* Molecular_Glue_Discovery_Agent - Glue degraders
* TPD_Ternary_Complex_Agent - Complex prediction
* Molecular_Docking_Agent - Docking analysis
* ADMET_Prediction_Agent - Property prediction

## ADMET Optimization Strategies

| Property | Challenge | Approach |
|----------|-----------|----------|
| Permeability | High MW limits | Intramolecular H-bonds |
| Solubility | Lipophilicity | Polar linker groups |
| Metabolic Stability | Linker metabolism | Stable chemistries |
| Clearance | High metabolism | Optimize logD |

## Special Considerations

1. **Target Suitability**: Not all proteins are degradable
2. **E3 Expression**: Check tissue-specific E3 levels
3. **Ubiquitination Sites**: Surface lysines needed
4. **Resistance**: Target mutations, E3 downregulation
5. **Selectivity**: Validate off-target degradation

## Quality Control Metrics

| QC Check | Threshold | Rationale |
|----------|-----------|-----------|
| Ternary Complex Score | >0.7 | Productive complex |
| Linker Strain | <5 kcal/mol | Favorable geometry |
| ADMET Score | >0.5 | Drug-like properties |
| Synthetic Accessibility | <5 | Feasible synthesis |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->