---
name: research-reporting-rmarkdown-reports
description: 提供用R Markdown编排可复现分析报告的方法与调用指南；用于处理Rmd模板、数据、R包和参数。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: rmarkdown
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


# R Markdown Reports

## Codex 调用

- **选择**：请求涉及“用R Markdown编排可复现分析报告”时使用；显式调用 `$research-reporting-rmarkdown-reports`。
- **输入**：Rmd模板、数据、R包和参数。
- **预期产物**：HTML、PDF或Word报告；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`rmarkdown`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Basic Document Structure

```yaml
---
title: "RNA-seq Analysis Report"
author: "Your Name"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_float: true
    code_folding: hide
    theme: cosmo
---
```

## Setup Chunk

````r
```{r setup, include=FALSE}
knitr::opts_chunk$set(
    echo = TRUE,
    message = FALSE,
    warning = FALSE,
    fig.width = 10,
    fig.height = 6,
    fig.align = 'center'
)
library(tidyverse)
library(DESeq2)
library(pheatmap)
```
````

## Code Chunk Options

````r
```{r analysis, echo=TRUE, results='hide'}
# echo: show code
# results: 'hide', 'asis', 'markup'
# include: FALSE hides chunk entirely
# eval: FALSE shows code but doesn't run
# cache: TRUE caches results
```
````

## Parameterized Reports

```yaml
---
title: "Sample Report"
params:
  sample_id: "sample1"
  count_file: "counts.csv"
  fdr_threshold: 0.05
---
```

````r
```{r}
counts <- read.csv(params$count_file)
sample <- params$sample_id
fdr <- params$fdr_threshold
```
````

```r
# Render with parameters
rmarkdown::render('report.Rmd', params = list(sample_id = 'sample2', fdr_threshold = 0.01))

# Batch render
samples <- c('sample1', 'sample2', 'sample3')
for (s in samples) {
    rmarkdown::render('report.Rmd', params = list(sample_id = s),
                       output_file = paste0(s, '_report.html'))
}
```

## Tables

````r
```{r}
# Basic kable table
knitr::kable(head(results), caption = 'Top DE genes')

# Interactive table with DT
library(DT)
datatable(results, filter = 'top', options = list(pageLength = 10))

# Formatted table with kableExtra
library(kableExtra)
results %>%
    head(10) %>%
    kable() %>%
    kable_styling(bootstrap_options = c('striped', 'hover')) %>%
    row_spec(which(results$padj < 0.01), bold = TRUE, color = 'red')
```
````

## Figures

````r
```{r volcano-plot, fig.cap="Volcano plot of differential expression"}
ggplot(results, aes(log2FoldChange, -log10(pvalue))) +
    geom_point(aes(color = padj < 0.05)) +
    theme_minimal()
```
````

## Inline Code

```markdown
We identified `r sum(res$padj < 0.05, na.rm=TRUE)` significantly
DE genes (FDR < 0.05) out of `r nrow(res)` tested.
```

## Child Documents

```yaml
---
title: "Main Report"
---
```

````r
```{r child='methods.Rmd'}
```

```{r child='results.Rmd'}
```
````

## PDF Output

```yaml
---
output:
  pdf_document:
    toc: true
    number_sections: true
    fig_caption: true
    latex_engine: xelatex
---
```

## HTML with Tabs

````r
## Results {.tabset}

### PCA Plot
```{r}
plotPCA(vsd, intgroup = 'condition')
```

### Heatmap
```{r}
pheatmap(assay(vsd)[top_genes, ])
```
````

## Caching Long Computations

````r
```{r deseq-analysis, cache=TRUE, cache.extra=tools::md5sum('counts.csv')}
# Cached unless counts.csv changes
dds <- DESeqDataSetFromMatrix(counts, metadata, ~ condition)
dds <- DESeq(dds)
```

```{r downstream, dependson='deseq-analysis'}
# Re-runs when deseq-analysis cache changes
res <- results(dds)
```
````

## Custom CSS

```yaml
---
output:
  html_document:
    css: custom.css
---
```

```css
/* custom.css */
body { font-family: 'Helvetica', sans-serif; }
h1 { color: #2c3e50; }
.figure { margin: 20px auto; }
```

## Complete Report Template

````markdown
---
title: "RNA-seq Analysis Report"
author: "Bioinformatics Core"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_float: true
    code_folding: hide
params:
  count_file: "counts.csv"
  metadata_file: "metadata.csv"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
library(DESeq2)
library(tidyverse)
library(pheatmap)
library(DT)
```

## Data Overview

```{r load-data}
counts <- read.csv(params$count_file, row.names = 1)
metadata <- read.csv(params$metadata_file, row.names = 1)
```

Loaded `r nrow(counts)` genes across `r ncol(counts)` samples.

## Differential Expression

```{r de-analysis, cache=TRUE}
dds <- DESeqDataSetFromMatrix(counts, metadata, ~ condition)
dds <- DESeq(dds)
res <- results(dds) %>% as.data.frame() %>% arrange(padj)
```

## Results

```{r results-table}
datatable(res %>% filter(padj < 0.05), options = list(pageLength = 10))
```
````

## Related Skills

- reporting/quarto-reports - Modern alternative
- data-visualization/ggplot2-fundamentals - Figure creation
- differential-expression/de-visualization - Analysis plots


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->