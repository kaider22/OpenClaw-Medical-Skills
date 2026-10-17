---
name: omics-bulk-to-single-deconvolution
description: 提供估计细胞比例并由bulk生成合成单细胞谱的方法与调用指南；用于处理bulk原始计数、匹配scRNA参考和细胞标签。
metadata:
  source_extensions:
    title: Bulk RNA-seq deconvolution with Bulk2Single
---

# Bulk RNA-seq deconvolution with Bulk2Single

## Codex 调用

- **选择**：请求涉及“估计细胞比例并由bulk生成合成单细胞谱”时使用；显式调用 `$omics-bulk-to-single-deconvolution`。
- **输入**：bulk原始计数、匹配scRNA参考和细胞标签。
- **预期产物**：比例表、合成AnnData及参考对照QC；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **按需阅读**：[reference.md](reference.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview
Use this skill when a user wants to reconstruct single-cell profiles from bulk RNA-seq together with a matched reference scRNA-seq atlas. It follows `t_bulk2single.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk2single/t_bulk2single.ipynb`，使用该参考分支前需取得资源）, which demonstrates how to harmonise PDAC bulk replicates, train the beta-VAE generator, and benchmark the output cells against dentate gyrus scRNA-seq.

## Instructions
1. **Load libraries and data**
   - Import `omicverse as ov`, `scanpy as sc`, `scvelo as scv`, `anndata`, and `matplotlib.pyplot as plt`, then call `ov.plot_set()` to match omicverse styling.
   - Read the bulk counts table with `ov.read(...)`/`ov.utils.read(...)` and harmonise gene identifiers via `ov.bulk.Matrix_ID_mapping(<df>, 'genesets/pair_GRCm39.tsv')`.
   - Load the reference scRNA-seq AnnData (e.g., `scv.datasets.dentategyrus()`) and confirm the cluster labels (stored in `adata.obs['clusters']`).
2. **Initialise the Bulk2Single model**
   - Instantiate `ov.bulk2single.Bulk2Single(bulk_data=bulk_df, single_data=adata, celltype_key='clusters', bulk_group=['dg_d_1', 'dg_d_2', 'dg_d_3'], top_marker_num=200, ratio_num=1, gpu=0)`.
   - Explain GPU selection (`gpu=-1` forces CPU) and how `bulk_group` names align with column IDs in the bulk matrix.
3. **Estimate cell fractions**
   - Call `model.predicted_fraction()` to run the integrated TAPE estimator, then plot stacked bar charts per sample to validate proportions.
   - Encourage saving the fraction table for downstream reporting (`df.to_csv(...)`).
4. **Preprocess for beta-VAE**
   - Execute `model.bulk_preprocess_lazy()`, `model.single_preprocess_lazy()`, and `model.prepare_input()` to produce matched feature spaces.
   - Clarify that the lazy preprocessing expects raw counts; skip if the user has already log-normalised data and instead provide aligned matrices manually.
5. **Train or load the beta-VAE**
   - Train with `model.train(batch_size=512, learning_rate=1e-4, hidden_size=256, epoch_num=3500, vae_save_dir='...', vae_save_name='dg_vae', generate_save_dir='...', generate_save_name='dg')`.
   - Mention early stopping via `patience` and how to resume by reloading weights with `model.load('.../dg_vae.pth')`.
   - Use `model.plot_loss()` to monitor convergence.
6. **Generate and filter synthetic cells**
   - Produce an AnnData using `model.generate()` and reduce noise through `model.filtered(generate_adata, leiden_size=25)`.
   - Store the filtered AnnData (`.write_h5ad`) for reuse, noting it contains PCA embeddings in `obsm['X_pca']`.
7. **Benchmark against the reference atlas**
   - Plot cell-type compositions with `ov.bulk2single.bulk2single_plot_cellprop(...)` for both generated and reference data.
   - Assess correlation using `ov.bulk2single.bulk2single_plot_correlation(single_data, generate_adata, celltype_key='clusters')`.
   - Embed with `generate_adata.obsm['X_mde'] = ov.utils.mde(generate_adata.obsm['X_pca'])` and visualise via `ov.utils.embedding(..., color=['clusters'], palette=ov.utils.pyomic_palette())`.
8. **Troubleshooting tips**
   - If marker selection fails, increase `top_marker_num` or provide a curated marker list.
   - Alignment errors typically stem from mismatched `bulk_group` names—double-check column IDs in the bulk matrix.
   - Training on CPU can take several hours; advise switching `gpu` to an available CUDA device for speed.

## Examples
- "Estimate cell fractions for PDAC bulk replicates and generate synthetic scRNA-seq using Bulk2Single."
- "Load a pre-trained Bulk2Single model, regenerate cells, and compare cluster proportions to the dentate gyrus atlas."
- "Plot correlation heatmaps between generated cells and reference clusters after filtering noisy synthetic cells."

## References
- Tutorial notebook: `t_bulk2single.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk2single/t_bulk2single.ipynb`，使用该参考分支前需取得资源）
- Example data and weights: `omicverse_guide/docs/Tutorials-bulk2single/data/`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk2single/data/`，使用该参考分支前需取得资源）
- Quick copy/paste commands: [`reference.md`](reference.md)
