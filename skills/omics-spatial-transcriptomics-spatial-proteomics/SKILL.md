---
name: omics-spatial-transcriptomics-spatial-proteomics
description: 提供处理CODEX/IMC/MIBI的表型与空间邻域的方法与调用指南；用于处理细胞×标记强度、空间坐标和批次信息。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: scimap
---

## Version Compatibility

Reference examples tested with: anndata 0.10+, scanpy 1.10+, squidpy 1.3+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Spatial Proteomics Analysis

## Codex 调用

- **选择**：请求涉及“处理CODEX/IMC/MIBI的表型与空间邻域”时使用；显式调用 `$omics-spatial-transcriptomics-spatial-proteomics`。
- **输入**：细胞×标记强度、空间坐标和批次信息。
- **预期产物**：表型标签、邻域互作、共定位与图形；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`anndata`、`scimap`、`squidpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Analyze my CODEX/IMC spatial proteomics data"** → Process multiplexed imaging data including cell segmentation, protein phenotyping, spatial neighborhood analysis, and protein colocalization scoring.
- Python: `scimap.tl.phenotype_cells()`, `squidpy.gr.nhood_enrichment()`

## Data Loading

**Goal:** Process multiplexed spatial proteomics data (CODEX/IMC/MIBI) through cell phenotyping, spatial neighborhood analysis, and protein colocalization scoring.

**Approach:** Load the cell-by-marker intensity matrix with spatial coordinates into AnnData, normalize and rescale marker intensities, phenotype cells by marker expression gating, then analyze spatial neighborhoods and cell-cell interactions using scimap and squidpy.

```python
import scimap as sm
import anndata as ad

# Load CODEX/IMC data (cell x marker matrix with spatial coordinates)
adata = ad.read_h5ad('spatial_proteomics.h5ad')

# Required: spatial coordinates in adata.obsm['spatial']
# Required: protein intensities in adata.X
```

## Preprocessing

```python
# Log transform intensities
sm.pp.log1p(adata)

# Rescale markers (0-1 per marker)
sm.pp.rescale(adata)

# Combat batch correction if multiple FOVs
sm.pp.combat(adata, batch_key='fov')
```

## Phenotyping Cells

```python
# Manual gating approach
phenotype_markers = {
    'T_cell': ['CD3', 'CD45'],
    'B_cell': ['CD20', 'CD45'],
    'Macrophage': ['CD68', 'CD163'],
    'Tumor': ['panCK', 'Ki67']
}

sm.tl.phenotype_cells(adata, phenotype=phenotype_markers,
                      gate=0.5, label='phenotype')

# Clustering-based phenotyping
sm.tl.cluster(adata, method='leiden', resolution=1.0)
```

## Spatial Analysis

```python
# Build spatial neighbors graph
sm.tl.spatial_distance(adata, x_coordinate='X', y_coordinate='Y')

# Neighborhood enrichment
sm.tl.spatial_interaction(adata, phenotype='phenotype',
                          method='knn', knn=10)

# Spatial clustering (communities of cells)
sm.tl.spatial_cluster(adata, phenotype='phenotype')
```

## Visualization

```python
# Spatial scatter plot
sm.pl.spatial_scatterPlot(adata, colorBy='phenotype',
                          x='X', y='Y', s=5)

# Heatmap of spatial interactions
sm.pl.spatial_interaction(adata)

# Marker expression overlay
sm.pl.image_viewer(adata, markers=['CD3', 'CD20', 'panCK'])
```

## Integration with Transcriptomics

```python
import squidpy as sq

# If matched spatial transcriptomics available
# Transfer labels or integrate modalities
sq.gr.spatial_neighbors(adata_protein)
sq.gr.spatial_neighbors(adata_rna)

# Compare spatial patterns across modalities
```

## Platform-Specific Notes

| Platform | Markers | Resolution | Notes |
|----------|---------|------------|-------|
| CODEX | 40-60 | Subcellular | Cyclic staining |
| IMC | 40+ | 1 um | Metal-tagged antibodies |
| MIBI | 40+ | 260 nm | Mass spectrometry |

## Related Skills

- spatial-transcriptomics/spatial-neighbors - Spatial graph construction
- spatial-transcriptomics/spatial-domains - Domain identification
- imaging-mass-cytometry/phenotyping - IMC-specific analysis
