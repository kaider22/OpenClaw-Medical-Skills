---
name: sop-omics-proteomics-pipeline
description: 从MaxQuant或DIA-NN结果做蛋白差异丰度分析；用于处理proteinGroups/evidence、样本注释和实验分组。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: MSstats
    workflow: true
    depends_on:
    - omics-proteomics-data-import
    - omics-proteomics-proteomics-qc
    - omics-proteomics-quantification
    - omics-proteomics-protein-inference
    - omics-proteomics-differential-abundance
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


# Proteomics Pipeline

## Codex 调用

- **选择**：请求涉及“从MaxQuant或DIA-NN结果做蛋白差异丰度分析”时使用；显式调用 `$sop-omics-proteomics-pipeline`。
- **输入**：proteinGroups/evidence、样本注释和实验分组。
- **预期产物**：归一化矩阵、差异蛋白表和QC图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文 SOP 顺序调用所列软件，逐阶段核对输入、输出和质量检查；有分支时按当前数据选择，不把流程文档当作已完成的运行。
- **环境核对**：`MSstats`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **流程依赖**：[omics-proteomics-data-import](../omics-proteomics-data-import/SKILL.md) → [omics-proteomics-proteomics-qc](../omics-proteomics-proteomics-qc/SKILL.md) → [omics-proteomics-quantification](../omics-proteomics-quantification/SKILL.md) → [omics-proteomics-protein-inference](../omics-proteomics-protein-inference/SKILL.md) → [omics-proteomics-differential-abundance](../omics-proteomics-differential-abundance/SKILL.md)。依赖所需数据或环境缺失时停止对应阶段，不把后续阶段标为通过。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Pipeline Overview

```
Raw MS Data (mzML) ──> MaxQuant/DIA-NN ──> proteinGroups.txt
                                                 │
                                                 ▼
                    ┌────────────────────────────────────────────┐
                    │           proteomics-pipeline              │
                    ├────────────────────────────────────────────┤
                    │  1. Data Import & Filtering                │
                    │  2. Log2 Transform & Normalization         │
                    │  3. Missing Value Imputation               │
                    │  4. QC: PCA, Correlation                   │
                    │  5. Differential Abundance (limma/MSstats) │
                    │  6. Visualization & Export                 │
                    └────────────────────────────────────────────┘
                                                 │
                                                 ▼
                          Differential Proteins + Volcano Plots
```

## Complete R Workflow

```r
library(limma)
library(ggplot2)
library(pheatmap)

# === 1. DATA IMPORT ===
proteins <- read.delim('proteinGroups.txt', stringsAsFactors = FALSE)
cat('Loaded', nrow(proteins), 'protein groups\n')

# Filter contaminants, reverse, only-by-site
proteins <- proteins[proteins$Potential.contaminant != '+' &
                      proteins$Reverse != '+' &
                      proteins$Only.identified.by.site != '+', ]
cat('After filtering:', nrow(proteins), 'proteins\n')

# Extract LFQ intensities
lfq_cols <- grep('^LFQ\\.intensity\\.', colnames(proteins), value = TRUE)
intensities <- proteins[, lfq_cols]
rownames(intensities) <- proteins$Majority.protein.IDs
colnames(intensities) <- gsub('LFQ\\.intensity\\.', '', colnames(intensities))

# === 2. LOG2 TRANSFORM & NORMALIZE ===
intensities[intensities == 0] <- NA
log2_int <- log2(intensities)

# Median centering
sample_medians <- apply(log2_int, 2, median, na.rm = TRUE)
global_median <- median(sample_medians)
normalized <- sweep(log2_int, 2, sample_medians - global_median)

# === 3. FILTER & IMPUTE ===
# Keep proteins with < 50% missing
valid_rows <- rowSums(is.na(normalized)) < ncol(normalized) * 0.5
filtered <- normalized[valid_rows, ]
cat('Proteins after filtering:', nrow(filtered), '\n')

# MinProb imputation (left-censored)
impute_minprob <- function(x) {
    nas <- is.na(x)
    if (all(nas)) return(x)
    x[nas] <- rnorm(sum(nas), mean = mean(x, na.rm = TRUE) - 1.8 * sd(x, na.rm = TRUE),
                    sd = 0.3 * sd(x, na.rm = TRUE))
    x
}
imputed <- as.data.frame(t(apply(filtered, 1, impute_minprob)))

# === 4. QC ===
# PCA
pca <- prcomp(t(imputed), scale. = TRUE)
pca_df <- data.frame(PC1 = pca$x[, 1], PC2 = pca$x[, 2], Sample = rownames(pca$x))

# === 5. DIFFERENTIAL ANALYSIS ===
# Load sample annotation (columns: sample, condition)
sample_info <- read.csv('sample_annotation.csv')
sample_info$condition <- factor(sample_info$condition)

design <- model.matrix(~ 0 + condition, data = sample_info)
colnames(design) <- levels(sample_info$condition)

fit <- lmFit(as.matrix(imputed), design)
contrast <- makeContrasts(Treatment - Control, levels = design)
fit2 <- contrasts.fit(fit, contrast)
fit2 <- eBayes(fit2)

results <- topTable(fit2, number = Inf, adjust.method = 'BH')
results$protein <- rownames(results)
results$significant <- abs(results$logFC) > 1 & results$adj.P.Val < 0.05

# === 6. OUTPUT ===
cat('\nResults:\n')
cat('  Significant proteins:', sum(results$significant), '\n')
cat('  Up-regulated:', sum(results$significant & results$logFC > 0), '\n')
cat('  Down-regulated:', sum(results$significant & results$logFC < 0), '\n')

write.csv(results, 'differential_proteins.csv', row.names = FALSE)
```

## MSstats Workflow

```r
library(MSstats)

# From MaxQuant
evidence <- read.table('evidence.txt', sep = '\t', header = TRUE)
proteinGroups <- read.table('proteinGroups.txt', sep = '\t', header = TRUE)
annotation <- read.csv('annotation.csv')

# Convert to MSstats format
msstats_input <- MaxQtoMSstatsFormat(evidence = evidence,
                                      proteinGroups = proteinGroups,
                                      annotation = annotation)

# Process data
processed <- dataProcess(msstats_input, normalization = 'equalizeMedians',
                         summaryMethod = 'TMP', censoredInt = 'NA')

# Comparison
comparison <- matrix(c(1, -1), nrow = 1)
rownames(comparison) <- 'Treatment_vs_Control'
colnames(comparison) <- c('Control', 'Treatment')

results <- groupComparison(contrast.matrix = comparison, data = processed)
```

## QC Checkpoints

| Stage | Check | Action if Failed |
|-------|-------|------------------|
| Import | >1000 proteins | Re-run MaxQuant |
| Filter | <30% removed | Check sample prep |
| Missing | <40% per sample | Check MS performance |
| PCA | Replicates cluster | Check for batch effects |
| Stats | >1% differential | Adjust thresholds |

## Workflow Variants

### TMT/iTRAQ Isobaric Labeling
```r
library(MSnbase)

# Load TMT data
tmt_data <- readMSnSet('tmt_psms.txt')

# Normalize with reference channel
tmt_norm <- normalize(tmt_data, method = 'center.median')

# Summarize to protein level
protein_data <- combineFeatures(tmt_norm, groupBy = fData(tmt_norm)$protein, fun = 'median')

# Then proceed with limma as above
```

### SILAC Workflow
```r
# SILAC ratios from MaxQuant
silac <- read.delim('proteinGroups.txt')
ratio_cols <- grep('Ratio.H.L.normalized', colnames(silac), value = TRUE)

# Log2 transform ratios
silac_log2 <- log2(silac[, ratio_cols])

# One-sample t-test against 0 (no change)
results <- apply(silac_log2, 1, function(x) t.test(x, mu = 0)$p.value)
```

### DIA-NN Workflow
```r
# Load DIA-NN report
diann <- read.delim('report.tsv')

# Pivot to matrix
library(tidyr)
protein_matrix <- diann %>%
    select(Protein.Group, Run, PG.MaxLFQ) %>%
    pivot_wider(names_from = Run, values_from = PG.MaxLFQ)

# Then proceed with normalization and limma
```

## Related Skills

- proteomics/data-import - Load MS data formats
- proteomics/proteomics-qc - Quality control before analysis
- proteomics/quantification - Normalization methods
- proteomics/differential-abundance - Statistical testing details
- proteomics/ptm-analysis - Phosphoproteomics and other PTMs
- data-visualization/specialized-omics-plots - Volcano plots


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->