---
name: omics-flow-cytometry-differential-analysis
description: 提供比较细胞群丰度和标志物状态的组间差异的方法与调用指南；用于处理已聚类SCE、样本/条件元数据、设计和对比。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: CATALYST
---

## Version Compatibility

Reference examples tested with: R stats (base), edgeR 4.0+, ggplot2 3.5+, limma 3.58+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Differential Analysis

## Codex 调用

- **选择**：请求涉及“比较细胞群丰度和标志物状态的组间差异”时使用；显式调用 `$omics-flow-cytometry-differential-analysis`。
- **输入**：已聚类SCE、样本/条件元数据、设计和对比。
- **预期产物**：DA/DS统计表、校正p值、热图和导出结果；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`CATALYST`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Compare cell populations between my conditions"** → Test for significant changes in cell type frequencies (differential abundance) or marker expression levels (differential state) between experimental groups.
- R: `CATALYST::testDA_edgeR()` or `diffcyt::testDA_GLMM()`

## Differential Abundance (DA)

**Goal:** Test which cell population clusters differ in frequency between experimental conditions.

**Approach:** Create a design matrix and contrast from sample metadata, then run edgeR-based differential abundance testing on cluster counts per sample using testDA_edgeR from the diffcyt framework.

```r
library(CATALYST)
library(diffcyt)

# Load clustered data
sce <- readRDS('sce_clustered.rds')

# Create design matrix
design <- createDesignMatrix(ei(sce), cols_design = 'condition')

# Create contrast
contrast <- createContrast(c(0, 1))  # Treatment vs Control

# Differential abundance test
res_DA <- testDA_edgeR(sce, design, contrast, cluster_id = 'meta20')

# View results
rowData(res_DA)$cluster_id
rowData(res_DA)$p_adj

# Significant clusters
sig_DA <- rowData(res_DA)$p_adj < 0.05
table(sig_DA)
```

## Differential State (DS)

```r
# Test for marker expression differences within clusters
res_DS <- testDS_limma(sce, design, contrast,
                        cluster_id = 'meta20',
                        markers_include = rownames(sce)[rowData(sce)$marker_class == 'state'])

# Results per marker per cluster
ds_results <- rowData(res_DS)
```

## Visualization

```r
# DA results heatmap
plotDiffHeatmap(sce, res_DA, all = TRUE, fdr = 0.05)

# DS results heatmap
plotDiffHeatmap(sce, res_DS, all = TRUE, fdr = 0.05)

# Abundance by condition
plotAbundances(sce, k = 'meta20', by = 'cluster_id', group_by = 'condition')
```

## Manual Statistical Testing

```r
library(tidyverse)

# Get cluster frequencies per sample
freqs <- colData(sce) %>%
    as.data.frame() %>%
    group_by(sample_id, condition, cluster_id = cluster_ids(sce, 'meta20')) %>%
    summarise(n = n(), .groups = 'drop') %>%
    group_by(sample_id) %>%
    mutate(freq = n / sum(n) * 100)

# Test each cluster
test_abundance <- function(df, cluster) {
    cluster_data <- filter(df, cluster_id == cluster)
    ctrl <- filter(cluster_data, condition == 'Control')$freq
    treat <- filter(cluster_data, condition == 'Treatment')$freq

    if (length(ctrl) >= 2 && length(treat) >= 2) {
        test <- t.test(treat, ctrl)
        return(data.frame(
            cluster = cluster,
            fc = mean(treat) / mean(ctrl),
            pvalue = test$p.value
        ))
    }
    return(NULL)
}

results <- map_dfr(unique(freqs$cluster_id), ~test_abundance(freqs, .x))
results$padj <- p.adjust(results$pvalue, method = 'BH')
```

## Mixed Effects Models

```r
library(lme4)
library(lmerTest)

# For paired/repeated measures designs
# Random effect for patient/donor

fit_mixed <- function(df, cluster) {
    cluster_data <- filter(df, cluster_id == cluster)

    model <- lmer(freq ~ condition + (1|patient_id), data = cluster_data)

    coef <- summary(model)$coefficients
    return(data.frame(
        cluster = cluster,
        estimate = coef[2, 'Estimate'],
        pvalue = coef[2, 'Pr(>|t|)']
    ))
}
```

## CITRUS (Automated Discovery)

```r
library(citrus)

# Prepare data
fcs_files <- list.files('data', pattern = '\\.fcs$', full.names = TRUE)
labels <- c(rep('Control', 2), rep('Treatment', 2))

# Run CITRUS
citrus_result <- citrus(
    fcs_files,
    labels,
    fileSampleSize = 1000,
    featureType = 'abundances',
    modelType = 'glmnet',
    family = 'classification'
)

# Get significant clusters
citrus_plot(citrus_result)
```

## Volcano Plot

```r
library(ggplot2)

# From DA results
da_df <- as.data.frame(rowData(res_DA))
da_df$significant <- da_df$p_adj < 0.05

ggplot(da_df, aes(x = logFC, y = -log10(p_adj), color = significant)) +
    geom_point() +
    geom_hline(yintercept = -log10(0.05), linetype = 'dashed') +
    geom_vline(xintercept = c(-1, 1), linetype = 'dashed') +
    scale_color_manual(values = c('gray', 'red')) +
    theme_bw() +
    labs(title = 'Differential Abundance')
```

## Export Results

```r
# Combine DA and DS results
da_results <- as.data.frame(rowData(res_DA))
da_results$analysis <- 'DA'

ds_results <- as.data.frame(rowData(res_DS))
ds_results$analysis <- 'DS'

# Save
write.csv(da_results, 'da_results.csv', row.names = FALSE)
write.csv(ds_results, 'ds_results.csv', row.names = FALSE)
```

## Multiple Comparisons

```r
# For multiple conditions
design_full <- model.matrix(~ 0 + condition, data = ei(sce))
colnames(design_full) <- levels(factor(ei(sce)$condition))

# Multiple contrasts
contrasts <- makeContrasts(
    TreatA_vs_Ctrl = TreatmentA - Control,
    TreatB_vs_Ctrl = TreatmentB - Control,
    TreatA_vs_B = TreatmentA - TreatmentB,
    levels = design_full
)

# Test each contrast
res_list <- lapply(1:ncol(contrasts), function(i) {
    testDA_edgeR(sce, design_full, contrasts[, i], cluster_id = 'meta20')
})
```

## Related Skills

- clustering-phenotyping - Cluster data first
- gating-analysis - Compare gated populations
- differential-expression/de-results - Similar statistical concepts
