---
name: omics-methylation-dmr-detection
description: 提供用methylKit、bsseq或DMRcate定位差异甲基化区域的方法与调用指南；用于处理覆盖/胞嘧啶报告、beta矩阵和分组设计。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: methylKit
---

## Version Compatibility

Reference examples tested with: GenomicRanges 1.54+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# DMR Detection

## Codex 调用

- **选择**：请求涉及“用methylKit、bsseq或DMRcate定位差异甲基化区域”时使用；显式调用 `$omics-methylation-dmr-detection`。
- **输入**：覆盖/胞嘧啶报告、beta矩阵和分组设计。
- **预期产物**：显著DMR、方向、注释及BED/CSV文件；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`methylKit`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Find differentially methylated regions"** → Identify contiguous genomic regions with statistically significant methylation differences between conditions using tiling, smoothing, or kernel-based approaches.
- R: `methylKit::tileMethylCounts()` + `calculateDiffMeth()`, `bsseq::BSmooth()`, `DMRcate::dmrcate()`

## methylKit Tile-Based DMRs

```r
library(methylKit)

# Read and process data
meth_obj <- methRead(location = file_list, sample.id = sample_ids, treatment = treatment,
                      assembly = 'hg38', pipeline = 'bismarkCoverage')
meth_filt <- filterByCoverage(meth_obj, lo.count = 10, hi.perc = 99.9)

# Create tiles (windows)
tiles <- tileMethylCounts(meth_filt, win.size = 1000, step.size = 1000, cov.bases = 3)

tiles_united <- unite(tiles, destrand = TRUE)

# Differential methylation on tiles
diff_tiles <- calculateDiffMeth(tiles_united, overdispersion = 'MN', mc.cores = 4)

# Get significant DMRs
dmrs <- getMethylDiff(diff_tiles, difference = 25, qvalue = 0.01)
dmrs_hyper <- getMethylDiff(diff_tiles, difference = 25, qvalue = 0.01, type = 'hyper')
dmrs_hypo <- getMethylDiff(diff_tiles, difference = 25, qvalue = 0.01, type = 'hypo')
```

## bsseq BSmooth DMRs

```r
library(bsseq)

# Read Bismark cytosine reports
bs <- read.bismark(files = c('sample1.CpG_report.txt.gz', 'sample2.CpG_report.txt.gz'),
                    sampleNames = c('ctrl', 'treat'),
                    rmZeroCov = TRUE,
                    strandCollapse = TRUE)

# Smooth methylation data
bs_smooth <- BSmooth(bs, mc.cores = 4, verbose = TRUE)

# Filter by coverage
bs_cov <- getCoverage(bs_smooth)
keep <- which(rowSums(bs_cov >= 2) == ncol(bs_cov))
bs_filt <- bs_smooth[keep, ]

# Find DMRs with BSmooth
dmrs_bsseq <- dmrFinder(bs_filt, cutoff = c(-0.1, 0.1), stat = 'tstat.corrected')
```

## DMRcate Method

```r
library(DMRcate)
library(minfi)

# From methylation matrix (beta values)
# Rows = CpGs, columns = samples
design <- model.matrix(~ treatment)

# Run DMRcate
myannotation <- cpg.annotate('array', meth_matrix, what = 'Beta', arraytype = 'EPIC',
                               design = design, coef = 2)

dmr_results <- dmrcate(myannotation, lambda = 1000, C = 2)
dmr_ranges <- extractRanges(dmr_results)
```

## Annotate DMRs with Genes

**Goal:** Map differentially methylated regions to overlapping genes, promoters, and CpG islands for biological interpretation.

**Approach:** Build a genome annotation set with annotatr, convert DMRs to GRanges, and intersect with genomic features to classify each DMR by functional context.

```r
library(annotatr)

# Build annotations
annots <- build_annotations(genome = 'hg38', annotations = c(
    'hg38_basicgenes',
    'hg38_genes_promoters',
    'hg38_cpg_islands'
))

# Convert DMRs to GRanges
dmr_gr <- as(dmrs, 'GRanges')

# Annotate
dmr_annotated <- annotate_regions(regions = dmr_gr, annotations = annots, ignore.strand = TRUE)
dmr_df <- data.frame(dmr_annotated)
```

## Annotate with genomation

```r
library(genomation)

# Read gene annotations
gene_obj <- readTranscriptFeatures('genes.bed12')

# Annotate DMRs
dmr_gr <- as(dmrs, 'GRanges')
annot_result <- annotateWithGeneParts(dmr_gr, gene_obj)

# Get promoter/exon/intron breakdown
getTargetAnnotationStats(annot_result, percentage = TRUE, precedence = TRUE)
```

## Visualize DMR

```r
library(Gviz)

# Create track for a DMR
chr <- 'chr1'
start <- 1000000
end <- 1010000

# Methylation data track
meth_track <- DataTrack(
    range = bs_smooth,
    genome = 'hg38',
    name = 'Methylation',
    type = 'smooth'
)

# Gene annotation track
gene_track <- GeneRegionTrack(TxDb.Hsapiens.UCSC.hg38.knownGene, genome = 'hg38', name = 'Genes')

# Plot
plotTracks(list(meth_track, gene_track), from = start, to = end, chromosome = chr)
```

## Merge Adjacent DMRs

```r
library(GenomicRanges)

dmr_gr <- as(dmrs, 'GRanges')

# Merge DMRs within 500bp
dmr_merged <- reduce(dmr_gr, min.gapwidth = 500)
```

## Export DMRs

```r
# To BED
library(rtracklayer)
export(dmr_gr, 'dmrs.bed', format = 'BED')

# To CSV
dmr_df <- getData(dmrs)
write.csv(dmr_df, 'dmrs.csv', row.names = FALSE)

# To GFF
export(dmr_gr, 'dmrs.gff3', format = 'GFF3')
```

## DMR Comparison Across Methods

| Method | Package | Approach | Best For |
|--------|---------|----------|----------|
| Tiles | methylKit | Fixed windows | Quick analysis |
| BSmooth | bsseq | Smoothing | WGBS data |
| DMRcate | DMRcate | Kernel smoothing | Array data |
| DSS | DSS | Bayesian | Complex designs |

## Key Parameters

### methylKit tileMethylCounts

| Parameter | Default | Description |
|-----------|---------|-------------|
| win.size | 1000 | Window size (bp) |
| step.size | 1000 | Step size (bp) |
| cov.bases | 0 | Min CpGs per tile |

### bsseq dmrFinder

| Parameter | Description |
|-----------|-------------|
| cutoff | Methylation difference threshold |
| stat | Statistic to use |
| maxGap | Max gap between CpGs |

## Related Skills

- methylkit-analysis - Single CpG analysis
- methylation-calling - Generate input files
- pathway-analysis/go-enrichment - Functional annotation of DMR genes
- differential-expression/deseq2-basics - Compare with expression changes
