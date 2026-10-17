---
name: omics-multi-omics-data-harmonization
description: 提供统一多组学样本并处理归一化、批次和缺失值的方法与调用指南；用于处理RNA、蛋白、甲基化矩阵及样本/批次信息。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: MultiAssayExperiment
---

## Version Compatibility

Reference examples tested with: DESeq2 1.42+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Data Harmonization for Multi-Omics

## Codex 调用

- **选择**：请求涉及“统一多组学样本并处理归一化、批次和缺失值”时使用；显式调用 `$omics-multi-omics-data-harmonization`。
- **输入**：RNA、蛋白、甲基化矩阵及样本/批次信息。
- **预期产物**：MultiAssayExperiment和校正后的多组学矩阵；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`MultiAssayExperiment`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Prepare my multi-omics data for integration"** → Normalize, batch-correct, align features, and handle missing values across RNA-seq, proteomics, methylation, and other data types before joint analysis.
- R: `MultiAssayExperiment` for unified multi-omics containers

## MultiAssayExperiment Structure

```r
library(MultiAssayExperiment)

# Load individual assays
rna <- SummarizedExperiment(assays = list(counts = rna_matrix), colData = sample_info)
protein <- SummarizedExperiment(assays = list(intensity = protein_matrix), colData = sample_info)
methylation <- SummarizedExperiment(assays = list(beta = meth_matrix), colData = sample_info)

# Create experiment list
exp_list <- ExperimentList(RNA = rna, Protein = protein, Methylation = methylation)

# Sample map (links samples to assays)
smap <- data.frame(
    assay = rep(c('RNA', 'Protein', 'Methylation'), each = nrow(sample_info)),
    primary = rep(sample_info$SampleID, 3),
    colname = c(colnames(rna_matrix), colnames(protein_matrix), colnames(meth_matrix))
)

# Create MAE
mae <- MultiAssayExperiment(experiments = exp_list, colData = sample_info, sampleMap = smap)
```

## Normalization Per Assay

```r
# RNA-seq: VST normalization
library(DESeq2)
dds <- DESeqDataSetFromMatrix(countData = assay(mae, 'RNA'),
                               colData = colData(mae),
                               design = ~ 1)
vst_rna <- assay(vst(dds))

# Proteomics: Log2 + median centering
log2_protein <- log2(assay(mae, 'Protein'))
log2_protein[is.infinite(log2_protein)] <- NA
medians <- apply(log2_protein, 2, median, na.rm = TRUE)
norm_protein <- sweep(log2_protein, 2, medians - median(medians))

# Methylation: M-value transformation
beta <- assay(mae, 'Methylation')
m_values <- log2(beta / (1 - beta))
```

## Cross-Omics Batch Correction

**Goal:** Remove batch effects across multi-omics data types while preserving biological signal from condition differences.

**Approach:** Stack normalized matrices from RNA, protein, and methylation assays for common samples, apply ComBat batch correction on the combined matrix, then split back into per-assay corrected matrices.

```r
library(sva)

# Combine normalized matrices for joint batch correction
# Only use common samples
common_samples <- Reduce(intersect, colnames(mae))

combined <- rbind(
    vst_rna[, common_samples],
    norm_protein[, common_samples],
    m_values[, common_samples]
)

# Add omics type as covariate
omics_type <- c(rep('RNA', nrow(vst_rna)),
                rep('Protein', nrow(norm_protein)),
                rep('Methylation', nrow(m_values)))

# ComBat for batch correction
batch <- colData(mae)[common_samples, 'Batch']
mod <- model.matrix(~ Condition, data = colData(mae)[common_samples, ])

corrected <- ComBat(dat = combined, batch = batch, mod = mod)

# Split back into separate matrices
idx_rna <- 1:nrow(vst_rna)
idx_prot <- (nrow(vst_rna) + 1):(nrow(vst_rna) + nrow(norm_protein))
idx_meth <- (nrow(vst_rna) + nrow(norm_protein) + 1):nrow(combined)

corrected_rna <- corrected[idx_rna, ]
corrected_protein <- corrected[idx_prot, ]
corrected_meth <- corrected[idx_meth, ]
```

## Feature Alignment (Gene-Level)

```r
library(biomaRt)

# Map protein IDs to gene symbols
ensembl <- useEnsembl(biomart = 'genes', dataset = 'hsapiens_gene_ensembl')

# Protein to gene mapping
protein_ids <- rownames(norm_protein)
protein_mapping <- getBM(attributes = c('uniprotswissprot', 'hgnc_symbol'),
                          filters = 'uniprotswissprot',
                          values = protein_ids,
                          mart = ensembl)

# Aggregate proteins to gene level (mean)
protein_gene <- norm_protein
rownames(protein_gene) <- protein_mapping$hgnc_symbol[match(rownames(protein_gene), protein_mapping$uniprotswissprot)]
protein_gene <- protein_gene[!is.na(rownames(protein_gene)), ]
protein_gene <- aggregate(. ~ rownames(protein_gene), data = as.data.frame(protein_gene), FUN = mean)

# Map methylation probes to genes
# (requires annotation package, e.g., IlluminaHumanMethylation450kanno.ilmn12.hg19)
library(IlluminaHumanMethylation450kanno.ilmn12.hg19)
anno <- getAnnotation(IlluminaHumanMethylation450kanno.ilmn12.hg19)
probe_genes <- anno[rownames(m_values), 'UCSC_RefGene_Name']
```

## Missing Value Handling

```r
# Per-assay missing value analysis
missing_summary <- function(mat) {
    data.frame(
        total_missing = sum(is.na(mat)),
        pct_missing = mean(is.na(mat)) * 100,
        samples_complete = sum(colSums(is.na(mat)) == 0),
        features_complete = sum(rowSums(is.na(mat)) == 0)
    )
}

lapply(list(RNA = vst_rna, Protein = norm_protein, Methylation = m_values), missing_summary)

# Filter features with too many missing values
filter_missing <- function(mat, max_missing_pct = 50) {
    keep <- rowMeans(is.na(mat)) * 100 < max_missing_pct
    mat[keep, ]
}

protein_filtered <- filter_missing(norm_protein, max_missing_pct = 30)

# Imputation (MinProb for proteomics)
impute_minprob <- function(mat) {
    for (i in 1:ncol(mat)) {
        nas <- is.na(mat[, i])
        if (any(nas)) {
            q01 <- quantile(mat[, i], 0.01, na.rm = TRUE)
            mat[nas, i] <- rnorm(sum(nas), mean = q01, sd = abs(q01) * 0.1)
        }
    }
    mat
}

protein_imputed <- impute_minprob(protein_filtered)
```

## Sample Matching and Subsetting

```r
# Find complete samples across all assays
complete_samples <- intersectColumns(mae)
cat('Samples in all assays:', ncol(complete_samples), '\n')

# Subset to common samples
mae_matched <- mae[, complete_samples, ]

# Alternative: keep samples with N-1 assays
subsetByColData(mae, mae$has_at_least_2_assays)
```

## Scale and Center

```r
# Z-score transformation (per feature)
scale_matrix <- function(mat) {
    t(scale(t(mat)))
}

scaled_rna <- scale_matrix(vst_rna)
scaled_protein <- scale_matrix(norm_protein)
scaled_meth <- scale_matrix(m_values)

# Verify scaling
cat('RNA mean:', mean(scaled_rna, na.rm = TRUE), 'sd:', sd(scaled_rna, na.rm = TRUE), '\n')
```

## Export Harmonized Data

```r
# Save as list for integration tools
harmonized <- list(
    RNA = scaled_rna,
    Protein = scaled_protein,
    Methylation = scaled_meth,
    sample_info = colData(mae)[common_samples, ]
)

saveRDS(harmonized, 'harmonized_multiomics.rds')

# Or as separate CSVs
write.csv(scaled_rna, 'harmonized_rna.csv')
write.csv(scaled_protein, 'harmonized_protein.csv')
write.csv(scaled_meth, 'harmonized_methylation.csv')
```

## Related Skills

- mofa-integration - Use harmonized data in MOFA2
- mixomics-analysis - Use harmonized data in mixOmics
- differential-expression/batch-correction - RNA-seq batch correction
- proteomics/proteomics-qc - Proteomics-specific QC
