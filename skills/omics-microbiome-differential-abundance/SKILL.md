---
name: omics-microbiome-differential-abundance
description: 提供用ALDEx2、ANCOM-BC2或MaAsLin2比较菌群丰度的方法与调用指南；用于处理phyloseq对象、样本分组和协变量。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: ALDEx2
---

## Version Compatibility

Reference examples tested with: DESeq2 1.42+, ggplot2 3.5+, phyloseq 1.46+, scanpy 1.10+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Differential Abundance Testing

## Codex 调用

- **选择**：请求涉及“用ALDEx2、ANCOM-BC2或MaAsLin2比较菌群丰度”时使用；显式调用 `$omics-microbiome-differential-abundance`。
- **输入**：phyloseq对象、样本分组和协变量。
- **预期产物**：差异分类单元、效应量、校正P值和图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`ALDEx2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Find which taxa differ between my groups"** → Identify differentially abundant taxa between experimental conditions using compositionally-aware methods that account for the relative nature of microbiome data.
- R: `ALDEx2::aldex()` for CLR-transformed Welch's t-test
- R: `ANCOMBC::ancombc2()` for bias-corrected log-linear models
- R: `Maaslin2::Maaslin2()` for multivariable association

## The Compositionality Problem

Microbiome data is compositional - abundances are relative, not absolute. Standard tests (t-test, DESeq2) can give false positives.

## ALDEx2 (Recommended)

**Goal:** Identify differentially abundant taxa between groups using a compositionally-aware statistical framework.

**Approach:** Apply CLR transformation with Monte Carlo sampling on the OTU table, run Welch's t-test per taxon, and filter by FDR-corrected p-value and effect size.

```r
library(ALDEx2)
library(phyloseq)

ps <- readRDS('phyloseq_object.rds')
otu <- as.data.frame(otu_table(ps))
if (!taxa_are_rows(ps)) otu <- t(otu)

# Define groups
groups <- sample_data(ps)$Group

# Run ALDEx2 (CLR transformation + Welch's t-test)
aldex_results <- aldex(otu, groups, mc.samples = 128, test = 'welch',
                       effect = TRUE, include.sample.summary = FALSE)

# Filter significant
sig_aldex <- aldex_results[aldex_results$we.eBH < 0.05 & abs(aldex_results$effect) > 1, ]

# Volcano-like plot
aldex.plot(aldex_results, type = 'MW', test = 'welch')
```

## ANCOM-BC2 (Recommended)

```r
library(ANCOMBC)

# Run ANCOM-BC2 with sensitivity analysis
ancom_result <- ancombc2(data = ps, fix_formula = 'Group',
                         p_adj_method = 'BH', pseudo_sens = TRUE,
                         prv_cut = 0.1, lib_cut = 1000,
                         group = 'Group', struc_zero = TRUE)

# Extract results (includes sensitivity analysis)
res_df <- ancom_result$res

# Primary results
sig_ancom <- res_df[res_df$diff_Group == TRUE, ]

# Check sensitivity (passed_ss = passed sensitivity analysis)
robust_hits <- res_df[res_df$diff_Group == TRUE & res_df$passed_ss_Group == TRUE, ]
```

## MaAsLin2

```r
library(Maaslin2)

# Prepare data
features <- as.data.frame(t(otu_table(ps)))
metadata <- as.data.frame(sample_data(ps))

# Run MaAsLin2
maaslin_results <- Maaslin2(
    input_data = features,
    input_metadata = metadata,
    output = 'maaslin2_output',
    fixed_effects = 'Group',
    normalization = 'CLR',
    transform = 'NONE',
    analysis_method = 'LM'
)

# Results in maaslin2_output/all_results.tsv
sig_maaslin <- maaslin_results$results[maaslin_results$results$qval < 0.05, ]
```

## DESeq2 (with caution)

```r
library(DESeq2)
library(phyloseq)

# Convert to DESeq2 (use geometric mean of poscounts)
ps_deseq <- ps
ps_deseq <- prune_samples(sample_sums(ps_deseq) > 1000, ps_deseq)

dds <- phyloseq_to_deseq2(ps_deseq, ~ Group)
dds <- DESeq(dds, test = 'Wald', fitType = 'parametric', sfType = 'poscounts')

res <- results(dds, alpha = 0.05)
sig_deseq <- res[which(res$padj < 0.05 & abs(res$log2FoldChange) > 1), ]
```

## Visualization

```r
library(ggplot2)

# Volcano plot from ALDEx2
ggplot(aldex_results, aes(x = effect, y = -log10(we.eBH))) +
    geom_point(aes(color = we.eBH < 0.05 & abs(effect) > 1), alpha = 0.6) +
    geom_hline(yintercept = -log10(0.05), linetype = 'dashed') +
    geom_vline(xintercept = c(-1, 1), linetype = 'dashed') +
    scale_color_manual(values = c('grey', 'red')) +
    theme_minimal() +
    labs(x = 'Effect Size', y = '-log10(Adjusted P-value)')
```

## Method Comparison

| Method | Handles | Covariates | Speed | Notes |
|--------|---------|------------|-------|-------|
| ALDEx2 | Compositionality | Limited | Slow | Best for simple designs |
| ANCOM-BC2 | Compositionality, zeros, sensitivity | Yes | Medium | Recommended for complex designs |
| MaAsLin2 | Compositionality | Yes | Fast | Good for longitudinal |
| DESeq2 | Sparsity (less ideal) | Yes | Fast | Use with caution for microbiome |

## Related Skills

- diversity-analysis - Identify overall differences first
- differential-expression/deseq2-basics - Similar concepts
- pathway-analysis/go-enrichment - Enrichment of differential taxa
