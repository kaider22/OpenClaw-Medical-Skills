---
name: omics-tcr-bcr-analysis-scirpy-analysis
description: 提供整合单细胞VDJ克隆型与scRNA细胞状态的方法与调用指南；用于处理AnnData、10x VDJ或AIRR注释及细胞分组。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: scirpy
---

## Version Compatibility

Reference examples tested with: MiXCR 4.6+, VDJtools 1.2.1+, scanpy 1.10+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# scirpy Analysis

## Codex 调用

- **选择**：请求涉及“整合单细胞VDJ克隆型与scRNA细胞状态”时使用；显式调用 `$omics-tcr-bcr-analysis-scirpy-analysis`。
- **输入**：AnnData、10x VDJ或AIRR注释及细胞分组。
- **预期产物**：链QC、克隆扩增、多样性和表达差异结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`scanpy`、`scirpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Analyze single-cell TCR/BCR with gene expression"** → Integrate immune receptor clonotype data with scRNA-seq gene expression for joint analysis of clonal expansion and cell state.
- Python: `scirpy.io.read_10x_vdj()`, `scirpy.tl.clonal_expansion()`, `scirpy.tl.clonotype_network()`

## Load VDJ Data

**Goal:** Import single-cell VDJ annotations and integrate them with an existing scRNA-seq AnnData object.

**Approach:** Read 10x filtered_contig_annotations or AIRR-format files and attach receptor metadata to the AnnData obs.

```python
import scirpy as ir
import scanpy as sc

# Load 10x VDJ data
adata = sc.read_h5ad('scrnaseq.h5ad')

# Add VDJ annotations from 10x filtered_contig_annotations.csv
ir.io.read_10x_vdj(adata, 'filtered_contig_annotations.csv')

# Or load from AIRR format
ir.io.read_airr(adata, 'airr_rearrangement.tsv')
```

## Quality Control

**Goal:** Identify cells with aberrant chain pairing (doublets, orphan chains, ambiguous pairings).

**Approach:** Run scirpy chain QC to categorize cells by receptor chain status and visualize QC distributions.

```python
# QC for receptor chains
ir.tl.chain_qc(adata)

# QC categories:
# - multichain: More than 2 chains (potential doublet)
# - orphan: Only one chain detected
# - extra: Extra chains beyond expected pair
# - ambiguous: Ambiguous chain pairing

# Plot QC
ir.pl.group_abundance(adata, groupby='chain_pairing', target_col='receptor_subtype')
```

## Define Clonotypes

```python
# Define clonotypes by CDR3 sequence identity
ir.pp.ir_dist(
    adata,
    metric='identity',
    sequence='aa',
    cutoff=0
)

ir.tl.define_clonotypes(adata, receptor_arms='all', dual_ir='primary_only')

# Check clonotype distribution
print(f"Unique clonotypes: {adata.obs['clone_id'].nunique()}")
```

## Clonal Expansion

```python
# Identify expanded clonotypes
ir.tl.clonal_expansion(adata)

# Categories: 1 (singleton), 2, 3-10, >10

# Plot expansion by cell type
ir.pl.clonal_expansion(adata, groupby='cell_type')
```

## Repertoire Diversity

```python
# Calculate diversity metrics per group
diversity = ir.tl.repertoire_overlap(
    adata,
    groupby='sample',
    target_col='clone_id',
    metric='jaccard'
)

# Alpha diversity
ir.tl.alpha_diversity(adata, groupby='sample', target_col='clone_id')
```

## Compare Groups

```python
# Compare clonotype sharing between groups
ir.pl.group_abundance(
    adata,
    groupby='clone_id',
    target_col='condition',
    max_cols=20
)

# Repertoire overlap heatmap
ir.pl.repertoire_overlap(adata, groupby='sample', target_col='clone_id')
```

## V(D)J Gene Usage

```python
# Plot V gene usage
ir.pl.vdj_usage(
    adata,
    vdj_cols=['v_call_TRA', 'v_call_TRB'],
    full_names=False
)

# Spectratype (CDR3 length distribution)
ir.pl.spectratype(adata, chain='TRB', target_col='cell_type')
```

## Integration with Gene Expression

```python
# Subset to cells with TCR
adata_tcr = adata[adata.obs['has_ir'] == 'True'].copy()

# Find marker genes for expanded vs non-expanded
adata_tcr.obs['is_expanded'] = adata_tcr.obs['clonal_expansion'].isin(['3-10', '>10'])

sc.tl.rank_genes_groups(adata_tcr, groupby='is_expanded')
sc.pl.rank_genes_groups(adata_tcr, n_genes=20)

# UMAP colored by clonal expansion
sc.pl.umap(adata_tcr, color=['cell_type', 'clonal_expansion'])
```

## Export for Downstream Analysis

```python
# Export clonotype table
clonotypes = adata.obs[['clone_id', 'IR_VDJ_1_junction_aa', 'IR_VJ_1_junction_aa',
                         'IR_VDJ_1_v_call', 'IR_VDJ_1_j_call']].drop_duplicates()
clonotypes.to_csv('clonotypes.csv')

# Export for VDJtools
ir.io.write_airr(adata, 'scirpy_airr.tsv')
```

## Related Skills

- mixcr-analysis - Process raw VDJ FASTQ
- single-cell/data-io - Load scRNA-seq data
- single-cell/clustering - Cell type annotation
