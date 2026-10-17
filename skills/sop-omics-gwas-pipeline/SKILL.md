---
name: sop-omics-gwas-pipeline
description: 从基因型数据完成QC、PCA和全基因组关联；用于处理VCF/PLINK、表型、协变量和样本信息。
metadata:
  source_extensions:
    tool_type: mixed
    primary_tool: PLINK2
    workflow: true
    depends_on:
    - omics-population-genetics-plink-basics
    - omics-population-genetics-population-structure
    - omics-population-genetics-association-testing
    - omics-population-genetics-linkage-disequilibrium
    qc_checkpoints:
    - after_qc: Sample/variant call rates >95%, HWE p>1e-6
    - after_structure: No population stratification bias
    - after_association: Lambda ~1.0, expected QQ plot
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


# GWAS Pipeline

## Codex 调用

- **选择**：请求涉及“从基因型数据完成QC、PCA和全基因组关联”时使用；显式调用 `$sop-omics-gwas-pipeline`。
- **输入**：VCF/PLINK、表型、协变量和样本信息。
- **预期产物**：关联统计、PCA、Manhattan/QQ图和显著位点；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文 SOP 顺序调用所列软件，逐阶段核对输入、输出和质量检查；有分支时按当前数据选择，不把流程文档当作已完成的运行。
- **环境核对**：`PLINK2`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **流程依赖**：[omics-population-genetics-plink-basics](../omics-population-genetics-plink-basics/SKILL.md) → [omics-population-genetics-population-structure](../omics-population-genetics-population-structure/SKILL.md) → [omics-population-genetics-association-testing](../omics-population-genetics-association-testing/SKILL.md) → [omics-population-genetics-linkage-disequilibrium](../omics-population-genetics-linkage-disequilibrium/SKILL.md)。依赖所需数据或环境缺失时停止对应阶段，不把后续阶段标为通过。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Complete workflow for genome-wide association studies from genotype data to significant associations.

## Workflow Overview

```
VCF/PLINK files
    |
    v
[1. QC Filtering] ------> Sample and variant QC
    |
    v
[2. LD Pruning] --------> Independent variants for PCA
    |
    v
[3. Population Structure] --> PCA for covariates
    |
    v
[4. Association Testing] --> Logistic/linear regression
    |
    v
[5. Results] -----------> Manhattan plot, QQ plot
    |
    v
Significant associations
```

## Step 1: Data Import and QC

### Convert VCF to PLINK

```bash
# VCF to PLINK binary format
plink2 --vcf input.vcf.gz \
    --make-bed \
    --out study

# Or with phenotype/covariate files
plink2 --vcf input.vcf.gz \
    --pheno phenotypes.txt \
    --make-bed \
    --out study
```

### Sample QC

```bash
# Calculate sample statistics
plink2 --bfile study \
    --missing \
    --out study_stats

# Remove samples with high missing rate (>5%)
plink2 --bfile study \
    --mind 0.05 \
    --make-bed \
    --out study_sample_qc

# Check for sex discrepancies (if sex chromosome data available)
plink2 --bfile study_sample_qc \
    --check-sex \
    --out study_sex_check

# Remove related individuals (optional, requires IBD)
plink2 --bfile study_sample_qc \
    --king-cutoff 0.0884 \
    --make-bed \
    --out study_unrelated
```

### Variant QC

```bash
# Apply standard variant filters
plink2 --bfile study_sample_qc \
    --geno 0.05 \
    --maf 0.01 \
    --hwe 1e-6 \
    --make-bed \
    --out study_qc

# Summary
plink2 --bfile study_qc --freq --out study_qc
```

**QC Checkpoint:**
- Sample call rate >95%
- Variant call rate >95%
- MAF >1%
- HWE p-value >1e-6 (controls only for case-control)

## Step 2: LD Pruning for PCA

```bash
# Identify independent variants
plink2 --bfile study_qc \
    --indep-pairwise 50 5 0.2 \
    --out pruned

# Extract pruned variants
plink2 --bfile study_qc \
    --extract pruned.prune.in \
    --make-bed \
    --out study_pruned
```

## Step 3: Population Structure (PCA)

```bash
# Calculate principal components
plink2 --bfile study_pruned \
    --pca 10 \
    --out study_pca

# The eigenvec file contains PCs for use as covariates
```

### Visualize PCA

```r
library(ggplot2)

# Load PCA results
pca <- read.table('study_pca.eigenvec', header = FALSE)
colnames(pca) <- c('FID', 'IID', paste0('PC', 1:10))

# Load phenotype for coloring
pheno <- read.table('phenotypes.txt', header = TRUE)
pca <- merge(pca, pheno, by = c('FID', 'IID'))

# Plot
ggplot(pca, aes(x = PC1, y = PC2, color = as.factor(PHENO))) +
    geom_point(alpha = 0.5) +
    labs(title = 'PCA of Study Samples', color = 'Phenotype') +
    theme_minimal()
ggsave('pca_plot.pdf', width = 8, height = 6)
```

## Step 4: Association Testing

### Case-Control (Binary Trait)

```bash
# Logistic regression with PCA covariates
plink2 --bfile study_qc \
    --pheno phenotypes.txt \
    --covar study_pca.eigenvec \
    --covar-col-nums 3-12 \
    --glm hide-covar \
    --out gwas_results

# Results in gwas_results.PHENO.glm.logistic
```

### Quantitative Trait

```bash
# Linear regression
plink2 --bfile study_qc \
    --pheno phenotypes.txt \
    --pheno-name BMI \
    --covar study_pca.eigenvec \
    --covar-col-nums 3-12 \
    --glm hide-covar \
    --out gwas_bmi

# Results in gwas_bmi.BMI.glm.linear
```

### With Additional Covariates

```bash
# Include age, sex, and PCs
plink2 --bfile study_qc \
    --pheno phenotypes.txt \
    --covar covariates.txt \
    --covar-name AGE,SEX,PC1-PC10 \
    --glm hide-covar \
    --out gwas_adjusted
```

## Step 5: Results Visualization

### Manhattan Plot

```r
library(qqman)

# Load results
results <- read.table('gwas_results.PHENO.glm.logistic', header = TRUE)
results <- results[!is.na(results$P),]

# Manhattan plot
png('manhattan.png', width = 1200, height = 600)
manhattan(results, chr = 'X.CHROM', bp = 'POS', snp = 'ID', p = 'P',
          suggestiveline = -log10(1e-5), genomewideline = -log10(5e-8))
dev.off()

# QQ plot
png('qq_plot.png', width = 600, height = 600)
qq(results$P)
dev.off()
```

### Calculate Genomic Inflation

```r
# Lambda (genomic inflation factor)
chisq <- qchisq(1 - results$P, 1)
lambda <- median(chisq) / qchisq(0.5, 1)
cat('Lambda:', round(lambda, 3), '\n')
# Lambda should be close to 1.0 (1.0-1.1 acceptable)
```

### Extract Significant Hits

```bash
# Genome-wide significant (p < 5e-8)
awk '$12 < 5e-8' gwas_results.PHENO.glm.logistic > significant_hits.txt

# Suggestive (p < 1e-5)
awk '$12 < 1e-5' gwas_results.PHENO.glm.logistic > suggestive_hits.txt
```

## Parameter Recommendations

| Step | Parameter | Value |
|------|-----------|-------|
| Sample QC | --mind | 0.05 |
| Variant QC | --geno | 0.05 |
| Variant QC | --maf | 0.01 |
| Variant QC | --hwe | 1e-6 |
| LD pruning | --indep-pairwise | 50 5 0.2 |
| PCA | --pca | 10 |
| Significance | p-value | 5e-8 |

## Troubleshooting

| Issue | Likely Cause | Solution |
|-------|--------------|----------|
| High lambda (>1.1) | Population stratification | Add more PCs, check ancestry |
| No significant hits | Low power | Increase sample size, meta-analysis |
| Deflated lambda (<1) | Over-correction | Reduce PC covariates |
| QQ deviation at low end | Batch effects | Check for technical artifacts |

## Complete Pipeline Script

```bash
#!/bin/bash
set -e

INPUT_VCF="genotypes.vcf.gz"
PHENO="phenotypes.txt"
OUTDIR="gwas_results"

mkdir -p ${OUTDIR}

# Step 1: Convert and QC
plink2 --vcf ${INPUT_VCF} --make-bed --out ${OUTDIR}/raw
plink2 --bfile ${OUTDIR}/raw --mind 0.05 --geno 0.05 --maf 0.01 --hwe 1e-6 \
    --make-bed --out ${OUTDIR}/qc

# Step 2: LD pruning
plink2 --bfile ${OUTDIR}/qc --indep-pairwise 50 5 0.2 --out ${OUTDIR}/pruned
plink2 --bfile ${OUTDIR}/qc --extract ${OUTDIR}/pruned.prune.in \
    --make-bed --out ${OUTDIR}/pruned

# Step 3: PCA
plink2 --bfile ${OUTDIR}/pruned --pca 10 --out ${OUTDIR}/pca

# Step 4: Association
plink2 --bfile ${OUTDIR}/qc --pheno ${PHENO} \
    --covar ${OUTDIR}/pca.eigenvec --covar-col-nums 3-12 \
    --glm hide-covar --out ${OUTDIR}/gwas

echo "=== GWAS Complete ==="
echo "Results: ${OUTDIR}/gwas.*.glm.*"
```

## Related Skills

- population-genetics/plink-basics - PLINK file formats and commands
- population-genetics/population-structure - PCA and admixture
- population-genetics/association-testing - Statistical models
- population-genetics/linkage-disequilibrium - LD concepts


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->