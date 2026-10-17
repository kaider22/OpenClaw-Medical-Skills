---
name: omics-cryoem-ai-drug-design
description: 整合冷冻电镜密度、结构预测和动力学设计配体的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# Cryo-EM AI Drug Design Agent

## Codex 调用

- **选择**：请求涉及“整合冷冻电镜密度、结构预测和动力学设计配体”时使用；显式调用 `$omics-cryoem-ai-drug-design`。
- **输入**：MRC密度图、蛋白序列、分辨率和配体库。
- **预期产物**：配体构象、结合评分、MD轨迹和设计报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Structural_Biology/CryoEM_AI_Drug_Design_Agent/design_from_cryoem.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **Cryo-EM AI Drug Design Agent** integrates cryo-electron microscopy structural data with AlphaFold3, generative AI, and molecular dynamics for structure-based drug design. It enables targeting of previously "undruggable" proteins including flexible, membrane-bound, and large macromolecular complexes through high-resolution structure-guided optimization.

## When to Use This Skill

* When designing drugs against cryo-EM-solved targets.
* For fragment-based drug discovery with EM structures.
* To model ligand binding in flexible protein regions.
* When targeting membrane proteins and large complexes.
* For integrating AlphaFold predictions with experimental EM density.

## Core Capabilities

1. **Density-Guided Design**: Fit ligands into cryo-EM density maps.

2. **AlphaFold Integration**: Combine AF3 predictions with EM data.

3. **Flexible Docking**: Account for protein dynamics in binding.

4. **Fragment Screening**: Virtual fragment screening with EM structures.

5. **Complex Targeting**: Design for multi-protein assemblies.

6. **Dynamics-Based Design**: Incorporate conformational flexibility.

## Cryo-EM for Drug Discovery

| Target Class | Cryo-EM Advantage | Drug Discovery Application |
|--------------|-------------------|---------------------------|
| GPCRs | Native lipid environment | Allosteric sites |
| Ion Channels | Multiple conformations | State-specific design |
| Transporters | Conformational states | Mechanism-based |
| Ribosomes | Antibiotic binding | New antibiotics |
| Viral Proteins | Large assemblies | Vaccines, antivirals |
| Intrinsically Disordered | Flexible regions | Challenging targets |

## Workflow

1. **Input**: Cryo-EM density map, protein sequence, ligand/fragment.

2. **Structure Refinement**: AlphaFold + density-guided refinement.

3. **Binding Site Identification**: Detect pockets in EM structure.

4. **Ligand Placement**: Density-guided ligand fitting.

5. **MD Simulation**: Flexible binding simulation.

6. **Optimization**: Generative design around hits.

7. **Output**: Optimized ligands, binding models, design recommendations.

## Example Usage

**User**: "Design ligands for this GPCR cryo-EM structure, accounting for receptor flexibility in the binding pocket."

**Agent Action**:
```bash
python3 Skills/Structural_Biology/CryoEM_AI_Drug_Design_Agent/design_from_cryoem.py \
    --density_map gpcr_3.2A.mrc \
    --protein_sequence gpcr.fasta \
    --alphafold_model gpcr_af2.pdb \
    --resolution 3.2 \
    --ligand_screening fragment_library.sdf \
    --binding_site_residues "3.32,5.46,6.48,7.39" \
    --md_refinement true \
    --generative_optimization true \
    --output gpcr_drug_design/
```

## Input Requirements

| Input | Format | Purpose |
|-------|--------|---------|
| Density Map | MRC/MAP | EM density |
| Protein Sequence | FASTA | AlphaFold input |
| Resolution | Float (Å) | Quality metric |
| Ligand Library | SDF | Virtual screening |
| Known Ligand | Optional SDF | Starting point |

## Output Components

| Output | Description | Format |
|--------|-------------|--------|
| Refined Structure | EM + AF combined | .pdb |
| Ligand Poses | Density-fitted poses | .sdf |
| Binding Scores | Affinity predictions | .csv |
| Optimized Compounds | Generative designs | .sdf |
| MD Trajectory | Flexibility analysis | .xtc |
| Design Report | Recommendations | .pdf |

## AI/ML Components

**Structure Prediction**:
- AlphaFold3 for initial model
- Density-guided refinement
- Confidence scoring (pLDDT, local resolution)

**Ligand Design**:
- Generative AI (diffusion, VAE)
- Reinforcement learning optimization
- Multi-objective scoring

**Dynamics Integration**:
- Molecular dynamics simulation
- Ensemble docking
- Flexibility-aware scoring

## Resolution Considerations

| Resolution | Applications | Limitations |
|------------|--------------|-------------|
| <3.0 Å | Fragment screening, detailed design | Rare |
| 3.0-4.0 Å | Drug optimization, binding mode | Most targets |
| 4.0-5.0 Å | Pocket identification, scaffold | Less detail |
| >5.0 Å | Architecture, general binding | Low for SBDD |

## AlphaFold3 + Cryo-EM Integration

| Scenario | Approach | Benefit |
|----------|----------|---------|
| Missing Loops | AF3 prediction | Complete structure |
| Flexible Regions | Ensemble models | Multiple conformations |
| Low Resolution | AF3 template | Higher confidence |
| Ligand Binding | AF3 complex prediction | Binding mode |

## Prerequisites

* Python 3.10+
* AlphaFold3, ChimeraX
* GROMACS/OpenMM for MD
* RDKit, AutoDock Vina
* GPU with 16GB+ VRAM

## Related Skills

* Time_Resolved_CryoEM_Agent - Dynamics from EM
* PROTAC_Design_Agent - Degrader design
* Molecular_Glue_Discovery_Agent - Glue design
* AlphaFold3_Agent - Structure prediction

## Fragment-Based Discovery with Cryo-EM

| Step | Method | Cryo-EM Role |
|------|--------|--------------|
| Fragment Screening | Virtual dock to EM | Density-guided |
| Hit Identification | Cryo-EM soaking | Experimental validation |
| Fragment Growing | EM + modeling | Structure guidance |
| Lead Optimization | Iterative EM | Binding mode confirmation |

## Membrane Protein Targets

| Target Type | Cryo-EM Advantage | Examples |
|-------------|-------------------|----------|
| GPCRs | Native membrane | Numerous drugs |
| Ion Channels | State-dependent | Painkillers, antiepileptics |
| Transporters | Mechanism insight | Cancer, infection |
| Receptors | Complex structures | Immunotherapy |

## Special Considerations

1. **Resolution Limits**: Design confidence depends on resolution
2. **Map Quality**: Local resolution varies across structure
3. **Conformational States**: Multiple states may be captured
4. **Ligand Density**: May be weak at lower resolution
5. **Validation**: Experimental validation essential

## Quality Metrics

| Metric | Purpose | Threshold |
|--------|---------|-----------|
| Global Resolution | Overall quality | <4.0 Å for SBDD |
| Local Resolution | Binding site quality | <3.5 Å preferred |
| Map Correlation | Model-to-map fit | >0.8 |
| Real-Space R | Atomic fit | <0.3 |
| Ligand CCC | Ligand fit | >0.6 |

## Drug Discovery Success Stories

| Drug | Target | Cryo-EM Role |
|------|--------|--------------|
| Numerous | GPCRs | Structure determination |
| Antibiotics | Ribosome | Binding mode |
| Antivirals | Spike protein | Epitope mapping |
| Various | Ion channels | State-specific design |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->