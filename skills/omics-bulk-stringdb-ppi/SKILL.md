---
name: omics-bulk-stringdb-ppi
description: 提供查询STRING互作并构建带分组样式的PPI网络的方法与调用指南；用于处理基因符号列表、物种ID和节点分组。
metadata:
  source_extensions:
    title: STRING protein interaction analysis with omicverse
---

# STRING protein interaction analysis with omicverse

## Codex 调用

- **选择**：请求涉及“查询STRING互作并构建带分组样式的PPI网络”时使用；显式调用 `$omics-bulk-stringdb-ppi`。
- **输入**：基因符号列表、物种ID和节点分组。
- **预期产物**：互作边表、证据分数和网络图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **按需阅读**：[reference.md](reference.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Overview
Invoke this skill when the user has a list of genes and wants to explore STRING protein–protein interactions via omicverse. The
 workflow mirrors `t_network.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_network.ipynb`，使用该参考分支前需取得资源）, covering species selection, S
TRING API queries, and quick visualisation of the resulting network.

## Instructions
1. **Set up libraries**
   - Import `omicverse as ov` and call `ov.utils.ov_plot_set()` (or `ov.plot_set()`) to match omicverse aesthetics.
2. **Collect gene inputs**
   - Accept a curated list of gene symbols (`gene_list = [...]`).
   - Encourage the user to flag priority genes or categories so you can colour-code groups in the plot.
3. **Assign metadata for plotting**
   - Build dictionaries mapping genes to types and colours, e.g. `gene_type_dict = dict(zip(gene_list, ['Type1']*5 + ['Type2']*6
))` and `gene_color_dict = {...}`.
   - Remind users that consistent group labels improve legend readability.
4. **Query STRING interactions**
   - Call `ov.bulk.string_interaction(gene_list, species_id)` where `species_id` is the NCBI taxonomy ID (e.g. 4932 for yeast).
   - Inspect the resulting DataFrame for combined scores and evidence channels to verify coverage.
5. **Construct the network object**
   - Initialise `ppi = ov.bulk.pyPPI(gene=gene_list, gene_type_dict=..., gene_color_dict=..., species=species_id)`.
   - Run `ppi.interaction_analysis()` to fetch and cache STRING edges.
6. **Visualise the network**
   - Generate a default plot with `ppi.plot_network()` to reproduce the notebook figure.
   - Mention that advanced styling (layout, node size, legends) can be tuned through `ov.utils.plot_network` keyword arguments if
 the user requests adjustments.
7. **Troubleshooting**
   - Ensure gene symbols match the species—STRING expects case-sensitive identifiers; suggest mapping Ensembl IDs to symbols when
 queries fail.
   - If the API rate-limits, instruct the user to wait or provide a cached interaction table.
   - For missing interactions, recommend enabling STRING's "add_nodes" option via `ppi.interaction_analysis(add_nodes=...)` to exp
and the network.

## Examples
- "Retrieve STRING interactions for FAA4 and plot the network highlighting two gene classes."
- "Download the STRING edge table for my Saccharomyces cerevisiae gene panel and colour nodes by module."
- "Extend the network by adding the top five predicted partners before plotting."

## References
- Tutorial notebook: `t_network.ipynb`（资源未随仓库提供：`../../omicverse_guide/docs/Tutorials-bulk/t_network.ipynb`，使用该参考分支前需取得资源）
- STRING background: [string-db.org](https://string-db.org/)
- Quick copy/paste commands: [`reference.md`](reference.md)
