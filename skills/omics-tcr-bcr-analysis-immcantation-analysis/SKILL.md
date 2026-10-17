---
name: omics-tcr-bcr-analysis-immcantation-analysis
description: 提供分析BCR克隆、高变、选择压力和谱系树的方法与调用指南；用于处理AIRR/Change-O表、V(D)J注释和胚系库。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: alakazam
---

## Version Compatibility

Reference examples tested with: MiXCR 4.6+, ggplot2 3.5+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Immcantation Analysis

## Codex 调用

- **选择**：请求涉及“分析BCR克隆、高变、选择压力和谱系树”时使用；显式调用 `$omics-tcr-bcr-analysis-immcantation-analysis`。
- **输入**：AIRR/Change-O表、V(D)J注释和胚系库。
- **预期产物**：克隆分组、突变/选择统计、谱系树和基因用量；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`alakazam`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Analyze B cell repertoire evolution and clonal lineages"** → Study somatic hypermutation, build B cell phylogenies, and track affinity maturation using the Immcantation framework for BCR repertoire analysis.
- R: `alakazam::plotMutability()`, `dowser::buildPhylipLineage()`, `scoper::spectralClones()`

Requires Immcantation suite: alakazam 1.3+, shazam 1.2+, scoper 1.3+, dowser 2.0+, tigger 1.1+.

## Load and Format Data

**Goal:** Import AIRR-formatted repertoire data into the Immcantation framework for downstream analysis.

**Approach:** Read Change-O/AIRR tab-delimited files into R data frames with required V(D)J annotation columns.

```r
library(alakazam)
library(shazam)
library(dplyr)

# Load AIRR-formatted data (from MiXCR, IMGT/HighV-QUEST, etc.)
db <- readChangeoDb('clones_airr.tsv')

# Required columns:
# sequence_id, sequence, v_call, d_call, j_call, junction, junction_aa
```

## Clonal Clustering

**Goal:** Group B cell sequences into clonal lineages based on junction sequence similarity.

**Approach:** Apply hierarchical clustering on nucleotide distance of junction regions with a threshold-based cutoff.

```r
library(scoper)

# Assign clones based on junction similarity
# Threshold typically 0.15-0.2 (15-20% nucleotide distance)
db <- hierarchicalClones(
    db,
    threshold = 0.15,
    method = 'nt',
    linkage = 'single'
)

# Count clones
clone_sizes <- countClones(db, groups = 'sample_id')
```

## Somatic Hypermutation Analysis

**Goal:** Quantify somatic hypermutation rates across replacement and silent categories for each clone.

**Approach:** Compare observed sequences to germline alignments using the S5F targeting model to count and classify mutations.

```r
# Calculate mutation frequencies
db <- observedMutations(
    db,
    sequenceColumn = 'sequence_alignment',
    germlineColumn = 'germline_alignment_d_mask',
    regionDefinition = IMGT_V,
    mutationDefinition = MUTATION_SCHEMES$S5F
)

# Mutation frequency columns added:
# mu_count_seq_r, mu_count_seq_s (replacement/silent mutations)
# mu_freq_seq_r, mu_freq_seq_s (frequencies)

# Summarize by clone
mutation_summary <- db %>%
    group_by(clone_id) %>%
    summarize(
        mean_mu = mean(mu_freq_seq_r, na.rm = TRUE),
        n_sequences = n()
    )
```

## Selection Analysis

**Goal:** Test whether observed replacement/silent mutation ratios deviate from neutral expectation, indicating positive or negative selection.

**Approach:** Estimate BASELINe selection strength (sigma) by comparing observed R/S ratios to a null model of somatic hypermutation targeting.

```r
library(shazam)

# Test for selection pressure
# Compares observed R/S ratio to expected under neutrality
baseline <- estimateBaseline(
    db,
    sequenceColumn = 'sequence_alignment',
    germlineColumn = 'germline_alignment_d_mask',
    testStatistic = 'focused',
    regionDefinition = IMGT_V,
    nproc = 4
)

# Summarize selection
selection <- summarizeBaseline(baseline, returnType = 'df')

# Positive sigma = positive selection (beneficial mutations retained)
# Negative sigma = negative selection (deleterious mutations removed)
```

## Build Clonal Lineage Trees

**Goal:** Reconstruct phylogenetic lineage trees for each B cell clone to visualize affinity maturation pathways.

**Approach:** Build maximum parsimony trees from clonal sequence alignments using PHYLIP's dnapars algorithm via dowser.

```r
library(dowser)

# Build lineage trees for each clone
# Requires multiple sequences per clone
clones_multi <- db %>%
    group_by(clone_id) %>%
    filter(n() >= 3) %>%
    ungroup()

# Build trees using maximum parsimony
trees <- buildPhylipLineage(
    clones_multi,
    phylip_exec = 'dnapars',
    rm_temp = TRUE
)

# Plot a tree
plotTrees(trees[[1]])
```

## Germline Inference

**Goal:** Discover novel V gene alleles and correct V gene assignments using individual-level genotyping.

**Approach:** Infer novel alleles from mutation patterns with TIgGER, build a personalized genotype, and reassign allele calls.

```r
library(tigger)

# Infer novel V gene alleles
novel <- findNovelAlleles(
    db,
    germline_db = 'IMGT_Human_IGHV.fasta',
    nproc = 4
)

# Genotype the individual
genotype <- inferGenotype(db, germline_db = 'IMGT_Human_IGHV.fasta')

# Correct V gene calls
db <- reassignAlleles(db, genotype)
```

## Visualization

**Goal:** Generate summary plots of mutation frequencies and V gene usage across samples.

**Approach:** Plot mutation frequency distributions with ggplot2 histograms and V gene usage bar charts via alakazam helpers.

```r
# Plot mutation frequency distribution
library(ggplot2)

ggplot(db, aes(x = mu_freq_seq_r)) +
    geom_histogram(bins = 50) +
    facet_wrap(~ sample_id) +
    labs(x = 'Replacement Mutation Frequency', y = 'Count')

# Plot V gene usage
v_usage <- countGenes(db, gene = 'v_call', groups = 'sample_id')
plotGeneUsage(v_usage, gene = 'v_call')
```

## Related Skills

- mixcr-analysis - Generate input clonotype data
- vdjtools-analysis - Diversity metrics (TCR-focused)
- omics-phylogenetics/tree-io - General tree concepts
