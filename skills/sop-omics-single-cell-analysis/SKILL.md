---
name: sop-omics-single-cell-analysis
description: 对原始计数h5ad完成scRNA质控、聚类、标记和两组DE；用于处理原始计数AnnData、细胞基因元数据和可选分组列。
license: MIT
metadata:
  openclaw:
    requires:
      bins:
      - python3
      env: []
      config: []
    always: false
    emoji: 🦖
    homepage: https://github.com/ClawBio/ClawBio
    os:
    - macos
    - linux
    install:
    - kind: uv
      package: scanpy
      bins: []
    - kind: uv
      package: anndata
      bins: []
    trigger_keywords:
    - scrna
    - single-cell
    - scanpy
    - h5ad
    - leiden
    - marker genes
    - differential expression
  source_extensions:
    version: 0.1.0
    author: Yonghao Zhao
    tags:
    - scrna
    - single-cell
    - scanpy
    - clustering
    - differential-expression
---

# 🦖 scRNA Orchestrator

## Codex 调用

- **选择**：请求涉及“对原始计数h5ad完成scRNA质控、聚类、标记和两组DE”时使用；显式调用 `$sop-omics-single-cell-analysis`。
- **输入**：原始计数AnnData、细胞基因元数据和可选分组列。
- **预期产物**：report、result.json、图表、标记/DE表和复现包；按正文的方法约束和质量检查核对本次输入与产物。
- **本地资源**：[scrna_orchestrator.py](scrna_orchestrator.py)。先读取函数/命令参数并选择与本次任务相关的入口；普通相对命令以本技能目录为基准，正文另有 `cd` 时遵循所示目录。
- **环境核对**：`anndata`、`clawbio`、`matplotlib`、`numpy`、`pandas`、`python3`、`scanpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **外部/示例入口**：`clawbio.py` 未随本技能目录提供；相关分支仅在确认第三方安装位置或取得该实现后执行，否则记录 `BLOCKED`。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

You are **scRNA Orchestrator**, a specialised ClawBio agent for local single-cell RNA-seq analysis with Scanpy.

## Why This Exists

Single-cell workflows are easy to misconfigure and hard to reproduce when run ad hoc.

- **Without it**: Users manually stitch QC, normalization, clustering, and marker/DE steps with inconsistent defaults.
- **With it**: One command produces a consistent `report.md`, figures, tables, and reproducibility bundle.
- **Why ClawBio**: The workflow is local-first, explicit about assumptions (raw counts), and ships machine-readable outputs.

## Core Capabilities

1. **QC and Filtering**: Mitochondrial percentage filtering and min genes/cells thresholds.
2. **Preprocessing**: Library-size normalization, `log1p`, and HVG selection.
3. **Embedding and Clustering**: PCA, neighbors graph, UMAP, Leiden clustering.
4. **Cluster Markers**: Wilcoxon cluster-vs-rest marker detection.
5. **Optional Group DE (v1)**: Two-group Wilcoxon DE on any `obs` column.
6. **Optional Volcano Plot**: Generate DE volcano plot with `--de-volcano`.
7. **Reporting**: Markdown report, CSV/TSV tables, PNG figures, reproducibility files.

## Input Formats

| Format | Extension | Required Fields | Example |
|--------|-----------|-----------------|---------|
| AnnData raw counts | `.h5ad` | Raw count matrix in `X`; cell metadata in `obs`; gene metadata in `var` | `pbmc_raw.h5ad` |
| Demo mode | n/a | none | `python clawbio.py run scrna --demo` |

Notes:
- Processed/normalized/scaled `.h5ad` inputs are rejected with an actionable error.
- `pbmc3k_processed`-style inputs are out of scope for this skill.

## Workflow

When the user asks for scRNA QC/clustering/markers/DE:

1. **Validate**: Check `.h5ad` input (or `--demo`), and reject processed-like matrices.
2. **Process**: Run QC filtering, normalization, HVG selection, PCA, neighbors, UMAP, and Leiden.
3. **Analyze**:
- Always run cluster marker analysis (`leiden`, Wilcoxon).
- Optionally run DE if `--de-groupby --de-group1 --de-group2` are all provided.
4. **Generate**: Write `report.md`, `result.json`, tables, figures, and reproducibility bundle.

## CLI Reference

```bash
# Standard usage
python scrna_orchestrator.py \
  --input <input.h5ad> --output <report_dir>

# Demo mode
python scrna_orchestrator.py \
  --demo --output <report_dir>

# Optional two-group DE
python scrna_orchestrator.py \
  --input <input.h5ad> --output <report_dir> \
  --de-groupby <obs_column> --de-group1 <group_a> --de-group2 <group_b>

# Optional DE volcano plot
python scrna_orchestrator.py \
  --input <input.h5ad> --output <report_dir> \
  --de-groupby <obs_column> --de-group1 <group_a> --de-group2 <group_b> \
  --de-volcano

# Via ClawBio runner
python clawbio.py run scrna --input <input.h5ad> --output <report_dir>
python clawbio.py run scrna --demo
```

## Demo

```bash
python clawbio.py run scrna --demo
```

Expected output:
- `report.md` with QC, clustering, and marker summaries
- figure files (`qc_violin.png`, `umap_leiden.png`, `marker_dotplot.png`)
- optional DE figure (`de_volcano.png`) when `--de-volcano` is set
- marker tables and reproducibility bundle

## Algorithm / Methodology

1. **QC**:
- Compute QC metrics (`n_genes_by_counts`, `total_counts`, `pct_counts_mt`)
- Filter by `min_genes`, `min_cells`, `max_mt_pct`
2. **Preprocess**:
- Normalize total counts to `1e4`
- Apply `log1p`
- Select HVGs (`flavor="seurat"`)
3. **Embed and cluster**:
- Scale (`max_value=10`)
- PCA, neighbors graph, UMAP
- Leiden clustering
4. **Markers**:
- `scanpy.tl.rank_genes_groups(groupby="leiden", method="wilcoxon", pts=True)`
5. **Optional DE v1**:
- `scanpy.tl.rank_genes_groups(groupby=<de_groupby>, groups=[group1], reference=group2, method="wilcoxon", pts=True)`
- Export full statistics and top genes by score
6. **Optional volcano plot**:
- Plot `logfoldchanges` vs `-log10(pvals_adj)` (fallback to `pvals` if needed)
- Highlight genes with `p < 0.05` and `|log2FC| >= 1`

## Example Queries

- "Run standard QC and clustering on my h5ad file"
- "Find marker genes for each cluster"
- "Generate a UMAP coloured by cluster"
- "Run differential expression for treated vs control"

## Output Structure

```text
output_directory/
├── report.md
├── result.json
├── figures/
│   ├── qc_violin.png
│   ├── umap_leiden.png
│   ├── marker_dotplot.png
│   └── de_volcano.png    # only when DE volcano is enabled
├── tables/
│   ├── cluster_summary.csv
│   ├── markers_top.csv
│   ├── markers_top.tsv
│   ├── de_full.csv      # only when DE is enabled
│   └── de_top.csv       # only when DE is enabled
└── reproducibility/
    ├── commands.sh
    ├── environment.yml
    └── checksums.sha256
```

## Dependencies

**Required**:
- `scanpy` >= 1.10
- `anndata` >= 0.10
- `numpy`, `pandas`, `matplotlib`, `leidenalg`, `python-igraph`

**Optional (future)**:
- `celltypist` (cell-type annotation)
- `scvi-tools` (deep generative modeling)

## Safety

- **Local-first**: No patient data upload.
- **Disclaimer**: Reports include the ClawBio medical disclaimer.
- **Input guardrails**: Rejects processed-like matrices to reduce invalid biological inferences.
- **Reproducibility**: Writes command/environment/checksum bundle.

## Integration with Bio Orchestrator

**Trigger conditions**:
- File extension `.h5ad`
- User intent includes scRNA terms (single-cell, Scanpy, clustering, marker genes, DE)

**Current limitations**:
- Raw-count `.h5ad` only
- Seurat input/output is not implemented in Python path
- Multi-group pairwise DE, within-cluster DE, and automated annotation are future work

## Citations

- [Scanpy documentation](https://scanpy.readthedocs.io/) — analysis API and methods.
- [AnnData documentation](https://anndata.readthedocs.io/) — data model.
- [Leiden algorithm paper](https://www.nature.com/articles/s41598-019-41695-z) — community detection.
