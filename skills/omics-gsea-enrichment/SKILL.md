---
name: omics-gsea-enrichment
description: 提供用OmicVerse执行GO/KEGG等基因集富集并绘图的方法与调用指南；用于处理DEG基因列表、基因集文件、物种和可选背景。
metadata:
  source_extensions:
    title: GSEA and Pathway Enrichment Analysis
---

# GSEA and Pathway Enrichment Analysis

## Codex 调用

- **选择**：请求涉及“用OmicVerse执行GO/KEGG等基因集富集并绘图”时使用；显式调用 `$omics-gsea-enrichment`。
- **输入**：DEG基因列表、基因集文件、物种和可选背景。
- **预期产物**：富集结果、p值/q值及单库或多库图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`omicverse`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview
This skill covers gene set enrichment analysis (GSEA) and pathway enrichment workflows in OmicVerse. It provides critical guidance on the correct data formats and API usage patterns to avoid common errors.

## Critical API Reference - Geneset Format

### IMPORTANT: Use Dictionary Format, NOT File Path!

The `ov.bulk.geneset_enrichment()` function requires a **dictionary** of gene sets, NOT a file path string. You must first load the geneset file using `ov.utils.geneset_prepare()`.

**CORRECT usage:**
```python
# Step 1: Download pathway database (if not already available)
ov.utils.download_pathway_database()

# Step 2: Load geneset file into dictionary format - REQUIRED!
pathways_dict = ov.utils.geneset_prepare(
    'genesets/GO_Biological_Process_2021.txt',  # or .gmt file
    organism='Human'  # or 'Mouse'
)

# Step 3: Now run enrichment with the DICTIONARY
enr = ov.bulk.geneset_enrichment(
    gene_list=deg_genes,
    pathways_dict=pathways_dict,  # Pass the DICTIONARY, not file path!
    pvalue_type='auto',
    organism='Human'
)
```

**WRONG - DO NOT USE:**
```python
# WRONG! Don't pass file path directly to geneset_enrichment!
# enr = ov.bulk.geneset_enrichment(
#     gene_list=deg_genes,
#     pathways_dict='genesets/GO_Biological_Process_2021.gmt'  # ERROR! String path doesn't work!
# )

# WRONG! geneset_enrichment expects dict, not file path
# enr = ov.bulk.geneset_enrichment(
#     gene_list=deg_genes,
#     pathways_dict='GO_Biological_Process_2021'  # ERROR!
# )
```

### File Format Support

| File Extension | Load Method | Notes |
|---------------|-------------|-------|
| `.txt` | `ov.utils.geneset_prepare()` | OmicVerse format |
| `.gmt` | `ov.utils.geneset_prepare()` | Standard GMT format |
| `.json` | `json.load()` then convert | Custom handling needed |

### Complete Enrichment Workflow

```python
import omicverse as ov

# 1. Setup
ov.plot_set()

# 2. Ensure pathway database is available
ov.utils.download_pathway_database()

# 3. Load gene sets - ALWAYS use geneset_prepare first!
go_bp = ov.utils.geneset_prepare('genesets/GO_Biological_Process_2021.txt', organism='Human')
go_mf = ov.utils.geneset_prepare('genesets/GO_Molecular_Function_2021.txt', organism='Human')
kegg = ov.utils.geneset_prepare('genesets/KEGG_2021_Human.txt', organism='Human')

# 4. Prepare gene list (e.g., from DEG analysis)
# Assuming dds is a pyDEG object with results
deg_genes = dds.result.loc[dds.result['sig'] != 'normal'].index.tolist()

# 5. Run enrichment with dictionary
enr_go_bp = ov.bulk.geneset_enrichment(
    gene_list=deg_genes,
    pathways_dict=go_bp,  # Dictionary, NOT file path!
    pvalue_type='auto',
    organism='Human'
)

# 6. Visualize results
ov.bulk.geneset_plot(enr_go_bp, figsize=(6, 8), num=10)

# 7. For multiple databases, combine into dict
enr_dict = {
    'GO_BP': enr_go_bp,
    'GO_MF': enr_go_mf,
    'KEGG': enr_kegg
}
colors_dict = {
    'GO_BP': '#1f77b4',
    'GO_MF': '#ff7f0e',
    'KEGG': '#2ca02c'
}
ov.bulk.geneset_plot_multi(enr_dict, colors_dict, num=5)
```

## Common Errors and Solutions

### Error: "FileNotFoundError" or "pathways_dict is not a dict"
**Cause**: Passing file path string instead of dictionary to `geneset_enrichment()`
**Solution**: First load with `ov.utils.geneset_prepare()`, then pass the returned dictionary

### Error: "Missing file 'genesets/GO_Biological_Process_2021.gmt'"
**Cause**: Pathway database not downloaded
**Solution**: Run `ov.utils.download_pathway_database()` first

### Error: "No enriched pathways found"
**Cause**: Gene list doesn't overlap with pathway genes, or organism mismatch
**Solution**:
- Verify gene symbols match (human vs mouse capitalization)
- Check `organism` parameter matches your data
- Ensure gene list has sufficient genes (>10 recommended)

## Pathway Databases Available

After running `ov.utils.download_pathway_database()`:
- `GO_Biological_Process_2021.txt`
- `GO_Molecular_Function_2021.txt`
- `GO_Cellular_Component_2021.txt`
- `KEGG_2021_Human.txt`
- `KEGG_2021_Mouse.txt`
- `Reactome_2022.txt`
- `WikiPathway_2023_Human.txt`
- And many more...

## Best Practices

1. **Always load genesets first**: Never pass file paths directly to `geneset_enrichment()`
2. **Check gene format**: Ensure gene symbols match (CAPS for human, Title case for mouse)
3. **Download once**: Run `download_pathway_database()` once per environment
4. **Specify organism**: Always set `organism='Human'` or `organism='Mouse'`
5. **Use background genes**: For more accurate results, provide `background` parameter

## Examples
- "Run GO enrichment on my DEG results using the correct geneset_prepare workflow"
- "Perform KEGG pathway analysis on upregulated genes with proper dictionary format"
- "Compare GO BP, MF, and KEGG enrichment results using geneset_plot_multi"

## References
- Tutorial notebook: `t_deg.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_deg.ipynb`，使用该参考分支前需取得资源） (enrichment section)
- Pathway download: `ov.utils.download_pathway_database()`
- Quick reference: `reference.md`（资源未随仓库提供：`reference.md`，使用该参考分支前需取得资源）
