---
name: omics-tcga-preprocessing
description: 提供整理TCGA表达、临床元数据并开展基因生存分析的方法与调用指南；用于处理GDC样本表、表达归档目录和clinical cart目录。
metadata:
  source_extensions:
    title: TCGA bulk data preprocessing with omicverse
---

# TCGA bulk data preprocessing with omicverse

## Codex 调用

- **选择**：请求涉及“整理TCGA表达、临床元数据并开展基因生存分析”时使用；显式调用 `$omics-tcga-preprocessing`。
- **输入**：GDC样本表、表达归档目录和clinical cart目录。
- **预期产物**：含counts/FPKM/TPM层的AnnData及生存曲线/统计；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **按需阅读**：[reference.md](reference.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview
Follow this skill to recreate the preprocessing routine from `t_tcga.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_tcga.ipynb`，使用该参考分支前需取得资源）. It automates loading TCGA downloads, generating raw/normalised matrices, initialising metadata, and running survival analyses through `ov.bulk.pyTCGA`.

## Instructions
1. **Gather required downloads**
   - Confirm the user has:
     - `gdc_sample_sheet.<date>.tsv` from the TCGA Sample Sheet export.
     - The decompressed `gdc_download_xxxxx` directory containing expression archives.
     - The `clinical.cart.<date>` directory with clinical XML/JSON files.
   - Mention that sample data are available under `omicverse_guide/docs/Tutorials-bulk/data/TCGA_OV/`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/data/TCGA_OV/`，使用该参考分支前需取得资源）.
2. **Initialise the TCGA helper**
   - Import `omicverse as ov` (and `scanpy as sc` if plotting) then call `ov.plot_set()`.
   - Instantiate `aml_tcga = ov.bulk.pyTCGA(sample_sheet_path, download_dir, clinical_dir)`.
   - Run `aml_tcga.adata_init()` to build the AnnData object with raw counts, FPKM, and TPM layers.
3. **Persist the dataset**
   - Encourage saving the initial AnnData: `aml_tcga.adata.write_h5ad('data/TCGA_OV/ov_tcga_raw.h5ad', compression='gzip')`.
   - When reloading, reconstruct the class with the same paths and call `aml_tcga.adata_read(<path>)`.
4. **Initialise metadata and clinical information**
   - Populate sample metadata using `aml_tcga.adata_meta_init()` to convert gene IDs to symbols and attach patient info.
   - Add survival attributes via `aml_tcga.survial_init()` (note the intentional spelling in the API).
5. **Perform survival analyses**
   - Plot gene-level survival curves with `aml_tcga.survival_analysis('GENE', layer='deseq_normalize', plot=True)`.
   - To process all genes, call `aml_tcga.survial_analysis_all()`; warn that it may take time.
6. **Export results**
   - Save enriched metadata to a new AnnData file (`aml_tcga.adata.write_h5ad('.../ov_tcga_survial_all.h5ad', compression='gzip')`).
   - Suggest exporting summary tables (e.g., survival statistics) if users need to share outputs outside Python.
7. **Troubleshooting tips**
   - Ensure TCGA archives are fully extracted; missing XML/TSV files trigger parsing errors.
   - The helper expects matching case IDs between the sample sheet and expression files—direct users to re-download if IDs do not
 align.
   - Survival plots require clinical dates; if absent, instruct users to check the `clinical_cart` contents.

## Examples
- "Read my TCGA OV download, initialise metadata, and plot MYC survival curves using DESeq-normalised counts."
- "Reload a saved AnnData file, attach survival annotations, and export the updated `.h5ad`."
- "Run survival analysis for all genes and store the enriched dataset."

## References
- Tutorial notebook: `t_tcga.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_tcga.ipynb`，使用该参考分支前需取得资源）
- Sample dataset: `data/TCGA_OV/`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/data/TCGA_OV/`，使用该参考分支前需取得资源）
- Quick copy/paste commands: [`reference.md`](reference.md)
