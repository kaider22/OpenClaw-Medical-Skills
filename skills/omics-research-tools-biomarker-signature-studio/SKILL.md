---
name: omics-research-tools-biomarker-signature-studio
description: 筛选并评估可解释的多组学生物标志物；用于处理表达矩阵、标签元数据及可选生存字段。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: scikit-learn
    depends_on:
    - omics-machine-learning-biomarker-discovery
    - omics-machine-learning-model-validation
    - omics-machine-learning-omics-classifiers
    - omics-de-results
    - sop-omics-biomarker-pipeline
    measurable_outcome: Run biomarker_signature_studio.py end-to-end on provided data within 20 minutes and produce metrics + feature rankings JSON artifacts.
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


# Biomarker Signature Studio

## Codex 调用

- **选择**：请求涉及“筛选并评估可解释的多组学生物标志物”时使用；显式调用 `$omics-research-tools-biomarker-signature-studio`。
- **输入**：表达矩阵、标签元数据及可选生存字段。
- **预期产物**：嵌套CV指标、特征排名、SHAP和生存JSON；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scripts/biomarker_signature_studio.py](scripts/biomarker_signature_studio.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`boruta`、`lifelines`、`mrmr`、`numpy`、`pandas`、`scikit-learn`、`shap`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **流程依赖**：[omics-machine-learning-biomarker-discovery](../omics-machine-learning-biomarker-discovery/SKILL.md) → [omics-machine-learning-model-validation](../omics-machine-learning-model-validation/SKILL.md) → [omics-machine-learning-omics-classifiers](../omics-machine-learning-omics-classifiers/SKILL.md) → [omics-de-results](../omics-de-results/SKILL.md) → [sop-omics-biomarker-pipeline](../sop-omics-biomarker-pipeline/SKILL.md)。依赖所需数据或环境缺失时停止对应阶段，不把后续阶段标为通过。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Design validated biomarker panels that are explainable, stable, and ready for translational follow-up. This skill stitches together the existing biomarker pipeline tooling, adds configurable feature-selection ensembles, a small survival-analysis hook, and artifact export so downstream lab teams can review QC outputs.

## What This Skill Does

1. **QC + Harmonization:** Align expression matrices (samples x features) with metadata, check label balance, and compute summary stats.
2. **Feature Selection Ensemble:** Supports Boruta, elastic-net stability, mutual-information top-K, and mRMR with optional intersection voting.
3. **Model Factory:** Trains multiple estimators (Logistic L1, RandomForest, XGBoost if present) under nested CV, picks champion by AUC.
4. **Explainability + Export:** Produces SHAP tables/plots when packages are available, exports feature rankings and model weights.
5. **Survival Hook:** If metadata contains `time_to_event` and `event` the skill computes concordance for selected features via Cox model.

All logic lives in `scripts/biomarker_signature_studio.py`.

## Inputs

- Expression matrix (`--expression`): CSV/TSV genes x samples or samples x genes (auto-detected by metadata match).
- Metadata (`--metadata`): Must contain `--label-column`. Optional `--id-column` (default `sample_id`), `time_to_event`, `event`.
- Optional gene list for filtering (`--feature-list`).
- Output directory (`--output-dir`), created if missing.

## Quick CLI Usage

```bash
python scripts/biomarker_signature_studio.py \
  --expression data/expression.csv \
  --metadata data/metadata.csv \
  --label-column phenotype \
  --selectors boruta,lasso,mrmr \
  --models rf,logit \
  --output-dir outputs/biomarkers_run1
```

Key flags:

| Flag | Description |
|------|-------------|
| `--selectors` | Comma list of selection strategies (`boruta`, `lasso`, `mrmr`, `mi_topk`). |
| `--models` | Models to evaluate (`logit`, `rf`, `xgb`). |
| `--k-features` | Target number of features for `mrmr`/`mi_topk`. |
| `--survival` | Enable Cox evaluation when survival columns exist. |
| `--random-state` | Reproducibility. |
| `--nested-folds` | Outer CV folds (default 5). |

## Workflow

1. Load + align inputs, infer orientation, impute missing values.
2. Standardize features (fit on train set only).
3. Run requested selectors; create intersection + union candidate lists.
4. For each selector output run nested CV training across requested models.
5. Export champion metrics (`metrics.json`), feature table (`selected_features.csv`), SHAP summary (`shap_summary.csv` when available), and survival stats (`survival.json`).

## QC Expectations

- Class count ratio ≤3:1; warnings logged otherwise.
- Selected features between 5 and 250 unless user overrides.
- Nested CV AUC ≥0.70 or flagged in report.
- SHAP overlap with selected features ≥60% (reported).

## Related Assets

- `examples/configs/biomarker_studio_template.yaml` (scaffold for teams)
- `scripts/biomarker_signature_studio.py` (entry point)
- Existing biomarker workflow skill for orchestrated runs.

Use this skill whenever you need a ready-to-review biomarker dossier (data QC, model metrics, explainability artifacts) before moving to validation cohorts or lab assays.


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->
