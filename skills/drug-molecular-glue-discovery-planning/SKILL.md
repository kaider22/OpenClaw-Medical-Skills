---
name: drug-molecular-glue-discovery-planning
description: 规划分子胶虚拟筛选与三元复合物建模的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# Molecular Glue Discovery Agent

## Codex 调用

- **选择**：请求涉及“规划分子胶虚拟筛选与三元复合物建模”时使用；显式调用 `$drug-molecular-glue-discovery-planning`。
- **输入**：底物、E3连接酶、化合物库和复合物结构。
- **预期产物**：候选分子、底物谱和选择性预测；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Drug_Discovery/Molecular_Glue_Discovery_Agent/discover_glue.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Molecular Glue Discovery Agent** enables AI-driven discovery of molecular glue degraders that induce protein-protein interactions between E3 ligases and neo-substrates for targeted protein degradation. Unlike PROTACs, molecular glues are smaller, more drug-like molecules that can access previously "undruggable" targets through induced proximity mechanisms.

## When to Use This Skill

* When discovering new molecular glue scaffolds.
* For identifying neo-substrate targets for existing glues.
* To design glues for specific E3-substrate pairs.
* When optimizing glue selectivity and potency.
* For virtual screening of glue candidates.

## Core Capabilities

1. **Glue Scaffold Discovery**: Identify novel molecular glue chemotypes.

2. **Neo-Substrate Prediction**: Predict proteins degraded by glues.

3. **Interface Modeling**: Model E3-glue-substrate ternary interfaces.

4. **Selectivity Optimization**: Design for specific substrate profiles.

5. **SAR Analysis**: Structure-activity relationship modeling.

6. **Virtual Screening**: Screen compounds for glue activity.

## Molecular Glue Mechanisms

| Class | E3 Ligase | Mechanism | Example |
|-------|-----------|-----------|---------|
| IMiDs | CRBN | Degron recognition | Lenalidomide |
| CELMoDs | CRBN | Enhanced IKZF binding | Iberdomide |
| DCAF15 Glues | DCAF15 | Splicing factor degradation | Indisulam |
| CDK12 Glues | DDB1-CRBN | Cyclin K degradation | CR8 derivatives |
| β-catenin Glues | Novel | WNT pathway targets | Emerging |

## Key Neo-Substrates

| Substrate | Glue Class | Disease Relevance |
|-----------|------------|-------------------|
| IKZF1/3 | IMiDs | Multiple myeloma |
| CK1α | Lenalidomide | MDS del(5q) |
| GSPT1 | CC-885 | AML |
| RBM39 | Indisulam | Solid tumors |
| Cyclin K | CR8 | Cancer |
| SALL4 | Thalidomide | Teratogenicity |

## Workflow

1. **Input**: Target substrate, E3 ligase, screening library.

2. **Interface Analysis**: Model E3 surface and potential binding sites.

3. **Virtual Screening**: Screen compounds for interface binding.

4. **Glue Scoring**: Predict neo-substrate recruitment potential.

5. **Selectivity Analysis**: Predict off-target degradation.

6. **Optimization**: Iterative design for potency/selectivity.

7. **Output**: Ranked glue candidates with predicted profiles.

## Example Usage

**User**: "Discover molecular glues that degrade IKZF1 through CRBN with improved selectivity over IKZF3."

**Agent Action**:
```bash
python3 Skills/Drug_Discovery/Molecular_Glue_Discovery_Agent/discover_glue.py \
    --target_substrate IKZF1 \
    --e3_ligase CRBN \
    --selectivity_against IKZF3 \
    --scaffold_library imid_derivatives.sdf \
    --interface_model crbn_ikzf1_complex.pdb \
    --n_candidates 100 \
    --output glue_discovery/
```

## Glue Design Parameters

| Parameter | Consideration | Optimization |
|-----------|---------------|--------------|
| Interface Complementarity | E3-substrate fit | Shape/electrostatics |
| Degron Recognition | Substrate degron motifs | Motif compatibility |
| Binding Cooperativity | Positive cooperativity | Enhanced ternary |
| Selectivity | Off-target degradation | Substrate specificity |
| Drug Properties | MW, solubility, permeability | Standard optimization |

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| Glue Candidates | Ranked molecules | .sdf, SMILES |
| Predicted Substrates | Neo-substrate profiles | .csv |
| Interface Models | Ternary complex structures | .pdb |
| Selectivity Scores | On-target vs off-target | .csv |
| Degradation Predictions | DC50, Dmax estimates | .csv |
| SAR Analysis | Structure-activity trends | .json |

## AI/ML Components

**Interface Prediction**:
- Protein-protein docking
- Molecular surface analysis
- Deep learning interface scoring

**Neo-Substrate Discovery**:
- Degron motif prediction
- Proteome-wide screening
- Structural similarity to known substrates

**Glue Optimization**:
- Generative chemistry
- Multi-objective optimization
- Active learning for synthesis prioritization

## Glue vs PROTAC Comparison

| Feature | Molecular Glue | PROTAC |
|---------|----------------|--------|
| Molecular Weight | <500 Da | 700-1500 Da |
| Target Discovery | Serendipitous/AI | Rational |
| Selectivity | Can be exquisite | Often broader |
| Substrate Range | Induced neo-substrates | Direct binders |
| Oral Bioavailability | Generally better | Challenging |

## Clinical Pipeline (2026)

| Drug | Mechanism | Target | Phase |
|------|-----------|--------|-------|
| Iberdomide (CC-220) | CELMoD | IKZF1/3, Aiolos | Phase 3 |
| Mezigdomide (CC-92480) | CELMoD | IKZF1/3 | Phase 3 |
| Golcadomide (CC-99282) | CELMoD | IKZF1/3 | Phase 2 |
| CFT7455 | IKZF1/3 | IKZF1/3 | Phase 1 |

## Degron Motif Analysis

| Degron Type | Sequence Features | E3 Recognition |
|-------------|-------------------|----------------|
| Zinc Finger | C2H2 ZF domain | CRBN-IMiD |
| Phosphodegron | pSer/pThr motifs | SCF E3s |
| N-degron | N-terminal residues | UBR1/2 |
| Hydrophobic | Exposed hydrophobics | Quality control |

## Prerequisites

* Python 3.10+
* RDKit, Molecular modeling tools
* AlphaFold2/3, docking software
* Deep learning frameworks
* Protein structure databases

## Related Skills

* PROTAC_Design_Agent - Bifunctional degraders
* TPD_Ternary_Complex_Agent - Complex modeling
* Virtual_Screening_Agent - High-throughput screening
* Protein_Protein_Docking_Agent - PPI modeling

## Discovery Strategies

| Strategy | Approach | Success Examples |
|----------|----------|------------------|
| Phenotypic Screening | Degradation readout | IMiDs, indisulam |
| Target-Based | E3-substrate docking | Rational glues |
| Chemoproteomics | Pull-down identification | Neo-substrate discovery |
| AI-Guided | Computational prediction | Emerging |

## Special Considerations

1. **Polypharmacology**: Glues often degrade multiple substrates
2. **Species Differences**: Neo-substrates may differ across species
3. **Resistance**: Substrate mutations, E3 downregulation
4. **Toxicity**: Off-target degradation (e.g., SALL4)
5. **Hook Effect**: Less common than PROTACs

## Quality Control

| Metric | Purpose | Threshold |
|--------|---------|-----------|
| Interface Score | Complex stability | >0.6 |
| Cooperativity | Enhanced binding | >1.5 |
| Selectivity Index | On/off-target ratio | >10 |
| Drug-likeness | Developability | Lipinski compliant |

## Future Directions

| Direction | Status | Potential |
|-----------|--------|-----------|
| New E3 Ligases | Active research | Expanded target space |
| Protein-Protein Glues | Emerging | Beyond degradation |
| AI-First Discovery | Advancing | Reduced serendipity |
| Combination Glues | Conceptual | Multi-target degradation |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->