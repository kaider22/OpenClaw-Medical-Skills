---
name: research-reporting-quarto-reports
description: 提供用Quarto渲染可复现多语言科研文档的方法与调用指南；用于处理QMD文件、代码环境及参数。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: Quarto
    measurable_outcome: Execute skill workflow successfully with valid output within 15 minutes.
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


# Quarto Reports

## Codex 调用

- **选择**：请求涉及“用Quarto渲染可复现多语言科研文档”时使用；显式调用 `$research-reporting-quarto-reports`。
- **输入**：QMD文件、代码环境及参数。
- **预期产物**：HTML/PDF/DOCX、演示文稿或网站；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`Quarto`、`matplotlib`、`pandas`、`scanpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Basic Document

```yaml
---
title: "Analysis Report"
author: "Your Name"
date: today
format:
  html:
    toc: true
    code-fold: true
    theme: cosmo
---
```

## Python Document

````markdown
---
title: "scRNA-seq Analysis"
format: html
jupyter: python3
---

```{python}
import scanpy as sc
import matplotlib.pyplot as plt

adata = sc.read_h5ad('data.h5ad')
sc.pl.umap(adata, color='leiden')
```
````

## R Document

````markdown
---
title: "DE Analysis"
format: html
---

```{r}
library(DESeq2)
dds <- DESeqDataSetFromMatrix(counts, metadata, ~ condition)
dds <- DESeq(dds)
```
````

## Multiple Formats

```yaml
---
title: "Multi-format Report"
format:
  html:
    toc: true
  pdf:
    documentclass: article
  docx:
    reference-doc: template.docx
---
```

```bash
# Render all formats
quarto render report.qmd

# Render specific format
quarto render report.qmd --to pdf
```

## Parameters

```yaml
---
title: "Parameterized Report"
params:
  sample: "sample1"
  threshold: 0.05
---
```

```bash
# Render with parameters
quarto render report.qmd -P sample:sample2 -P threshold:0.01
```

## Tabsets

````markdown
::: {.panel-tabset}

## PCA
```{r}
plotPCA(vsd)
```

## Heatmap
```{r}
pheatmap(mat)
```

:::
````

## Callouts

```markdown
::: {.callout-note}
This is an important note about the analysis.
:::

::: {.callout-warning}
Check your input data format before proceeding.
:::

::: {.callout-tip}
Use caching for long computations.
:::
```

## Cross-References

````markdown
See @fig-volcano for the volcano plot.

```{r}
#| label: fig-volcano
#| fig-cap: "Volcano plot showing DE genes"
ggplot(res, aes(log2FC, -log10(pvalue))) + geom_point()
```

Results are summarized in @tbl-summary.

```{r}
#| label: tbl-summary
#| tbl-cap: "Summary statistics"
knitr::kable(summary_df)
```
````

## Code Cell Options

````markdown
```{python}
#| echo: true
#| warning: false
#| fig-width: 10
#| fig-height: 6
#| cache: true

import scanpy as sc
sc.pl.umap(adata, color='leiden')
```
````

## Inline Code

```markdown
We found `{python} len(sig_genes)` significant genes.
We found `{r} nrow(sig)` significant genes.
```

## Presentations

```yaml
---
title: "Analysis Results"
format: revealjs
---

## Slide 1

Content here

## Slide 2 {.smaller}

More content with smaller text
```

## Quarto Projects

```yaml
# _quarto.yml
project:
  type: website
  output-dir: docs

website:
  title: "Analysis Portal"
  navbar:
    left:
      - href: index.qmd
        text: Home
      - href: methods.qmd
        text: Methods
      - href: results.qmd
        text: Results
```

## Bibliography

```yaml
---
bibliography: references.bib
csl: nature.csl
---
```

```markdown
Gene expression analysis was performed using DESeq2 [@love2014].

## References
```

## Freeze Computations

```yaml
# _quarto.yml
execute:
  freeze: auto  # Only re-run when source changes
```

## Include Files

```markdown
{{< include _methods.qmd >}}
```

## Diagrams with Mermaid

````markdown
```{mermaid}
flowchart LR
    A[Raw Data] --> B[QC]
    B --> C[Alignment]
    C --> D[Quantification]
    D --> E[DE Analysis]
```
````

## Multi-Language Document

````markdown
---
title: "R + Python Analysis"
---

Load in R:
```{r}
library(reticulate)
counts <- read.csv('counts.csv')
```

Process in Python:
```{python}
import pandas as pd
counts_py = r.counts  # Access R object
```
````

## Related Skills

- reporting/rmarkdown-reports - R-focused alternative
- data-visualization/ggplot2-fundamentals - R visualizations
- workflow-management/snakemake-workflows - Pipeline integration


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->