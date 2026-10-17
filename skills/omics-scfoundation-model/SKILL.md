---
name: omics-scfoundation-model
description: 提供规划单细胞基础模型的注释、扰动和网络推断的方法与调用指南；用于处理AnnData、模型权重、参考数据及任务参数。
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



# scFoundation Model Agent

## Codex 调用

- **选择**：请求涉及“规划单细胞基础模型的注释、扰动和网络推断”时使用；显式调用 `$omics-scfoundation-model`。
- **输入**：AnnData、模型权重、参考数据及任务参数。
- **预期产物**：注释h5ad、扰动预测、GRN或整合嵌入；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **外部/示例入口**：`Skills/Genomics/scFoundation_Model_Agent/foundation_predict.py`、`foundation_predict.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

The **scFoundation Model Agent** provides a unified interface to leverage state-of-the-art single-cell foundation models for diverse downstream tasks. It integrates scGPT, scBERT, Geneformer, scFoundation, and emerging models to enable cross-species cell annotation, in silico perturbation prediction, gene regulatory network inference, and batch integration.

## When to Use This Skill

* When annotating cell types across species (human, mouse, cross-species).
* For predicting perturbation effects (knockouts, drug treatments) in silico.
* To infer gene regulatory networks from single-cell data.
* When integrating batches without losing biological signal.
* For generating cell embeddings for downstream analysis.

## Core Capabilities

1. **Cross-Species Cell Annotation**: Transfer cell type labels across species using unified embeddings.

2. **In Silico Perturbation**: Predict gene expression changes from knockouts/treatments.

3. **Gene Regulatory Network Inference**: Discover TF-target relationships from attention patterns.

4. **Batch Integration**: Remove technical variation while preserving biology.

5. **Cell Embedding Generation**: Generate universal cell representations for any downstream task.

6. **Multi-Model Ensemble**: Combine predictions from multiple foundation models.

## Supported Foundation Models

| Model | Parameters | Training Data | Strengths |
|-------|------------|---------------|-----------|
| scGPT | 50M | 33M human cells | General purpose, perturbations |
| Geneformer | 10M | 30M cells | Chromatin, gene networks |
| scBERT | 20M | 1.2M cells | Cell type annotation |
| scFoundation | 100M | 50M cells | Large-scale, multi-species |
| scTab | 15M | 22M cells | Tabular prediction |
| UCE (Universal Cell Embeddings) | 100M | 36M cells | Cross-species transfer |

## Workflow

1. **Input**: Single-cell RNA-seq data (AnnData format).

2. **Model Selection**: Choose appropriate model(s) for task.

3. **Preprocessing**: Tokenize genes, normalize expression.

4. **Inference**: Generate embeddings or predictions.

5. **Task Execution**: Annotation, perturbation, or network inference.

6. **Ensemble (Optional)**: Combine multi-model predictions.

7. **Output**: Annotated data, predictions, networks.

## Example Usage

**User**: "Use scGPT to predict the effect of CRISPR knockout of TP53 on these cancer cells."

**Agent Action**:
```bash
python3 Skills/Genomics/scFoundation_Model_Agent/foundation_predict.py \
    --input cancer_cells.h5ad \
    --model scgpt \
    --task perturbation \
    --perturbation "TP53 knockout" \
    --model_checkpoint scgpt_human_gene_v1.pt \
    --output tp53_ko_predictions.h5ad
```

## Task-Specific Usage

### Cell Type Annotation
```bash
python3 foundation_predict.py \
    --input query_cells.h5ad \
    --model geneformer \
    --task annotation \
    --reference tabula_sapiens.h5ad \
    --output annotated_cells.h5ad
```

### Gene Network Inference
```bash
python3 foundation_predict.py \
    --input cells.h5ad \
    --model scgpt \
    --task grn_inference \
    --transcription_factors tf_list.txt \
    --output gene_network.csv
```

### Batch Integration
```bash
python3 foundation_predict.py \
    --input multi_batch.h5ad \
    --model scfoundation \
    --task integration \
    --batch_key batch \
    --output integrated.h5ad
```

## Output Formats

| Task | Output | Format |
|------|--------|--------|
| Annotation | Cell type labels | .h5ad obs column |
| Perturbation | Predicted expression | .h5ad layer |
| GRN | TF-target edges | .csv, .graphml |
| Integration | Corrected embeddings | .h5ad obsm |
| Embeddings | Cell representations | .h5ad obsm |

## Performance Benchmarks

| Task | Model | Dataset | Performance |
|------|-------|---------|-------------|
| Annotation | scGPT | Tabula Sapiens | 93% accuracy |
| Annotation | Geneformer | HLCA | 91% accuracy |
| Perturbation (R²) | scGPT | Norman 2019 | 0.87 |
| Integration (kBET) | scFoundation | Multi-atlas | 0.92 |
| Cross-species | UCE | Human→Mouse | 85% F1 |

## AI/ML Architecture

**Transformer Backbone**:
- Gene-level tokenization
- Attention-based gene interactions
- Masked expression prediction pretraining

**Perturbation Module**:
- Conditional generation
- Counterfactual prediction
- Dose-response modeling

**Transfer Learning**:
- Zero-shot annotation
- Few-shot fine-tuning
- Domain adaptation

## Prerequisites

* Python 3.10+
* PyTorch 2.0+
* transformers, flash-attn
* Scanpy, AnnData
* Model-specific weights
* GPU with 16GB+ VRAM

## Related Skills

* Nicheformer_Spatial_Agent - For spatial foundation models
* scGPT_Agent - Dedicated scGPT workflows
* Cell_Type_Annotation - Traditional annotation methods
* Pathway_Analysis - Gene set enrichment

## Model Selection Guide

| Use Case | Recommended Model | Reason |
|----------|-------------------|--------|
| General annotation | scGPT | Broad training, robust |
| Cross-species | UCE | Species-agnostic embeddings |
| Perturbation | scGPT | Best perturbation performance |
| GRN inference | Geneformer | Attention → regulatory links |
| Large-scale | scFoundation | Efficient, scalable |
| Tabular prediction | scTab | Optimized for classification |

## Special Considerations

1. **Gene Coverage**: Models trained on variable gene sets; check overlap
2. **Species**: Some models human-only; use UCE for cross-species
3. **Compute**: Large models need significant GPU memory
4. **Fine-Tuning**: Task-specific fine-tuning improves performance
5. **Versioning**: Model weights update frequently; track versions

## Ensemble Strategies

| Strategy | Method | Benefit |
|----------|--------|---------|
| Majority Vote | Mode of predictions | Robust to outliers |
| Weighted Average | Confidence-weighted | Leverages uncertainty |
| Stacking | Meta-model | Learns model strengths |
| Attention Fusion | Cross-model attention | Deep integration |

## Author

AI Group - Biomedical AI Platform


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->