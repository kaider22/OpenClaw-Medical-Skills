---
name: omics-bulk-combat-correction
description: 提供用ComBat校正多批次bulk表达矩阵并评估混合的方法与调用指南；用于处理多批次表达矩阵、批次标签和AnnData。
metadata:
  source_extensions:
    title: Bulk RNA-seq batch correction with ComBat
---

# Bulk RNA-seq batch correction with ComBat

## Codex 调用

- **选择**：请求涉及“用ComBat校正多批次bulk表达矩阵并评估混合”时使用；显式调用 `$omics-bulk-combat-correction`。
- **输入**：多批次表达矩阵、批次标签和AnnData。
- **预期产物**：校正矩阵、原始矩阵、AnnData及PCA前后图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **按需阅读**：[reference.md](reference.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview
Apply this skill when a user has multiple bulk expression matrices measured across different batches and needs to harmonise them
 before downstream analysis. It follows `t_bulk_combat.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_bulk_combat.ipynb`，使用该参考分支前需取得资源）, w
hich demonstrates the pyComBat workflow on ovarian cancer microarray cohorts.

## Instructions
1. **Import core libraries**
   - Load `omicverse as ov`, `anndata`, `pandas as pd`, and `matplotlib.pyplot as plt`.
   - Call `ov.ov_plot_set()` (aliased `ov.plot_set()` in some releases) to align figures with omicverse styling.
2. **Load each batch separately**
   - Read the prepared pickled matrices (or user-provided expression tables) with `pd.read_pickle(...)`/`pd.read_csv(...)`.
   - Transpose to gene × sample before wrapping them in `anndata.AnnData` objects so `adata.obs` stores sample metadata.
   - Assign a `batch` column for every cohort (`adata.obs['batch'] = '1'`, `'2'`, ...). Encourage descriptive labels when availa
ble.
3. **Concatenate on shared genes**
   - Use `anndata.concat([adata1, adata2, adata3], merge='same')` to retain the intersection of genes across batches.
   - Confirm the combined `adata` reports balanced sample counts per batch; if not, prompt users to re-check inputs.
4. **Run ComBat batch correction**
   - Execute `ov.bulk.batch_correction(adata, batch_key='batch')`.
   - Explain that corrected values are stored in `adata.layers['batch_correction']` while the original counts remain in `adata.X`.
5. **Export corrected and raw matrices**
   - Obtain DataFrames via `adata.to_df().T` (raw) and `adata.to_df(layer='batch_correction').T` (corrected).
   - Encourage saving both tables (`.to_csv(...)`) plus the harmonised AnnData (`adata.write_h5ad('adata_batch.h5ad', compressio
n='gzip')`).
6. **Benchmark the correction**
   - For per-sample variance checks, draw before/after boxplots and recolour boxes using `ov.utils.red_color`, `blue_color`, `gree
n_color` palettes to match batches.
   - Copy raw counts to a named layer with `adata.layers['raw'] = adata.X.copy()` before PCA.
   - Run `ov.pp.pca(adata, layer='raw', n_pcs=50)` and `ov.pp.pca(adata, layer='batch_correction', n_pcs=50)`.
   - Visualise embeddings with `ov.utils.embedding(..., basis='raw|original|X_pca', color='batch', frameon='small')` and repeat fo
r the corrected layer to verify mixing.
7. **Troubleshooting tips**
   - Mismatched gene identifiers cause dropped features—remind users to harmonise feature names (e.g., gene symbols) before conca
tenation.
   - pyComBat expects log-scale intensities or similarly distributed counts; recommend log-transforming strongly skewed matrices.
   - If `batch_correction` layer is missing, ensure the `batch_key` matches the column name in `adata.obs`.

## Examples
- "Combine three GEO ovarian cohorts, run ComBat, and export both the raw and corrected CSV matrices."
- "Plot PCA embeddings before and after batch correction to confirm that batches 1–3 overlap."
- "Save the harmonised AnnData file so I can reload it later for downstream DEG analysis."

## References
- Tutorial notebook: `t_bulk_combat.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_bulk_combat.ipynb`，使用该参考分支前需取得资源）
- Example inputs: `omicverse_guide/docs/Tutorials-bulk/data/combat/`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/data/combat/`，使用该参考分支前需取得资源）
- Quick copy/paste commands: [`reference.md`](reference.md)
