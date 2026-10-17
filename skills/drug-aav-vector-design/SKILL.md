---
name: drug-aav-vector-design
description: 规划AAV衣壳、启动子与基因载荷设计的任务规划指南。仓库未提供完整执行入口，不能把方案说明当成已运行结果。
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



# AAV Vector Design Agent

## Codex 调用

- **选择**：请求涉及“规划AAV衣壳、启动子与基因载荷设计”时使用；显式调用 `$drug-aav-vector-design`。
- **输入**：靶组织、治疗基因和患者特征。
- **预期产物**：载体构型、免疫原性与制造建议；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：先完成任务规划和输入核对。原文的模型/脚本示例没有完整随附实现；需要实际计算时必须先提供相应实现和运行条件，缺少时记录 `BLOCKED`。
- **外部/示例入口**：`Skills/Gene_Therapy/AAV_Vector_Design_Agent/aav_designer.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **AAV Vector Design Agent** provides AI-driven design of adeno-associated virus vectors for gene therapy applications. It covers capsid selection and engineering, promoter/enhancer design, transgene optimization, and manufacturing considerations.

## When to Use This Skill

* When selecting optimal AAV serotype for tissue-specific targeting.
* To design novel capsid variants with enhanced properties.
* For optimizing transgene expression cassettes.
* When predicting immunogenicity and neutralizing antibody escape.
* To design liver-detargeted or CNS-tropic vectors.

## Core Capabilities

1. **Capsid Selection**: Match AAV serotype to target tissue based on tropism profiles.

2. **Capsid Engineering**: Design modified capsids for enhanced transduction or immune evasion.

3. **Promoter Design**: Select and optimize tissue-specific or ubiquitous promoters.

4. **Transgene Optimization**: Codon optimization and regulatory element design.

5. **Immunogenicity Prediction**: Predict NAb binding and T-cell epitopes.

6. **Manufacturing Assessment**: Evaluate producibility and purification considerations.

## AAV Serotype Tropism

| Serotype | Primary Tropism | Clinical Use |
|----------|-----------------|--------------|
| AAV1 | Muscle, CNS | Glybera (muscle) |
| AAV2 | Broad (liver, muscle) | Luxturna (retina) |
| AAV5 | CNS, liver, retina | Hemgenix (liver) |
| AAV8 | Liver, muscle | Multiple trials |
| AAV9 | CNS, cardiac, liver | Zolgensma (CNS) |
| AAVrh10 | CNS, liver | CNS trials |
| AAVrh74 | Muscle | Elevidys (muscle) |
| AAV-PHP.eB | CNS (mouse) | Research |

## Workflow

1. **Input**: Target tissue, therapeutic gene, patient population characteristics.

2. **Capsid Selection**: Rank serotypes by tropism profile match.

3. **Capsid Engineering**: Design modifications if needed (peptide insertion, point mutations).

4. **Cassette Design**: Optimize ITR-to-ITR expression cassette.

5. **Immunogenicity Analysis**: Predict NAb prevalence and T-cell epitopes.

6. **Manufacturing Review**: Assess production feasibility.

7. **Output**: Complete vector design with rationale.

## Example Usage

**User**: "Design an AAV vector for liver-directed gene therapy in hemophilia B with low immunogenicity."

**Agent Action**:
```bash
python3 Skills/Gene_Therapy/AAV_Vector_Design_Agent/aav_designer.py \
    --target_tissue liver \
    --therapeutic_gene F9 \
    --indication hemophilia_b \
    --minimize_immunogenicity true \
    --nab_escape true \
    --promoter liver_specific \
    --output aav_design/
```

## Expression Cassette Components

```
5' ITR - [Promoter] - [5' UTR] - [Transgene] - [WPRE] - [PolyA] - 3' ITR

Packaging limit: ~4.7 kb between ITRs
```

**Promoter Options**:
| Promoter | Type | Size | Application |
|----------|------|------|-------------|
| CAG | Ubiquitous | 1.7 kb | Strong expression |
| EF1α | Ubiquitous | 1.2 kb | Constitutive |
| LP1 | Liver-specific | 0.5 kb | Hepatocyte targeting |
| hSyn | Neuron-specific | 0.5 kb | CNS applications |
| MCK | Muscle-specific | 0.6 kb | Myopathies |
| CMV | Ubiquitous | 0.6 kb | High initial (silenced) |

## Capsid Engineering Strategies

**Directed Evolution**:
- Error-prone PCR libraries
- DNA shuffling
- Selection in target tissue

**Rational Design**:
- Peptide display (insertion in variable loops)
- Point mutations for receptor targeting
- Tyrosine-to-phenylalanine for stability

**Machine Learning**:
- Sequence-function models
- Generative models for novel capsids
- Tropism prediction

## Immunogenicity Considerations

**Pre-existing NAbs**:
| Serotype | NAb Prevalence |
|----------|----------------|
| AAV2 | 30-60% |
| AAV5 | 15-30% |
| AAV8 | 15-25% |
| AAV9 | 20-35% |

**Mitigation Strategies**:
- Serotype selection based on patient screening
- Engineered NAb-evading capsids
- Immunosuppression protocols
- Plasmapheresis

## AI/ML Components

**Tropism Prediction**:
- CNN on capsid sequence
- Cell-type specific transduction
- Cross-species translation

**Immunogenicity Modeling**:
- MHC binding prediction
- T-cell epitope mapping
- NAb epitope prediction

**Expression Optimization**:
- Codon optimization algorithms
- RNA structure prediction
- miRNA target site avoidance

## Manufacturing Considerations

| Factor | Impact | Optimization |
|--------|--------|--------------|
| Capsid yield | Production cost | Sequence modifications |
| Empty/full ratio | Potency | Purification method |
| Aggregation | Stability | Formulation |
| DNA packaging | Transgene size | Cassette design |

## Prerequisites

* Python 3.10+
* Sequence analysis tools
* Immunoinformatics packages
* Structural biology tools

## Related Skills

* CRISPR_Design_Agent - For gene editing payloads
* Protein_Engineering - For capsid design
* RNA_Therapeutics - For alternative modalities

## Regulatory Considerations

1. **Biodistribution**: Required for IND
2. **Shedding**: Vector in bodily fluids
3. **Germline transmission**: Gonadal presence
4. **Integration risk**: Random vs site-specific
5. **Immunogenicity**: Pre-existing and induced

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->