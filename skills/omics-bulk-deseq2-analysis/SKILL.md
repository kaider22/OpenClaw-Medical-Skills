---
name: omics-bulk-deseq2-analysis
description: 提供用PyDESeq2完成bulk RNA-seq差异表达和GSEA的方法与调用指南；用于处理featureCounts原始计数、物种映射和组别。
metadata:
  source_extensions:
    title: Bulk RNA-seq DESeq2 analysis with omicverse
---

# Bulk RNA-seq DESeq2 analysis with omicverse

## Codex 调用

- **选择**：请求涉及“用PyDESeq2完成bulk RNA-seq差异表达和GSEA”时使用；显式调用 `$omics-bulk-deseq2-analysis`。
- **输入**：featureCounts原始计数、物种映射和组别。
- **预期产物**：标准化差异表、阈值结果、火山图和GSEA；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **按需阅读**：[reference.md](reference.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview
Use this skill when a user wants to reproduce the DESeq2 workflow showcased in `t_deseq2.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_deseq2.ipynb`，使用该参考分支前需取得资源）. It covers loading raw featureCounts matrices, mapping Ensembl IDs to symbols, running PyDESeq2 via `ov.bulk.pyDEG`, and exploring downstream enrichment plots.

## Instructions
1. **Import and format the expression matrix**
   - Call `import omicverse as ov` and `ov.utils.ov_plot_set()` to standardise visuals.
   - Read tab-separated count data from featureCounts using `ov.utils.read(..., index_col=0, header=1)`.
   - Strip trailing `.bam` from column names with `[c.split('/')[-1].replace('.bam', '') for c in data.columns]`.
2. **Map gene identifiers**
   - Ensure the appropriate mapping pair exists by running `ov.utils.download_geneid_annotation_pair()`.
   - Replace `gene_id` with gene symbols using `ov.bulk.Matrix_ID_mapping(data, 'genesets/pair_<GENOME>.tsv')`.
3. **Initialise the DEG object**
   - Create `dds = ov.bulk.pyDEG(data)` from the mapped counts.
   - Resolve duplicate gene names with `dds.drop_duplicates_index()` and confirm success in logs.
4. **Define contrasts and run DESeq2**
   - Collect sample labels into `treatment_groups` and `control_groups` lists that match column names exactly.
   - Execute `dds.deg_analysis(treatment_groups, control_groups, method='DEseq2')` to invoke PyDESeq2.
5. **Filter and tune thresholds**
   - Inspect result shape (`dds.result.shape`) and optionally filter low-expression genes, e.g. `dds.result.loc[dds.result['log2(BaseMean)'] > 1]`.
   - Set thresholds via `dds.foldchange_set(fc_threshold=-1, pval_threshold=0.05, logp_max=6)` to auto-pick fold-change cutoffs.
6. **Visualise differential genes**
   - Draw volcano plots with `dds.plot_volcano(...)` and summarise key genes.
   - Produce per-gene boxplots: `dds.plot_boxplot(genes=[...], treatment_groups=..., control_groups=..., figsize=(2, 3))`.
7. **Run enrichment analyses (optional)**
   - Download enrichment libraries using `ov.utils.download_pathway_database()` and load them through `ov.utils.geneset_prepare`.
   - Rank genes for GSEA with `rnk = dds.ranking2gsea()`.
   - Instantiate `gsea_obj = ov.bulk.pyGSEA(rnk, pathway_dict)` and call `gsea_obj.enrichment()` to compute terms.
   - Plot enrichment bubble charts via `gsea_obj.plot_enrichment(...)` and GSEA curves with `gsea_obj.plot_gsea(term_num=..., ...)`.
8. **Troubleshooting**
   - If PyDESeq2 raises errors about size factors, remind users to provide raw counts (not log-transformed data).
   - `gene_id` mapping depends on species; direct them to download the correct genome pair when results look sparse.
   - Large pathway libraries may require raising recursion limits or filtering to the top N terms before plotting.

## Examples
- "Run PyDESeq2 on treated vs control replicates and highlight the top enriched WikiPathways terms."
- "Filter DEGs to genes with log2(BaseMean) > 1, auto-select fold-change cutoffs, and create volcano and boxplots."
- "Generate the ranked gene list for GSEA and plot the enrichment curve for the top pathway."

## References
- Tutorial notebook: `t_deseq2.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_deseq2.ipynb`，使用该参考分支前需取得资源）
- Sample featureCounts matrix: `sample/counts.txt`（资源未随仓库提供：`../../sample/counts.txt`，使用该参考分支前需取得资源）
- Quick copy/paste commands: [`reference.md`](reference.md)
